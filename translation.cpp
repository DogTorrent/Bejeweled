#include "translation.h"

TranslationHandler::TranslationHandler(QQmlEngine *engine) {
    auto zh_CNtrans = std::make_shared<QTranslator>();
    zh_CNtrans->load("lang/zh_CN.qm");
    transMap.insert(QString("简体中文"),zh_CNtrans);

    auto en_UStrans = std::make_shared<QTranslator>();
    en_UStrans->load("lang/en_US.qm");
    transMap.insert(QString("English(US)"),en_UStrans);

    QCoreApplication::installTranslator(en_UStrans.get());
    lastQTranslator = en_UStrans.get();
    this->engine=engine;
}

void TranslationHandler::reTranslate(const QString lang){
    if(transMap.contains(lang)){
        QCoreApplication::removeTranslator(lastQTranslator);
        auto targetTrans = transMap.find(lang).value();
        QCoreApplication::installTranslator(targetTrans.get());
        lastQTranslator = targetTrans.get();
        engine->retranslate();
    }
}
