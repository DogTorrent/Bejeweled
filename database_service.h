#ifndef DATABASESERVICE_H
#define DATABASESERVICE_H

#include <QDateTime>
#include <QDebug>
#include <QObject>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>

class GameRoundDataObj : public QObject {
    Q_OBJECT
public:
    explicit GameRoundDataObj(QObject *parent = nullptr);

    QString mode;
    int score = -1;
    int level = -1;
    int hintTimes = -1;
    QString endTime = "";
    int duration = -1;

    Q_INVOKABLE QString getMode() const;
    Q_INVOKABLE void setMode(const QString &value);
    Q_INVOKABLE int getScore() const;
    Q_INVOKABLE void setScore(int value);
    Q_INVOKABLE int getLevel() const;
    Q_INVOKABLE void setLevel(int value);
    Q_INVOKABLE int getHintTimes() const;
    Q_INVOKABLE void setHintTimes(int value);
    Q_INVOKABLE QString getEndTime() const;
    Q_INVOKABLE void setEndTime(const QString &value);
    Q_INVOKABLE int getDuration() const;
    Q_INVOKABLE void setDuration(const int &value);

    Q_PROPERTY(QString mode READ getMode WRITE setMode NOTIFY modeChanged)
    Q_PROPERTY(int score READ getScore WRITE setScore NOTIFY scoreChanged)
    Q_PROPERTY(int level READ getLevel WRITE setLevel NOTIFY levelChanged)
    Q_PROPERTY(int hintTimes READ getHintTimes WRITE setHintTimes NOTIFY hintTimesChanged)
    Q_PROPERTY(QString endTime READ getEndTime WRITE setEndTime NOTIFY endTimeChanged)
    Q_PROPERTY(int duration READ getDuration WRITE setDuration NOTIFY durationChanged)

signals:
    void modeChanged();
    void scoreChanged();
    void levelChanged();
    void hintTimesChanged();
    void endTimeChanged();
    void durationChanged();
};

class DatabaseService : public QObject {
    Q_OBJECT
public:
    explicit DatabaseService(QObject *parent = nullptr);
    Q_INVOKABLE bool addNewScore(QString mode, int score, int hintTimes);
    Q_INVOKABLE bool addNewLevel(QString mode, int level, int hintTimes, int duration);
    Q_INVOKABLE QList<QObject *> getDataByMode(QString mode);

private:
    QSqlDatabase *db;
signals:
};

#endif // DATABASESERVICE_H
