import QtQuick 2.12
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
import "component"

Column {
    id: cols
    property color colColor: "#B0CEDAE9"
    property color colHighlightColor: "#B0E1ECFF"

    SwitchOption {
        titleText.text: qsTr("BGM")
        optionSwitch.checked: settings_sound.enable_bgm
        optionSwitch.onCheckedChanged: settings_sound.enable_bgm = optionSwitch.checked

        width: parent.width
        height: Math.min(parent.height / parent.children.length, 80)
        titleText.font.family: settings_other.font_family
        titleText.font.pointSize: settings_other.font_pt_size
        backgroundRec.color: recMouseArea.containsMouse ? parent.colHighlightColor : parent.colColor
    }

    SwitchOption {
        titleText.text: qsTr("Effect Sound")
        optionSwitch.checked: settings_sound.enable_effect_sound
        optionSwitch.onCheckedChanged: settings_sound.enable_effect_sound = optionSwitch.checked

        width: parent.width
        height: Math.min(parent.height / parent.children.length, 80)
        titleText.font.family: settings_other.font_family
        titleText.font.pointSize: settings_other.font_pt_size
        backgroundRec.color: recMouseArea.containsMouse ? parent.colHighlightColor : parent.colColor
    }

    SliderOption {
        titleText.text: qsTr("BGM Volume")
        optionSlider.value: settings_sound.bgm_volume
        optionSlider.onValueChanged: settings_sound.bgm_volume = optionSlider.value

        width: parent.width
        height: Math.min(parent.height / parent.children.length, 80)
        titleText.font.family: settings_other.font_family
        titleText.font.pointSize: settings_other.font_pt_size
        optionSlider.from: 0
        optionSlider.to: 100
        optionSlider.live: false
        optionSlider.stepSize: 320
        optionSlider.snapMode: Slider.SnapAlways
        backgroundRec.color: recMouseArea.containsMouse ? parent.colHighlightColor : parent.colColor
    }

    SliderOption {
        titleText.text: qsTr("Effect Sound Volume")
        optionSlider.value: settings_sound.effect_sound_volume
        optionSlider.onValueChanged: settings_sound.effect_sound_volume = optionSlider.value

        width: parent.width
        height: Math.min(parent.height / parent.children.length, 80)
        titleText.font.family: settings_other.font_family
        titleText.font.pointSize: settings_other.font_pt_size
        optionSlider.from: 0
        optionSlider.to: 100
        optionSlider.live: false
        optionSlider.stepSize: 180
        optionSlider.snapMode: Slider.SnapAlways
        backgroundRec.color: recMouseArea.containsMouse ? parent.colHighlightColor : parent.colColor
    }
}
