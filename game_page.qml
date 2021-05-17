import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

Item {
    anchors.fill: parent
    Item {
        id: gamePageMain
        anchors.fill: parent
        Image {
            id: backGround
            source: "qrc:/res/image/background" //16:9
            property var aspectRatio: 16 / 9
            width: (parent.width / parent.height
                    >= aspectRatio) ? parent.width : parent.height * aspectRatio
            height: width / aspectRatio
            //保证居中
            x: -(width / 2 - Window.width / 2)
            y: -(height / 2 - Window.height / 2)
        }

        ImagesButton {
            id: stopButton
            anchors.right: parent.right
            implicitWidth: 64
            implicitHeight: 64
            imagePath: "qrc:/res/image/pause"
            column: 3
            row: 1
            normalImage: 0
            horverImage: 1
            onclickImage: 2
            onClicked: stopMenuLoader.item.show()
        }

        Loader {
            id: gameBoardLoader
            source: "game_board.qml"
            asynchronous: true

            width: Math.min(parent.width, parent.height) * 4 / 5
            height: width
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
        }
    }

    Loader {
        id: stopMenuLoader
        anchors.fill: parent
        signal loadStopMenu
        signal closeStopMenu
        Component.onCompleted: setSource("stop_menu.qml", {
                                             "bottomLayerComponent": gamePageMain
                                         })

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
            stopMenuLoader.item.enabled ? stopMenuLoader.closeStopMenu(
                                              ) : stopMenuLoader.loadStopMenu()
        }
        Component.onCompleted: forceActiveFocus()
        onActiveFocusChanged: forceActiveFocus()
    }
}
