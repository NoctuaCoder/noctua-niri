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

    Process {
        id: volProcess
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                // Exemplo de saída: "Volume: 0.75 [MUTED]" ou "Volume: 0.75"
                let parts = data.trim().split(" ")
                if (parts.length >= 2) {
                    let volFloat = parseFloat(parts[1])
                    root.volume = Math.round(volFloat * 100)
                    root.muted = data.includes("MUTED")
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: root.updateVolume()
    }

    Component.onCompleted: {
        root.updateVolume()
    }
}
