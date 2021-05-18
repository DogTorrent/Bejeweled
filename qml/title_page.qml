import QtQuick 2.0
import "component"

Item {
    anchors.fill: parent

    Image {
        id: backGround
        source: "qrc:/res/image/background" //16:9
        property var aspectRatio: 16 / 9
        width: (parent.width / parent.height
                >= aspectRatio) ? parent.width : parent.height * aspectRatio
        height: width / aspectRatio
        //保证居中
        x: -(width / 2 - parent.width / 2)
        y: -(height / 2 - parent.height / 2)
    }

    Image {
        id: logo
        source: "qrc:/res/image/logo" //2:1
        width: height * 2
        height: parent.height / 2 - 50
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -height / 2
    }

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: (buttonHeight + spacing) * 4 / 2 + 50
        property var buttonWidth: 240
        property var buttonHeight: Math.min(
                                       60,
                                       (parent.height / 2 - 50) / 4 - spacing)
        spacing: 10

        CustButton {
            id: startButton
            width: parent.buttonWidth
            height: parent.buttonHeight
            text: "开始游戏"
            font.pixelSize: 30
            font.family: "Microsoft Yahei"
            radius: 5
            color: "#FFA607"
            borderWidth: 3
            borderColor: "#5D101D"
            rippleColor: "#60FFFFFF"
            shouldRippleCoverBorder: true
            onClicked: setMainPage("qrc:/qml/game_page.qml")
        }
        CustButton {
            id: configButton
            width: parent.buttonWidth
            height: parent.buttonHeight
            text: "游戏设置"
            font.pixelSize: 30
            font.family: "Microsoft Yahei"
            radius: 5
            color: "#E5E5E5"
            borderWidth: 3
            borderColor: "#5D101D"
            rippleColor: "#90FFFFFF"
            shouldRippleCoverBorder: true
            onClicked: setMainPage("qrc:/qml/config_page.qml")
        }
        CustButton {
            id: rankButton
            width: parent.buttonWidth
            height: parent.buttonHeight
            text: "分数榜"
            font.pixelSize: 30
            font.family: "Microsoft Yahei"
            radius: 5
            color: "#E5E5E5"
            borderWidth: 3
            borderColor: "#5D101D"
            rippleColor: "#90FFFFFF"
            shouldRippleCoverBorder: true
            onClicked: {

            }
        }
        CustButton {
            id: exitButton
            width: parent.buttonWidth
            height: parent.buttonHeight
            text: "退出游戏"
            font.pixelSize: 30
            font.family: "Microsoft Yahei"
            radius: 5
            color: "#E5E5E5"
            borderWidth: 3
            borderColor: "#5D101D"
            rippleColor: "#90FFFFFF"
            shouldRippleCoverBorder: true
            onClicked: Qt.quit()
        }
    }
}
