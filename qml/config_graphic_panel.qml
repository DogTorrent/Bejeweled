import QtQuick 2.12
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
import "component"

Column {
    id: cols
    property color colColor: "#B0CEDAE9"
    property color colHighlightColor: "#B0E1ECFF"

    SwitchOption {
        titleText.text: qsTr("平滑过渡")
        optionSwitch.checked: settings_graphic.enable_smooth
        optionSwitch.onCheckedChanged: settings_graphic.enable_smooth = optionSwitch.checked

        width: parent.width
        height: Math.min(parent.height / parent.children.length, 80)
        titleText.font.family: settings_other.font_family
        titleText.font.pointSize: settings_other.font_pt_size
        backgroundRec.color: recMouseArea.containsMouse ? parent.colHighlightColor : parent.colColor
    }

    SwitchOption {
        titleText.text: qsTr("Mipmap过滤")
        optionSwitch.checked: settings_graphic.enable_mipmap
        optionSwitch.onCheckedChanged: settings_graphic.enable_mipmap = optionSwitch.checked

        width: parent.width
        height: Math.min(parent.height / parent.children.length, 80)
        titleText.font.family: settings_other.font_family
        titleText.font.pointSize: settings_other.font_pt_size
        backgroundRec.color: recMouseArea.containsMouse ? parent.colHighlightColor : parent.colColor
    }

    SwitchOption {
        titleText.text: qsTr("图像缓存")
        optionSwitch.checked: settings_graphic.enable_cache
        optionSwitch.onCheckedChanged: settings_graphic.enable_cache = optionSwitch.checked

        width: parent.width
        height: Math.min(parent.height / parent.children.length, 80)
        titleText.font.family: settings_other.font_family
        titleText.font.pointSize: settings_other.font_pt_size
        backgroundRec.color: recMouseArea.containsMouse ? parent.colHighlightColor : parent.colColor
    }
}
