import QtQuick
import "../services"

Rectangle {
    id: root

    property string text: ""
    property string icon: ""
    property color baseColor: ConfigService.surface
    property color hoverColor: ConfigService.surfaceHover
    property color textColor: ConfigService.text
    property int radius: 10

    signal clicked()

    width: 100
    height: 36
    color: mouseArea.containsMouse ? hoverColor : baseColor
    radius: root.radius
    border.width: 1
    border.color: mouseArea.containsMouse ? ConfigService.accent : ConfigService.surfaceHover

    Behavior on color {
        ColorAnimation { duration: 150 }
    }

    Row {
        anchors.centerIn: parent
        spacing: 6

        Text {
            text: root.icon
            font.family: ConfigService.fontFamily
            font.pixelSize: 14
            color: root.textColor
            visible: root.icon !== ""
        }

        Text {
            text: root.text
            font.family: ConfigService.fontFamily
            font.pixelSize: 12
            font.bold: true
            color: root.textColor
            visible: root.text !== ""
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
}
