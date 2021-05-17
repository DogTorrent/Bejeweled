import QtQuick 2.0

Item {
    ImagesButton {
        id: configButton
        anchors.left: parent.left
        implicitWidth: 64
        implicitHeight: 64
        imagePath: "qrc:/res/image/back"
        column: 3
        row: 1
        normalImage: 0
        horverImage: 1
        onclickImage: 2
        onClicked: setMainPage("title_page.qml")
    }
}
