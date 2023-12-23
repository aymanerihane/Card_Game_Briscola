#include "score.h"


Score::Score(Deck* deck)
    : score1(0),score2(0),deck(deck) /*set score to 0 in the begining*/
{}


//get score of player1
int Score::getScore1() const
{
    return score1;
}



//get score of bot
int Score::getScore2() const
{
    return score2;
}


void Score::setScore(int indexOfCard1,int indexOfCard2,int briscoS)
{
    int scoreP1 = deck->getValue(indexOfCard1); /*get value of card played by the player*/
    int scoreP2 = deck->getValue(indexOfCard2);/*get value of card played by the bot*/
    int suitP1 = deck->getSuite(indexOfCard1);/*get suit of card played by the player*/
    int suitP2 = deck->getSuite(indexOfCard2);/*get suit of card played by the bot*/

//    in case the two card belong to the briscola suit or there not at the same time
    if((suitP1 == briscoS && suitP2 == briscoS) || (suitP1 != briscoS && suitP2 != briscoS)){
//        in case the score of the card played by the player is higher then bot card
        if(scoreP1>scoreP2){
            score1= score1+( scoreP1+scoreP2);
            emit score1Changed(score1);
        }
//        in case the score of the card played by the player is lower then the bot card
        else if (scoreP1 < scoreP2){
            score2 = score2+( scoreP1+scoreP2);
            emit score2Changed(score2);
        }
//    in case the player played a card belong to the briscola suit and the bot didn't
    }else if(suitP1 == briscoS && suitP2 != briscoS){
        if((scoreP1 !=0 && scoreP2 != 0) || (scoreP1 !=0 && scoreP2 == 0) || (scoreP1 ==0 && scoreP2 != 0)){
            score1= score1+( scoreP1+scoreP2);
            emit score1Changed(score1);
        }
//    in case the bot played a card belong to the briscola suit and the player didn't
    }else if(suitP1 != briscoS && suitP2 == briscoS){
        if((scoreP1 !=0 && scoreP2 != 0) || (scoreP1 !=0 && scoreP2 == 0) || (scoreP1 ==0 && scoreP2 != 0)){
            score2 = score2+(scoreP1+scoreP2);
            emit score2Changed(score2);
        }
    }
}

//reset score to 0
void Score::clearScore()
{
    score1=0;
    score2=0;
    emit score2Changed(score2);
    emit score1Changed(score1);
}
