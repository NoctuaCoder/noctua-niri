import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../services"
import "../../components"

Scope {
    id: root

    property bool isOpen: false

    function toggle() {
        isOpen = !isOpen
    }

    Process {
        id: powerProc
    }

    Variants {
        model: Quickshell.screens
        delegate: PanelWindow {
            id: panel
            screen: modelData
            color: "transparent"
            visible: root.isOpen
            width: screen.width
            height: screen.height

            MouseArea {
                anchors.fill: parent
                enabled: root.isOpen
                onClicked: root.isOpen = false

                Item {
                    width: 400
                    height: 180
                    anchors.centerIn: parent

                    MouseArea {
                        anchors.fill: parent
                        onClicked: mouse.accepted = true
                    }

                    NoctuaCard {
                        anchors.fill: parent
                        cardColor: ConfigService.background
                        borderColor: ConfigService.accent
                        cardOpacity: 0.98
                        cardRadius: 20
                        hoverEffect: false

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 16

                            Text {
                                text: "Session Controls"
                                font.family: ConfigService.fontFamily
                                font.bold: true
                                font.pixelSize: 16
                                color: ConfigService.peach
                                Layout.alignment: Qt.AlignHCenter
                            }

                            GridLayout {
                                Layout.fillWidth: true
                                columns: 2
                                rowSpacing: 12
                                columnSpacing: 12

                                NoctuaButton {
                                    Layout.fillWidth: true
                                    height: 44
                                    icon: "󰌾"
                                    text: "Lock"
                                    radius: 10
                                    onClicked: {
                                        powerProc.command = ["swaylock"]
                                        powerProc.running = true
                                        root.isOpen = false
                                    }
                                }

                                NoctuaButton {
                                    Layout.fillWidth: true
                                    height: 44
                                    icon: "󰍃"
                                    text: "Logout"
                                    radius: 10
                                    onClicked: {
                                        powerProc.command = ["niri", "msg", "action", "quit"]
                                        powerProc.running = true
                                        root.isOpen = false
                                    }
                                }

                                NoctuaButton {
                                    Layout.fillWidth: true
                                    height: 44
                                    icon: "󰜉"
                                    text: "Reboot"
                                    radius: 10
                                    onClicked: {
                                        powerProc.command = ["systemctl", "reboot"]
                                        powerProc.running = true
                                        root.isOpen = false
                                    }
                                }

                                NoctuaButton {
                                    Layout.fillWidth: true
                                    height: 44
                                    icon: "󰐥"
                                    text: "Shutdown"
                                    radius: 10
                                    onClicked: {
                                        powerProc.command = ["systemctl", "poweroff"]
                                        powerProc.running = true
                                        root.isOpen = false
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
