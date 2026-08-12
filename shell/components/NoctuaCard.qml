import QtQuick

Rectangle {
    id: root

    property alias contentItem: container.data
    property color cardColor: "#1e1e2e"
    property color borderColor: "#cba6f7"
    property real cardOpacity: 0.88
    property int cardRadius: 16
    property bool hoverEffect: true

    signal clicked()

    color: cardColor
    opacity: cardOpacity
    radius: cardRadius
    border.width: 1
    border.color: mouseArea.containsMouse && hoverEffect ? "#f5e0dc" : borderColor

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
