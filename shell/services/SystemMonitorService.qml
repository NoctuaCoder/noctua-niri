pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property int cpuUsage: 0
    property int ramUsage: 0
    property string diskUsage: "0%"

    function updateStats() {
        cpuProcess.running = true
        ramProcess.running = true
        diskProcess.running = true
    }

    // Leitura simplificada de CPU via top/awk no Linux
    Process {
        id: cpuProcess
        command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print 100 - $8}' | cut -d'.' -f1"]
        stdout: SplitParser {
            onRead: data => {
                let val = parseInt(data.trim())
                if (!isNaN(val)) root.cpuUsage = val
            }
        }
    }

    // Leitura de RAM via free
    Process {
        id: ramProcess
        command: ["sh", "-c", "free | grep Mem | awk '{print int($3/$2 * 100)}'"]
        stdout: SplitParser {
            onRead: data => {
                let val = parseInt(data.trim())
                if (!isNaN(val)) root.ramUsage = val
            }
        }
    }

    // Leitura de Disco principal
    Process {
        id: diskProcess
        command: ["sh", "-c", "df / | tail -1 | awk '{print $5}'"]
        stdout: SplitParser {
            onRead: data => {
                let val = data.trim()
                if (val !== "") root.diskUsage = val
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: root.updateStats()
    }

    Component.onCompleted: {
        root.updateStats()
    }
}
