#ifndef SCORE_H
#define SCORE_H

#include <QObject>
#include "deck.h"

class Score : public QObject
{
    Q_OBJECT

public:
    Score(Deck* deck);
    Score(int score1,int score2);

    int getScore1() const;

    int getScore2() const;
    void setScore(int indexOfCard1, int indexOfCard2,int briscoS);
    Q_INVOKABLE void clearScore();

private:
    Deck* deck;
    int score1; /*score of player*/
    int score2; /*score of the bot*/


signals:
//    signal that notify that the score1 has changed
    void score1Changed(int score1);
//    signal that notify that the score2 has changed
    void score2Changed(int score2);

};

#endif // SCORE_H


