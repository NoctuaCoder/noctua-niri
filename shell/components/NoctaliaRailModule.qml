import QtQuick
import "../services"

Rectangle {
    id: root

    property string icon: ""
    property string label: ""
    property string value: ""
    property string details: ""
    property color accentColor: ConfigService.blue
    property int compactWidth: 42
    property int expandedWidth: 118

    width: mouse.containsMouse ? expandedWidth : compactWidth
    height: 32
    radius: 16
    color: mouse.containsMouse ? ConfigService.surfaceHover : ConfigService.surface
    border.width: 1
    border.color: mouse.containsMouse ? accentColor : ConfigService.surfaceHover

    Behavior on width { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
    Behavior on color { ColorAnimation { duration: 120 } }
    Behavior on border.color { ColorAnimation { duration: 120 } }

    Row {
        anchors.centerIn: parent
        spacing: 7

        Text {
            text: root.icon
            color: root.accentColor
            font.family: ConfigService.fontFamily
            font.pixelSize: 15
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: mouse.containsMouse ? root.details : root.value
            color: ConfigService.text
            font.family: ConfigService.fontFamily
            font.pixelSize: 11
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            elide: Text.ElideRight
            maximumLineCount: 1
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }

    signal clicked()
}
