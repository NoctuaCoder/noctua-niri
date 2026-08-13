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
            width: 340
            height: screen.height - 100
            anchors {
                top: true
                right: true
                topMargin: 70
                rightMargin: 16
            }

            ListView {
                id: notifListView
                anchors.fill: parent
                model: NotificationService.notifications
                spacing: 10
                clip: true

                delegate: Item {
                    width: notifListView.width
                    height: contentCard.height

                    NoctuaCard {
                        id: contentCard
                        width: parent.width
                        height: colLayout.height + 24
                        cardColor: ConfigService.background
                        borderColor: ConfigService.accent
                        cardOpacity: 0.96
                        cardRadius: 16
                        hoverEffect: false

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            // Pausa o auto-dismiss ou apenas interage
                            onEntered: {}
                            onExited: {}
                        }

                        ColumnLayout {
                            id: colLayout
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 8

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 10

                                Image {
                                    width: 22
                                    height: 22
                                    source: modelData.appIcon 
                                        ? (modelData.appIcon.startsWith("/") ? "file://" + modelData.appIcon : "image://icon/" + modelData.appIcon)
                                        : ""
                                    sourceSize.width: 22
                                    sourceSize.height: 22
                                }

                                Text {
                                    text: modelData.appName || "System Notification"
                                    font.family: ConfigService.fontFamily
                                    font.bold: true
                                    font.pixelSize: 13
                                    color: ConfigService.peach
                                    Layout.fillWidth: true
                                }

                                NoctuaButton {
                                    width: 22
                                    height: 22
                                    icon: "󰅖"
                                    baseColor: "transparent"
                                    textColor: ConfigService.subtext
                                    radius: 4
                                    onClicked: {
                                        NotificationService.dismiss(modelData.id)
                                    }
                                }
                            }

                            Text {
                                text: modelData.summary
                                font.family: ConfigService.fontFamily
                                font.bold: true
                                font.pixelSize: 13
                                color: ConfigService.text
                                Layout.fillWidth: true
                                wrapMode: Text.WordWrap
                            }

                            Text {
                                text: modelData.body
                                font.family: ConfigService.fontFamily
                                font.pixelSize: 12
                                color: ConfigService.subtext
                                Layout.fillWidth: true
                                wrapMode: Text.WordWrap
                                visible: modelData.body !== ""
                            }
                        }
                    }

                    Component.onCompleted: {
                        enterAnim.start()
                    }

                    PropertyAnimation {
                        id: enterAnim
                        target: contentCard
                        property: "x"
                        from: 100
                        to: 0
                        duration: 250
                        easing.type: Easing.OutQuad
                    }
                }
            }
        }
    }
}
