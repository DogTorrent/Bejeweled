import QtQuick 2.0
import QtQuick.Window 2.1
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

ApplicationWindow {
    id: mainWindow
    Item {
        id: settings
        Settings {
            id: settings_general
            fileName: "config.ini"
            category: "General"
            //语言
            property string language: value("language", "简体中文")
            //是否全屏
            property bool enable_fullscreen: value("enable_fullscreen",
                                                   "false") === "true"
            //窗口宽度
            property int width: value("width", 1280)
            //窗口高度
            property int height: value("height", 720)
        }
        Settings {
            id: settings_graphic
            fileName: "config.ini"
            category: "Graphic"
            //缩放或变换图像时是否进行平滑处理
            property bool enable_smooth: value("enable_smooth", true)
            //缩放或变换图像时是否使用Mipmap过滤
            property bool enable_mipmap: value("enable_mipmap", true)
            //加载图像时是否缓存
            property bool enable_cache: value("enable_cache", true)
        }
        Settings {
            id: settings_sound
            fileName: "config.ini"
            category: "Sound"
            //是否开启bgm
            property bool enable_bgm: value("enable_bgm", true)
            //是否开启音效
            property bool enable_effect_sound: value("enable_effect_sound",
                                                     true)
            //BGM音量
            property int bgm_volume: value("bgm_volume", 100)
            //音效音量
            property int effect_sound_volume: value("effect_sound_volume", 100)
        }
        Settings {
            id: settings_control
            fileName: "config.ini"
            category: "Control"
            //暂停键
            property int pause_key: value("pause_key", Qt.Key_Escape)
        }
        Settings {
            id: settings_other
            fileName: "config.ini"
            category: "Other"
            //字体
            property string font_family: value("font_family", "Microsoft Yahei")
            //字号
            property real font_pt_size: value("font_pt_size", 18)
        }
    }
    width: settings_general.width
    height: settings_general.height
    visible: true
    visibility: settings_general.enable_fullscreen ? Window.FullScreen : Window.Windowed
    title: qsTr("Bejeweled")

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
        //            smooth: settings.value("Graphic/enable_smooth", "true") === "true"
        //            mipmap: settings.value("Graphic/enable_mipmap", "true") === "true"
        //            cache: settings.value("Graphic/enable_cache", "true") === "true"
    }

    StackView {
        id: mainPageView
        anchors.fill: parent
        initialItem: "qrc:/qml/title_page.qml"
        replaceEnter: Transition {
            NumberAnimation {
                from: 0
                to: 1
                property: "opacity"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
        replaceExit: Transition {
            NumberAnimation {
                from: 1
                to: 0
                property: "opacity"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }

    Loader {
        id: configPageLoader
        asynchronous: false
        source: "qrc:/qml/config_page.qml"
        anchors.fill: parent
        visible: false
        enabled: false
    }

    signal setMainPage(string pagePath)
    onSetMainPage: {
        //mainPageLoader.source = pagePath
        mainPageView.replace(null, pagePath)
    }
}
