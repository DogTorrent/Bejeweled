#include "translation.h"

TranslationHandler::TranslationHandler(QQmlEngine *engine) {
    this->engine = engine;

    auto zh_CNtrans = std::make_shared<QTranslator>();
    zh_CNtrans->load("lang/zh_CN.qm");
    transMap.insert(QString("简体中文"), zh_CNtrans);

    auto en_UStrans = std::make_shared<QTranslator>();
    en_UStrans->load("lang/en_US.qm");
    transMap.insert(QString("English"), en_UStrans);

    QCoreApplication::installTranslator(en_UStrans.get());
    currLang = "English";
}

void TranslationHandler::reTranslate(const QString lang) {
    if (transMap.contains(lang)) {
        QCoreApplication::removeTranslator(transMap.value(currLang).get());
        QCoreApplication::installTranslator(transMap.find(lang).value().get());
        currLang = lang;
        engine->retranslate();
    }
}

QStringList TranslationHandler::languages() { return transMap.keys(); }

QString TranslationHandler::getCurrLang() { return currLang; }
