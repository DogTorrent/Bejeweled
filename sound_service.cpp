#include "sound_service.h"

SoundService::SoundService() {
    cleanSound->setMedia(QUrl("qrc:/res/sound/item_cleaned_se"));
    int tempIndex = 0;

    bgmMain->setAudioRole(QAudio::GameRole);
    if (bgmListMain->addMedia(QUrl("qrc:/res/sound/game_beginning_bgm"))) {
        bgmListSub->addMedia(bgmListMain->media(tempIndex));
        bgmIndexMap.insert(BGM::GameBeginning, tempIndex);
        bgmDurationMap.insert(BGM::GameBeginning, 54517);
        tempIndex++;
    }
    if (bgmListMain->addMedia(QUrl("qrc:/res/sound/game_climax_bgm"))) {
        bgmListSub->addMedia(bgmListMain->media(tempIndex));
        bgmIndexMap.insert(BGM::GameClimax, tempIndex);
        bgmDurationMap.insert(BGM::GameClimax, 41508);
        tempIndex++;
    }
    if (bgmListMain->addMedia(QUrl("qrc:/res/sound/game_failed_bgm"))) {
        bgmListSub->addMedia(bgmListMain->media(tempIndex));
        bgmIndexMap.insert(BGM::GameFailed, tempIndex);
        bgmDurationMap.insert(BGM::GameFailed, 6138);
        tempIndex++;
    }
    if (bgmListMain->addMedia(QUrl("qrc:/res/sound/game_paused_bgm"))) {
        bgmListSub->addMedia(bgmListMain->media(tempIndex));
        bgmIndexMap.insert(BGM::GamePaused, tempIndex);
        bgmDurationMap.insert(BGM::GamePaused, 6138);
        tempIndex++;
    }
    if (bgmListMain->addMedia(QUrl("qrc:/res/sound/game_success_bgm"))) {
        bgmListSub->addMedia(bgmListMain->media(tempIndex));
        bgmIndexMap.insert(BGM::GameSuccess, tempIndex);
        bgmDurationMap.insert(BGM::GameSuccess, 7993);
        tempIndex++;
    }
    bgmListMain->setPlaybackMode(QMediaPlaylist::CurrentItemOnce);
    bgmListSub->setPlaybackMode(QMediaPlaylist::CurrentItemOnce);
    bgmMain->setPlaylist(bgmListMain);
    bgmSub->setPlaylist(bgmListSub);
    bgmMain->setNotifyInterval(1);
    bgmSub->setNotifyInterval(1);
}

void SoundService::playBgm(SoundService::BGM bgm) {
    if (!bgmIndexMap.contains(bgm)) return;
    int index = bgmIndexMap.value(bgm);
    if (currBgm != bgm ||
        (bgmMain->state() != QMediaPlayer::PlayingState && bgmSub->state() != QMediaPlayer::PlayingState)) {
        lastBgm = currBgm;
        currBgm = bgm;
        bgmMain->stop();
        bgmSub->stop();
        bgmMain->disconnect();
        bgmSub->disconnect();
        bgmListMain->setCurrentIndex(index);
        bgmListSub->setCurrentIndex(index);
        bgmMain->play();
        connect(bgmMain, &QMediaPlayer::positionChanged, this, &SoundService::mainLoopToSub);
    }
}

void SoundService::playCleanSound() {
    cleanSound->stop();
    cleanSound->play();
}

void SoundService::playBeginningBgm() { playBgm(BGM::GameBeginning); }

void SoundService::playClimaxBgm() { playBgm(BGM::GameClimax); }

void SoundService::playFailedBgm() { playBgm(BGM::GameFailed); }

void SoundService::playPausedBgm() { playBgm(BGM::GamePaused); }

void SoundService::playSuccessBgm() { playBgm(BGM::GameSuccess); }

void SoundService::playLastBgm() { playBgm(lastBgm); }

void SoundService::setBgmVolume(int volume) {
    bgmMain->setVolume(volume);
    bgmSub->setVolume(volume);
}

void SoundService::setSeVolume(int volume) { cleanSound->setVolume(volume); }

void SoundService::setBgmEnabled(bool enabled) {
    bgmMain->setMuted(!enabled);
    bgmSub->setMuted(!enabled);
}

void SoundService::setSeEnabled(bool enabled) { cleanSound->setMuted(!enabled); }

void SoundService::mainLoopToSub(qint64 position) {
    int index = bgmIndexMap.value(currBgm);
    int duration = bgmDurationMap.value(currBgm);

    if (duration != 0 && position <= duration && position >= duration - 100) {
        if (bgmListSub->currentIndex() != index) bgmListSub->setCurrentIndex(index);
        bgmSub->play();
        bgmSub->setPosition(duration - position);
        bgmMain->disconnect();
        connect(bgmSub, &QMediaPlayer::positionChanged, this, &SoundService::subLoopToMain);
    }
}

void SoundService::subLoopToMain(qint64 position) {
    int index = bgmIndexMap.value(currBgm);
    int duration = bgmDurationMap.value(currBgm);

    if (duration != 0 && position <= duration && position >= duration - 100) {
        if (bgmListMain->currentIndex() != index) bgmListMain->setCurrentIndex(index);
        bgmMain->play();
        bgmMain->setPosition(duration - position);
        bgmSub->disconnect();
        connect(bgmMain, &QMediaPlayer::positionChanged, this, &SoundService::mainLoopToSub);
    }
}
