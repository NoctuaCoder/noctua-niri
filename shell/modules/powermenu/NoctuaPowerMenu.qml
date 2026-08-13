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

    Timer {
        interval: 100
        running: true
        repeat: true
        triggeredOnStart: false
        onTriggered: {
            checkPowerProc.running = true
        }
    }

    Process {
        id: checkPowerProc
        command: ["sh", "-c", "if [ -f /tmp/noctua_power_toggle ]; then rm /tmp/noctua_power_toggle && echo 'TOGGLE_POWER'; fi"]
        stdout: SplitParser {
            onRead: data => {
                if (data.trim() === "TOGGLE_POWER") {
                    root.toggle()
                }
            }
        }
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
                                        powerProc.command = ["sh", "-c", "touch /tmp/noctua_lock_toggle"]
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
