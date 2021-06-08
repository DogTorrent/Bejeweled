#ifndef TRANSLATION_H
#define TRANSLATION_H

#include <QCoreApplication>
#include <QDebug>
#include <QObject>
#include <QQmlEngine>
#include <QTranslator>

class TranslationHandler : public QObject {
    Q_OBJECT
public:
    explicit TranslationHandler(QQmlEngine *engine);
    Q_INVOKABLE void reTranslate(const QString lang);
    Q_INVOKABLE QStringList languages();
    Q_INVOKABLE QString getCurrLang();

private:
    QMap<QString, std::shared_ptr<QTranslator>> transMap;
    QQmlEngine *engine;
    QString currLang;

signals:
};

#endif // TRANSLATION_H
