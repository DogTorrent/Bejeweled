#include "database_service.h"
#include "game_service.h"
#include "sound_service.h"
#include "translation.h"
#include <QGuiApplication>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QSettings>
#include <QTextCodec>

int main(int argc, char *argv[]) {
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon("://res/image/icon/icon-128"));

    QSettings settings("config.ini", QSettings::IniFormat);
    settings.setIniCodec(QTextCodec::codecForName("UTF-8"));

    QQmlApplicationEngine engine;

    auto *translationHandler = new TranslationHandler(&engine);
    engine.rootContext()->setContextProperty("TranslationHandler", translationHandler);

    auto *gameService = new GameService(8, 8);
    engine.rootContext()->setContextProperty("GameService", gameService);

    auto *soundService = new SoundService();
    engine.rootContext()->setContextProperty("SoundService", soundService);

    auto *databaseService = new DatabaseService();
    engine.rootContext()->setContextProperty("DatabaseService", databaseService);

    const QUrl url(QStringLiteral("qrc:/qml/main_window.qml"));
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated, &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl) QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
