#include "deck.h"
#include "Player.h"
using namespace std;



Deck::Deck()
{

}
//getter

//get deck size
int Deck::sizeOfDeck()
{
    return deck.size();
}
//get suite of card by index
int Deck::getSuite(int card)
{
    return suits[card];
}
//get value of card by index
int Deck::getValue(int card)
{
    return cardValue[card];
}
//get the list of deck
QList<int> Deck::getDeck()
{
    return deck;
}
//get the path of briscola card
QString Deck::getBris()
{
    QString path = transfertImgSor(brisco);
    return path;
}
//get the suite of the briscola card
int Deck::getBriscoSuite(){
    return briscoSuite;
}

//setup deck
void Deck::setupDeck(){

    deck.clear();
    cardValue.clear();
    suits.clear();

//    push all cards to the deck list
    for(int i =0; i<10; i++){

        deck.push_back((i));
    }

//    push all value of card to the cardValue list
    for(int i =0; i<40; i++){

        if(i%10 == 0){
            cardValue.push_back(11);
        }else if(i%10 == 2){
            cardValue.push_back(10);
        }else if(i%10 == 1 || i%10 == 3 || i%10 == 4 || i%10 == 5 ||i%10 == 6){
            cardValue.push_back(0);
        }else if(i%10 == 7){
            cardValue.push_back(2);
        }else if(i%10 == 8){
            cardValue.push_back(3);
        }else if(i%10 == 9){
            cardValue.push_back(4);
        }
    }
//    push all Suites of card to the suits list
    for(int i =0; i<40; i++){
        QString index;
        if(i<10){
            index="0"+QString::number(i);
        }else{
            index=QString::number(i);
        }
        //coins = 1, battons =2 , swords = 3, cups = 4
        if(index[0] == '1'){
            suits.push_back(2);
        }else if(index[0] == '2'){
            suits.push_back(3);
        }else if(index[0] == '3'){
            suits.push_back(4);
        }else if(index[0]== '0'){
            suits.push_back(1);
        }

    }

}



//transfert index to path
QString Deck::transfertImgSor(int image){
    QString path= QString("cards/%1.gif").arg(image, 2, 10, QChar('0'));
    return path;
}

//set the suit and the index of briscola card and return path
QString Deck::briscola(int img)
{
    QString path = QString("cards/%1.gif").arg(img, 2, 10, QChar('0'));

    brisco = img;
    briscoSuite = getSuite(img);
    return path;
}


//check the deck if is empty or not =1 if it's not emty and = 0 if is empty
int Deck::isEmp(QList<int> de)
{
    if(!de.isEmpty()){
        return 1;
    }else{
        return 0;
    }
}


//to take a randow card
int Deck::getCard()
{
//    update the size of deck
    int lenght= deck.size()-1;
    emit lenghtChanged(lenght);

    srand(time(0));

    while (true) {
//        choose a card between 0 and 39 randomly
        int chosenCard = rand() % 40;
        auto it = find(deck.begin(), deck.end(), chosenCard);

//        in case the card is found in deck it erased and return the choosen card
        if (it != deck.end()) {
            deck.erase(it);

            return chosenCard;
        }
//        in case the card is not found in deck the loop restart and chose another card intil it found one card in deck
    }
}


