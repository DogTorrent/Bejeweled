import QtQuick 2.15
import QtQuick.Window 2.12

Item {
    id: stopMenu
    anchors.fill: parent

    property bool isMenuShow: false

    signal show
    signal hide

    onShow: {
        stopMenuMask.show()
        buttonColume.show()
    }

    onHide: {
        stopMenuMask.hide()
        buttonColume.hide()
    }

    PopupMask {
        id: stopMenuMask
        anchors.fill: parent
        rippleCenterX: parent.width
        rippleCenterY: 0
        rippleAnimDuration: 230
        maskColor: "#A0000000"
        enableMaskGrowAnim: true
        enableBlurAnim: true
        blurRadius: 60
        blurSource: backGround
    }

    Column {
        id: buttonColume
        spacing: 15
        property var buttonWidth: 300
        property var buttonHeight: 80
        property var buttonNum: 3
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: parent.isMenuShow ? 1 : 0

        signal show
        signal hide
        onShow: parent.isMenuShow = true
        onHide: parent.isMenuShow = false

        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }

        CustButton {
            text: qsTr("🏃‍ 标题界面")
            font.family: "Microsoft Yahei"
            font.pixelSize: 25
            width: parent.buttonWidth
            height: parent.buttonHeight
            radius: height / 2
            color: "#B0FFFFFF"
            borderColor: "#C0FFFFFF"
            rippleColor: "#D0FFFFFF"
            x: stopMenu.isMenuShow ? 0 : 20
            Behavior on x {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
            onClicked: setMainPage("title_page.qml")
        }
        CustButton {
            text: qsTr("⚙ 游戏设置")
            font.family: "Microsoft Yahei"
            font.pixelSize: 25
            width: parent.buttonWidth
            height: parent.buttonHeight
            radius: height / 2
            color: "#B0FFFFFF"
            borderColor: "#C0FFFFFF"
            rippleColor: "#D0FFFFFF"
            x: stopMenu.isMenuShow ? 0 : 40
            Behavior on x {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
            onClicked: {

            }
        }
        CustButton {
            text: qsTr("🎮 继续游戏")
            font.family: "Microsoft Yahei"
            font.pixelSize: 25
            width: parent.buttonWidth
            height: parent.buttonHeight
            radius: height / 2
            color: "#B0FFFFFF"
            borderColor: "#C0FFFFFF"
            rippleColor: "#D0FFFFFF"
            x: stopMenu.isMenuShow ? 0 : 60
            Behavior on x {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
            onClicked: stopMenu.hide()
        }
    }
}
