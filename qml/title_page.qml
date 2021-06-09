import QtQuick 2.7
import QtQml.Models 2.15
import "component"

Item {

    Loader {
        id: backGround
        anchors.fill: parent
        source: "qrc:/qml/back_ground.qml"
    }

    Image {
        id: logo
        source: "qrc:/res/image/logo" //2:1
        width: height * 2
        height: parent.height / 2 - 50
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -height / 2
        smooth: settings_graphic.enable_smooth
        mipmap: settings_graphic.enable_mipmap
        cache: settings_graphic.enable_cache
    }

    ListView {
        id: titleButtonListView
        x: (parent.width - width) / 2
        y: parent.height / 2 + (parent.height / 2 - height) / 2
        width: buttonWidth
        height: (buttonHeight + spacing) * count
        property int buttonWidth: 240
        property int buttonHeight: Math.min(
                                       60,
                                       (parent.height / 2) / count - spacing)
        interactive: false

        spacing: 10
        delegate: Component {
            CustButton {
                width: titleButtonListView.buttonWidth
                height: titleButtonListView.buttonHeight
                text: buttonText
                radius: 5
                color: "#FFA607"
                borderWidth: 3
                borderColor: "#5D101D"
                rippleColor: "#60FFFFFF"
                shouldRippleCoverBorder: true
                onClicked: titleButtonListView.titleButtonClicked(operation)
            }
        }

        model: titleMainMenuList

        ListModel {
            id: titleMainMenuList
            ListElement {
                operation: "StartMenu"
                buttonText: qsTr("START")
            }
            ListElement {
                operation: "ConfigPage"
                buttonText: qsTr("CONFIG")
            }
            ListElement {
                operation: "ScorePage"
                buttonText: qsTr("SCORE")
            }
            ListElement {
                operation: "Exit"
                buttonText: qsTr("EXIT")
            }
        }

        ListModel {
            id: titleStartMenuList
            ListElement {
                operation: "NormalMode"
                buttonText: qsTr("NORMAL")
            }
            ListElement {
                operation: "HardMode"
                buttonText: qsTr("HARD")
            }
            ListElement {
                operation: "ChallengeMode"
                buttonText: qsTr("CHALLENGE")
            }
            ListElement {
                operation: "MainMenu"
                buttonText: qsTr("BACK")
            }
        }

        signal titleButtonClicked(var operation)
        onTitleButtonClicked: {
            switch (operation) {
            case "StartMenu":
                titleButtonListView.model = titleStartMenuList
                break
            case "MainMenu":
                titleButtonListView.model = titleMainMenuList
                break
            case "ConfigPage":
                pushMainPage("qrc:/qml/config_page.qml")
                break
            case "ScorePage":
                break
            case "Exit":
                Qt.quit()
                break
            case "NormalMode":
                setMainPage("qrc:/qml/game_page.qml")
                break
            case "HardMode":
                setMainPage("qrc:/qml/game_page.qml")
                break
            case "ChallengeMode":
                setMainPage("qrc:/qml/game_page.qml")
                break
            }
        }
    }
}
