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
    bgmMain->setNotifyInterval(80);
    bgmSub->setNotifyInterval(80);

    connect(this, &SoundService::playBeginningBgm, this, &SoundService::onPlayBeginningBgm);
    connect(this, &SoundService::playCleanSound, this, &SoundService::onPlayCleanSound);
    connect(this, &SoundService::playClimaxBgm, this, &SoundService::onPlayClimaxBgm);
    connect(this, &SoundService::playFailedBgm, this, &SoundService::onPlayFailedBgm);
    connect(this, &SoundService::playLastBgm, this, &SoundService::onPlayLastBgm);
    connect(this, &SoundService::playPausedBgm, this, &SoundService::onPlayPausedBgm);
    connect(this, &SoundService::playSuccessBgm, this, &SoundService::onPlaySuccessBgm);
}

void SoundService::playBgm(SoundService::BGM bgm, bool loop) {
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
        if (loop) connect(bgmMain, &QMediaPlayer::positionChanged, this, &SoundService::mainLoopToSub);
    }
}

void SoundService::onPlayCleanSound() {
    cleanSound->stop();
    cleanSound->play();
}

void SoundService::onPlayBeginningBgm() { playBgm(BGM::GameBeginning, true); }

void SoundService::onPlayClimaxBgm() { playBgm(BGM::GameClimax, true); }

void SoundService::onPlayFailedBgm() { playBgm(BGM::GameFailed, false); }

void SoundService::onPlayPausedBgm() { playBgm(BGM::GamePaused, true); }

void SoundService::onPlaySuccessBgm() { playBgm(BGM::GameSuccess, false); }

void SoundService::onPlayLastBgm() { playBgm(lastBgm, true); }

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
    position = bgmMain->position();

    if (duration != 0 && position <= duration && position >= duration - 160) {
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
    position = bgmSub->position();

    if (duration != 0 && position <= duration && position >= duration - 160) {
        if (bgmListMain->currentIndex() != index) bgmListMain->setCurrentIndex(index);
        bgmMain->play();
        bgmMain->setPosition(duration - position);
        bgmSub->disconnect();
        connect(bgmMain, &QMediaPlayer::positionChanged, this, &SoundService::mainLoopToSub);
    }
}
