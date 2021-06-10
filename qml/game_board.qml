import QtQuick 2.12
import "component"

Item {
    id: gameBoard
    anchors.fill: parent
    property string mode: "Normal"

    GridView {
        id: boardGrid
        anchors.fill: parent
        clip: true
        model: boardModel
        cellWidth: width / 8
        cellHeight: width / 8
        interactive: false
        delegate: Component {
            Rectangle {
                border.width: 1
                width: boardGrid.width / 8
                height: boardGrid.height / 8
                color: "#A0515151"
                border.color: "#5D101D"
            }
        }
    }

    ListModel {
        id: boardModel
    }

    GridView {
        id: jewelGrid
        anchors.fill: parent
        clip: true
        model: jewelModel
        cellWidth: width / 8
        cellHeight: width / 8
        interactive: false
        keyNavigationEnabled: true
        property int lastSelectIndex: -1
        property bool itemChangeToBlankAnimationRunning: false
        property bool itemChangeFromBlankAnimationRunning: false
        property bool itemMovingAnimationRunning: objectMovingTransition.running
                                                  || subjectMovingTransition.running
        delegate: Component {
            ImagesButton {
                id: jewelSample
                imagePath: "qrc:/res/image/jewels"
                column: 1
                rowCount: 8
                width: jewelGrid.width / 8
                height: jewelGrid.height / 8
                property int currJewelImage: mainImage
                property bool highlight: false
                smooth: settings_graphic.enable_smooth
                mipmap: settings_graphic.enable_mipmap
                cache: settings_graphic.enable_cache
                Rectangle {
                    id: borderRec
                    border.width: parent.containsMouse
                                  || index === jewelGrid.lastSelectIndex
                                  || parent.highlight ? 5 : 0
                    anchors.fill: parent
                    color: "#00515151"
                    border.color: "lightblue"
                }

                Timer {
                    id: unsetHighlightTimer
                    interval: 1000
                    repeat: false
                    triggeredOnStart: false
                    onTriggered: parent.highlight = false
                }

                onHighlightChanged: unsetHighlightTimer.start()

                SequentialAnimation {
                    id: itemChangeToBlankAnimation
                    NumberAnimation {
                        target: jewelSample
                        property: "opacity"
                        from: 1
                        to: 0
                        duration: 100
                    }

                    ScriptAction {
                        script: normalImage = currJewelImage
                    }

                    NumberAnimation {
                        target: jewelSample
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 100
                    }
                    onStarted: {
                        jewelGrid.itemChangeToBlankAnimationRunning = true
                    }

                    onStopped: {
                        jewelGrid.itemChangeToBlankAnimationRunning = false
                    }
                }

                SequentialAnimation {
                    id: itemChangefromBlankAnimation
                    NumberAnimation {
                        target: jewelSample
                        property: "opacity"
                        from: 1
                        to: 0
                        duration: 100
                    }

                    ScriptAction {
                        script: normalImage = currJewelImage
                    }

                    NumberAnimation {
                        target: jewelSample
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 100
                    }

                    onStarted: {
                        jewelGrid.itemChangeFromBlankAnimationRunning = true
                    }

                    onStopped: {
                        jewelGrid.itemChangeFromBlankAnimationRunning = false
                    }
                }

                onCurrJewelImageChanged: {
                    jewelGrid.forceLayout()
                    if (currJewelImage == 8) {
                        jewelGrid.itemChangeToBlankAnimationRunning = true
                        itemChangeToBlankAnimation.start()
                    } else if (normalImage == 8) {
                        jewelGrid.itemChangeFromBlankAnimationRunning = true
                        itemChangefromBlankAnimation.start()
                    } else
                        normalImage = currJewelImage
                }
                onClicked: {
                    jewelGrid.update()
                    if (jewelGrid.lastSelectIndex != -1) {
                        //原x,y在边界，为了防止indexAt()识别出错，给x移到正中心
                        var l = jewelGrid.indexAt(x - jewelGrid.cellWidth / 2,
                                                  y + jewelGrid.cellHeight / 2)
                        var r = jewelGrid.indexAt(
                                    x + jewelGrid.cellWidth * 1.5,
                                    y + jewelGrid.cellHeight / 2)
                        var u = jewelGrid.indexAt(x + jewelGrid.cellWidth / 2,
                                                  y - jewelGrid.cellHeight / 2)
                        var d = jewelGrid.indexAt(
                                    x + jewelGrid.cellWidth / 2,
                                    y + jewelGrid.cellHeight * 1.5)
                        //如果上一次选择项是本次选择项的上、下、左或右
                        if (jewelGrid.lastSelectIndex === l
                                || jewelGrid.lastSelectIndex === r
                                || jewelGrid.lastSelectIndex === u
                                || jewelGrid.lastSelectIndex === d) {
                            //如果当前没有正在执行的任务
                            if (gameServiceConnection.jobQueue.length == 0
                                    && !jewelGrid.itemMovingAnimationRunning
                                    && !jewelGrid.itemChangeToBlankAnimationRunning
                                    && !jewelGrid.itemChangeFromBlankAnimationRunning)
                                //调用后端尝试执行交换
                                GameService.inputSwap(
                                            jewelGrid.lastSelectIndex, index)
                        }
                        jewelGrid.lastSelectIndex = -1
                    } else {
                        jewelGrid.lastSelectIndex = index
                    }
                }
            }
        }
        moveDisplaced: Transition {
            //被动
            id: objectMovingTransition
            NumberAnimation {
                properties: "x,y"
                duration: 200
            }
        }
        move: Transition {
            //主动
            id: subjectMovingTransition
            NumberAnimation {
                properties: "x,y"
                duration: 200
            }
        }
    }

    ListModel {
        id: jewelModel
    }

    Component.onCompleted: {
        for (var i = 0; i < 64; i++) {
            jewelModel.append({
                                  "mainImage": GameService.getStat(i)
                              })
            boardModel.append({})
        }
        console.debug(mode)
    }

    Connections {
        id: gameServiceConnection
        target: GameService
        property var jobQueue: [] //任务列表
        function onItemMoved(from, to) {
            jobQueue.push({
                              "opType": "ItemMoved",
                              "targetIndex": from,
                              "opPara": to,
                              "func": () => {
                                  if (from < to) {
                                      jewelModel.move(from, to, 1)
                                      jewelModel.move(to - 1, from, 1)
                                  } else {
                                      jewelModel.move(from, to, 1)
                                      jewelModel.move(to + 1, from, 1)
                                  }
                              }
                          })
        }
        function onItemChanged(number, type) {
            jobQueue.push({
                              "opType": "ItemChanged",
                              "targetIndex": number,
                              "opPara": type,
                              "func": () => {
                                  jewelModel.get(number).mainImage = type
                              }
                          })
        }
    }

    Timer {
        id: timer
        interval: 20
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            var jobNeedToDo = gameServiceConnection.jobQueue[0]
            if (jobNeedToDo) {
                if (jobNeedToDo.opType === "ItemMoved") {
                    if (!jewelGrid.itemChangeToBlankAnimationRunning
                            && !jewelGrid.itemChangeFromBlankAnimationRunning) {
                        gameServiceConnection.jobQueue.shift()
                        jobNeedToDo.func()
                    }
                } else {
                    if (!jewelGrid.itemMovingAnimationRunning) {
                        if (jobNeedToDo.opPara === 8) {
                            if (!jewelGrid.itemChangeFromBlankAnimationRunning) {
                                timeLimitBar.addTime()
                                gameServiceConnection.jobQueue.shift()
                                jobNeedToDo.func()
                            }
                        } else {
                            if (!jewelGrid.itemChangeToBlankAnimationRunning) {
                                gameServiceConnection.jobQueue.shift()
                                jobNeedToDo.func()
                            }
                        }
                    }
                }
            }
        }
    }

    function hint(index1, index2) {
        jewelGrid.itemAtIndex(index1).highlight = true
        jewelGrid.itemAtIndex(index2).highlight = true
    }
}
