import QtQuick 2.3

Item {
    id: imagesButton
    property string imagePath: ""
    property int imageWidth: image.sourceSize.width
    property int imageHeight: image.sourceSize.height
    property int column: 1
    property int row: 1
    property int normalImage: 0
    property int horverImage: 0
    property int onclickImage: 0
    property alias containsMouse: mouseArea.containsMouse
    property font font
    property string text
    property bool smooth: true
    property bool mipmap: true
    property bool cache: true
    signal clicked
    signal entered
    signal exited
    signal pressed
    signal released

    property int currBtnState: normalImage

    Item {
        clip: true
        anchors.fill: parent
        Image {
            id: image
            source: imagePath
            width: parent.width * column
            height: parent.height * row
            smooth: imagesButton.smooth
            mipmap: imagesButton.mipmap
            cache: imagesButton.cache

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
        id: mouseArea
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
