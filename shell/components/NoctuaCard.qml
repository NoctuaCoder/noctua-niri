import QtQuick
import "../services"

Rectangle {
    id: root

    property alias contentItem: container.data
    property color cardColor: ConfigService.background
    property color borderColor: ConfigService.accent
    property real cardOpacity: ConfigService.shellOpacity
    property int cardRadius: ConfigService.shellRadius
    property bool hoverEffect: true

    signal clicked()

    color: cardColor
    opacity: cardOpacity
    radius: cardRadius
    border.width: 1
    border.color: mouseArea.containsMouse && hoverEffect ? ConfigService.accentBorder : borderColor

    Behavior on border.color {
        ColorAnimation { duration: 200 }
    }

    Item {
        id: container
        anchors.fill: parent
        anchors.margins: 12
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: hoverEffect
        onClicked: root.clicked()
    }
}
