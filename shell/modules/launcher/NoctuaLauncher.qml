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

    // Parser Python robusto para arquivos .desktop (filtra NoDisplay, Terminal=true indesejados, e mapeia ícones)
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
            
        # Limpa argumentos do Exec (%f, %U, etc.)
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
                                        execProc.command = ["sh", "-c", target]
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

                                Image {
                                    width: 28
                                    height: 28
                                    // Tenta carregar o ícone do tema do sistema ou usa fallback
                                    source: "image://icon/" + modelData.icon
                                    sourceSize.width: 28
                                    sourceSize.height: 28

                                    // Fallback caso o provedor de ícones não resolva diretamente
                                    defaultSource: "qrc:/qt-project.org/imports/QuickControls2/images/navigation-indicator.png"
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
                                    execProc.command = ["sh", "-c", modelData.exec]
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
