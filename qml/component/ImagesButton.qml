import QtQuick 2.3

Item {
    id: imagesButton
    property string imagePath: ""
    property int imageWidth: image.sourceSize.width
    property int imageHeight: image.sourceSize.height
    property int column: 1
    property int rowCount: 1
    property int normalImage: 0
    property int horverImage: normalImage
    property int onclickImage: normalImage
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
            height: parent.height * rowCount
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
            parent.currBtnState = Qt.binding(() => {
                                                 return horverImage
                                             })
        }
        onExited: {
            parent.exited()
            parent.currBtnState = Qt.binding(() => {
                                                 return normalImage
                                             })
        }
        onPressed: {
            parent.pressed()
            parent.currBtnState = Qt.binding(() => {
                                                 return onclickImage
                                             })
        }
        onReleased: {
            parent.released()
            parent.currBtnState = containsMouse ? Qt.binding(() => {
                                                                 return horverImage
                                                             }) : Qt.binding(
                                                      () => {
                                                          return normalImage
                                                      })
        }
        onClicked: parent.clicked()
    }
}
