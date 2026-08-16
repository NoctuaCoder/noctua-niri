import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../services"
import "../../components"

Scope {
    id: root

    property bool isOpen: false

    function toggle() {
        isOpen = !isOpen
    }

    // Gatilho externo para o Dashboard
    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            checkDashProc.running = true
        }
    }

    Process {
        id: checkDashProc
        command: ["sh", "-c", "if [ -f /tmp/noctua_dash_toggle ]; then rm /tmp/noctua_dash_toggle && echo 'TOGGLE'; fi"]
        stdout: SplitParser {
            onRead: data => {
                if (data.trim() === "TOGGLE") {
                    root.toggle()
                }
            }
        }
    }

    Variants {
        model: Quickshell.screens
        delegate: PanelWindow {
            id: panel
            screen: modelData
            color: "transparent"
            visible: true // Sempre ativo para animação suave
            width: 360
            height: screen.height - 40
            
            anchors {
                right: true
                top: true
                topMargin: 20
            }

            // A janela se move para fora da tela, mas o conteúdo é animado
            x: root.isOpen ? (screen.width - width - 20) : screen.width + 20
            Behavior on x { NumberAnimation { duration: 400; easing.type: Easing.OutQuint } }

            NoctuaCard {
                anchors.fill: parent
                cardColor: ConfigService.background
                borderColor: ConfigService.accent
                cardOpacity: 0.95
                cardRadius: 12
                hoverEffect: false

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 28
                    spacing: 20

                    // Editorial Header
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        
                        Text {
                            text: "NOCTUA PRIME"
                            font.family: ConfigService.fontFamilySerif
                            font.pixelSize: 24
                            font.italic: true
                            color: ConfigService.text
                            style: Text.Outline
                            styleColor: ConfigService.accent
                            Layout.alignment: Qt.AlignLeft
                        }
                        
                        Text {
                            text: "CELESTIAL DASHBOARD // V2.0"
                            font.family: ConfigService.fontFamily
                            font.pixelSize: 10
                            color: ConfigService.accent
                            style: Text.Normal
                            Layout.alignment: Qt.AlignLeft
                            opacity: 0.8
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: ConfigService.surface; opacity: 0.3 }

                    // System Telemetry (Editorial Grid Style)
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16

                        Text {
                            text: "SYSTEM TELEMETRY"
                            font.family: ConfigService.fontFamily
                            font.pixelSize: 11
                            font.bold: true
                            color: ConfigService.subtext
                            opacity: 0.6
                        }

                        GridLayout {
                            columns: 2
                            Layout.fillWidth: true
                            columnSpacing: 20
                            rowSpacing: 12

                            // CPU Widget
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 6
                                Text { text: "CPU LOAD"; font.family: ConfigService.fontFamily; font.pixelSize: 9; color: ConfigService.subtext }
                                Text { text: SystemMonitorService.cpuUsage + "%"; font.family: ConfigService.fontFamilySerif; font.pixelSize: 20; color: ConfigService.blue }
                                Rectangle { Layout.fillWidth: true; height: 2; color: ConfigService.surface; Rectangle { width: parent.width * (SystemMonitorService.cpuUsage/100); height: 2; color: ConfigService.blue } }
                            }

                            // RAM Widget
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 6
                                Text { text: "MEMORY"; font.family: ConfigService.fontFamily; font.pixelSize: 9; color: ConfigService.subtext }
                                Text { text: SystemMonitorService.ramUsage + "%"; font.family: ConfigService.fontFamilySerif; font.pixelSize: 20; color: ConfigService.accent }
                                Rectangle { Layout.fillWidth: true; height: 2; color: ConfigService.surface; Rectangle { width: parent.width * (SystemMonitorService.ramUsage/100); height: 2; color: ConfigService.accent } }
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: ConfigService.surface; opacity: 0.3 }

                    // Notification History
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 16

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: "ASTRAL LOGS"
                                font.family: ConfigService.fontFamily
                                font.pixelSize: 11
                                font.bold: true
                                color: ConfigService.subtext
                                opacity: 0.6
                            }
                            Item { Layout.fillWidth: true }
                            Text {
                                text: "CLEAR"
                                font.family: ConfigService.fontFamily
                                font.pixelSize: 9
                                color: ConfigService.red
                                MouseArea { anchors.fill: parent; onClicked: NotificationService.clearHistory() }
                            }
                        }

                        ListView {
                            id: historyList
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            model: NotificationService.history
                            spacing: 12
                            
                            delegate: ColumnLayout {
                                width: historyList.width
                                spacing: 4
                                
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: modelData.appName.toUpperCase(); font.family: ConfigService.fontFamily; font.pixelSize: 8; color: ConfigService.accent; opacity: 0.8 }
                                    Item { Layout.fillWidth: true }
                                    Text { text: modelData.timestamp; font.family: ConfigService.fontFamily; font.pixelSize: 8; color: ConfigService.subtext; opacity: 0.5 }
                                }
                                
                                Text {
                                    text: modelData.summary
                                    font.family: ConfigService.fontFamilySerif
                                    font.pixelSize: 14
                                    color: ConfigService.text
                                    Layout.fillWidth: true
                                    wrapMode: Text.WordWrap
                                }
                                
                                Rectangle { Layout.fillWidth: true; height: 1; color: ConfigService.surface; opacity: 0.1 }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: "NO LOGS FOUND IN THIS QUADRANT"
                                font.family: ConfigService.fontFamily
                                font.pixelSize: 10
                                color: ConfigService.subtext
                                opacity: 0.4
                                visible: NotificationService.history.length === 0
                            }
                        }
                    }

                    // Footer / Quick Actions
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        
                        NoctuaButton { 
                            Layout.fillWidth: true
                            text: "LOCK"
                            baseColor: "transparent"
                            borderColor: ConfigService.surface
                            onClicked: { root.isOpen = false; shellRoot.noctuaLock.lock(); } 
                        }
                        
                        NoctuaButton { 
                            Layout.fillWidth: true
                            text: "POWER"
                            baseColor: ConfigService.accent
                            textColor: ConfigService.background
                            onClicked: { root.isOpen = false; shellRoot.noctuaPowerMenu.toggle(); } 
                        }
                    }
                }
            }
        }
    }
}
