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
        sqlQuery.exec("CREATE TABLE Normal (end_time TEXT ,score INTEGER NOT NULL , hint_times INTEGER);");
        sqlQuery.exec("CREATE TABLE Hard (end_time TEXT ,score INTEGER NOT NULL , hint_times INTEGER);");
        sqlQuery.exec("CREATE TABLE Challenge (end_time TEXT ,level INTEGER NOT NULL, hint_times INTEGER);");
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
        sqlQuery.addBindValue(QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss"));
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

bool DatabaseService::addNewLevel(QString mode, int level, int hintTimes) {
    if (!db->open()) {
        qDebug() << db->lastError();
        return false;
    } else {
        QSqlQuery sqlQuery(*db);
        bool isSucceed = false;
        if (mode == "Challenge") {
            sqlQuery.prepare("INSERT INTO Challenge (end_time, level, hint_times) VALUES (?, ?, ?)");
            sqlQuery.addBindValue(QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss"));
            sqlQuery.addBindValue(level);
            sqlQuery.addBindValue(hintTimes);
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
