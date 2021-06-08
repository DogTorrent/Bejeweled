import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.1
import "component"

Item {
    Item {
        id: gamePageMain
        anchors.fill: parent

        Loader {
            id: backGround
            anchors.fill: parent
            source: "qrc:/qml/back_ground.qml"
        }

        Loader {
            id: gameBoardLoader
            source: "qrc:/qml/game_board.qml"
            asynchronous: true

            width: Math.min(parent.width, parent.height) * 4 / 5
            height: width
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
        }

        ProgressBar {
            id: timeLimitBar
            minimumValue: 0
            maximumValue: 100
            value: 100
            orientation: Qt.Vertical
            width: 30
            height: gameBoardLoader.height
            x: (parent.width + gameBoardLoader.x + gameBoardLoader.width - width) / 2
            y: gameBoardLoader.y
            style: ProgressBarStyle {
                background: Rectangle {
                    radius: 2
                    color: "#A0515151"
                    border.color: "#5D101D"
                    border.width: 2
                }
                progress: Rectangle {
                    color: "orange"
                    border.color: "#5D101D"
                    border.width: 2
                }
            }
            Timer {
                id: timeLimitBarTimer
                interval: 50
                repeat: true
                running: true
                onTriggered: {
                    timeLimitBar.value -= 0.1
                }
            }
        }

        ImagesButton {
            id: stopButton
            anchors.right: parent.right
            implicitWidth: 64
            implicitHeight: 64
            imagePath: "qrc:/res/image/pause"
            column: 3
            rowCount: 1
            normalImage: 0
            horverImage: 1
            onclickImage: 2
            onClicked: stopMenuLoader.loadStopMenu()
            smooth: settings_graphic.enable_smooth
            mipmap: settings_graphic.enable_mipmap
            cache: settings_graphic.enable_cache
        }
    }

    Loader {
        id: stopMenuLoader
        anchors.fill: parent
        signal loadStopMenu
        signal closeStopMenu
        asynchronous: true
        Component.onCompleted: setSource("qrc:/qml/stop_menu.qml", {
                                             "bottomLayerComponent": gamePageMain
                                         })

        onLoadStopMenu: {
            timeLimitBarTimer.stop()
            item.show()
        }
        onCloseStopMenu: {
            timeLimitBarTimer.start()
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

    Component.onCompleted: GameService.gameInit()
}
