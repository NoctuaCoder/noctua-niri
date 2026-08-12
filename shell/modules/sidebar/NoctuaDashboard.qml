import Quickshell
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
            width: 320
            height: screen.height - 72
            anchors {
                top: true
                right: true
                topMargin: 64
                rightMargin: 16
            }

            Rectangle {
                anchors.fill: parent
                color: "#1e1e2e"
                opacity: 0.90
                radius: 20
                border.width: 1
                border.color: "#cba6f7"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 16

                    // Header do Dashboard
                    RowLayout {
                        spacing: 12
                        Rectangle {
                            width: 40
                            height: 40
                            radius: 12
                            color: "#313244"
                            border.width: 1
                            border.color: "#89b4fa"

                            Text {
                                anchors.centerIn: parent
                                text: ""
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 20
                                color: "#89b4fa"
                            }
                        }

                        ColumnLayout {
                            spacing: 2
                            Text {
                                text: "Noctua-Niri"
                                font.family: "JetBrainsMono Nerd Font"
                                font.bold: true
                                font.pixelSize: 15
                                color: "#cdd6f4"
                            }
                            Text {
                                text: "Wayland Scrollable Suite"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 11
                                color: "#9399b2"
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#313244"
                    }

                    // Seção de System Monitor (CPU, RAM, Disco)
                    Text {
                        text: "System Monitor"
                        font.family: "JetBrainsMono Nerd Font"
                        font.bold: true
                        font.pixelSize: 13
                        color: "#fab387"
                    }

                    // CPU Usage Bar
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "󰻠 CPU Usage"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; color: "#cdd6f4" }
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
                            }
                        }
                    }

                    // RAM Usage Bar
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "󰍛 RAM Usage"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; color: "#cdd6f4" }
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
                            }
                        }
                    }

                    // Disk Usage Bar
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "󰋊 Disk Root"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; color: "#cdd6f4" }
                            Item { Layout.fillWidth: true }
                            Text { text: SystemMonitorService.diskUsage; font.family: "JetBrainsMono Nerd Font"; font.bold: true; font.pixelSize: 12; color: "#a6e3a1" }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#313244"
                    }

                    // Quick Actions / Status
                    Text {
                        text: "Quick Controls"
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

                        Rectangle {
                            Layout.fillWidth: true
                            height: 36
                            radius: 8
                            color: "#313244"
                            Text { anchors.centerIn: parent; text: "󰖩 " + NetworkService.connectionType; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; color: "#a6e3a1" }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 36
                            radius: 8
                            color: "#313244"
                            Text { anchors.centerIn: parent; text: "󰂯 Bluetooth"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; color: "#89b4fa" }
                        }
                    }

                    Item { Layout.fillHeight: true }

                    // Rodapé do Dashboard
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        Text {
                            text: "Noctua-Niri • r/unixporn Edition"
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
