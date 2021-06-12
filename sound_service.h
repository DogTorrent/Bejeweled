#ifndef SOUND_SERVICE_H
#define SOUND_SERVICE_H

#include <QObject>
#include <QMediaPlayer>
#include <QMediaContent>
#include <QMediaPlaylist>

class SoundService: public QObject {
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
private:
    QMediaPlayer *bgm = new QMediaPlayer(this,QMediaPlayer::StreamPlayback);
    QMediaPlayer *cleanSound = new QMediaPlayer(this,QMediaPlayer::LowLatency);
    QMediaPlaylist *bgmList = new QMediaPlaylist(this);
    int gameBeginningBgmIndex=-1;
    int gameClimaxBgm = -1;
    int gameFailedBgmIndex=-1;
    int gamePausedBgmIndex=-1;
    int gameSuccessBgmIndex=-1;
    int lastBgmIndex=-1;
signals:;
};

#endif // SOUND_SERVICE_H
