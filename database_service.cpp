#include "database_service.h"

DatabaseService::DatabaseService(QObject *parent) : QObject(parent) {
    if (QSqlDatabase::contains("jewel_game_save_connection")) {
        db = new QSqlDatabase(QSqlDatabase::database("jewel_game_save_connection"));
    } else {
        db = new QSqlDatabase(QSqlDatabase::addDatabase("QSQLITE", "jewel_game_save_connection"));
        db->setDatabaseName("data.db");
    }
    if (!db->open()) {
        qDebug() << db->lastError();
    } else {
        QSqlQuery sqlQuery(*db);
        sqlQuery.exec(
            "CREATE TABLE Normal (end_time TEXT NOT NULL, score INTEGER NOT NULL, hint_times INTEGER NOT NULL);");
        sqlQuery.exec(
            "CREATE TABLE Hard (end_time TEXT NOT NULL, score INTEGER NOT NULL, hint_times INTEGER NOT NULL);");
        sqlQuery.exec("CREATE TABLE Challenge (end_time TEXT NOT NULL, level INTEGER NOT NULL, hint_times INTEGER NOT "
                      "NULL, duration INTEGER NOT NULL);");
    }
}
bool DatabaseService::addNewScore(QString mode, int score, int hintTimes) {
    if (!db->open()) {
        qDebug() << db->lastError();
        return false;
    } else {
        QSqlQuery sqlQuery(*db);
        bool isSucceed = false;
        if (mode == "Normal") {
            sqlQuery.prepare("INSERT INTO Normal (end_time, score, hint_times) VALUES (?, ?, ?)");
        } else if (mode == "Hard") {
            sqlQuery.prepare("INSERT INTO Hard (end_time, score, hint_times) VALUES (?, ?, ?)");
        } else {
            isSucceed = false;
            db->close();
            return isSucceed;
        }
        sqlQuery.addBindValue(QDateTime::currentDateTime().toString("yy/MM/dd hh:mm:ss"));
        sqlQuery.addBindValue(score);
        sqlQuery.addBindValue(hintTimes);
        if (sqlQuery.exec()) {
            isSucceed = true;
        } else {
            qDebug() << db->lastError();
            isSucceed = false;
        }
        db->close();
        return isSucceed;
    }
}

bool DatabaseService::addNewLevel(QString mode, int level, int hintTimes, int duration) {
    if (!db->open()) {
        qDebug() << db->lastError();
        return false;
    } else {
        QSqlQuery sqlQuery(*db);
        bool isSucceed = false;
        if (mode == "Challenge") {
            sqlQuery.prepare("INSERT INTO Challenge (end_time, level, hint_times, duration) VALUES (?, ?, ?, ?)");
            sqlQuery.addBindValue(QDateTime::currentDateTime().toString("yy/MM/dd hh:mm:ss"));
            sqlQuery.addBindValue(level);
            sqlQuery.addBindValue(hintTimes);
            sqlQuery.addBindValue(duration);
        } else {
            isSucceed = false;
            db->close();
            return isSucceed;
        }
        if (sqlQuery.exec()) {
            isSucceed = true;
        } else {
            qDebug() << db->lastError();
            isSucceed = false;
        }
        db->close();
        return isSucceed;
    }
}

QList<QObject *> DatabaseService::getDataByMode(QString mode) {

    auto list = QList<QObject *>();

    if (!db->open()) {
        qDebug() << db->lastError();
        return list;
    } else {
        QSqlQuery sqlQuery(*db);

        if (mode == "Normal") {
            sqlQuery.prepare("select end_time, score, hint_times from Normal");
        } else if (mode == "Hard") {
            sqlQuery.prepare("select end_time, score, hint_times from Hard");
        } else if (mode == "Challenge") {
            sqlQuery.prepare("select end_time, level, hint_times, duration from Challenge");
        } else {
            return list;
        }

        if (!sqlQuery.exec()) {
            qDebug() << sqlQuery.lastError();
        } else {
            while (sqlQuery.next()) {
                GameRoundDataObj *newData = new GameRoundDataObj;
                newData->mode = mode;
                newData->endTime = sqlQuery.value(0).toString();
                if (mode == "Challenge") {
                    newData->level = sqlQuery.value(1).toInt();
                    newData->duration = sqlQuery.value(3).toInt();
                } else
                    newData->score = sqlQuery.value(1).toInt();
                ;
                newData->hintTimes = sqlQuery.value(2).toInt();
                list.append(newData);
            }
        }
    }
    return list;
}

GameRoundDataObj::GameRoundDataObj(QObject *parent) {}

int GameRoundDataObj::getDuration() const { return duration; }

void GameRoundDataObj::setDuration(const int &value) { duration = value; }

QString GameRoundDataObj::getEndTime() const { return endTime; }

void GameRoundDataObj::setEndTime(const QString &value) { endTime = value; }

int GameRoundDataObj::getScore() const { return score; }

void GameRoundDataObj::setScore(int value) { score = value; }

int GameRoundDataObj::getLevel() const { return level; }

void GameRoundDataObj::setLevel(int value) { level = value; }

int GameRoundDataObj::getHintTimes() const { return hintTimes; }

void GameRoundDataObj::setHintTimes(int value) { hintTimes = value; }

QString GameRoundDataObj::getMode() const { return mode; }

void GameRoundDataObj::setMode(const QString &value) { mode = value; }
