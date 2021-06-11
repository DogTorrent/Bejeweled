#ifndef GAME_SERVICE_H
#define GAME_SERVICE_H

#include <QObject>
#include <QPoint>
#include <ctime>
#include <iostream>
#include <list>
#include <string>
#include <vector>
//#define ROW 8
//#define COL 8

class GameService : public QObject {
    Q_OBJECT
private:
    int *nums;     //[8][8];
    bool *visited; //[8][8];
    int rowCount = 8;
    int colCount = 8;

    class Grid {
    public:
        int x, y;
        Grid(int x, int y) {
            this->x = x;
            this->y = y;
        }
    };

    std::list<Grid> *rowRemoveList = new std::list<Grid>();
    std::list<Grid> *colRemoveList = new std::list<Grid>();
    std::list<Grid> *removeList = new std::list<Grid>();
    std::list<int> *pointList= new std::list<int>();

    //向左向下判断是否存在可消除行
    bool isLine(int i, int j) const;

    void cleanLines();

    //遍历查找是否存在可消除行
    bool hasLine() const;

    // 销毁已找到的可消除行
    void destroyValidBlocks();

    /*!
     * @brief 非死图的第一种情况
     * @verbatim
     * O O
     *  X
     * O O
     * @endverbatim
     * @param x
     * @param y
     * @return
     */
    bool isFirstLineCast(int x, int y) const;

    /*!
     * @brief 非死图的第二种情况
     * @verbatim
     * O O
     *  X
     *  X
     * O O
     * @endverbatim
     * @param x
     * @param y
     * @return
     */
    bool isSecondLineCast(int x, int y) const;

    /*!
     * @brief 非死图的第三种情况
     * @verbatim
     * O  O
     *  XX
     * O  O
     * @endverbatim
     * @param x
     * @param y
     * @return
     */
    bool isThirdLineCast(int x, int y) const;

    std::list<int> isFirstLineCastH(int x, int y) const;
    std::list<int> isSecondLineCastH(int x, int y) const;
    std::list<int> isThridLineCastH(int x, int y) const;

    //交换
    void swap(int x1, int y1, int x2, int y2);

    //是否该点是否连成三个以上直线
    bool isValidLine(int x, int y, int maxLength) const;

    //如果横向和纵向队列都有可消除的宝石，则将他们都加入到消除队列中，并去重
    void addValidBlocks() const;

    //交换后两颗宝石是否可以进行消除
    bool isValid(int x1, int y1, int x2, int y2) const;

    //将已被排到顶部的被消除块随机为新宝石
    void addNewBlocks();

    // 宝石下落
    void blocksDown();

public:
    Q_PROPERTY(int score READ getScore NOTIFY scoreChanged)
    GameService(int rowCount, int colCount);

    int score = 0;

    //游戏初始化
    Q_INVOKABLE void gameInit();

    Q_INVOKABLE bool isDead() const;

    //输入要交换的两块，如果交换后可以消除则交换并消除，如果不能消除则交换回来
    Q_INVOKABLE void inputSwap(int from, int to);

    Q_INVOKABLE QVector<int> getStats();
    Q_INVOKABLE int getStat(int number);
    Q_INVOKABLE int getScore();
    Q_INVOKABLE QPoint getHint();

signals:
    void itemMoved(int from, int to);
    void itemChanged(int number, int type);
    void scoreChanged();
};

#endif // GAME_SERVICE_H
