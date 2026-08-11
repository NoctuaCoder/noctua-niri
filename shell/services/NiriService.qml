pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

// Serviço para interface com o compositor Niri usando niri msg
QtObject {
    id: root

    property var workspaces: []
    property var activeWorkspace: null

    function updateState() {
        workspacesProcess.running = true
    }

    Process {
        id: workspacesProcess
        command: ["niri", "msg", "-j", "workspaces"]
        stdout: SplitParser {
            onRead: data => {
                try {
                    root.workspaces = JSON.parse(data)
                    for (var i = 0; i < root.workspaces.length; i++) {
                        if (root.workspaces[i].is_active) {
                            root.activeWorkspace = root.workspaces[i]
                            break
                        }
                    }
                } catch (e) {
                    console.log("Error parsing niri workspaces:", e)
                }
            }
        }
    }

    Component.onCompleted: {
        updateState()
    }
}
