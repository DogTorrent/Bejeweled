import QtQuick 2.0
import QtQuick.Window 2.1

Window {
    width: 1280
    height: 720
    visible: true
    title: qsTr("Bejeweled")

    Loader {
        id: mainPageLoader
        asynchronous: false
        source: "title_page.qml"
        anchors.fill: parent
    }
    signal setMainPage(string pagePath)
    onSetMainPage: {
        mainPageLoader.source = pagePath
    }
}
