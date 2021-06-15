#ifndef GAME_SERVICE_H
#define GAME_SERVICE_H

#include <QDateTime>
#include <QObject>
#include <QPoint>
#include <ctime>
#include <iostream>
#include <list>
#include <string>
#include <vector>

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

    //点击提示时获取的两个宝石的序号
    QPair<int, int> hintPoints;

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
     * @param row
     * @param col
     * @return
     */
    bool isFirstLineCast(int row, int col);

    /*!
     * @brief 非死图的第二种情况
     * @verbatim
     * O O      O      O
     *  X   or  x  or  O
     *  X       O      X
     * O O      O      O
     * @endverbatim
     * @param row
     * @param col
     * @return
     */
    bool isSecondLineCast(int row, int col);

    /*!
     * @brief 非死图的第三种情况
     * @verbatim
     * O  O
     *  XX   or  OOXO  or  OXOO
     * O  O
     * @endverbatim
     * @param row
     * @param col
     * @return
     */
    bool isThirdLineCast(int row, int col);

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
    Q_PROPERTY(int score READ getScore WRITE setScore NOTIFY scoreChanged)
    Q_PROPERTY(int duration READ getDuration)
    GameService(int rowCount, int colCount);

    int score = 0;
    QDateTime startTime;
    int duration = 0;

    //游戏初始化
    Q_INVOKABLE void gameInit();

    Q_INVOKABLE bool isDead();

    //输入要交换的两块，如果交换后可以消除则交换并消除，如果不能消除则交换回来
    Q_INVOKABLE void inputSwap(int from, int to);

    Q_INVOKABLE QVector<int> getStats();
    Q_INVOKABLE int getStat(int number);
    Q_INVOKABLE int getScore();
    Q_INVOKABLE void setScore(int value);
    Q_INVOKABLE QPoint getHint();
    Q_INVOKABLE int getDuration();

signals:
    void itemMoved(int from, int to);
    void itemChanged(int number, int type);
    void scoreChanged();
};

#endif // GAME_SERVICE_H
