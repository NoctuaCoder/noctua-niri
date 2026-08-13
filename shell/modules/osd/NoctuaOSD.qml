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

    // Monitora alterações de volume do AudioService para disparar o OSD automaticamente
    Connections {
        target: AudioService
        function onVolumeChanged() {
            root.show("Volume", AudioService.muted ? "󰝟" : "󰕾", AudioService.volume)
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
