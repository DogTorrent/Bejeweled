import QtQuick 2.0

Canvas {
    implicitWidth: 240
    implicitHeight: 100
    property var imagePath: ""
    property int imageWidth: 240
    property int imageHeight: 100
    property int column: 1
    property int row: 1
    property int normalImage: 0
    property int horverImage: 0
    property int onclickImage: 0
    property var canvasFont: "bold 10px Arial"
    property var canvasFontColor: "#000000"
    property var text: ""
    signal clicked

    property int currBtnState: 0
    Component.onCompleted: loadImage(imagePath)
    onImageLoaded: requestPaint()
    onCurrBtnStateChanged: requestPaint()
    onPaint: {
        var singleWidth = imageWidth / column
        var singleHeight = imageHeight / row

        var currCol = currBtnState % column
        var currRow = (currBtnState - currCol) / column

        var ctx = getContext("2d")
        ctx.clearRect(0, 0, width, height)
        ctx.drawImage(imagePath, currCol * singleWidth, currRow * singleHeight,
                      singleWidth, singleHeight, 0, 0, width, height)
        if (text) {
            ctx.font = canvasFont
            ctx.fillStyle = canvasFontColor
            ctx.textAlign = "center"
            ctx.textBaseline = "middle"
            ctx.fillText(text, singleWidth / 2, singleHeight / 2)
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: parent.currBtnState = horverImage
        onExited: parent.currBtnState = normalImage
        onPressed: parent.currBtnState = onclickImage
        onReleased: parent.currBtnState = containsMouse ? horverImage : normalImage
        onClicked: parent.clicked()
    }
}
