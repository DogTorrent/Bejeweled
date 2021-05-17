import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: mask
    anchors.fill: parent
    color: "#00000000"
    property var rippleCenterX: width / 2
    property var rippleCenterY: height / 2
    property var animationDuration: 200
    property var maskColor: "#C0000000"
    property var blurRadius: 50
    property var blurSource
    property bool enableMaskGrowAnim: true
    property bool enableBlurAnim: true
    enabled: false
    signal show
    signal hide
    signal clicked
    FastBlur {
        id: fastBlur
        source: blurSource
        opacity: source && mask.enabled ? 1 : 0
        width: source ? source.width : 0
        height: source ? source.height : 0
        x: source ? source.x : 0
        y: source ? source.y : 0
        scale: source ? source.scale : 0
        radius: enabled ? blurRadius : 0
        Behavior on radius {
            NumberAnimation {
                duration: enableBlurAnim ? animationDuration : 0
                easing.type: Easing.InOutQuad
            }
        }
    }
    Rectangle {
        id: ripple
        radius: mask.enabled ? maxRadius : 0
        //计算圆角，使得无论圆心在哪，圆都能够覆盖其parent
        property var maxRadius: Math.sqrt(
                                    Math.pow(Math.max(
                                                 Math.abs(mask.width
                                                          - mask.rippleCenterX), Math.abs(
                                                     0 - mask.rippleCenterX)),
                                             2) + Math.pow(
                                        Math.max(Math.abs(
                                                     mask.height - mask.rippleCenterY),
                                                 Math.abs(0 - mask.rippleCenterY)), 2))
        width: radius * 2
        height: radius * 2
        x: (-width) / 2 + mask.rippleCenterX
        y: (-height) / 2 + mask.rippleCenterY
        color: maskColor
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            enabled: mask.enabled
            onClicked: mask.clicked()
        }
        Behavior on radius {
            NumberAnimation {
                duration: mask.enableMaskGrowAnim ? mask.animationDuration : 0
                easing.type: Easing.InOutQuad
            }
        }
    }
    onShow: enabled = true
    onHide: enabled = false
}
