#ifndef DATABASESERVICE_H
#define DATABASESERVICE_H

#include <QDateTime>
#include <QDebug>
#include <QObject>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>

class DatabaseService : public QObject {
    Q_OBJECT
public:
    explicit DatabaseService(QObject *parent = nullptr);
    Q_INVOKABLE bool addNewScore(QString mode, int score, int hintTimes);
    Q_INVOKABLE bool addNewLevel(QString mode, int level, int hintTimes);

private:
    QSqlDatabase *db;
signals:
};

#endif // DATABASESERVICE_H
