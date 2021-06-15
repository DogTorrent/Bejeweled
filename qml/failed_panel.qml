import QtQuick 2.15
import "component"

Item {
    Component.onCompleted: SoundService.playFailedBgm()

    property var animationDuration: 230
    property var bottomLayerComponent
    PopupMask {
        id: stopMenuMask
        anchors.fill: parent
        rippleCenterX: parent.width / 2
        rippleCenterY: parent.height / 2
        animationDuration: parent.animationDuration
        maskColor: "#A0000000"
        enableMaskGrowAnim: true
        enableBlurAnim: true
        blurRadius: 60
        blurSource: parent.bottomLayerComponent
        enabled: parent.enabled
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width / 2
        height: parent.height / 2
        color: "#B0777777"
        border.color: "#777777"
        border.width: 5
        radius: 10
        Image {
            id: resultImage
            source: "qrc:/res/image/lose"
            y: -sourceSize.height / 2
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Column {
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20
                Text {
                    font.family: settings_other.font_family
                    font.pointSize: settings_other.font_pt_size
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("MODE")
                    color: "white"
                }
                Text {
                    font.family: settings_other.font_family
                    font.pointSize: settings_other.font_pt_size
                    verticalAlignment: Text.AlignVCenter
                    text: gamePage.mode
                    color: "lightgrey"
                }
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20
                Text {
                    font.family: settings_other.font_family
                    font.pointSize: settings_other.font_pt_size
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                    text: gamePage.mode === "Challenge" ? qsTr("LEVEL") : qsTr(
                                                              "SCORE")
                    color: "white"
                }
                Text {
                    font.family: settings_other.font_family
                    font.pointSize: settings_other.font_pt_size
                    verticalAlignment: Text.AlignVCenter
                    text: gamePage.mode === "Challenge" ? gamePage.level : GameService.score
                    color: "lightgrey"
                }
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20
                Text {
                    font.family: settings_other.font_family
                    font.pointSize: settings_other.font_pt_size
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("HINT")
                    color: "white"
                }
                Text {
                    font.family: settings_other.font_family
                    font.pointSize: settings_other.font_pt_size
                    verticalAlignment: Text.AlignVCenter
                    text: gamePage.hintTimes
                    color: "lightgrey"
                }
            }
        }
        Row {
            id: buttonsRow
            width: parent.width
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            spacing: width / 3 / 3
            leftPadding: spacing
            rightPadding: spacing
            CustButton {
                text: qsTr("Leave")
                radius: 5
                color: "#FFA607"
                borderWidth: 3
                width: parent.width / 3
                borderColor: "#5D101D"
                rippleColor: "#60FFFFFF"
                shouldRippleCoverBorder: true
                onClicked: setMainPage("qrc:/qml/title_page.qml")
            }
            CustButton {
                text: qsTr("Restart")
                radius: 5
                color: "#FFA607"
                borderWidth: 3
                width: parent.width / 3
                borderColor: "#5D101D"
                rippleColor: "#60FFFFFF"
                shouldRippleCoverBorder: true
                onClicked: levelEndPanelLoader.closePanel()
            }
        }
    }
}
