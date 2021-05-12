import QtQuick 2.12

Item {
    anchors.fill: parent

    Image {
        id: backGround
        source: "qrc:/res/image/background"
        anchors.fill: parent
    }

    Image {
        id: logo
        source: "qrc:/res/image/logo"
        width: 1024
        height: 512
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -100
    }

    CustButton {
        id: startButton
        implicitWidth: 240
        implicitHeight: 100
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 200
        text: "Start Game"
        font.pixelSize: 30
        font.family: "Arial"
        radius: 20
        color: "#FFC66D"
        borderColor: "#FFA607"
        borderWidth: 8
        rippleColor: "#40FFFFFF"
        shouldRippleCoverBorder: true
        onClicked: changePage("game_page")
    }

    ImageButton {
        id: configButton
        anchors.right: parent.right
        implicitWidth: 64
        implicitHeight: 64
        imagePath: "qrc:/res/image/config"
        imageWidth: 192
        imageHeight: 64
        column: 3
        row: 1
        normalImage: 0
        horverImage: 1
        onclickImage: 2
        onClicked: changePage("config_page")
    }
}
