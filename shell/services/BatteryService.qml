pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property int capacity: 100
    property bool charging: false

    function updateBattery() {
        batProcess.running = true
    }

    Process {
        id: batProcess
        command: ["cat", "/sys/class/power_supply/BAT0/capacity"]
        stdout: SplitParser {
            onRead: data => {
                let val = parseInt(data.trim())
                if (!isNaN(val)) root.capacity = val
            }
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: root.updateBattery()
    }

    Component.onCompleted: {
        root.updateBattery()
    }
}
