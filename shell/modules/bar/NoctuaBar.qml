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
            height: 190
            anchors {
                top: true
                left: true
                right: true
                topMargin: 12
                leftMargin: 16
                rightMargin: 16
            }

            NoctuaCard {
                id: rail
                x: 0
                y: 0
                width: parent.width
                height: 44
                cardColor: ConfigService.background
                borderColor: ConfigService.accent
                cardOpacity: ConfigService.shellOpacity
                cardRadius: 18
                hoverEffect: false

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 8

                    NoctuaRailModule {
                        compactWidth: 42
                        expandedWidth: 104
                        icon: ""
                        value: ""
                        details: "LAUNCH"
                        accentColor: ConfigService.blue
                        onClicked: launcherProc.running = true
                    }

                    Process {
                        id: launcherProc
                        command: ["sh", "-c", "touch /tmp/noctua_toggle"]
                    }

                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: 20
                        color: ConfigService.surfaceHover
                    }

                    RowLayout {
                        spacing: 5
                        Repeater {
                            model: NiriService.workspaces
                            delegate: Rectangle {
                                Layout.preferredWidth: modelData.is_active ? 34 : 30
                                Layout.preferredHeight: 30
                                radius: 15
                                color: modelData.is_active ? ConfigService.accent : (wsMouse.containsMouse ? ConfigService.surfaceHover : ConfigService.surface)
                                border.width: 1
                                border.color: modelData.is_active ? ConfigService.accentBorder : ConfigService.surfaceHover

                                Behavior on color { ColorAnimation { duration: 120 } }
                                Behavior on Layout.preferredWidth { NumberAnimation { duration: 120 } }

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.idx
                                    color: modelData.is_active ? ConfigService.background : ConfigService.text
                                    font.family: ConfigService.fontFamily
                                    font.pixelSize: 11
                                    font.bold: true
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

                    Rectangle {
                        Layout.preferredWidth: 126
                        Layout.preferredHeight: 30
                        radius: 15
                        color: ConfigService.surface
                        border.width: 1
                        border.color: ConfigService.peach

                        Row {
                            anchors.centerIn: parent
                            spacing: 8
                            Text {
                                text: "✦"
                                color: ConfigService.peach
                                font.pixelSize: 12
                            }
                            Text {
                                id: clockText
                                text: Qt.formatTime(new Date(), "hh:mm")
                                color: ConfigService.peach
                                font.family: ConfigService.fontFamily
                                font.pixelSize: 12
                                font.bold: true
                            }
                            Timer {
                                interval: 1000
                                running: true
                                repeat: true
                                onTriggered: clockText.text = Qt.formatTime(new Date(), "hh:mm")
                            }
                        }
                    }

                    Item { Layout.fillWidth: true }

                    NoctaliaRailModule {
                        compactWidth: 42
                        expandedWidth: 112
                        icon: AudioService.muted ? "󰝟" : "󰕾"
                        value: AudioService.volume + "%"
                        details: AudioService.muted ? "MUTED" : "VOL " + AudioService.volume + "%"
                        accentColor: AudioService.muted ? ConfigService.red : ConfigService.blue
                        onClicked: AudioService.toggleMute()
                    }

                    NoctaliaRailModule {
                        compactWidth: 42
                        expandedWidth: 116
                        icon: "󰘚"
                        value: SystemMonitorService.cpuUsage + "%"
                        details: "CPU " + SystemMonitorService.cpuUsage + "%"
                        accentColor: ConfigService.peach
                    }

                    NoctaliaRailModule {
                        compactWidth: 42
                        expandedWidth: 116
                        icon: "󰍛"
                        value: SystemMonitorService.ramUsage + "%"
                        details: "RAM " + SystemMonitorService.ramUsage + "%"
                        accentColor: ConfigService.accent
                    }

                    NoctaliaRailModule {
                        compactWidth: 42
                        expandedWidth: 112
                        visible: BatteryService.hasBattery
                        icon: "󰁹"
                        value: BatteryService.capacity + "%"
                        details: "BAT " + BatteryService.capacity + "%"
                        accentColor: ConfigService.green
                    }

                    NoctaliaRailModule {
                        compactWidth: 42
                        expandedWidth: 122
                        icon: NetworkService.connected ? "󰖩" : "󰖪"
                        value: ""
                        details: NetworkService.connectionType.toUpperCase()
                        accentColor: NetworkService.connected ? ConfigService.green : ConfigService.red
                    }
                }
            }
        }
    }
}
