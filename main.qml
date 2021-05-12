import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls.Material 2.12

Window {
    width: 1280
    height: 720
    visible: true
    title: qsTr("Bejeweled")
    Loader {
        id: pageLoader
        asynchronous: true
        source: "title_page.qml"
        anchors.fill: parent
    }

    signal changePage(string pageName)

    onChangePage: {
        pageLoader.source = pageName + ".qml"
    }
}
