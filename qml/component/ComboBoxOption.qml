import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

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
        delegate: ItemDelegate {
            parent: option
            width: option.width
            contentItem: Text {
                text: modelData
                font.family: option.font.family
                font.pointSize: option.font.pointSize
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
            highlighted: option.highlightedIndex === index
        }
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
