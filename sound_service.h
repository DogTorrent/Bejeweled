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
    Q_INVOKABLE void onPlayCleanSound();
    Q_INVOKABLE void onPlayBeginningBgm();
    Q_INVOKABLE void onPlayClimaxBgm();
    Q_INVOKABLE void onPlayFailedBgm();
    Q_INVOKABLE void onPlayPausedBgm();
    Q_INVOKABLE void onPlaySuccessBgm();
    Q_INVOKABLE void onPlayLastBgm();
    Q_INVOKABLE void setBgmVolume(int volume);
    Q_INVOKABLE void setSeVolume(int volume);
    Q_INVOKABLE void setBgmEnabled(bool enabled);
    Q_INVOKABLE void setSeEnabled(bool enabled);
signals:
    void playCleanSound();
    void playBeginningBgm();
    void playClimaxBgm();
    void playFailedBgm();
    void playPausedBgm();
    void playSuccessBgm();
    void playLastBgm();

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
    void playBgm(BGM bgm, bool loop);
};

#endif // SOUND_SERVICE_H
