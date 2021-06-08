import QtQuick 2.7
import "component"

Item {
    id: gameBoard
    anchors.fill: parent

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
        delegate: Component {
            ImagesButton {
                id: jewelSample
                imagePath: "qrc:/res/image/jewels"
                column: 1
                rowCount: 8
                width: jewelGrid.width / 8
                height: jewelGrid.height / 8
                normalImage: mainImage
                horverImage: mainImage
                onclickImage: mainImage
                smooth: settings_graphic.enable_smooth
                mipmap: settings_graphic.enable_mipmap
                cache: settings_graphic.enable_cache
                Rectangle {
                    id: borderRec
                    border.width: parent.containsMouse
                                  || index === jewelGrid.lastSelectIndex ? 5 : 0
                    anchors.fill: parent
                    color: "#00515151"
                    border.color: "lightblue"
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
                                    && !itemMovingTransition.running)
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
        Transition {
            id: itemMovingTransition
            NumberAnimation {
                properties: "x,y"
                duration: 200
                alwaysRunToEnd: true
            }
        }
        moveDisplaced: itemMovingTransition
        move: itemMovingTransition
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
    }

    Connections {
        id: gameServiceConnection
        target: GameService
        property var jobQueue: [] //任务列表
        function onItemMoved(from, to) {
            jobQueue.push(["ItemMoved", () => {
                               if (from < to) {
                                   jewelModel.move(from, to, 1)
                                   jewelModel.move(to - 1, from, 1)
                               } else {
                                   jewelModel.move(from, to, 1)
                                   jewelModel.move(to + 1, from, 1)
                               }
                           }])
        }
        function onItemChanged(number, type) {
            jobQueue.push(["ItemChanged" + type, () => {
                               jewelModel.set(number, {
                                                  "mainImage": type
                                              })
                           }])
        }
    }

    Timer {
        id: timer
        interval: 20
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            var temp = gameServiceConnection.jobQueue[0]
            if (temp) {
                if (temp[0] === "ItemMoved") {
                    gameServiceConnection.jobQueue.shift()
                    temp[1]()
                } else {
                    if (!itemMovingTransition.running) {
                        var next = temp
                        //如果任务队列后面也全是ItemChange型，则全部一起改
                        while (next) {
                            if (next[0] === "ItemMoved")
                                break
                            if (next[0] === "ItemChanged8")
                                timeLimitBar.value += 1
                            gameServiceConnection.jobQueue.shift()
                            next[1]()
                            next = gameServiceConnection.jobQueue[0]
                        }
                    }
                }
            }
        }
    }
}
