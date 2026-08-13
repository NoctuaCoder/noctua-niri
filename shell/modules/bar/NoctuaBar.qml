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
                cardColor: ConfigService.background
                borderColor: ConfigService.accent
                cardOpacity: ConfigService.shellOpacity
                cardRadius: ConfigService.shellRadius
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
                        baseColor: ConfigService.surface
                        hoverColor: ConfigService.blue
                        textColor: ConfigService.text
                        radius: 8
                        onClicked: {
                            launcherProc.running = true
                        }
                    }

                    Process {
                        id: launcherProc
                        command: ["sh", "-c", "touch /tmp/noctua_toggle"]
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
                                color: modelData.is_active ? ConfigService.accent : (wsMouse.containsMouse ? ConfigService.surface : "transparent")
                                border.width: 1
                                border.color: modelData.is_active ? ConfigService.accentBorder : ConfigService.surfaceHover

                                Behavior on color {
                                    ColorAnimation { duration: 150 }
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.idx
                                    font.family: ConfigService.fontFamily
                                    font.pixelSize: 12
                                    font.bold: true
                                    color: modelData.is_active ? ConfigService.background : ConfigService.text
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

                    // Relógio central
                    Rectangle {
                        Layout.preferredWidth: 120
                        Layout.preferredHeight: 30
                        color: ConfigService.surface
                        radius: 10
                        border.width: 1
                        border.color: ConfigService.peach

                        Text {
                            anchors.centerIn: parent
                            text: Qt.formatTime(new Date(), "hh:mm:ss")
                            font.family: ConfigService.fontFamily
                            font.pixelSize: 12
                            font.bold: true
                            color: ConfigService.peach

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
                            baseColor: ConfigService.surface
                            textColor: AudioService.muted ? ConfigService.red : ConfigService.text
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
                            baseColor: ConfigService.surface
                            textColor: ConfigService.text
                            radius: 8
                            hoverEffect: false
                        }

                        // Network indicator
                        NoctuaButton {
                            width: 75
                            height: 28
                            icon: "󰖩"
                            text: NetworkService.connectionType
                            baseColor: ConfigService.surface
                            textColor: ConfigService.green
                            radius: 8
                            hoverEffect: false
                        }
                    }
                }
            }
        }
    }
}
