import QtQuick 2.15
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12
import QtGraphicalEffects 1.12

Rectangle {
    anchors.fill: parent
    color: "#00000000"
    property var rippleCenterX: width / 2
    property var rippleCenterY: height / 2
    property var rippleAnimDuration: 200
    property var maskColor: "#C0000000"
    property var blurRadius: 50
    property var blurSource
    property bool enableMaskGrowAnim: true
    property bool enableBlurAnim: true
    property bool isMaskShow: false
    signal show
    signal hide
    signal clicked
    FastBlur {
        source: blurSource
        opacity: blurSource ? 1 : 0
        anchors.fill: parent
        radius: isMaskShow ? blurRadius : 0
        Behavior on radius {
            NumberAnimation {
                duration: enableBlurAnim ? rippleAnimDuration : 0
                easing.type: Easing.InOutQuad
            }
        }
    }
    Rectangle {
        id: ripple
        radius: isMaskShow ? maxRadius : 0
        //计算圆角，使得无论圆心在哪，圆都能够覆盖其parent
        property var maxRadius: Math.sqrt(
                                    Math.pow(Math.max(
                                                 Math.abs(parent.width - rippleCenterX), Math.abs(
                                                     0 - rippleCenterX)),
                                             2) + Math.pow(
                                        Math.max(Math.abs(
                                                     parent.height - rippleCenterY),
                                                 Math.abs(0 - rippleCenterY)), 2))
        width: radius * 2
        height: radius * 2
        x: (-width) / 2 + rippleCenterX
        y: (-height) / 2 + rippleCenterY
        color: maskColor
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            enabled: false
            onClicked: parent.parent.clicked()
        }
        Behavior on radius {
            NumberAnimation {
                duration: enableMaskGrowAnim ? rippleAnimDuration : 0
                easing.type: Easing.InOutQuad
            }
        }
    }
    onShow: {
        mouseArea.enabled = true
        isMaskShow = true
    }
    onHide: {
        mouseArea.enabled = false
        isMaskShow = false
    }
}
