import QtQuick 2.0
import QtQuick.Window 2.1
import "component"

Item {
    id: stopMenu
    anchors.fill: parent

    enabled: false
    property var animationDuration: 230
    property var bottomLayerComponent

    signal show
    signal hide

    onShow: enabled = true
    onHide: enabled = false

    PopupMask {
        id: stopMenuMask
        anchors.fill: parent
        rippleCenterX: parent.width
        rippleCenterY: 0
        animationDuration: stopMenu.animationDuration
        maskColor: "#A0000000"
        enableMaskGrowAnim: true
        enableBlurAnim: true
        blurRadius: 60
        blurSource: bottomLayerComponent
        enabled: stopMenu.enabled
    }

    Column {
        id: buttonColumn
        spacing: 15
        property var buttonWidth: 300
        property var buttonHeight: 80
        property var buttonNum: 3
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: stopMenu.enabled ? 1 : 0
        enabled: stopMenu.enabled

        Behavior on opacity {
            NumberAnimation {
                duration: stopMenu.animationDuration
                easing.type: Easing.InOutQuad
            }
        }

        CustButton {
            text: qsTr("🏃‍ 标题界面")
            //            font.family: "Microsoft Yahei"
            //            font.pixelSize: 25
            font.pointSize: 18
            width: parent.buttonWidth
            height: parent.buttonHeight
            radius: height / 2
            color: "#B0FFFFFF"
            borderColor: "#C0FFFFFF"
            rippleColor: "#D0FFFFFF"
            x: stopMenu.enabled ? 0 : 20
            enabled: stopMenu.enabled
            Behavior on x {
                NumberAnimation {
                    duration: stopMenu.animationDuration
                    easing.type: Easing.InOutQuad
                }
            }
            onClicked: setMainPage("qrc:/qml/title_page.qml")
        }
        CustButton {
            text: qsTr("⚙ 游戏设置")
            //            font.family: "Microsoft Yahei"
            //            font.pixelSize: 25
            font.pointSize: 18
            width: parent.buttonWidth
            height: parent.buttonHeight
            radius: height / 2
            color: "#B0FFFFFF"
            borderColor: "#C0FFFFFF"
            rippleColor: "#D0FFFFFF"
            x: stopMenu.enabled ? 0 : 40
            enabled: stopMenu.enabled
            Behavior on x {
                NumberAnimation {
                    duration: stopMenu.animationDuration
                    easing.type: Easing.InOutQuad
                }
            }
            onClicked: pushMainPage("qrc:/qml/config_page.qml")
        }
        CustButton {
            text: qsTr("🎮 继续游戏")
            //            font.family: "Microsoft Yahei"
            //            font.pixelSize: 25
            font.pointSize: 18
            width: parent.buttonWidth
            height: parent.buttonHeight
            radius: height / 2
            color: "#B0FFFFFF"
            borderColor: "#C0FFFFFF"
            rippleColor: "#D0FFFFFF"
            x: stopMenu.enabled ? 0 : 60
            enabled: stopMenu.enabled
            Behavior on x {
                NumberAnimation {
                    duration: stopMenu.animationDuration
                    easing.type: Easing.InOutQuad
                }
            }
            onClicked: stopMenu.hide()
        }
    }

    Loader {
        id: configPageLoader
        asynchronous: false
        source: ""
        anchors.fill: parent
        signal open
        signal close
        onOpen: {
            source = "qrc:/qml/config_page.qml"
        }
        onClose: {
            source = ""
        }
    }
}
