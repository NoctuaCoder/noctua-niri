pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property int capacity: 100
    property bool charging: false
    property bool hasBattery: false
    property string batteryPath: ""

    function checkBattery() {
        batDetectProcess.running = true
    }

    // Detecta automaticamente se existe BAT0, BAT1, etc. em /sys/class/power_supply/
    Process {
        id: batDetectProcess
        command: ["sh", "-c", "for b in /sys/class/power_supply/BAT*; do [ -d \"$b\" ] && echo \"$b\" && break; done"]
        stdout: SplitParser {
            onRead: data => {
                let path = data.trim()
                if (path !== "") {
                    root.batteryPath = path
                    root.hasBattery = true
                    batCapacityProcess.command = ["cat", path + "/capacity"]
                    batCapacityProcess.running = true
                } else {
                    root.hasBattery = false
                }
            }
        }
    }

    Process {
        id: batCapacityProcess
        stdout: SplitParser {
            onRead: data => {
                let val = parseInt(data.trim())
                if (!isNaN(val)) root.capacity = val
            }
        }
    }

    Timer {
        interval: 15000
        running: true
        repeat: true
        onTriggered: {
            if (root.hasBattery && root.batteryPath !== "") {
                batCapacityProcess.running = true
            }
        }
    }

    Component.onCompleted: {
        root.checkBattery()
    }
}
