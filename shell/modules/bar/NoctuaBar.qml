import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../services"
import "../../components"

Scope {
    id: root

    Variants {
        model: Quickshell.screens
        delegate: PanelWindow {
            id: panel
            screen: modelData
            color: "transparent"
            width: screen.width - 40
            height: 48
            
            anchors {
                top: true
                horizontalCenter: true
                topMargin: 20
            }

            NoctuaCard {
                anchors.fill: parent
                cardColor: ConfigService.background
                borderColor: ConfigService.accent
                cardOpacity: 0.95
                cardRadius: 12
                hoverEffect: false

                // Starfield Background (Editorial Style)
                Item {
                    anchors.fill: parent
                    clip: true
                    opacity: 0.15

                    Repeater {
                        model: 12
                        delegate: Rectangle {
                            x: Math.random() * parent.width
                            y: Math.random() * parent.height
                            width: 2
                            height: 2
                            radius: 1
                            color: ConfigService.text
                            SequentialAnimation on opacity {
                                loops: Animation.Infinite
                                NumberAnimation { from: 0.2; to: 1.0; duration: 2000 + Math.random() * 3000 }
                                NumberAnimation { from: 1.0; to: 0.2; duration: 2000 + Math.random() * 3000 }
                            }
                        }
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 24

                    // Left: Brand & Launcher
                    RowLayout {
                        spacing: 12
                        Text {
                            text: "NOCTUA"
                            font.family: ConfigService.fontFamilySerif
                            font.pixelSize: 14
                            font.italic: true
                            font.bold: true
                            color: ConfigService.text
                            letterSpacing: 4
                        }
                        
                        Rectangle { width: 1; height: 16; color: ConfigService.surface; opacity: 0.5 }
                        
                        Text {
                            text: "󰣆"
                            font.family: ConfigService.fontFamily
                            font.pixelSize: 16
                            color: ConfigService.accent
                            MouseArea { anchors.fill: parent; onClicked: launcherProc.running = true }
                        }
                    }

                    Process { id: launcherProc; command: ["sh", "-c", "touch /tmp/noctua_toggle"] }

                    Item { Layout.fillWidth: true }

                    // Center: Workspaces (Celestial Style)
                    RowLayout {
                        spacing: 8
                        Repeater {
                            model: NiriService.workspaces
                            delegate: Rectangle {
                                width: modelData.is_active ? 28 : 8
                                height: 8
                                radius: 4
                                color: modelData.is_active ? ConfigService.accent : ConfigService.surface
                                border.width: 1
                                border.color: modelData.is_active ? ConfigService.accent : "transparent"
                                
                                Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutQuint } }
                                Behavior on color { ColorAnimation { duration: 300 } }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        wsProcess.command = ["niri", "msg", "action", "focus-workspace", modelData.idx.toString()]
                                        wsProcess.running = true
                                    }
                                }
                            }
                        }
                    }

                    Process { id: wsProcess }

                    Item { Layout.fillWidth: true }

                    // Right: Status & Clock
                    RowLayout {
                        spacing: 20
                        
                        // Clock
                        Text {
                            id: clockText
                            text: Qt.formatTime(new Date(), "HH:MM")
                            font.family: ConfigService.fontFamilySerif
                            font.pixelSize: 14
                            font.italic: true
                            color: ConfigService.text
                            letterSpacing: 2
                            
                            Timer {
                                interval: 1000; running: true; repeat: true
                                onTriggered: clockText.text = Qt.formatTime(new Date(), "HH:mm")
                            }
                        }

                        Rectangle { width: 1; height: 16; color: ConfigService.surface; opacity: 0.5 }

                        // Dashboard Trigger
                        Text {
                            text: "SYSTEM"
                            font.family: ConfigService.fontFamily
                            font.pixelSize: 10
                            font.bold: true
                            color: ConfigService.accent
                            letterSpacing: 2
                            MouseArea { anchors.fill: parent; onClicked: dashProc.running = true }
                        }
                    }
                }
            }
        }
    }
    
    Process { id: dashProc; command: ["sh", "-c", "touch /tmp/noctua_dash_toggle"] }
}
