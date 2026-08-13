pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property var notifications: []

    readonly property string daemonPath: Quickshell.env("HOME") + "/.config/quickshell/services/notification_daemon.py"

    function dismiss(id) {
        notifications = notifications.filter(n => n.id !== id)
    }

    // Auto-dismiss timer a cada 500ms para verificar expirados
    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            let now = Date.now()
            let current = root.notifications.slice()
            let filtered = current.filter(n => {
                if (n.expiresAt === 0) return true // sticky
                if (n.paused) return true // pausa se o mouse estiver em cima
                return n.expiresAt > now
            })
            if (filtered.length !== current.length) {
                root.notifications = filtered
            }
        }
    }

    // Inicia o daemon Python automaticamente
    Process {
        running: true
        command: ["python3", root.daemonPath]
    }

    // Processo de escuta do socket com reconexão automática
    Process {
        id: socketListener
        running: true
        command: ["nc", "-U", "/tmp/noctua_notifications.sock"]
        stdout: SplitParser {
            onRead: data => {
                try {
                    let msg = JSON.parse(data.trim())
                    if (msg.type === "close") {
                        root.dismiss(msg.id)
                        return
                    }
                    if (msg.type === "notify" || msg.id !== undefined) {
                        let notif = msg
                        let current = root.notifications.filter(n => n.id !== notif.id)
                        
                        let timeout = notif.expireTimeout
                        let duration = 5000
                        if (timeout === 0) duration = 0
                        else if (timeout > 0) duration = timeout

                        notif.expiresAt = duration === 0 ? 0 : (Date.now() + duration)
                        notif.paused = false
                        
                        current.unshift(notif)
                        if (current.length > 5) current.pop()
                        root.notifications = current
                    }
                } catch (e) {
                    console.log("Error parsing notification message:", e)
                }
            }
        }
        onExited: {
            reconnectTimer.start()
        }
    }

    Timer {
        id: reconnectTimer
        interval: 300
        onTriggered: socketListener.running = true
    }
}
