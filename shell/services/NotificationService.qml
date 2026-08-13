pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property var notifications: []

    function dismiss(id) {
        notifications = notifications.filter(n => n.id !== id)
    }

    // Inicia o daemon Python automaticamente se não estiver rodando
    Process {
        running: true
        command: ["python3", Quickshell.env("HOME") + "/.config/quickshell/notification_daemon.py"] // ou caminho absoluto
    }

    // Processo para ler o socket UNIX
    Process {
        id: socketListener
        running: true
        command: ["nc", "-U", "/tmp/noctua_notifications.sock"]
        stdout: SplitParser {
            onRead: data => {
                try {
                    let notif = JSON.parse(data.trim())
                    // Adiciona na lista mantendo um limite de 5 notificações visíveis
                    let current = root.notifications.slice()
                    current.unshift(notif)
                    if (current.length > 5) current.pop()
                    root.notifications = current
                } catch (e) {
                    console.log("Error parsing notification JSON:", e)
                }
            }
        }
    }
}
