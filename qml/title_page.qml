import QtQuick 2.3
import "component"

Item {

    Loader {
        id: backGround
        anchors.fill: parent
        source: "qrc:/qml/back_ground.qml"
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
            text: qsTr("START")

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
            text: qsTr("CONFIG")
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
            text: qsTr("SCORE")
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
            text: qsTr("EXIT")
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
