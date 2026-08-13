pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property var notifications: [] // Banners ativos
    property var history: []       // Histórico completo

    readonly property string daemonPath: Quickshell.env("HOME") + "/.config/quickshell/services/notification_daemon.py"

    function dismiss(id) {
        notifications = notifications.filter(n => n.id !== id)
    }

    function clearHistory() {
        history = []
    }

    function dismissFromHistory(id) {
        history = history.filter(n => n.id !== id)
    }

    // Auto-dismiss timer a cada 500ms para banners
    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            let now = Date.now()
            let current = root.notifications.slice()
            let filtered = current.filter(n => {
                if (n.expiresAt === 0) return true
                if (n.paused) return true
                return n.expiresAt > now
            })
            if (filtered.length !== current.length) {
                root.notifications = filtered
            }
        }
    }

    Process {
        running: true
        command: ["python3", root.daemonPath]
    }

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
                        let currentNotifs = root.notifications.filter(n => n.id !== notif.id)
                        let currentHistory = root.history.filter(n => n.id !== notif.id)
                        
                        let timeout = notif.expireTimeout
                        let duration = 5000
                        if (timeout === 0) duration = 0
                        else if (timeout > 0) duration = timeout

                        notif.expiresAt = duration === 0 ? 0 : (Date.now() + duration)
                        notif.timestamp = Qt.formatTime(new Date(), "hh:mm")
                        notif.paused = false
                        
                        // Adiciona ao banner
                        currentNotifs.unshift(notif)
                        if (currentNotifs.length > 5) currentNotifs.pop()
                        root.notifications = currentNotifs

                        // Adiciona ao histórico (limite de 50)
                        currentHistory.unshift(notif)
                        if (currentHistory.length > 50) currentHistory.pop()
                        root.history = currentHistory
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
