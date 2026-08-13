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

    // Gatilho externo para o Dashboard (opcional)
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
            visible: root.isOpen
            width: 340
            height: screen.height - 40
            anchors {
                right: true
                top: true
                topMargin: 20
                rightMargin: 20
            }

            NoctuaCard {
                anchors.fill: parent
                cardColor: ConfigService.background
                borderColor: ConfigService.accent
                cardOpacity: 0.98
                cardRadius: 24
                hoverEffect: false

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 24
                    spacing: 16

                    // Header
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        
                        Rectangle {
                            width: 44
                            height: 44
                            radius: 12
                            color: ConfigService.surface
                            border.width: 1
                            border.color: ConfigService.accent

                            Text {
                                anchors.centerIn: parent
                                text: "󰣆"
                                font.family: ConfigService.fontFamily
                                font.pixelSize: 22
                                color: ConfigService.accent
                            }
                        }

                        ColumnLayout {
                            spacing: 0
                            Text {
                                text: "Noctua Prime"
                                font.family: ConfigService.fontFamily
                                font.bold: true
                                font.pixelSize: 16
                                color: ConfigService.text
                            }
                            Text {
                                text: "Sovereign Edition v2.0"
                                font.family: ConfigService.fontFamily
                                font.pixelSize: 10
                                color: ConfigService.peach
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: ConfigService.surface }

                    // System Monitors
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        Text {
                            text: "System Telemetry"
                            font.family: ConfigService.fontFamily
                            font.bold: true
                            font.pixelSize: 13
                            color: ConfigService.peach
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            // CPU
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4
                                RowLayout {
                                    Text { text: "󰻠 CPU Usage"; font.family: ConfigService.fontFamily; font.pixelSize: 11; color: ConfigService.text }
                                    Item { Layout.fillWidth: true }
                                    Text { text: SystemMonitorService.cpuUsage + "%"; font.family: ConfigService.fontFamily; font.bold: true; font.pixelSize: 11; color: ConfigService.blue }
                                }
                                Rectangle {
                                    Layout.fillWidth: true; height: 6; radius: 3; color: ConfigService.surface
                                    Rectangle {
                                        width: parent.width * (SystemMonitorService.cpuUsage/100)
                                        height: 6; radius: 3; color: ConfigService.blue
                                        Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutQuad } }
                                    }
                                }
                            }

                            // RAM
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4
                                RowLayout {
                                    Text { text: "󰍛 RAM Usage"; font.family: ConfigService.fontFamily; font.pixelSize: 11; color: ConfigService.text }
                                    Item { Layout.fillWidth: true }
                                    Text { text: SystemMonitorService.ramUsage + "%"; font.family: ConfigService.fontFamily; font.bold: true; font.pixelSize: 11; color: ConfigService.accent }
                                }
                                Rectangle {
                                    Layout.fillWidth: true; height: 6; radius: 3; color: ConfigService.surface
                                    Rectangle {
                                        width: parent.width * (SystemMonitorService.ramUsage/100)
                                        height: 6; radius: 3; color: ConfigService.accent
                                        Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutQuad } }
                                    }
                                }
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: ConfigService.surface }

                    // Notification History (NoctuaCenter)
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 12

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: "Notification History"
                                font.family: ConfigService.fontFamily
                                font.bold: true
                                font.pixelSize: 13
                                color: ConfigService.mauve
                            }
                            Item { Layout.fillWidth: true }
                            NoctuaButton {
                                text: "Clear"
                                radius: 6
                                height: 22
                                baseColor: "transparent"
                                textColor: ConfigService.subtext
                                onClicked: NotificationService.clearHistory()
                            }
                        }

                        ListView {
                            id: historyList
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            model: NotificationService.history
                            spacing: 8
                            
                            delegate: Rectangle {
                                width: historyList.width
                                height: notifCol.height + 16
                                radius: 12
                                color: ConfigService.surface
                                border.width: 1
                                border.color: ConfigService.accentBorder
                                
                                ColumnLayout {
                                    id: notifCol
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 4

                                    RowLayout {
                                        Layout.fillWidth: true
                                        Text {
                                            text: modelData.appName
                                            font.bold: true; font.pixelSize: 10; color: ConfigService.peach
                                        }
                                        Item { Layout.fillWidth: true }
                                        Text {
                                            text: modelData.timestamp
                                            font.pixelSize: 9; color: ConfigService.subtext
                                        }
                                    }
                                    Text {
                                        text: modelData.summary
                                        font.bold: true; font.pixelSize: 12; color: ConfigService.text; Layout.fillWidth: true; wrapMode: Text.WordWrap
                                    }
                                    Text {
                                        text: modelData.body
                                        font.pixelSize: 11; color: ConfigService.subtext; Layout.fillWidth: true; wrapMode: Text.WordWrap; visible: text !== ""
                                    }
                                }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: "No notifications"
                                font.family: ConfigService.fontFamily
                                font.pixelSize: 12
                                color: ConfigService.subtext
                                visible: NotificationService.history.length === 0
                            }
                        }
                    }

                    // Footer / Quick Actions
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10
                        NoctuaButton { Layout.fillWidth: true; text: "Lock"; icon: "󰌾"; onClicked: { root.isOpen = false; shellRoot.noctuaLock.lock(); } }
                        NoctuaButton { Layout.fillWidth: true; text: "Power"; icon: "󰐥"; onClicked: { root.isOpen = false; shellRoot.noctuaPowerMenu.toggle(); } }
                    }
                }
            }

            // Animação de Entrada (Slide)
            x: root.isOpen ? (screen.width - width - 20) : screen.width
            Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutQuint } }
        }
    }
}
