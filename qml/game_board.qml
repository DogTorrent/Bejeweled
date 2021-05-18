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
        displaced: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 200
            }
        }
        move: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 200
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
                row: 8
                width: jewelGrid.width / 8
                height: jewelGrid.height / 8
                normalImage: mainImage
                horverImage: mainImage
                onclickImage: mainImage
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
                        var l = jewelGrid.indexAt(
                                    x - jewelGrid.cellWidth / 2.0,
                                    y + jewelGrid.cellHeight / 2.0)
                        var r = jewelGrid.indexAt(
                                    x + jewelGrid.cellWidth * 1.5,
                                    y + jewelGrid.cellHeight / 2.0)
                        var u = jewelGrid.indexAt(
                                    x + jewelGrid.cellWidth / 2.0,
                                    y - jewelGrid.cellHeight / 2.0)
                        var d = jewelGrid.indexAt(
                                    x + jewelGrid.cellWidth / 2.0,
                                    y + jewelGrid.cellHeight * 1.5)
                        if (jewelGrid.lastSelectIndex === l
                                || jewelGrid.lastSelectIndex === r
                                || jewelGrid.lastSelectIndex === u
                                || jewelGrid.lastSelectIndex === d) {
                            gameBoard.move(jewelGrid.lastSelectIndex, index)
                        }
                        jewelGrid.lastSelectIndex = -1
                    } else {
                        jewelGrid.lastSelectIndex = index
                    }
                }
            }
        }
        displaced: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 200
            }
        }
        move: Transition {
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
                                  "mainImage": Math.random() * 7
                              })
            boardModel.append({})
        }
    }
    signal move(var from, var to)
    onMove: {
        if (from < to) {
            jewelModel.move(from, to, 1)
            jewelModel.move(to - 1, from, 1)
        } else {
            jewelModel.move(from, to, 1)
            jewelModel.move(to + 1, from, 1)
        }
    }
}
