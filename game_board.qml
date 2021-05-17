import QtQuick 2.15

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
                    border.width: 0
                    anchors.fill: parent
                    color: "#00515151"
                    border.color: "lightblue"
                }
                onEntered: {
                    borderRec.border.width = 5
                }
                onExited: {
                    borderRec.border.width = 0
                }
                onClicked: move(1, 2)
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
        jewelModel.move(from, to, 1)
    }
}
