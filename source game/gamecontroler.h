#ifndef GAMECONTROLER_H
#define GAMECONTROLER_H

#include "deck.h"
#include "player.h"
#include "score.h"
#include <QObject>
#include <QList>
#include <QDebug>
#include <iterator>
#include <random>
#include <time.h>
#include <QTimer>
#include <QFile>
#include <QTextStream>
#include <QStandardPaths>

class GameControler : public QObject
{
    Q_OBJECT

public:
    GameControler(Deck* deck , Player* player1, Player* player2 ,Score* score);


    void switchTurn(); /*function that switch turns*/
    Q_INVOKABLE int toindex(QString path); /*convert a path to index*/
    Q_INVOKABLE QString toPath(int index); /*convert a path to index*/
    Q_INVOKABLE bool getTurn(); /*a player1Turn's getter*/
    Q_INVOKABLE void setTurn(bool turn); /*a player1Turn's setter*/
    Q_INVOKABLE int searchCard(QString path,Player* p1); /*a function that searches for a card in the hand of a specific player.*/
    Q_INVOKABLE QString botPlay(int turn, int cardPlayed=0); /*a function that makes the bot play one card, considering the difficult*/
    Q_INVOKABLE void play(QString cardPlayed);/*a function that take the card playerd from a player or a bot and make the other play*/
    Q_INVOKABLE int getTurnDouble();/*a turn's getter*/
    Q_INVOKABLE void setTurnDouble(int turn);/*a turn's setter*/
    Q_INVOKABLE void winner(); /*a function that determines the winner*/
    Q_INVOKABLE int getWhoWin(); /*a getter of whoWin*/
    Q_INVOKABLE void setDifficulty(QString diff); /*a function that it set difficulty from Qml*/
    Q_INVOKABLE int hightScore(); /*get/set the hight score from/in a file*/

private:
    Deck* deck;
    Score* score;
    Player* player1;
    Player* player2;
    int turn; /*it increment after each player play*/
    int whoWin;/*=0 if it's egalite =1 if the player 1 win =2 id the bot win*/
    int card2;  /*it's the card played from the second player*/
    bool player1Turn; /*if it's = true then is the player 1 turn*/
    QString difficulty; /*can equal easy or hard or medium*/

signals:

    void handChanged(QString imageEmit); /*a signal when the bot has played*/
    void clearBattle(int turn); /*a signal that clear the battle from card*/
    void turnChanged(bool player1Turn); /*a signal of the turn has changed*/
    void winnerDetected(); /*a signal when the game is over*/
    void hightScorechanged(int hightScore); /*a signal when hight score is changed*/
};

#endif // GAMECONTROLER_H
