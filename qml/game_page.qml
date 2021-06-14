import QtQuick 2.15
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.1
import "component"

Item {
    id: gamePage
    property string mode: "Normal"
    property int level: 1
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
            property alias mode: gamePage.mode

            width: Math.min(parent.width, parent.height) * 4 / 5
            height: width
            x: (parent.width * 3 / 5 - width / 2)
            y: (parent.height - height) / 2
            Component.onCompleted: setSource("qrc:/qml/game_board.qml", {
                                                 "mode": gamePage.mode
                                             })
        }

        ProgressBar {
            id: timeLimitBar
            minimumValue: 0
            maximumValue: 100
            value: mode === "Challengr" ? 0 : 100
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
                    color: timeLimitBar.value > 75 ? "lightgreen" : timeLimitBar.value
                                                     > 25 ? "orange" : "red"
                    border.color: "#5D101D"
                    border.width: 2
                }
            }
            function addTime() {
                timeLimitBar.value += 4
            }

            Timer {
                id: timeLimitBarTimer
                interval: 50
                repeat: true
                running: true
                onTriggered: {
                    switch (gamePage.mode) {
                    case "Normal":
                        timeLimitBar.value -= 0.1
                        break
                    case "Hard":
                        timeLimitBar.value -= 0.2
                        break
                    case "Challenge":
                        timeLimitBar.value -= (0.05 + level * 0.01)
                        break
                    }
                }
            }
            onValueChanged: {
                if (timeLimitBar.value == timeLimitBar.maximumValue
                        && mode == "Challenge") {
                    levelEndPanelLoader.loadSuccessPanel()
                } else if (timeLimitBar.value == timeLimitBar.minimumValue
                           && (mode == "Normal" || mode == "Hard")) {
                    levelEndPanelLoader.loadFailedPanel()
                }
            }
        }

        Rectangle {
            id: gameInfoPanel
            width: Math.min(gameBoardLoader.x - 100, parent.width / 4)
            height: gameBoardLoader.height
            x: (gameBoardLoader.x - width) / 2
            y: gameBoardLoader.y
            clip: true
            color: "#A0515151"
            border.color: "#5D101D"
            Column {
                anchors.fill: parent
                spacing: 20
                padding: 20
                Image {
                    source: "qrc:/res/image/logo" //2:1
                    width: parent.width - 2 * parent.padding
                    height: width / 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    smooth: settings_graphic.enable_smooth
                    mipmap: settings_graphic.enable_mipmap
                    cache: settings_graphic.enable_cache
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Mode") + ": " + mode
                    font.family: settings_other.font_family
                    font.pointSize: settings_other.font_pt_size
                    color: "orange"
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: mode === "Challenge" ? (qsTr("Level") + ": "
                                                  + level) : (qsTr("Score") + ": "
                                                              + GameService.score)
                    font.family: settings_other.font_family
                    font.pointSize: settings_other.font_pt_size
                    color: "orange"
                }
                CustButton {
                    width: parent.width - 2 * parent.padding
                    height: Math.min(80, parent.width / 5)
                    text: qsTr("Hint")
                    radius: 5
                    color: "#FFA607"
                    borderWidth: 3
                    borderColor: "#5D101D"
                    rippleColor: "#60FFFFFF"
                    shouldRippleCoverBorder: true
                    onClicked: {
                        var hintResult = GameService.getHint()
                        gameBoardLoader.item.hint(hintResult.x, hintResult.y)
                    }
                }
                CustButton {
                    width: parent.width - 2 * parent.padding
                    height: Math.min(80, parent.width / 5)
                    text: qsTr("Restart")
                    radius: 5
                    color: "#FFA607"
                    borderWidth: 3
                    borderColor: "#5D101D"
                    rippleColor: "#60FFFFFF"
                    shouldRippleCoverBorder: true
                    onClicked: loadGame(mode, 1)
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
            gameBoardLoader.enabled = false
            gameInfoPanel.enabled = false
            item.show()
            SoundService.playPausedBgm()
        }
        onCloseStopMenu: {
            timeLimitBarTimer.start()
            gameBoardLoader.enabled = true
            gameInfoPanel.enabled = true
            item.hide()
            SoundService.playLastBgm()
        }
    }

    Loader {
        id: levelEndPanelLoader
        signal loadSuccessPanel
        signal loadFailedPanel
        signal closePanel
        asynchronous: true
        anchors.fill: parent

        onLoadSuccessPanel: {
            if (source == "") {
                gameBoardLoader.enabled = false
                gameInfoPanel.enabled = false
                timeLimitBarTimer.stop()
                setSource("qrc:/qml/success_panel.qml", {
                              "bottomLayerComponent": gamePageMain
                          })
            }
        }
        onLoadFailedPanel: {
            if (source == "") {
                gameBoardLoader.enabled = false
                gameInfoPanel.enabled = false
                timeLimitBarTimer.stop()
                setSource("qrc:/qml/failed_panel.qml", {
                              "bottomLayerComponent": gamePageMain
                          })
            }
        }
        onClosePanel: {
            setSource("")
            if (mode === "Challenge") {
                loadGame(mode, level + 1)
            } else {
                loadGame(mode)
            }
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

    Component.onCompleted: {
        level = 1
        timeLimitBar.value = mode === "Challenge" ? 0 : 100
        GameService.gameInit()
        if (level > 1)
            SoundService.playClimaxBgm()
        else
            SoundService.playBeginningBgm()
    }

    function loadGame(gameMode, gamelevel) {
        if (gameMode)
            mode = gameMode
        if (gamelevel)
            level = gamelevel
        else
            level = 1
        GameService.gameInit()
        timeLimitBar.value = mode === "Challenge" ? 0 : 100
        timeLimitBarTimer.restart()
        gameBoardLoader.enabled = true
        gameInfoPanel.enabled = true
        gameBoardLoader.Component.completed()
        if (level > 1)
            SoundService.playClimaxBgm()
        else
            SoundService.playBeginningBgm()
    }
}
