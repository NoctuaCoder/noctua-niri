import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../services"

Scope {
    id: root

    Variants {
        model: Quickshell.screens
        delegate: PanelWindow {
            id: panel
            screen: modelData
            color: "transparent"
            width: screen.width - 32
            height: 40
            anchors {
                top: true
                left: true
                right: true
                topMargin: 12
                leftMargin: 16
                rightMargin: 16
            }

            Rectangle {
                anchors.fill: parent
                color: "#1e1e2e"
                opacity: 0.88
                radius: 16
                border.width: 1
                border.color: "#cba6f7"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 16

                    // Launcher icon
                    Text {
                        text: ""
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 18
                        color: "#89b4fa"
                    }

                    // Workspaces dinâmicos do Niri com Hover e Feedback Visual
                    RowLayout {
                        spacing: 6
                        Repeater {
                            model: NiriService.workspaces
                            delegate: Rectangle {
                                id: wsRect
                                width: 26
                                height: 26
                                radius: 8
                                color: modelData.is_active ? "#cba6f7" : (wsMouse.containsMouse ? "#313244" : "transparent")
                                border.width: 1
                                border.color: modelData.is_active ? "#f5e0dc" : "#45475a"

                                behavior on color {
                                    ColorAnimation { duration: 150 }
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.idx
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 12
                                    font.bold: true
                                    color: modelData.is_active ? "#1e1e2e" : "#cdd6f4"
                                }

                                MouseArea {
                                    id: wsMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
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

                    // Relógio central neon pastel
                    Rectangle {
                        Layout.preferredWidth: 110
                        Layout.preferredHeight: 28
                        color: "#313244"
                        radius: 8
                        border.width: 1
                        border.color: "#fab387"

                        Text {
                            anchors.centerIn: parent
                            text: Qt.formatTime(new Date(), "hh:mm:ss")
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            font.bold: true
                            color: "#fab387"

                            Timer {
                                interval: 1000
                                running: true
                                repeat: true
                                onTriggered: parent.text = Qt.formatTime(new Date(), "hh:mm:ss")
                            }
                        }
                    }

                    Item { Layout.fillWidth: true }

                    // Status reais (Áudio interativo e Bateria dinâmica)
                    RowLayout {
                        spacing: 14

                        // Audio com clique para Mute
                        RowLayout {
                            spacing: 4
                            Text {
                                text: AudioService.muted ? "󰝟" : "󰕾"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 14
                                color: AudioService.muted ? "#f38ba8" : "#a6e3a1"
                            }
                            Text {
                                text: AudioService.volume + "%"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 12
                                color: "#cdd6f4"
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: AudioService.toggleMute()
                            }
                        }

                        // Battery (Apenas se houver bateria detectada)
                        RowLayout {
                            spacing: 4
                            visible: BatteryService.hasBattery
                            Text {
                                text: "󰁹"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 14
                                color: "#89b4fa"
                            }
                            Text {
                                text: BatteryService.capacity + "%"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 12
                                color: "#cdd6f4"
                            }
                        }
                    }
                }
            }
        }
    }
}
