import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12
import QtGraphicalEffects 1.12

RoundButton {
    implicitWidth: 240
    implicitHeight: 100
    font.family: "Arial"
    radius: 20
    property var color: "#FFC66D"
    property var borderColor: "#FFA607"
    property var borderWidth: 2
    property var rippleColor: "#40FFFFFF"
    property bool shouldRippleCoverBorder: true
    background: Rectangle {
        width: parent.width
        height: parent.height
        radius: parent.radius
        color: parent.color
        border.width: parent.borderWidth
        border.color: parent.borderColor
    }
    Ripple {
        id: ripple
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: shouldRippleCoverBorder ? parent.width : parent.width - parent.borderWidth * 2
        height: shouldRippleCoverBorder ? parent.height : parent.height - parent.borderWidth * 2
        pressed: parent.pressed
        active: parent.down || parent.visualFocus || parent.hovered
        color: parent.rippleColor
        property var radius: shouldRippleCoverBorder ? parent.radius : parent.radius
                                                       - parent.borderWidth
        clipRadius: radius
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: ripple.width
                height: ripple.height
                radius: ripple.radius
            }
        }
    }
}
