#ifndef TRANSLATION_H
#define TRANSLATION_H

#include <QObject>
#include <QDebug>
#include <QTranslator>
#include <QQmlEngine>
#include <QCoreApplication>

class TranslationHandler : public QObject
{
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
