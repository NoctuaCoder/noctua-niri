pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property var workspaces: []
    property var activeWorkspace: null

    function fetchWorkspaces() {
        workspacesProcess.running = true
    }

    // Processo único para buscar estado inicial
    Process {
        id: workspacesProcess
        command: ["niri", "msg", "-j", "workspaces"]
        stdout: SplitParser {
            onRead: data => {
                try {
                    let parsed = JSON.parse(data)
                    root.workspaces = parsed
                    for (let i = 0; i < parsed.length; i++) {
                        if (parsed[i].is_active) {
                            root.activeWorkspace = parsed[i]
                            break
                        }
                    }
                } catch (e) {
                    console.log("Error parsing niri workspaces:", e)
                }
            }
        }
    }

    // Processo contínuo para escutar o event-stream do Niri em tempo real
    Process {
        id: eventStreamProcess
        command: ["niri", "msg", "-j", "event-stream"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                try {
                    let event = JSON.parse(data)
                    // Sempre que houver mudança de workspace ou foco, atualizamos
                    if (event.WorkspaceActivated || event.WorkspacesChanged || event.WindowFocusChanged) {
                        root.fetchWorkspaces()
                    }
                } catch (e) {
                    // Ignora linhas parciais ou vazias
                }
            }
        }
    }

    Component.onCompleted: {
        root.fetchWorkspaces()
    }
}
