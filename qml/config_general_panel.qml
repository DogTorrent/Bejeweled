import QtQuick 2.12
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Window 2.0
import "component"

Column {
    id: cols
    property color colColor: "#B0CEDAE9"
    property color colHighlightColor: "#B0E1ECFF"

    SwitchOption {
        titleText.text: qsTr("Fullscreen")
        optionSwitch.checked: settings_general.enable_fullscreen
        optionSwitch.onCheckedChanged: settings_general.enable_fullscreen = optionSwitch.checked

        width: parent.width
        height: 80 //Math.min(parent.height / parent.children.length, 80)
        titleText.font.family: settings_other.font_family
        titleText.font.pointSize: settings_other.font_pt_size
        backgroundRec.color: recMouseArea.containsMouse ? parent.colHighlightColor : parent.colColor
    }

    SliderOption {
        titleText.text: qsTr("Window Width")
        optionSlider.value: settings_general.width
        optionSlider.onValueChanged: settings_general.width = optionSlider.value

        width: parent.width
        height: 80 //Math.min(parent.height / parent.children.length, 80)
        titleText.font.family: settings_other.font_family
        titleText.font.pointSize: settings_other.font_pt_size
        optionSlider.from: 960
        optionSlider.to: Screen.desktopAvailableWidth
        optionSlider.live: false
        optionSlider.stepSize: 320
        optionSlider.snapMode: Slider.SnapAlways
        backgroundRec.color: recMouseArea.containsMouse ? parent.colHighlightColor : parent.colColor
    }

    SliderOption {
        titleText.text: qsTr("Window Height")
        optionSlider.value: settings_general.height
        optionSlider.onValueChanged: settings_general.height = optionSlider.value

        width: parent.width
        height: 80 //Math.min(parent.height / parent.children.length, 80)
        titleText.font.family: settings_other.font_family
        titleText.font.pointSize: settings_other.font_pt_size
        optionSlider.from: 540
        optionSlider.to: Screen.desktopAvailableHeight
        optionSlider.live: false
        optionSlider.stepSize: 180
        optionSlider.snapMode: Slider.SnapAlways
        backgroundRec.color: recMouseArea.containsMouse ? parent.colHighlightColor : parent.colColor
    }

    ComboBoxOption {
        titleText.text: qsTr("Language")

        width: parent.width
        height: 80 //Math.min(parent.height / parent.children.length, 80)
        titleText.font.family: settings_other.font_family
        titleText.font.pointSize: settings_other.font_pt_size
        backgroundRec.color: recMouseArea.containsMouse ? parent.colHighlightColor : parent.colColor
        optionComboBox.model: TranslationHandler.languages()
        optionComboBox.onCurrentTextChanged: {
            settings_general.language = optionComboBox.currentText
        }
        optionComboBox.currentIndex: TranslationHandler.languages().indexOf(
                                         settings_general.language)
    }
}
