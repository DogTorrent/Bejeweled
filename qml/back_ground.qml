import QtQuick 2.3
import QtQuick.Window 2.1

Item {
    anchors.fill: parent
    Image {
        id: backGround
        source: "qrc:/res/image/background" //16:9
        property var aspectRatio: 16 / 9
        width: (parent.width / parent.height
                >= aspectRatio) ? parent.width : parent.height * aspectRatio
        height: width / aspectRatio
        //保证居中
        x: -(width / 2 - Window.width / 2)
        y: -(height / 2 - Window.height / 2)
        smooth: settings_graphic.enable_smooth
        mipmap: settings_graphic.enable_mipmap
        cache: settings_graphic.enable_cache
    }
}
