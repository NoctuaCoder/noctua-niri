import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../services"
import "../../components"

Scope {
    id: root

    property bool isLocked: false

    function lock() {
        isLocked = true
    }

    function unlock() {
        isLocked = false
    }

    // Monitora gatilho de lock / Alt+L
    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: lockCheckProc.running = true
    }

    Process {
        id: lockCheckProc
        command: ["sh", "-c", "if [ -f /tmp/noctua_lock_toggle ]; then rm /tmp/noctua_lock_toggle && echo 'LOCK'; fi"]
        stdout: SplitParser {
            onRead: data => {
                if (data.trim() === "LOCK") {
                    root.lock()
                }
            }
        }
    }

    Variants {
        model: Quickshell.screens
        delegate: PanelWindow {
            id: panel
            screen: modelData
            color: ConfigService.background
            visible: root.isLocked
            width: screen.width
            height: screen.height
            // Fica acima de tudo
            exclusionMode: ExclusionMode.Ignore
            z: 99999

            Item {
                anchors.fill: parent

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 24
                    alignment: Qt.AlignHCenter

                    // Relógio gigante
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: Qt.formatTime(new Date(), "hh:mm")
                        font.family: ConfigService.fontFamily
                        font.bold: true
                        font.pixelSize: 72
                        color: ConfigService.text

                        Timer {
                            interval: 1000
                            running: true
                            repeat: true
                            onTriggered: parent.text = Qt.formatTime(new Date(), "hh:mm")
                        }
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: Qt.formatDate(new Date(), "dddd, MMMM d")
                        font.family: ConfigService.fontFamily
                        font.pixelSize: 18
                        color: ConfigService.subtext
                    }

                    // Card de Senha / PIN
                    NoctuaCard {
                        Layout.preferredWidth: 320
                        Layout.preferredHeight: 52
                        cardColor: ConfigService.surface
                        borderColor: ConfigService.accent
                        cardOpacity: 0.95
                        cardRadius: 14
                        hoverEffect: false

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            spacing: 12

                            Text {
                                text: "󰌾"
                                font.family: ConfigService.fontFamily
                                font.pixelSize: 18
                                color: ConfigService.accent
                            }

                            TextInput {
                                id: passInput
                                Layout.fillWidth: true
                                font.family: ConfigService.fontFamily
                                font.pixelSize: 15
                                color: ConfigService.text
                                echoMode: TextInput.Password
                                focus: root.isLocked

                                Keys.onReturnPressed: {
                                    // Simulação de desbloqueio bem-sucedido ou chamada PAM futura
                                    root.unlock()
                                    text = ""
                                }
                            }
                        }
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Press Enter to unlock"
                        font.family: ConfigService.fontFamily
                        font.pixelSize: 12
                        color: ConfigService.subtext
                    }
                }
            }
        }
    }
}
