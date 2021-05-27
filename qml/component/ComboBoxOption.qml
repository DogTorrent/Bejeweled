import QtQuick 2.0
import QtQuick.Controls 2.0

Item {
    property alias titleText: title
    property alias optionComboBox: option
    property alias backgroundRec: background
    property alias recMouseArea: mouseArea
    Rectangle {
        id: background
        anchors.fill: parent
    }
    Text {
        id: title
        x: parent.width / 8
        width: parent.width / 4
        anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignVCenter
    }
    ComboBox {
        id: option
        x: parent.width * 5 / 8
        width: parent.width / 4
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: 12
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
        onClicked: mouse.accepted = false
        onPressed: mouse.accepted = false
    }
}
