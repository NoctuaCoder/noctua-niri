pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property int volume: 0
    property bool muted: false

    function updateVolume() {
        volProcess.running = true
    }

    function toggleMute() {
        volToggleProcess.running = true
    }

    Process {
        id: volProcess
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split(" ")
                if (parts.length >= 2) {
                    let volFloat = parseFloat(parts[1])
                    root.volume = Math.round(volFloat * 100)
                    root.muted = data.includes("MUTED")
                }
            }
        }
    }

    Process {
        id: volToggleProcess
        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
        onExited: root.updateVolume()
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: root.updateVolume()
    }

    Component.onCompleted: {
        root.updateVolume()
    }
}
