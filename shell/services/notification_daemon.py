#!/usr/bin/env python3
import os
import json
import socket
import dbus
import dbus.service
import dbus.mainloop.glib
from gi.repository import GLib

SOCKET_PATH = "/tmp/noctua_notifications.sock"

class NotificationDaemon(dbus.service.Object):
    def __init__(self, bus):
        dbus.service.Object.__init__(self, bus, "/org/freedesktop/Notifications")
        self.next_id = 1
        self.clients = []
        
        if os.path.exists(SOCKET_PATH):
            try:
                # Testa se o socket está ativo
                test_sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
                test_sock.connect(SOCKET_PATH)
                test_sock.close()
                # Se conectou, já tem outro daemon rodando
                print("Notification daemon already running. Exiting.")
                os._exit(0)
            except Exception:
                os.remove(SOCKET_PATH)
            
        self.server_sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self.server_sock.bind(SOCKET_PATH)
        self.server_sock.listen(5)
        self.server_sock.setblocking(False)
        
        GLib.io_add_watch(self.server_sock, GLib.IO_IN, self.on_client_connect)

    def on_client_connect(self, source, condition):
        conn, addr = source.accept()
        conn.setblocking(False)
        self.clients.append(conn)
        return True

    def broadcast(self, data):
        message = json.dumps(data) + "\n"
        dead_clients = []
        for client in self.clients:
            try:
                client.sendall(message.encode('utf-8'))
            except Exception:
                dead_clients.append(client)
        for dc in dead_clients:
            self.clients.remove(dc)

    @dbus.service.method("org.freedesktop.Notifications", in_signature="susssasa{sv}i", out_signature="u")
    def Notify(self, app_name, replaces_id, app_icon, summary, body, actions, hints, expire_timeout):
        nid = self.next_id if replaces_id == 0 else replaces_id
        if replaces_id == 0:
            self.next_id += 1
            
        notif = {
            "type": "notify",
            "id": nid,
            "appName": str(app_name),
            "appIcon": str(app_icon or ""),
            "summary": str(summary),
            "body": str(body),
            "expireTimeout": int(expire_timeout),
            "actions": [str(a) for a in actions],
            "urgency": int(hints.get("urgency", 1)) if hints else 1
        }
        
        self.broadcast(notif)
        return nid

    @dbus.service.method("org.freedesktop.Notifications", in_signature="u", out_signature="")
    def CloseNotification(self, id):
        self.broadcast({"type": "close", "id": int(id)})
        self.NotificationClosed(id, 3) # 3 = closed by call to CloseNotification

    @dbus.service.signal("org.freedesktop.Notifications", signature="uu")
    def NotificationClosed(self, id, reason):
        pass

    @dbus.service.method("org.freedesktop.Notifications", in_signature="", out_signature="as")
    def GetCapabilities(self):
        return ["body", "actions", "icon-static", "persistence"]

    @dbus.service.method("org.freedesktop.Notifications", in_signature="", out_signature="sss")
    def GetServerInformation(self):
        return ("NoctuaNotifications", "Noctua-Niri Prime", "1.0", "1.2")

if __name__ == "__main__":
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
    session_bus = dbus.SessionBus()
    
    try:
        name = dbus.service.BusName("org.freedesktop.Notifications", session_bus, do_not_queue=True)
    except dbus.exceptions.NameExistsException:
        print("Notification service name already claimed on session bus. Exiting.")
        os._exit(0)

    daemon = NotificationDaemon(session_bus)
    loop = GLib.MainLoop()
    try:
        loop.run()
    except KeyboardInterrupt:
        if os.path.exists(SOCKET_PATH):
            os.remove(SOCKET_PATH)
