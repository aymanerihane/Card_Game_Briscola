#ifndef Player_H
#define Player_H

#include <QObject>
#include <QDebug>
#include <QList>
#include <QtQml>
#include <string>
#include "deck.h"



class Player : public QObject
{
    Q_OBJECT

public:

    Player(Deck* deck); /*constructor*/

    Q_INVOKABLE void remove(int index);
    Q_INVOKABLE int addCard(int index);
    Q_INVOKABLE QList<int> getHand();
    Q_INVOKABLE void clearHand(QList<int>);
    Q_INVOKABLE QString sourceImage(int);

private:
    //    variable
    Deck* deck; /*object of Deck*/
    QList<int> hand; /*list of card in hand*/
};

#endif // Player_H
