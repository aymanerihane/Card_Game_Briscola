#ifndef HAND_H
#define HAND_H

#include "card.h"
#include"deck.h"
#include <QObject>
#include <QList>

class Hand : public QObject, public Deck
{
    Q_OBJECT
public:
    explicit Hand(QObject *parent = nullptr);

    void add(const Card& card);

    void remove(const Card& card);
    void clear();
    const QList<Card>& getCards() const;
private:
    QList<Card> handCard;


signals:
    //    signal for hand changed
    void handChanged();

};

#endif // HAND_H
