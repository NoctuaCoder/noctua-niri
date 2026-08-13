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
            currentIndex = 0
            searchInput.text = ""
            searchInput.forceActiveFocus()
        }
    }

    property int currentIndex: 0

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
            currentIndex = 0
        }
    }

    Process {
        id: appsProc
        command: ["python3", "-c", "
import glob, os, configparser

apps = []
seen = set()

for path in glob.glob('/usr/share/applications/*.desktop') + glob.glob(os.path.expanduser('~/.local/share/applications/*.desktop')):
    try:
        config = configparser.ConfigParser(interpolation=None)
        config.read(path, encoding='utf-8')
        if not config.has_section('Desktop Entry'):
            continue
        entry = config['Desktop Entry']
        if entry.getboolean('NoDisplay', False) or entry.getboolean('Hidden', False):
            continue
        if entry.get('Type', '') != 'Application':
            continue
        name = entry.get('Name', '')
        exec_cmd = entry.get('Exec', '')
        icon = entry.get('Icon', 'application-x-executable')
        
        if not name or not exec_cmd:
            continue
            
        exec_clean = exec_cmd.split('%')[0].strip()
        
        if name not in seen:
            seen.add(name)
            apps.append({'name': name, 'exec': exec_clean, 'icon': icon})
    except Exception:
        pass

import json
print(json.dumps(apps))
"]
        stdout: SplitParser {
            onRead: data => {
                try {
                    let list = JSON.parse(data.trim())
                    appService.allApps = list
                    appService.filteredApps = list
                } catch (e) {
                    console.log("Error parsing apps:", e)
                }
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
            width: screen.width
            height: screen.height

            // Área externa translúcida para fechar ao clicar fora
            MouseArea {
                anchors.fill: parent
                enabled: root.isOpen
                onClicked: {
                    root.isOpen = false
                }

                // Conteúdo centralizado do Launcher
                Item {
                    id: launcherContainer
                    width: 620
                    height: 480
                    anchors.centerIn: parent

                    // Impede que cliques dentro do card fechem o launcher
                    MouseArea {
                        anchors.fill: parent
                        onClicked: mouse.accepted = true
                    }

                    NoctuaCard {
                        anchors.fill: parent
                        cardColor: ConfigService.background
                        borderColor: ConfigService.accent
                        cardOpacity: 0.98
                        cardRadius: 22
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

                                        Keys.onDownPressed: {
                                            if (appService.filteredApps.length > 0) {
                                                root.currentIndex = (root.currentIndex + 1) % appService.filteredApps.length
                                                appListView.positionViewAtIndex(root.currentIndex, ListView.Contain)
                                            }
                                        }

                                        Keys.onUpPressed: {
                                            if (appService.filteredApps.length > 0) {
                                                root.currentIndex = (root.currentIndex - 1 + appService.filteredApps.length) % appService.filteredApps.length
                                                appListView.positionViewAtIndex(root.currentIndex, ListView.Contain)
                                            }
                                        }

                                        Keys.onReturnPressed: {
                                            if (appService.filteredApps.length > 0 && root.currentIndex >= 0 && root.currentIndex < appService.filteredApps.length) {
                                                let target = appService.filteredApps[root.currentIndex].exec
                                                execProc.command = ["sh", "-c", target]
                                                execProc.running = true
                                                root.isOpen = false
                                            }
                                        }
                                    }
                                }
                            }

                            // Lista de Aplicativos com Navegação por Teclado
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
                                    color: index === root.currentIndex ? ConfigService.surfaceHover : (appMouse.containsMouse ? ConfigService.surface : "transparent")
                                    border.width: index === root.currentIndex ? 1 : 0
                                    border.color: ConfigService.accentBorder

                                    Behavior on color {
                                        ColorAnimation { duration: 100 }
                                    }

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
                                        onEntered: {
                                            root.currentIndex = index
                                        }
                                        onClicked: {
                                            execProc.command = ["sh", "-c", modelData.exec]
                                            execProc.running = true
                                            root.isOpen = false
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Animação de Entrada (Fade & Scale)
                    opacity: root.isOpen ? 1 : 0
                    scale: root.isOpen ? 1 : 0.95
                    Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
                    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
                }
            }
        }
    }
}
