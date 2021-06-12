#include "sound_service.h"

SoundService::SoundService(){
    cleanSound->setMedia(QUrl("qrc:/res/sound/item_cleaned_se"));
    int tempIndex=0;
    if(bgmList->addMedia(QUrl("qrc:/res/sound/game_beginning_bgm"))) gameBeginningBgmIndex=tempIndex++;
    if(bgmList->addMedia(QUrl("qrc:/res/sound/game_climax_bgm"))) gameClimaxBgm =tempIndex++;
    if(bgmList->addMedia(QUrl("qrc:/res/sound/game_failed_bgm"))) gameFailedBgmIndex=tempIndex++;
    if(bgmList->addMedia(QUrl("qrc:/res/sound/game_paused_bgm"))) gamePausedBgmIndex=tempIndex++;
    if(bgmList->addMedia(QUrl("qrc:/res/sound/game_success_bgm"))) gameSuccessBgmIndex=tempIndex++;
    bgmList->setPlaybackMode(QMediaPlaylist::CurrentItemInLoop);
    bgm->setPlaylist(bgmList);
}

void SoundService::playCleanSound(){
    cleanSound->play();
}

void SoundService::playBeginningBgm(){
    lastBgmIndex=bgmList->currentIndex();
    bgmList->setCurrentIndex(gameBeginningBgmIndex);
    bgm->play();
    qDebug()<<gameBeginningBgmIndex;
}

void SoundService::playClimaxBgm(){
    lastBgmIndex=bgmList->currentIndex();
    bgmList->setCurrentIndex(gameClimaxBgm);
    bgm->play();
}

void SoundService::playFailedBgm(){
    lastBgmIndex=bgmList->currentIndex();
    bgmList->setCurrentIndex(gameFailedBgmIndex);
    bgm->play();
}

void SoundService::playPausedBgm(){
    lastBgmIndex=bgmList->currentIndex();
    bgmList->setCurrentIndex(gamePausedBgmIndex);
    bgm->play();
}

void SoundService::playSuccessBgm(){
    lastBgmIndex=bgmList->currentIndex();
    bgmList->setCurrentIndex(gameSuccessBgmIndex);
    bgm->play();
}

void SoundService::playLastBgm(){
    int bgmToPlayIndex = lastBgmIndex;
    lastBgmIndex=bgmList->currentIndex();
    bgmList->setCurrentIndex(bgmToPlayIndex);
    bgm->play();
}

