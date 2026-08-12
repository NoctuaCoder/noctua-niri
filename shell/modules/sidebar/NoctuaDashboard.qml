import Quickshell
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
            width: 320
            height: screen.height - 72
            anchors {
                top: true
                right: true
                topMargin: 68
                rightMargin: 16
            }

            NoctuaCard {
                anchors.fill: parent
                cardColor: "#1e1e2e"
                borderColor: "#cba6f7"
                cardOpacity: 0.92
                cardRadius: 20
                hoverEffect: false

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 16

                    // Header do Dashboard
                    RowLayout {
                        spacing: 12
                        Rectangle {
                            width: 42
                            height: 42
                            radius: 14
                            color: "#313244"
                            border.width: 1
                            border.color: "#89b4fa"

                            Text {
                                anchors.centerIn: parent
                                text: ""
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 22
                                color: "#89b4fa"
                            }
                        }

                        ColumnLayout {
                            spacing: 2
                            Text {
                                text: "Noctua-Niri"
                                font.family: "JetBrainsMono Nerd Font"
                                font.bold: true
                                font.pixelSize: 16
                                color: "#cdd6f4"
                            }
                            Text {
                                text: "Caffyne-Style Edition"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 11
                                color: "#fab387"
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#313244"
                    }

                    // Seção de System Monitor
                    Text {
                        text: "System Telemetry"
                        font.family: "JetBrainsMono Nerd Font"
                        font.bold: true
                        font.pixelSize: 13
                        color: "#fab387"
                    }

                    // CPU Usage
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "󰻠 CPU Cores"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; color: "#cdd6f4" }
                            Item { Layout.fillWidth: true }
                            Text { text: SystemMonitorService.cpuUsage + "%"; font.family: "JetBrainsMono Nerd Font"; font.bold: true; font.pixelSize: 12; color: "#89b4fa" }
                        }
                        Rectangle {
                            Layout.fillWidth: true
                            height: 8
                            radius: 4
                            color: "#313244"
                            Rectangle {
                                width: parent.width * (SystemMonitorService.cpuUsage / 100)
                                height: parent.height
                                radius: 4
                                color: "#89b4fa"

                                Behavior on width {
                                    NumberAnimation { duration: 300; easing.type: Easing.OutQuad }
                                }
                            }
                        }
                    }

                    // RAM Usage
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "󰍛 Memory"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; color: "#cdd6f4" }
                            Item { Layout.fillWidth: true }
                            Text { text: SystemMonitorService.ramUsage + "%"; font.family: "JetBrainsMono Nerd Font"; font.bold: true; font.pixelSize: 12; color: "#cba6f7" }
                        }
                        Rectangle {
                            Layout.fillWidth: true
                            height: 8
                            radius: 4
                            color: "#313244"
                            Rectangle {
                                width: parent.width * (SystemMonitorService.ramUsage / 100)
                                height: parent.height
                                radius: 4
                                color: "#cba6f7"

                                Behavior on width {
                                    NumberAnimation { duration: 300; easing.type: Easing.OutQuad }
                                }
                            }
                        }
                    }

                    // Disk Usage
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "󰋊 Root Storage"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; color: "#cdd6f4" }
                            Item { Layout.fillWidth: true }
                            Text { text: SystemMonitorService.diskUsage; font.family: "JetBrainsMono Nerd Font"; font.bold: true; font.pixelSize: 12; color: "#a6e3a1" }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#313244"
                    }

                    // Quick Actions
                    Text {
                        text: "Quick Toggles"
                        font.family: "JetBrainsMono Nerd Font"
                        font.bold: true
                        font.pixelSize: 13
                        color: "#fab387"
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        rowSpacing: 8
                        columnSpacing: 8

                        NoctuaButton {
                            Layout.fillWidth: true
                            height: 38
                            icon: "󰖩"
                            text: NetworkService.connectionType
                            radius: 10
                        }

                        NoctuaButton {
                            Layout.fillWidth: true
                            height: 38
                            icon: "󰂯"
                            text: "Bluetooth"
                            radius: 10
                        }
                    }

                    Item { Layout.fillHeight: true }

                    // Rodapé
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        Text {
                            text: "Noctua-Niri • Caffyne Architecture"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 10
                            color: "#6c7086"
                        }
                    }
                }
            }
        }
    }
}
