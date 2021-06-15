import QtQuick 2.15
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import "component"

Item {

    Loader {
        id: backGround
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

    Component {
        id: eachModeScoresTableSample
        Item {
            property string mode
            id: eachModeScoresTable

            ListView {
                id: eachModeScoresTableValueRows
                model: DatabaseService.getDataByMode(mode)
                width: parent.width
                height: parent.height - tableHeader.height
                y: tableHeader.height
                delegate: Component {
                    Rectangle {
                        //                    anchors.fill: parent
                        width: eachModeScoresTableValueRows.width
                        height: 60
                        color: mouseArea.containsMouse ? "#B0CEDAE9" : "#B0E1ECFF"
                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            propagateComposedEvents: true
                            onClicked: mouse.accepted = false
                            onPressed: mouse.accepted = false
                        }

                        Row {
                            anchors.fill: parent
                            Text {
                                width: parent.width / parent.visibleChildren.length
                                font.family: settings_other.font_family
                                font.pointSize: settings_other.font_pt_size
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                text: model.modelData.endTime
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Text {
                                width: parent.width / parent.visibleChildren.length
                                font.family: settings_other.font_family
                                font.pointSize: settings_other.font_pt_size
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                text: model.modelData.level
                                visible: eachModeScoresTable.mode === "Challenge"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Text {
                                width: parent.width / parent.visibleChildren.length
                                font.family: settings_other.font_family
                                font.pointSize: settings_other.font_pt_size
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                text: model.modelData.score
                                visible: eachModeScoresTable.mode !== "Challenge"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Text {
                                width: parent.width / parent.visibleChildren.length
                                font.family: settings_other.font_family
                                font.pointSize: settings_other.font_pt_size
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                text: model.modelData.hintTimes
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: tableHeader
                width: eachModeScoresTableValueRows.width
                height: 60
                color: mouseArea.containsMouse ? "#CEDAE9" : "#E1ECFF"
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    propagateComposedEvents: true
                    onClicked: mouse.accepted = false
                    onPressed: mouse.accepted = false
                }
                Row {
                    anchors.fill: parent
                    Text {
                        width: parent.width / parent.visibleChildren.length
                        font.family: settings_other.font_family
                        font.pointSize: settings_other.font_pt_size
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("Time")
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        width: parent.width / parent.visibleChildren.length
                        font.family: settings_other.font_family
                        font.pointSize: settings_other.font_pt_size
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("Level")
                        visible: eachModeScoresTable.mode === "Challenge"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        width: parent.width / parent.visibleChildren.length
                        font.family: settings_other.font_family
                        font.pointSize: settings_other.font_pt_size
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("Score")
                        visible: eachModeScoresTable.mode !== "Challenge"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        width: parent.width / parent.visibleChildren.length
                        font.family: settings_other.font_family
                        font.pointSize: settings_other.font_pt_size
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("Hint Times")
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }

    SwipeView {
        id: scoreTablesView
        x: leftMenu.width
        y: 0
        width: parent.width - x
        height: parent.height
        orientation: Qt.Vertical
        Component.onCompleted: {
            for (var i = 0; i < buttonModel.count; i++) {
                eachModeScoresTableSample.createObject(scoreTablesView, {
                                                           "mode": buttonModel.get(
                                                                       i).mode
                                                       })
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
            while (curr < scoreTablesView.currentIndex)
                scoreTablesView.decrementCurrentIndex()
            while (curr > scoreTablesView.currentIndex)
                scoreTablesView.incrementCurrentIndex()
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
                mode: "Normal"
                buttonText: qsTr("Normal")
            }
            ListElement {
                mode: "Hard"
                buttonText: qsTr("Hard")
            }
            ListElement {
                mode: "Challenge"
                buttonText: qsTr("Challenge")
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
