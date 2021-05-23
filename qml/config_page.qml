import QtQuick 2.0
import QtQml.Models 2.1
import QtQuick.Controls 2.0
import QtQuick.Controls 1.6
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.0
import "component"

Item {
    ListView {
        id: leftMenu
        height: parent.height
        width: parent.width / 5
        currentIndex: 0
        Behavior on width {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutQuad
            }
        }
        signal clicked(string page)

        delegate: Component {
            CustButton {
                text: buttonText
                width: ListView.isCurrentItem ? leftMenu.width + 10 : leftMenu.width
                height: Math.min(leftMenu.height / leftMenu.count, 80)
                radius: 0
                color: ListView.isCurrentItem ? "#EFEFEF" : "#B8B8B8"
                borderWidth: 0
                font.pointSize: 18
                font.family: "Microsoft Yahei"
                Behavior on width {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutQuad
                    }
                }
                onClicked: {
                    leftMenu.currentIndex = index
                    leftMenu.clicked(page)
                }
            }
        }

        model: ListModel {
            id: buttonModel
            ListElement {
                page: "general"
                buttonText: qsTr("全局")
            }
            ListElement {
                page: "graphic"
                buttonText: qsTr("图像")
            }
            ListElement {
                page: "sound"
                buttonText: qsTr("声音")
            }
            ListElement {
                page: "control"
                buttonText: qsTr("控制")
            }
            ListElement {
                page: "other"
                buttonText: qsTr("其他")
            }
        }

        onClicked: {
            console.debug(page)
        }
    }
}
