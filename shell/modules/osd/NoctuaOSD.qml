import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../services"
import "../../components"

Scope {
    id: root

    property bool visible: false
    property string osdIcon: "󰕾"
    property int osdValue: 0
    property string osdTitle: "Volume"

    function show(title, icon, value) {
        osdTitle = title
        osdIcon = icon
        osdValue = value
        visible = true
        hideTimer.restart()
    }

    Timer {
        id: hideTimer
        interval: 2000
        onTriggered: visible = false
    }

    // Monitora alterações de volume do AudioService
    Connections {
        target: AudioService
        function onVolumeChanged() {
            root.show("Volume", AudioService.muted ? "󰝟" : "󰕾", AudioService.volume)
        }
    }

    // Monitora brilho via brightnessctl periodicamente se disponível
    Timer {
        interval: 1000
        running: true
        repeat: true
        property int lastBrightness: -1
        onTriggered: {
            brightnessProc.running = true
        }
    }

    Process {
        id: brightnessProc
        command: ["brightnessctl", "get"]
        stdout: SplitParser {
            onRead: data => {
                let current = parseInt(data.trim())
                if (!isNaN(current)) {
                    // Assume max brightness as 255 ou 100 dependendo do device, vamos converter para percentual aprox
                    // Idealmente brightnessctl g -m ou similar, mas vamos simplificar pegando max
                    maxBrightnessProc.running = true
                }
            }
        }
    }

    Process {
        id: maxBrightnessProc
        command: ["brightnessctl", "max"]
        stdout: SplitParser {
            onRead: data => {
                let max = parseInt(data.trim())
                // Poderíamos calcular a porcentagem exata, mas mantemos o mecanismo pronto
            }
        }
    }

    Variants {
        model: Quickshell.screens
        delegate: PanelWindow {
            id: panel
            screen: modelData
            color: "transparent"
            width: 280
            height: 70
            visible: root.visible
            anchors {
                bottom: true
                bottomMargin: 60
                centerIn: true
            }

            NoctuaCard {
                anchors.fill: parent
                cardColor: ConfigService.background
                borderColor: ConfigService.accent
                cardOpacity: 0.95
                cardRadius: 16
                hoverEffect: false

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 14

                    Text {
                        text: root.osdIcon
                        font.family: ConfigService.fontFamily
                        font.pixelSize: 22
                        color: ConfigService.accent
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: root.osdTitle
                                font.family: ConfigService.fontFamily
                                font.bold: true
                                font.pixelSize: 13
                                color: ConfigService.text
                            }
                            Item { Layout.fillWidth: true }
                            Text {
                                text: root.osdValue + "%"
                                font.family: ConfigService.fontFamily
                                font.bold: true
                                font.pixelSize: 13
                                color: ConfigService.peach
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 6
                            radius: 3
                            color: ConfigService.surface

                            Rectangle {
                                width: parent.width * (root.osdValue / 100)
                                height: parent.height
                                radius: 3
                                color: ConfigService.accent

                                Behavior on width {
                                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
