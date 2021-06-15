#include "game_service.h"
#include <qdebug.h>

GameService::GameService(int rowCount, int colCount) {
    this->rowCount = rowCount;
    this->colCount = colCount;
    this->score = 0;
    this->nums = new int[rowCount * colCount];
    this->visited = new bool[rowCount * colCount];
    gameInit();
}

int GameService::getDuration() {
    duration = startTime.secsTo(QDateTime::currentDateTime());
    return duration;
}

void GameService::setScore(int value) {
    score = value;
    emit scoreChanged();
}
bool GameService::isLine(int i, int j) const {
    if (i >= 2 && nums[i * colCount + j] == nums[(i - 1) * colCount + j] &&
        nums[i * colCount + j] == nums[(i - 2) * colCount + j])
        return true;
    if (j >= 2 && nums[i * colCount + j] == nums[i * colCount + (j - 1)] &&
        nums[i * colCount + j] == nums[i * colCount + (j - 2)])
        return true;
    return false;
}

bool GameService::isFirstLineCast(int row, int col) {
    int upperRow = row - 1;
    int leftCol = col - 1;
    int bottomRow = row + 1;
    int rightCol = col + 1;
    bool isBottonLeftSame =
        (leftCol >= 0 && bottomRow < 8 && nums[bottomRow * colCount + leftCol] == nums[row * colCount + col]);
    bool isUpperLeftSame =
        (leftCol >= 0 && upperRow >= 0 && nums[upperRow * colCount + leftCol] == nums[row * colCount + col]);
    bool isBottomRightSame =
        (rightCol < 8 && bottomRow < 8 && nums[bottomRow * colCount + rightCol] == nums[row * colCount + col]);
    bool isUpperRightSame =
        (rightCol < 8 && upperRow >= 0 && nums[upperRow * colCount + rightCol] == nums[row * colCount + col]);

    hintPoints.first = -1;
    hintPoints.second = -1;

    // 左下角与右下角
    if (isBottonLeftSame && isBottomRightSame) {
        hintPoints.first = row * colCount + col;
        hintPoints.second = bottomRow * colCount + col;
        return true;
    }
    // 左下角与左上角
    if (isBottonLeftSame && isUpperLeftSame) {
        hintPoints.first = row * colCount + col;
        hintPoints.second = row * colCount + leftCol;
        return true;
    }
    // 左上角与右上角
    if (isUpperLeftSame && isUpperRightSame) {
        hintPoints.first = row * colCount + col;
        hintPoints.second = upperRow * colCount + col;
        return true;
    }
    // 右上角与右下角
    if (isUpperRightSame && isBottomRightSame) {
        hintPoints.first = row * colCount + col;
        hintPoints.second = row * colCount + rightCol;
        return true;
    }

    return false;
}

bool GameService::isSecondLineCast(int row, int col) {
    int upperRow = row - 1;
    int leftCol = col - 1;
    int bottomRow = row + 1;
    int rightCol = col + 1;
    int rightTwoCol = col + 2;
    int leftTwoCol = col - 2;
    int rightThreeCol = col + 3;
    bool isBottomLeftSame =
        (upperRow >= 0 && rightTwoCol < 8 && nums[upperRow * colCount + rightTwoCol] == nums[row * colCount + col]);
    bool isUpperLeftSame =
        (upperRow >= 0 && leftCol >= 0 && nums[upperRow * colCount + leftCol] == nums[row * colCount + col]);
    bool isBottomRightSame =
        (bottomRow < 8 && rightTwoCol < 8 && nums[bottomRow * colCount + rightTwoCol] == nums[row * colCount + col]);
    bool isUpperRightSame =
        (upperRow >= 0 && rightTwoCol < 8 && nums[upperRow * colCount + rightTwoCol] == nums[row * colCount + col]);
    bool isLeftSame = (leftTwoCol >= 0 && nums[row * colCount + leftTwoCol] == nums[row * colCount + col]);
    bool isRightSame = (rightThreeCol < 8 && nums[row * colCount + rightThreeCol] == nums[row * colCount + col]);

    hintPoints.first = -1;
    hintPoints.second = -1;

    if (col + 1 >= 0 && col + 1 < 8 && nums[row * colCount + rightCol] == nums[row * colCount + col]) {
        // 左上角
        if (isUpperLeftSame) {
            hintPoints.first = row * colCount + leftCol;
            hintPoints.second = upperRow * colCount + leftCol;
            return true;
        }
        // 右上角
        if (isUpperRightSame) {
            hintPoints.first = upperRow * colCount + rightTwoCol;
            hintPoints.second = row * colCount + rightTwoCol;
            return true;
        }
        // 左下角
        if (isBottomLeftSame) {
            hintPoints.first = row * colCount + leftCol;
            hintPoints.second = bottomRow * colCount + leftCol;
            return true;
        }
        // 右下角
        if (isBottomRightSame) {
            hintPoints.first = row * colCount + rightTwoCol;
            hintPoints.second = bottomRow * colCount + rightTwoCol;
            return true;
        }

        //左跳一格
        if (isLeftSame) {
            hintPoints.first = row * colCount + leftCol;
            hintPoints.second = row * colCount + leftTwoCol;
            return true;
        }

        //右跳一格
        if (isRightSame) {
            hintPoints.first = row * colCount + rightThreeCol;
            hintPoints.second = row * colCount + rightTwoCol;
            return true;
        }
    }
    return false;
}

