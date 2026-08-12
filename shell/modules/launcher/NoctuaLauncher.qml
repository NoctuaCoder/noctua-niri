import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../services"
import "../../components"

Scope {
    id: root

    property bool isOpen: false

    function toggle() {
        isOpen = !isOpen
        if (isOpen) {
            appService.loadApps()
        }
    }

    QtObject {
        id: appService
        property var allApps: []
        property var filteredApps: []

        function loadApps() {
            // Script simples para listar arquivos .desktop comuns no Linux
            appsProc.running = true
        }

        function filter(query) {
            if (!query || query.trim() === "") {
                filteredApps = allApps
                return
            }
            let q = query.toLowerCase()
            filteredApps = allApps.filter(app => app.name.toLowerCase().includes(q) || app.exec.toLowerCase().includes(q))
        }
    }

    Process {
        id: appsProc
        command: ["sh", "-c", "grep -h '^Name=\\|^Exec=' /usr/share/applications/*.desktop 2>/dev/null | sed 'N;s/\\n/|/' | sed 's/Name=//' | sed 's/Exec=//'"]
        stdout: SplitParser {
            onRead: data => {
                let lines = data.trim().split("\n")
                let list = []
                for (let i = 0; i < lines.length; i++) {
                    let parts = lines[i].split("|")
                    if (parts.length >= 2) {
                        let name = parts[0].trim()
                        let exec = parts[1].trim().split(" ")[0] // Pega o binário principal
                        if (name && exec && !name.includes("%")) {
                            list.push({ name: name, exec: exec })
                        }
                    }
                }
                // Remover duplicatas por nome
                let unique = []
                let seen = {}
                for (let i = 0; i < list.length; i++) {
                    if (!seen[list[i].name]) {
                        seen[list[i].name] = true
                        unique.push(list[i])
                    }
                }
                appService.allApps = unique
                appService.filteredApps = unique
            }
        }
    }

    Process {
        id: execProc
    }

    Variants {
        model: Quickshell.screens
        delegate: PanelWindow {
            id: panel
            screen: modelData
            color: "transparent"
            visible: root.isOpen
            width: 600
            height: 450
            anchors {
                centerIn: true
            }

            NoctuaCard {
                anchors.fill: parent
                cardColor: ConfigService.background
                borderColor: ConfigService.accent
                cardOpacity: 0.95
                cardRadius: 20
                hoverEffect: false

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 16

                    // Barra de pesquisa
                    Rectangle {
                        Layout.fillWidth: true
                        height: 46
                        color: ConfigService.surface
                        radius: 12
                        border.width: 1
                        border.color: ConfigService.accent

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            spacing: 12

                            Text {
                                text: "󰍉"
                                font.family: ConfigService.fontFamily
                                font.pixelSize: 18
                                color: ConfigService.accent
                            }

                            TextInput {
                                id: searchInput
                                Layout.fillWidth: true
                                font.family: ConfigService.fontFamily
                                font.pixelSize: 15
                                color: ConfigService.text
                                focus: true
                                selectByMouse: true

                                onTextChanged: {
                                    appService.filter(text)
                                }

                                Keys.onEscapePressed: {
                                    root.isOpen = false
                                }

                                Keys.onReturnPressed: {
                                    if (appService.filteredApps.length > 0) {
                                        let target = appService.filteredApps[0].exec
                                        execProc.command = [target]
                                        execProc.running = true
                                        root.isOpen = false
                                        text = ""
                                    }
                                }
                            }
                        }
                    }

                    // Lista de aplicativos
                    ListView {
                        id: appListView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        model: appService.filteredApps
                        spacing: 6

                        delegate: Rectangle {
                            width: appListView.width
                            height: 40
                            radius: 8
                            color: appMouse.containsMouse ? ConfigService.surfaceHover : "transparent"

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                spacing: 10

                                Text {
                                    text: "󰣆"
                                    font.family: ConfigService.fontFamily
                                    font.pixelSize: 14
                                    color: ConfigService.blue
                                }

                                Text {
                                    text: modelData.name
                                    font.family: ConfigService.fontFamily
                                    font.pixelSize: 13
                                    color: ConfigService.text
                                    Layout.fillWidth: true
                                }
                            }

                            MouseArea {
                                id: appMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    execProc.command = [modelData.exec]
                                    execProc.running = true
                                    root.isOpen = false
                                    searchInput.text = ""
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
