import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls.Material 2.12

Window {
    width: 1280
    height: 720
    visible: true
    title: qsTr("Bejeweled")

    Loader {
        id: mainPageLoader
        asynchronous: true
        source: "title_page.qml"
        anchors.fill: parent
    }
    signal setMainPage(string pagePath)
    onSetMainPage: {
        mainPageLoader.source = pagePath
    }
}
