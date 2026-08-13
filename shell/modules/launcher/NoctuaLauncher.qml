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

    Timer {
        interval: 100
        running: true
        repeat: true
        triggeredOnStart: false
        onTriggered: {
            checkProc.running = true
        }
    }

    Process {
        id: checkProc
        command: ["sh", "-c", "if [ -f /tmp/noctua_toggle ]; then rm /tmp/noctua_toggle && echo 'TOGGLE'; fi"]
        stdout: SplitParser {
            onRead: data => {
                if (data.trim() === "TOGGLE") {
                    root.toggle()
                }
            }
        }
    }

    QtObject {
        id: appService
        property var allApps: []
        property var filteredApps: []

        function loadApps() {
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
        // Extrai Name, Exec e Icon de arquivos .desktop
        command: ["sh", "-c", "grep -h '^Name=\\|^Exec=\\|^Icon=' /usr/share/applications/*.desktop 2>/dev/null | paste -d'|' - - - | sed 's/Name=//' | sed 's/Exec=//' | sed 's/Icon=//'"]
        stdout: SplitParser {
            onRead: data => {
                let lines = data.trim().split("\n")
                let list = []
                for (let i = 0; i < lines.length; i++) {
                    let parts = lines[i].split("|")
                    if (parts.length >= 3) {
                        let name = parts[0].trim()
                        let exec = parts[1].trim().split(" ")[0]
                        let icon = parts[2].trim()
                        if (name && exec && !name.includes("%")) {
                            list.push({ name: name, exec: exec, icon: icon })
                        }
                    }
                }
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
            width: 620
            height: 480
            anchors {
                centerIn: true
            }

            NoctuaCard {
                anchors.fill: parent
                cardColor: ConfigService.background
                borderColor: ConfigService.accent
                cardOpacity: 0.96
                cardRadius: 20
                hoverEffect: false

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 22
                    spacing: 16

                    // Cabeçalho de Pesquisa
                    Rectangle {
                        Layout.fillWidth: true
                        height: 48
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

                    // Lista de Aplicativos Otimizada
                    ListView {
                        id: appListView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        model: appService.filteredApps
                        spacing: 6

                        delegate: Rectangle {
                            width: appListView.width
                            height: 44
                            radius: 10
                            color: appMouse.containsMouse ? ConfigService.surfaceHover : "transparent"

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 14
                                anchors.rightMargin: 14
                                spacing: 12

                                Rectangle {
                                    width: 28
                                    height: 28
                                    radius: 6
                                    color: ConfigService.surface
                                    border.width: 1
                                    border.color: ConfigService.accentBorder

                                    Text {
                                        anchors.centerIn: parent
                                        text: "󰣆"
                                        font.family: ConfigService.fontFamily
                                        font.pixelSize: 14
                                        color: ConfigService.blue
                                    }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2
                                    Text {
                                        text: modelData.name
                                        font.family: ConfigService.fontFamily
                                        font.pixelSize: 14
                                        font.bold: true
                                        color: ConfigService.text
                                    }
                                    Text {
                                        text: modelData.exec
                                        font.family: ConfigService.fontFamily
                                        font.pixelSize: 11
                                        color: ConfigService.subtext
                                    }
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
