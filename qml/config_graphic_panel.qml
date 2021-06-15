import QtQuick 2.12
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
import Qt.labs.platform 1.1
import "component"

Column {
    id: cols
    property color colColor: "#B0CEDAE9"
    property color colHighlightColor: "#B0E1ECFF"

    SwitchOption {
        titleText.text: qsTr("Smooth Transition")
        optionSwitch.checked: settings_graphic.enable_smooth
        optionSwitch.onCheckedChanged: settings_graphic.enable_smooth = optionSwitch.checked

        width: parent.width
        height: Math.min(parent.height / parent.children.length, 80)
        titleText.font.family: settings_other.font_family
        titleText.font.pointSize: settings_other.font_pt_size
        backgroundRec.color: recMouseArea.containsMouse ? parent.colHighlightColor : parent.colColor
    }

    SwitchOption {
        titleText.text: qsTr("Mipmap Filtering")
        optionSwitch.checked: settings_graphic.enable_mipmap
        optionSwitch.onCheckedChanged: settings_graphic.enable_mipmap = optionSwitch.checked

        width: parent.width
        height: Math.min(parent.height / parent.children.length, 80)
        titleText.font.family: settings_other.font_family
        titleText.font.pointSize: settings_other.font_pt_size
        backgroundRec.color: recMouseArea.containsMouse ? parent.colHighlightColor : parent.colColor
    }

    SwitchOption {
        titleText.text: qsTr("Image Cache")
        optionSwitch.checked: settings_graphic.enable_cache
        optionSwitch.onCheckedChanged: settings_graphic.enable_cache = optionSwitch.checked

        width: parent.width
        height: Math.min(parent.height / parent.children.length, 80)
        titleText.font.family: settings_other.font_family
        titleText.font.pointSize: settings_other.font_pt_size
        backgroundRec.color: recMouseArea.containsMouse ? parent.colHighlightColor : parent.colColor
    }

    SwitchOption {
        id: enableCustBgOption
        titleText.text: qsTr("Use Custom Background")
        optionSwitch.checked: settings_graphic.use_custom_bg
        optionSwitch.onCheckedChanged: {
            if (optionSwitch.checked) {
                if (!settings_graphic.use_custom_bg)
                    imageSelectDialog.open()
            } else {
                if (settings_graphic.use_custom_bg)
                    settings_graphic.use_custom_bg = false
                if (settings_graphic.custom_bg_path !== "")
                    settings_graphic.custom_bg_path = ""
            }
        }
        width: parent.width
        height: Math.min(parent.height / parent.children.length, 80)
        titleText.font.family: settings_other.font_family
        titleText.font.pointSize: settings_other.font_pt_size
        backgroundRec.color: recMouseArea.containsMouse ? parent.colHighlightColor : parent.colColor
        FileDialog {
            id: imageSelectDialog
            title: qsTr("Choosing image file")
            nameFilters: ["Image files (*.jpg *.png *.bmp)"]
            onAccepted: {
                settings_graphic.use_custom_bg = true
                settings_graphic.custom_bg_path = imageSelectDialog.file
            }
            onRejected: {
                enableCustBgOption.optionSwitch.checked = false
                settings_graphic.use_custom_bg = false
                settings_graphic.custom_bg_path = ""
            }
        }
    }
}
