#ifndef SOUND_SERVICE_H
#define SOUND_SERVICE_H

#include <QMediaContent>
#include <QMediaMetaData>
#include <QMediaPlayer>
#include <QMediaPlaylist>
#include <QObject>

class SoundService : public QObject {
    Q_OBJECT
public:
    SoundService();
    Q_INVOKABLE void playCleanSound();
    Q_INVOKABLE void playBeginningBgm();
    Q_INVOKABLE void playClimaxBgm();
    Q_INVOKABLE void playFailedBgm();
    Q_INVOKABLE void playPausedBgm();
    Q_INVOKABLE void playSuccessBgm();
    Q_INVOKABLE void playLastBgm();
    Q_INVOKABLE void setBgmVolume(int volume);
    Q_INVOKABLE void setSeVolume(int volume);

private:
    QMediaPlayer *cleanSound = new QMediaPlayer(this, QMediaPlayer::LowLatency);
    QMediaPlayer *bgmMain = new QMediaPlayer(this, QMediaPlayer::StreamPlayback);
    QMediaPlayer *bgmSub = new QMediaPlayer(this, QMediaPlayer::StreamPlayback);
    QMediaPlaylist *bgmListMain = new QMediaPlaylist(this);
    QMediaPlaylist *bgmListSub = new QMediaPlaylist(this);

    enum BGM { GameBeginning, GameClimax, GameFailed, GamePaused, GameSuccess };

    QMap<BGM, int> bgmIndexMap;
    QMap<BGM, int> bgmDurationMap;

    BGM lastBgm;
    BGM currBgm;

    void mainLoopToSub(qint64 position);
    void subLoopToMain(qint64 position);
    void playBgm(BGM bgm);
};

#endif // SOUND_SERVICE_H
