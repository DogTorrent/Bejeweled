import QtQuick 2.0

Item {
    ImageButton {
        id: configButton
        anchors.left: parent.left
        implicitWidth: 64
        implicitHeight: 64
        imagePath: "qrc:/res/image/back"
        imageWidth: 192
        imageHeight: 64
        column: 3
        row: 1
        normalImage: 0
        horverImage: 1
        onclickImage: 2
        onClicked: setMainPage("title_page.qml")
    }

    Image {
        id: backGround
        source: "qrc:/res/image/background" //16:9
        width: 1920
        height: 1080
        //保证居中
        x: -(width / 2 - parent.width / 2)
        y: -(height / 2 - parent.height / 2)
        scale: (parent.width / parent.height >= width
                / height) ? parent.width / width : parent.height / height
    }

    Loader {
        id: stopMenuLoader
        source: "stop_menu.qml"
        anchors.fill: parent
        signal loadStopMenu
        signal closeStopMenu
        onLoadStopMenu: {
            item.show()
        }
        onCloseStopMenu: {
            item.hide()
        }
    }

    FocusScope {
        anchors.fill: parent
        focus: true
        Keys.enabled: true
        Keys.onEscapePressed: {
            stopMenuLoader.item.isMenuShow ? stopMenuLoader.closeStopMenu(
                                                 ) : stopMenuLoader.loadStopMenu()
        }
        Component.onCompleted: forceActiveFocus()
        onActiveFocusChanged: forceActiveFocus()
    }
}