bool GameService::isThirdLineCast(int row, int col) {
    int upperRow = row - 1;
    int leftCol = col - 1;
    int upperTwoRow = row - 2;
    int bottomTwoRow = row + 2;
    int bottomThreeRow = row + 3;
    int rightCol = col + 1;
    bool isLeftBottomSame =
        (bottomTwoRow < 8 && leftCol >= 0 && nums[bottomTwoRow * colCount + leftCol] == nums[row * colCount + col]);
    bool isLeftTopSame =
        (upperRow >= 0 && leftCol >= 0 && nums[upperRow * colCount + leftCol] == nums[row * colCount + col]);
    bool isRightBottomSame =
        (bottomTwoRow < 8 && rightCol < 8 && nums[bottomTwoRow * colCount + rightCol] == nums[row * colCount + col]);
    bool isRightTopSame =
        (upperRow >= 0 && rightCol < 8 && nums[upperRow * colCount + col] == nums[row * colCount + col]);
    bool isTopSame = (upperTwoRow >= 0 && nums[upperTwoRow * colCount + col] == nums[row * colCount + col]);
    bool isBottomSame = (bottomThreeRow < 8 && nums[bottomThreeRow * colCount + col] == nums[row * colCount + col]);

    hintPoints.first = -1;
    hintPoints.second = -1;

    if (row + 1 < 8 && row + 1 >= 0 && nums[(row + 1) * colCount + col] == nums[row * colCount + col]) {
        // 左上角
        if (isLeftTopSame) {
            hintPoints.first = upperRow * colCount + col;
            hintPoints.second = upperRow * colCount + leftCol;
            return true;
        }
        // 右上角
        if (isRightTopSame) {
            hintPoints.first = upperRow * colCount + col;
            hintPoints.second = upperRow * colCount + rightCol;
            return true;
        }
        // 左下角
        if (isLeftBottomSame) {
            hintPoints.first = bottomTwoRow * colCount + col;
            hintPoints.second = bottomTwoRow * colCount + leftCol;
            return true;
        }
        // 右下角
        if (isRightBottomSame) {
            hintPoints.first = bottomTwoRow * colCount + col;
            hintPoints.second = bottomTwoRow * colCount + rightCol;
            return true;
        }

        //上跳一格
        if (isTopSame) {
            hintPoints.first = upperRow * colCount + col;
            hintPoints.second = upperTwoRow * colCount + col;
            return true;
        }

        //下跳一格
        if (isBottomSame) {
            hintPoints.first = bottomThreeRow * colCount + col;
            hintPoints.second = bottomTwoRow * colCount + col;
            return true;
        }
    }
    return false;
}

void GameService::cleanLines() {
    removeList->clear();

    for (int i = 0; i < 8; i++)
        for (int j = 0; j < 8; j++)
            visited[i * colCount + j] = false;

    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            if (!visited[i * colCount + j] && isValidLine(i, j, 4)) {
                addValidBlocks();
            }
        }
    }
}

bool GameService::hasLine() const {
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            if (isLine(i, j)) return true;
        }
    }
    return false;
}

bool GameService::isDead() { //是否变成了死图
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            if (isFirstLineCast(i, j)) return false;
            if (isSecondLineCast(i, j)) return false;
            if (isThirdLineCast(i, j)) return false;
        }
    }
    return true;
}

void GameService::gameInit() {
    setScore(0);
    startTime = QDateTime::currentDateTime();
    duration = 0;
    srand(time(nullptr));
    for (int i = 0; i < rowCount; i++) {
        for (int j = 0; j < colCount; j++) {
            nums[i * colCount + j] = rand() % 7;

            while (isLine(i, j)) { //如果存在三个相连的情况，重新随机
                nums[i * colCount + j] = rand() % 7;
            }
        }
    }

    if (isDead()) { //如果是死图，重新生成
        gameInit();
    }
    // display();
}

void GameService::swap(int x1, int y1, int x2, int y2) {
    int n = nums[x1 * colCount + y1];
    nums[x1 * colCount + y1] = nums[x2 * colCount + y2];
    nums[x2 * colCount + y2] = n;
    emit itemMoved(x1 * colCount + y1, x2 * colCount + y2);
}

