import QtQuick 2.3
import "component"

Item {

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
        smooth: settings_graphic.enable_smooth
        mipmap: settings_graphic.enable_mipmap
        cache: settings_graphic.enable_cache
    }

    Image {
        id: logo
        source: "qrc:/res/image/logo" //2:1
        width: height * 2
        height: parent.height / 2 - 50
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -height / 2
        smooth: settings_graphic.enable_smooth
        mipmap: settings_graphic.enable_mipmap
        cache: settings_graphic.enable_cache
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
            text: qsTr("开始游戏")
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
            text: qsTr("游戏设置")
            radius: 5
            color: "#E5E5E5"
            borderWidth: 3
            borderColor: "#5D101D"
            rippleColor: "#90FFFFFF"
            shouldRippleCoverBorder: true
            onClicked: pushMainPage("qrc:/qml/config_page.qml")
        }
        CustButton {
            id: rankButton
            width: parent.buttonWidth
            height: parent.buttonHeight
            text: qsTr("分数榜")
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
            text: qsTr("退出游戏")
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
