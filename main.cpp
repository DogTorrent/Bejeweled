#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QSettings>
#include <QTextCodec>
#include "translation.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QSettings settings("config.ini",QSettings::IniFormat);
    settings.setIniCodec(QTextCodec::codecForName("UTF-8"));

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/qml/main_window.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    auto translationHandler = new TranslationHandler(&engine);
    //translationHandler->reTranslate(QString("简体中文"));

    return app.exec();
}