bool GameService::isValidLine(int x, int y, int maxLength) const {
    rowRemoveList->clear();
    colRemoveList->clear();
    rowRemoveList->push_back(*(new Grid(x, y)));
    colRemoveList->push_back(*(new Grid(x, y)));

    // 左
    for (int i = -1; i >= -maxLength; i--) {
        if (x + i >= 0 && nums[x * colCount + y] == nums[(x + i) * colCount + y])
            rowRemoveList->push_back(*(new Grid(x + i, y)));
        else
            break;
    }
    // 右
    for (int i = 1; i <= maxLength; i++) {
        if (x + i < 8 && nums[x * colCount + y] == nums[(x + i) * colCount + y])
            rowRemoveList->push_back(*(new Grid(x + i, y)));
        else
            break;
    }
    // 上
    for (int j = 1; j <= maxLength; j++) {
        if (y + j < 8 && nums[x * colCount + y] == nums[x * colCount + (y + j)])
            colRemoveList->push_back(*(new Grid(x, y + j)));
        else
            break;
    }
    // 下
    for (int j = -1; j >= -maxLength; j--) {
        if (y + j >= 0 && nums[x * colCount + y] == nums[x * colCount + (y + j)])
            colRemoveList->push_back(*(new Grid(x, y + j)));
        else
            break;
    }

    if (rowRemoveList->size() >= 3 || colRemoveList->size() >= 3) return true;
    return false;
}

void GameService::addValidBlocks() const {
    bool isRowValid = rowRemoveList->size() >= 3;
    bool isColValid = colRemoveList->size() >= 3;
    auto *List = new std::list<Grid>();

    if (isRowValid && isColValid) colRemoveList->pop_front();
    if (isRowValid) List->insert(List->begin(), rowRemoveList->begin(), rowRemoveList->end());
    if (isColValid) List->insert(List->begin(), colRemoveList->begin(), colRemoveList->end());

    for (Grid element : *List) {
        visited[element.x * colCount + element.y] = true;
    }

    removeList->insert(removeList->begin(), List->begin(), List->end());
}

bool GameService::isValid(int x1, int y1, int x2, int y2) const {
    removeList->clear();

    bool isValid = false;
    if (isValidLine(x1, y1, 2)) {
        isValid = true;
        addValidBlocks();
    }
    if (isValidLine(x2, y2, 2)) {
        isValid = true;
        addValidBlocks();
    }

    return isValid;
}

void GameService::addNewBlocks() {
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            if (nums[i * colCount + j] == 8) {
                nums[i * colCount + j] = rand() % 7;
                emit itemChanged(i * colCount + j, nums[i * colCount + j]);
            }
        }
    }

    if (hasLine()) {
        cleanLines();
        destroyValidBlocks();
    }
}

void GameService::blocksDown() {
    for (int x = 8; x >= 0; x--) {
        int upBlock = 0;
        int upSpace = 0;
        for (int y = 0; y < 8; y++) {
            if (nums[x * colCount + y] == 8) {
                upBlock = x - 1;
                while (upBlock >= 0 && nums[upBlock * colCount + y] == 8) {
                    upBlock--;
                }

                upSpace = upBlock - 1;
                while (upSpace >= 0 && nums[upSpace * colCount + y] != 8) {
                    upSpace--;
                }

                if (upBlock >= 0 && upBlock < 8) {
                    for (int k = upBlock; k > upSpace; k--) {
                        //                        nums[(x + k - upBlock) * colCount + y] = nums[k * colCount + y];
                        //                        nums[k * colCount + y] = 8;
                        swap(x + k - upBlock, y, k, y);
                    }

                    x++;
                    x -= (upSpace - upBlock);
                }
            }
        }
    }

    addNewBlocks();
}

void GameService::destroyValidBlocks() {
    for (int i = removeList->size() - 1; i >= 0; i--) {
        int x = removeList->front().x;
        int y = removeList->front().y;
        nums[x * colCount + y] = 8; //将销毁值设定为8
        removeList->pop_front();
        setScore(score + 1);
        emit itemChanged(x * colCount + y, 8);
    }

    blocksDown();
}

void GameService::inputSwap(int from, int to) {
    int x1 = from / colCount;
    int y1 = from % colCount;
    int x2 = to / colCount;
    int y2 = to % colCount;
    swap(x1, y1, x2, y2);
    if (isValid(x1, y1, x2, y2)) { //如果交换后可以消除
        //执行消除
        destroyValidBlocks();
    } else { //不能消除则交换回来
        swap(x1, y1, x2, y2);
    }
}

QVector<int> GameService::getStats() {
    QVector<int> result;
    for (int i = 0; i < rowCount; i++) {
        for (int j = 0; j < colCount; j++) {
            result.append(nums[i * colCount + j]);
        }
    }
    return result;
}

int GameService::getStat(int number) {
    if (number < 0 || number > rowCount * colCount - 1) return -1;
    int tempRow = number / colCount;
    int tempCol = number % colCount;
    return nums[tempRow * colCount + tempCol];
}

int GameService::getScore() { return score; }

QPoint GameService::getHint() {
    if (!isDead())
        return QPoint(hintPoints.first, hintPoints.second);
    else
        return QPoint(-1, -1);
}
