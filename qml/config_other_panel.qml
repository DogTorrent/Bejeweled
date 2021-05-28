import QtQuick 2.12
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
import "component"

Column {
    id: cols
    property color colColor: "#B0CEDAE9"
    property color colHighlightColor: "#B0E1ECFF"

    ComboBoxOption {
        id: fontComboBox
        titleText.text: qsTr("字体名称")
        optionComboBox.currentIndex: Qt.fontFamilies().indexOf(
                                         settings_other.font_family)
        optionComboBox.model: Qt.fontFamilies()
        optionComboBox.onCurrentTextChanged: settings_other.font_family = optionComboBox.currentText

        width: parent.width
        height: Math.min(parent.height / parent.children.length, 80)
        titleText.font.family: settings_other.font_family
        titleText.font.pointSize: settings_other.font_pt_size
        backgroundRec.color: recMouseArea.containsMouse ? parent.colHighlightColor : parent.colColor
        optionComboBox.delegate: ItemDelegate {
            width: fontComboBox.optionComboBox.width
            contentItem: Text {
                text: modelData
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                font.pointSize: fontComboBox.optionComboBox.font.pointSize
                font.family: text
            }
            highlighted: fontComboBox.optionComboBox.highlightedIndex === index
        }
    }

    ComboBoxOption {
        titleText.text: qsTr("字号大小")
        optionComboBox.currentIndex: optionComboBox.model.indexOf(
                                         settings_other.font_pt_size)
        optionComboBox.model: [10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30]
        optionComboBox.onCurrentTextChanged: settings_other.font_pt_size
                                             = optionComboBox.currentText

        width: parent.width
        height: Math.min(parent.height / parent.children.length, 80)
        titleText.font.family: settings_other.font_family
        titleText.font.pointSize: settings_other.font_pt_size
        backgroundRec.color: recMouseArea.containsMouse ? parent.colHighlightColor : parent.colColor
    }
}
