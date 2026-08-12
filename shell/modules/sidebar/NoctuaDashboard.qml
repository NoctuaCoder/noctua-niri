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
                cardColor: ConfigService.background
                borderColor: ConfigService.accent
                cardOpacity: ConfigService.shellOpacity
                cardRadius: ConfigService.shellRadius
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
                            color: ConfigService.surface
                            border.width: 1
                            border.color: ConfigService.blue

                            Text {
                                anchors.centerIn: parent
                                text: ""
                                font.family: ConfigService.fontFamily
                                font.pixelSize: 22
                                color: ConfigService.blue
                            }
                        }

                        ColumnLayout {
                            spacing: 2
                            Text {
                                text: "Noctua-Niri"
                                font.family: ConfigService.fontFamily
                                font.bold: true
                                font.pixelSize: 16
                                color: ConfigService.text
                            }
                            Text {
                                text: "Prime Edition"
                                font.family: ConfigService.fontFamily
                                font.pixelSize: 11
                                color: ConfigService.peach
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: ConfigService.surface
                    }

                    // Seção de System Monitor
                    Text {
                        text: "System Telemetry"
                        font.family: ConfigService.fontFamily
                        font.bold: true
                        font.pixelSize: 13
                        color: ConfigService.peach
                    }

                    // CPU Usage
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "󰻠 CPU Cores"; font.family: ConfigService.fontFamily; font.pixelSize: 12; color: ConfigService.text }
                            Item { Layout.fillWidth: true }
                            Text { text: SystemMonitorService.cpuUsage + "%"; font.family: ConfigService.fontFamily; font.bold: true; font.pixelSize: 12; color: ConfigService.blue }
                        }
                        Rectangle {
                            Layout.fillWidth: true
                            height: 8
                            radius: 4
                            color: ConfigService.surface
                            Rectangle {
                                width: parent.width * (SystemMonitorService.cpuUsage / 100)
                                height: parent.height
                                radius: 4
                                color: ConfigService.blue

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
                            Text { text: "󰍛 Memory"; font.family: ConfigService.fontFamily; font.pixelSize: 12; color: ConfigService.text }
                            Item { Layout.fillWidth: true }
                            Text { text: SystemMonitorService.ramUsage + "%"; font.family: ConfigService.fontFamily; font.bold: true; font.pixelSize: 12; color: ConfigService.accent }
                        }
                        Rectangle {
                            Layout.fillWidth: true
                            height: 8
                            radius: 4
                            color: ConfigService.surface
                            Rectangle {
                                width: parent.width * (SystemMonitorService.ramUsage / 100)
                                height: parent.height
                                radius: 4
                                color: ConfigService.accent

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
                            Text { text: "󰋊 Root Storage"; font.family: ConfigService.fontFamily; font.pixelSize: 12; color: ConfigService.text }
                            Item { Layout.fillWidth: true }
                            Text { text: SystemMonitorService.diskUsage; font.family: ConfigService.fontFamily; font.bold: true; font.pixelSize: 12; color: ConfigService.green }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: ConfigService.surface
                    }

                    // Quick Actions
                    Text {
                        text: "Quick Toggles"
                        font.family: ConfigService.fontFamily
                        font.bold: true
                        font.pixelSize: 13
                        color: ConfigService.peach
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
                            text: "Noctua-Niri • Sovereign Shell"
                            font.family: ConfigService.fontFamily
                            font.pixelSize: 10
                            color: ConfigService.subtext
                        }
                    }
                }
            }
        }
    }
}
