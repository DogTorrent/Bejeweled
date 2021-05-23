import QtQuick 2.0

Canvas {
    id: canvas
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

    property int currBtnState: normalImage
    Component.onCompleted: loadImage(imagePath)
    onImageLoaded: requestPaint()
    onCurrBtnStateChanged: requestPaint()
    onNormalImageChanged: requestPaint()
    onHorverImageChanged: requestPaint()
    onOnclickImageChanged: requestPaint()
    onPaint: {
        var singleWidth = canvas.imageWidth / canvas.column
        var singleHeight = canvas.imageHeight / canvas.row

        var currCol = canvas.currBtnState % canvas.column
        var currRow = (canvas.currBtnState - currCol) / canvas.column

        var ctx = getContext("2d")
        ctx.clearRect(0, 0, canvas.width, canvas.height)
        ctx.drawImage(canvas.imagePath, currCol * singleWidth,
                      currRow * singleHeight, singleWidth, singleHeight, 0, 0,
                      canvas.width, canvas.height)
        if (text) {
            ctx.font = canvas.canvasFont
            ctx.fillStyle = canvas.canvasFontColor
            ctx.textAlign = "center"
            ctx.textBaseline = "middle"
            ctx.fillText(canvas.text, singleWidth / 2, singleHeight / 2)
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: parent.enabled
        hoverEnabled: enabled
        onEntered: parent.currBtnState = horverImage
        onExited: parent.currBtnState = normalImage
        onPressed: parent.currBtnState = onclickImage
        onReleased: parent.currBtnState = containsMouse ? horverImage : normalImage
        onClicked: parent.clicked()
    }
}
