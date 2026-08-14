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

                Canvas {
                    id: seigaiha
                    anchors.fill: parent
                    anchors.margins: 1
                    opacity: ConfigService.waveOpacity
                    visible: ConfigService.paletteMode !== "off"
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0, 0, width, height)
                        ctx.lineWidth = 1
                        ctx.strokeStyle = ConfigService.waveColor
                        ctx.globalAlpha = 0.86
                        for (var x = -16; x < width + 32; x += 32) {
                            for (var y = 22; y < height + 24; y += 22) {
                                ctx.beginPath()
                                ctx.arc(x, y, 16, Math.PI, 0)
                                ctx.stroke()
                            }
                        }
                        ctx.strokeStyle = ConfigService.waveHighlight
                        ctx.globalAlpha = 0.34
                        for (var hx = 0; hx < width + 32; hx += 32) {
                            ctx.beginPath()
                            ctx.arc(hx, 22, 16, Math.PI, 0)
                            ctx.stroke()
                        }
                    }
                    Component.onCompleted: requestPaint()
                    Connections {
                        target: ConfigService
                        function onWaveColorChanged() { seigaiha.requestPaint() }
                        function onWaveHighlightChanged() { seigaiha.requestPaint() }
                        function onWaveOpacityChanged() { seigaiha.requestPaint() }
                    }
                }

                Item {
                    id: starfield
                    anchors.fill: parent
                    clip: true
                    z: 0

                    property var dots: [
                        [7, 10, 1.1], [14, 29, 0.8], [25, 17, 0.7], [33, 35, 1.0],
                        [43, 8, 0.7], [57, 30, 0.9], [68, 15, 0.8], [79, 35, 0.7],
                        [88, 9, 1.0], [96, 26, 0.8], [6, 37, 0.6], [74, 6, 0.6]
                    ]

                    Repeater {
                        model: starfield.dots
                        delegate: Rectangle {
                            x: modelData[0] / 100 * starfield.width
                            y: modelData[1]
                            width: modelData[2] * 2
                            height: width
                            radius: width / 2
                            color: ConfigService.waveHighlight
                            opacity: 0.28
                            z: 0
                            SequentialAnimation on opacity {
                                loops: Animation.Infinite
                                PauseAnimation { duration: 900 + index * 170 }
                                NumberAnimation { to: 0.82; duration: 650 }
                                NumberAnimation { to: 0.28; duration: 900 }
                            }
                        }
                    }

                    Repeater {
                        model: [18, 52, 84]
                        delegate: Text {
                            x: modelData / 100 * starfield.width - 5
                            y: index % 2 === 0 ? 5 : 25
                            text: "✦"
                            color: index === 1 ? ConfigService.accentBorder : ConfigService.waveColor
                            font.pixelSize: index === 1 ? 10 : 7
                            opacity: 0.34
                            z: 1
                            SequentialAnimation on opacity {
                                loops: Animation.Infinite
                                PauseAnimation { duration: 1200 + index * 300 }
                                NumberAnimation { to: 0.9; duration: 700 }
                                NumberAnimation { to: 0.34; duration: 1000 }
                            }
                        }
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    z: 2
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
