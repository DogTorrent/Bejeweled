import QtQuick 2.0

Item {
    implicitWidth: 240
    implicitHeight: 100
    property string imagePath: ""
    property int imageWidth: image.sourceSize.width
    property int imageHeight: image.sourceSize.height
    property int column: 1
    property int row: 1
    property int normalImage: 0
    property int horverImage: 0
    property int onclickImage: 0
    property font font
    property string text
    signal clicked
    signal entered
    signal exited
    signal pressed
    signal released

    property int currBtnState: normalImage

    Rectangle {
        id: buttonRect
        color: "#00000000"
        clip: true
        anchors.fill: parent
        Image {
            id: image
            source: imagePath
            width: parent.width * column
            height: parent.height * row

            property var currCol: currBtnState % column
            property var currRow: (currBtnState - currCol) / column

            x: -parent.width * currCol
            y: -parent.height * currRow
        }
    }
    Text {
        anchors.fill: parent
        id: textArea
        text: parent.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font: parent.font
    }
    MouseArea {
        anchors.fill: parent
        enabled: parent.enabled
        hoverEnabled: enabled
        onEntered: {
            parent.entered()
            parent.currBtnState = horverImage
        }
        onExited: {
            parent.exited()
            parent.currBtnState = normalImage
        }
        onPressed: {
            parent.pressed()
            parent.currBtnState = onclickImage
        }
        onReleased: {
            parent.released()
            parent.currBtnState = containsMouse ? horverImage : normalImage
        }
        onClicked: parent.clicked()
    }
}
