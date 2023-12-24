#include "Player.h"




Player::Player()
{
    hand.clear(); /*clear hand */
}



//delete card from  list of card hand
void Player::remove(int index)
{
    hand.removeAt(index);
}

//push card to hand
int Player::addCard(int index){
    hand.push_back(index);
    return index;
}

//get list of card in hand
QList<int> Player::getHand()
{
    return hand;
}

//function to clear hand
void Player::clearHand()
{
    hand.clear();
}


//transfert index to path and add it to hand
QString Player::sourceImage(int image=0)
{
    if(image < 0){
        exit(0);
    }
    QString path= QString("cards/%1.gif").arg(image, 2, 10, QChar('0'));

    hand.push_back(image);

    return path;
}




