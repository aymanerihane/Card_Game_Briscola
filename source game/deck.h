#ifndef DECK_H
#define DECK_H

#include <QObject>
#include <QDebug>
#include <QList>
#include <iterator>
#include <random>
#include <time.h>


using namespace std;


class Deck : public QObject
{
    Q_OBJECT

private:
    QList<int> deck; /*list of card in deck*/
    QList<int> cardValue; /*list of card Value*/
    QList<int> suits; /*list of card Suite*/
    int brisco; /*briscola card index*/
    int briscoSuite; /*briscola card suite*/


public:

    Deck();

    Q_INVOKABLE QString briscola(int img);
    Q_INVOKABLE QString transfertImgSor(int image=0);
    Q_INVOKABLE int getCard();

//    getter
    Q_INVOKABLE int sizeOfDeck();
    Q_INVOKABLE void setupDeck();
    Q_INVOKABLE int isEmp(QList<int> de);
    Q_INVOKABLE QList<int> getDeck();
    QString getBris();
    int getBriscoSuite();
    int getSuite(int card);
    int getValue(int card);



signals:
//    signal that update the size of deck
    void lenghtChanged(int lenght);

};


#endif // DECK_H
