import QtQuick 2.12
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
import "component"

Column {
    id: cols
    property color colColor: "#B0CEDAE9"
    property color colHighlightColor: "#B0E1ECFF"

    ComboBoxOption {
        titleText.text: qsTr("暂停按键")

        width: parent.width
        height: Math.min(parent.height / parent.children.length, 80)
        titleText.font.family: settings_other.font_family
        titleText.font.pointSize: settings_other.font_pt_size
        backgroundRec.color: recMouseArea.containsMouse ? parent.colHighlightColor : parent.colColor
    }
}
