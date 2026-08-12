pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property string connectionType: "Disconnected"
    property bool connected: false

    function updateNetwork() {
        netProcess.running = true
    }

    Process {
        id: netProcess
        command: ["sh", "-c", "ip route show default | awk '/default/ {print $5}'"]
        stdout: SplitParser {
            onRead: data => {
                let iface = data.trim()
                if (iface.startsWith("wl")) {
                    root.connectionType = "Wi-Fi"
                    root.connected = true
                } else if (iface.startsWith("en") || iface.startsWith("eth")) {
                    root.connectionType = "Ethernet"
                    root.connected = true
                } else {
                    root.connectionType = "Offline"
                    root.connected = false
                }
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: root.updateNetwork()
    }

    Component.onCompleted: {
        root.updateNetwork()
    }
}
