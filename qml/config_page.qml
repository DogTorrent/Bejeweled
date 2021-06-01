import QtQuick 2.15
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import "component"

Item {

    Loader {
        id:backGround
        anchors.fill: parent
        source: "qrc:/qml/back_ground.qml"
    }

    FastBlur {
        id: fastBlur
        source: backGround
        opacity: source ? 1 : 0
        width: source ? source.width : 0
        height: source ? source.height : 0
        x: source ? source.x : 0
        y: source ? source.y : 0
        scale: source ? source.scale : 0
        radius: 60
    }

    SwipeView {
        id: settingsView
        x: leftMenu.width
        y: 0
        width: parent.width - x
        height: parent.height
        orientation: Qt.Vertical
        Component.onCompleted: {
            for (var i = 0; i < buttonModel.count; i++) {
                var component = Qt.createComponent(buttonModel.get(i).page)
                if (component.status === Component.Ready) {
                    var objectInstance = component.createObject(settingsView)
                }
            }
        }
        onCurrentIndexChanged: {
            leftMenu.currentIndex = currentIndex
        }
    }

    ListView {
        id: leftMenu
        height: parent.height - backButton.height
        width: parent.width / 5
        currentIndex: 0
        onCurrentIndexChanged: {
            var curr = currentIndex
            while (curr < settingsView.currentIndex)
                settingsView.decrementCurrentIndex()
            while (curr > settingsView.currentIndex)
                settingsView.incrementCurrentIndex()
        }

        delegate: Component {
            CustButton {
                text: buttonText
                width: ListView.isCurrentItem
                       || hovered ? leftMenu.width + 10 : leftMenu.width
                height: 80 //Math.min(leftMenu.height / leftMenu.count, 80)
                radius: 0
                color: ListView.isCurrentItem ? "#EFEFEF" : "#B0B8B8B8"
                borderWidth: 0
                Behavior on width {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }
                }
                onClicked: {
                    leftMenu.currentIndex = index
                }
                hoverEnabled: true
            }
        }

        model: ListModel {
            id: buttonModel
            ListElement {
                page: "qrc:/qml/config_general_panel.qml"
                buttonText: qsTr("General")
            }
            ListElement {
                page: "qrc:/qml/config_graphic_panel.qml"
                buttonText: qsTr("Graphic")
            }
            ListElement {
                page: "qrc:/qml/config_sound_panel.qml"
                buttonText: qsTr("Sound")
            }
            ListElement {
                page: "qrc:/qml/config_control_panel.qml"
                buttonText: qsTr("Control")
            }
            ListElement {
                page: "qrc:/qml/config_other_panel.qml"
                buttonText: qsTr("Other")
            }
        }
    }

    CustButton {
        id: backButton
        text: qsTr("Back")
        x: 0
        y: parent.height - height
        width: hovered ? leftMenu.width + 10 : leftMenu.width
        height: 80 //Math.min(leftMenu.height / leftMenu.count, 80)
        radius: 0
        color: hovered ? "#EFEFEF" : "#B0B8B8B8"
        borderWidth: 0
        Behavior on width {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutQuad
            }
        }
        onClicked: popMainPage()
        hoverEnabled: true
    }
}
