import Quickshell
import QtQuick
import QtQuick.Layouts

Scope {
    id: root

    // Painel flutuante superior com estilo Glassmorphism supremo
    Variants {
        model: Quickshell.screens
        delegate: PanelWindow {
            id: panel
            screen: modelData
            color: "transparent"
            width: screen.width - 32
            height: 40
            anchors {
                top: true
                left: true
                right: true
                topMargin: 12
                leftMargin: 16
                rightMargin: 16
            }

            Rectangle {
                anchors.fill: parent
                color: "#1e1e2e"
                opacity: 0.75
                radius: 16
                border.width: 1
                border.color: "#cba6f7" // Gradiente/Borda Catppuccin Mauve

                // Conteúdo da barra
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 12

                    // Logo / Launcher button
                    Text {
                        text: ""
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 18
                        color: "#89b4fa"
                    }

                    Text {
                        text: "Noctua-Niri"
                        font.family: "JetBrainsMono Nerd Font"
                        font.bold: true
                        font.pixelSize: 13
                        color: "#cdd6f4"
                    }

                    Item { Layout.fillWidth: true }

                    // Relógio central com estética neon pastel
                    Rectangle {
                        Layout.preferredWidth: 120
                        Layout.preferredHeight: 28
                        color: "#313244"
                        radius: 8
                        border.width: 1
                        border.color: "#fab387"

                        Text {
                            anchors.centerIn: parent
                            text: Qt.formatTime(new Date(), "hh:mm:ss")
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            font.bold: true
                            color: "#fab387"

                            Timer {
                                interval: 1000
                                running: true
                                repeat: true
                                onTriggered: parent.text = Qt.formatTime(new Date(), "hh:mm:ss")
                            }
                        }
                    }

                    Item { Layout.fillWidth: true }

                    // Indicador de Status / Bateria / Audio
                    RowLayout {
                        spacing: 8
                        Text {
                            text: "󰖩 Conectado"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            color: "#a6e3a1"
                        }
                        Text {
                            text: "󰕾 80%"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            color: "#89b4fa"
                        }
                    }
                }
            }
        }
    }
}
