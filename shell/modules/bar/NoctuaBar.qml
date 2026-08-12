import Quickshell
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
            width: screen.width - 32
            height: 44
            anchors {
                top: true
                left: true
                right: true
                topMargin: 12
                leftMargin: 16
                rightMargin: 16
            }

            NoctuaCard {
                anchors.fill: parent
                cardColor: "#1e1e2e"
                borderColor: "#cba6f7"
                cardOpacity: 0.90
                cardRadius: 16
                hoverEffect: false

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 16

                    // Launcher icon com botão
                    NoctuaButton {
                        width: 32
                        height: 32
                        icon: ""
                        baseColor: "#313244"
                        hoverColor: "#89b4fa"
                        textColor: "#1e1e2e"
                        radius: 8
                        onClicked: {
                            launcherProc.running = true
                        }
                    }

                    Process {
                        id: launcherProc
                        command: ["fuzzel"]
                    }

                    // Workspaces dinâmicos do Niri com componentes refinados
                    RowLayout {
                        spacing: 6
                        Repeater {
                            model: NiriService.workspaces
                            delegate: Rectangle {
                                width: 28
                                height: 28
                                radius: 8
                                color: modelData.is_active ? "#cba6f7" : (wsMouse.containsMouse ? "#313244" : "transparent")
                                border.width: 1
                                border.color: modelData.is_active ? "#f5e0dc" : "#45475a"

                                Behavior on color {
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

                    // Relógio central Caffyne-style
                    Rectangle {
                        Layout.preferredWidth: 120
                        Layout.preferredHeight: 30
                        color: "#313244"
                        radius: 10
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

                    // Status (Áudio, Bateria e Rede)
                    RowLayout {
                        spacing: 12

                        // Audio button
                        NoctuaButton {
                            width: 65
                            height: 28
                            icon: AudioService.muted ? "󰝟" : "󰕾"
                            text: AudioService.volume + "%"
                            baseColor: "#313244"
                            textColor: AudioService.muted ? "#f38ba8" : "#cdd6f4"
                            radius: 8
                            onClicked: AudioService.toggleMute()
                        }

                        // Battery indicator
                        NoctuaButton {
                            width: 65
                            height: 28
                            visible: BatteryService.hasBattery
                            icon: "󰁹"
                            text: BatteryService.capacity + "%"
                            baseColor: "#313244"
                            radius: 8
                            hoverEffect: false
                        }

                        // Network indicator
                        NoctuaButton {
                            width: 75
                            height: 28
                            icon: "󰖩"
                            text: NetworkService.connectionType
                            baseColor: "#313244"
                            textColor: "#a6e3a1"
                            radius: 8
                            hoverEffect: false
                        }
                    }
                }
            }
        }
    }
}
