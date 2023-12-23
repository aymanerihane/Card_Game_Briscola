#include "gamecontroler.h"


using namespace std;


GameControler::GameControler(Deck* deck,Player* player1, Player* player2, Score* score)
    : deck(deck), player1(player1), player2(player2),score(score), player1Turn(true),turn(0),card2(0)
{
    deck->setupDeck();
}

void GameControler::switchTurn()
{
//    switching the player1Turn
   player1Turn=!player1Turn;


}

bool GameControler::getTurn()
{
   return player1Turn;
}

void GameControler::setTurn(bool turn)
{
   player1Turn= turn;
   emit turnChanged(player1Turn);
}

void GameControler::play(QString cardPlayedSource)
{
    QList<int> deckList = deck->getDeck();/* get the deck cards*/
    QList<int> player1Hand = player1->getHand(); /*get player1 hand*/
    QList<int> player2Hand = player2->getHand(); /*get player2 hand*/
    int briscoS= deck->getBriscoSuite();

    int indexOfCardPlayed = searchCard(cardPlayedSource,player1); /*trnasfert the path in function parametre to a index in the hand of the secand parametre*/
    int indexCard = toindex(cardPlayedSource); /*stock the index in deck of the cardPlayed*/
    int cardPlay= player1Hand[indexOfCardPlayed]; /*stock the index in the hand of player 1 of the card played*/
    int indexOfImageEmit =card2; /*stock the index of the last card played from the bot in indexOfImageEmit*/
    QString imageEmit=toPath(card2); /*stock the path of the last card played from the bot in indexOfImageEmit*/


        while (turn < 2) {
            if (player1Turn == false){/* turn of bot*/

                imageEmit=botPlay(turn, cardPlay);
                indexOfImageEmit =toindex(imageEmit);

            }else if(player1Turn == true){ /* turn of player1*/

                player1->remove(indexOfCardPlayed);
                if(turn == 0){
                    switchTurn();
                    qDebug() << "---------------" ;
                }
                    qDebug() << "le player a jouer" << indexCard;
                turn++;

            }
        }
//        initialize the turn with 0
        turn = 0;
//        set the score of the round
        score->setScore(indexCard,indexOfImageEmit ,briscoS);

        int valueCardEmit= deck->getValue(indexOfImageEmit); /*stock the value of card emit by bot*/
        int valueCardPlayed = deck->getValue(indexCard);    /*stock the value of card emit by player1*/
        int CardEmitS= deck->getSuite(indexOfCardPlayed);
        int CardPlayedS= deck->getSuite(indexCard);


//        clear the battle
        emit clearBattle(0);


        if((CardEmitS==briscoS && CardPlayedS==briscoS) || (CardEmitS!=briscoS && CardPlayedS!=briscoS)){

            if(valueCardEmit > valueCardPlayed){

                player1Turn = false;
                emit turnChanged(player1Turn);


            }else if(valueCardEmit == valueCardPlayed){
                if(valueCardEmit == 0 && valueCardPlayed == 0){
                    if((indexOfImageEmit%10) > (indexCard%10)){
                        player1Turn = false;
                        emit turnChanged(player1Turn);
                    }else{
                        player1Turn=true;
                        emit turnChanged(player1Turn);
                    }

                }else{
//                    player1Turn = true;
                    switchTurn();
                    emit turnChanged(player1Turn);
                }
            }else if(valueCardEmit < valueCardPlayed){ /*!! pass*/
                player1Turn = true;
                emit turnChanged(player1Turn);
            }

        }else if(CardEmitS!=briscoS && CardPlayedS==briscoS){
            player1Turn= true;
            emit turnChanged(player1Turn);
        }else if(CardEmitS==briscoS && CardPlayedS!=briscoS){
            player1Turn= false;
            emit turnChanged(player1Turn);
        }

//        if the player1 and do bot d'ont have any card that mean that the game is over
        if(player1Hand.size()==1 && (player2Hand.size()==1 || player2Hand.size() == 0)){
                winner();
        }


}



int GameControler::toindex(QString path)
{
    QRegularExpression regex("(\\d+)\\.gif");
    QRegularExpressionMatch match = regex.match(path);

    // Extract the captured digits from the match
    QString numberPart = match.captured(1);

    // Convert the extracted string to an integer
    int index = numberPart.toInt();

    return index;

}

QString GameControler::toPath(int index)
{
    QString path= QString("cards/%1.gif").arg(index, 2, 10, QChar('0'));
    return path;
}

int GameControler::getTurnDouble()
{
    return turn;

}

void GameControler::setTurnDouble(int turn)
{
    this->turn= turn;

}

void GameControler::winner()
{
        int score1=score->getScore1(); /*the score of the player1*/
        int score2=score->getScore2(); /*the score of the bot*/



//        in case the score 1> score2 the player1 win
        if(score1>score2){
            whoWin=1;
            hightScore();

        }else if(score2 >=score1){/*in case the score 1< score2 the bot win*/
            whoWin=2;
        }
//        emit the signal that the winner is determined
        emit winnerDetected();

}

int GameControler::getWhoWin()
{
        return whoWin;
}


void GameControler::setDifficulty(QString diff)
{
        difficulty= diff;
}

int GameControler::hightScore()
{
        int score1 = score->getScore1(); // the score of player1
        int hightScore = 0; // initialize high score
        QString appDirPath= QCoreApplication::applicationDirPath();
        QString fileName = appDirPath+"/hightScore.txt";
        QFile file(fileName);

        // Check if the file exists
        if (!file.exists()) {
            qDebug() << "File does not exist. Creating a new file...";

            // Open the file in write mode to create it
            if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
                QTextStream out(&file);
                out << "0";
                file.close();
            } else {
                qDebug() << "Error: Could not create the file.";
                return 0; // Return a default value or handle the error appropriately
            }
        }

        // Open the file in read-only mode
        if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            QTextStream in(&file);
            QString fileContents = in.readAll();
            hightScore = fileContents.toInt();
            file.close();
            qDebug() << "The high score is: " << hightScore;

            if (score1 > hightScore) {
                // Open the file in write mode to update the high score
                if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
                    QTextStream out(&file);
                    hightScore = score1;
                    out << hightScore;
                    file.close();
                    emit hightScorechanged(hightScore);
                    qDebug() << "High score updated successfully.";
                } else {
                    qDebug() << "Error: Could not open the file for writing.";
                }
            }
        } else {
            qDebug() << "Error: Could not open the file for reading.";
        }

        return hightScore;
}



int GameControler::searchCard(QString path, Player* p1)
{
    // Extract the numeric part from the path
    QRegularExpression regex("(\\d+)\\.gif");
    QRegularExpressionMatch match = regex.match(path);

    // Check if the match is successful
    if (match.hasMatch()) {
        // Extract the captured digits from the match
        QString numberPart = match.captured(1);

        // Convert the extracted string to an integer
        int cardNumber = numberPart.toInt();
        QList<int> handp1 = p1->getHand();
        // Check if the card was found
        int index = handp1.indexOf(cardNumber);
        if (index != -1) {
            qDebug() << "card choesen is " << cardNumber << "and the index is :"<<index;
            return index;
        } else { /*in case the card is not found in the hand*/
            qDebug() << "Card with number" << cardNumber << "not found in the hand.";
            return -1;
        }
    } else {
        qDebug() << "No match found for the card number in the path:" << path;
        return -2;
    }

}



QString GameControler::botPlay(int botTurn, int cardPlayed)
{

    QList<int> hand = player2->getHand();/*hand of player2(bot)*/
    QList<int> player1Hand = player1->getHand();/*hand of player1*/

    if(hand.size()==0)
        return "";
    //    if the player1 select the difficulty medium
    static int med = 0;
    if(difficulty == "Medium"){
        med++;
        srand(time(0));
        int randDifficulty= rand() % 2; /*generate a random = 0 or =1*/
        if(randDifficulty == 0){ /*in case this random is equal 0 the bot will play in hard difficulty*/
            difficulty="Hard";
            botPlay(botTurn,cardPlayed);
        }else{ /*in case this random is equal 0 the bot will play in easy difficulty*/
            difficulty="Easy";
            botPlay(botTurn,cardPlayed);
        }
        return "";

    }

    QString imageEmit = ""; /*the return value it represent the path of the card*/
    QString source = ""; /*stock the value that convert a index to a path*/


    int first = hand[0];/*first element of the hand player2(bot)*/
    int cardPlayedValue= deck->getValue(cardPlayed); /*The value of the card played by Player 1*/
    int cardPlayedSuit= deck->getSuite(cardPlayed); /*The suit of the card played by Player 1*/

//    counters
    int playedmaxB=0;
    int cardValue = 0; /*the value of the card in hand it change in loop*/
    int cardSuit= 0; /*the suits of the card in hand it change in loop*/
    int playedmax=0; /*counter to know if there is a hight value in bot hand that he can play if !=1 then he have min of a 1card hight then the player card played*/
    int brisDef=0; /*a counter that increments when a card that does not belong to the briscola suite is detected in the hand*/
    int playedMB=0; /*a counter that increments when a the max of cards briscola detected in the hand*/
    int briscoCounter=0; /*a counter that increments when there is a briscola card in hand*/
    int maxMinCounter=0;


    int index=first; /*stock the index of the card*/
    int min= deck->getValue(first); /*set initial min value of the hand*/
    int tempmin = first;/*the heigths card in hand that has a have small than cardPalyed*/
    int max = deck->getValue(first);/*set initial max value of the hand*/
    int temp = first; /*the heigths card in hand that has bigger value than cardPalyed*/
    int minDefBrisco=first; /*la valeur minimal different de briscola*/
    int minMax= first; /*value minimal of the cards that have a value superieur to cardPlayed*/
    int minMaxVa = deck->getValue(minMax); /*the value of the minMax*/
    int minMaxBrisco=first ;/*value minimal of the cards that have a value superieur to cardPlayed and it-s a briscola */
    int valueOfMinDefBris= 0; /*value of min card in hand that not blong to briscola suit*/
    int maxMin=first;

    //    briscola variable
    int briscoSuit = deck->getBriscoSuite(); /*stock the briscola suite*/
    int minMaxBriscoS=0; /*suite of the value minimal of the cards that have a value superieur to cardPlayed and it-s a briscola */
    int minBrisco=first; /*the min of briscola cards*/
    int maxBrisco=first; /*the max of briscola cards*/
    int min2= deck->getValue(first); /*set initial min2 value of the hand*/

    if(hand.size()== 3)
        qDebug()<<"les cartes du bot sont : "<<hand[0]<<", "<<hand[1]<< ", "<< hand[2];
    else if(hand.size() == 2)
        qDebug()<<"les cartes du bot sont : "<<hand[0]<<", "<<hand[1];
    else
        qDebug()<<"les cartes du bot sont : "<<hand[0];

//    a loop to detect if there is a briscola suit card in bot hand and stock the max, min and minMax briscola cards
    foreach (const int &card , hand){
        cardValue = deck->getValue(card);
        cardSuit = deck->getSuite(card);
        if( cardSuit == briscoSuit){
            briscoCounter++;
            if(cardPlayedValue < cardValue){
                if(min >= cardValue){
                 min = cardValue;

                 minMaxBrisco = card;
                }
                playedmaxB++;

            }
            if(min2 >= cardValue){
                min2 = cardValue;

                minBrisco = card;
            }else{
                maxBrisco= card;
                playedMB++;
            }

        }
    }

//    Initialize a variable for reuse
    min=deck->getValue(first);
    cardValue = 0;
    cardSuit= 0;

//    a loop to detect if there is a card taht not blong to briscola suit card in bot hand and stock the min deffirent de briscola cards
    foreach(const int &card, hand){
        cardValue = deck->getValue(card);
        cardSuit = deck->getSuite(card);
        if(cardSuit != briscoSuit){
            brisDef++;
            if(min>=cardValue){
                tempmin=card;
                min = cardValue;
                minDefBrisco = card;
            }
        }

    }

//    Initialize a variable for reuse
    max=deck->getValue(first);
    cardValue = 0;
    foreach(const int &card, hand){
        cardValue = deck->getValue(card);
        if(cardValue < cardPlayedValue){
            if(max <= cardValue){
                max= cardValue;
                maxMin=card;
            }
            maxMinCounter++;
        }
    }
    //    Initialize a variable for reuse
    min=deck->getValue(first);
    tempmin= first;
    cardValue = 0;

//  loop the find min , max and minMax card in all hand
    foreach (const int &card , hand){
        cardValue = deck->getValue(card);

        //            check if the bot have a better card

        if(cardPlayedValue >= cardValue){

            if(max < cardValue){

                temp = card;
                max = cardValue;
                if(max<= minMaxVa){
                 minMax = card;
                }

            }
            playedmax++; /*if yes the playedmax increment*/
        }else if(cardPlayedValue >= cardValue){ /*check the lowest card in bot hand*/


            if(min > cardValue){
                if(cardPlayedValue == cardValue){
                 if((card%10)<(cardPlayed%10)){
                     tempmin = card;
                     min = cardValue;
                 }
                }else{

                 tempmin = card;
                 min = cardValue;
                }


            }
        }

    }

    valueOfMinDefBris = deck->getValue(minDefBrisco);

    //        in case the bot is the first to play
    if(botTurn == 0){
        qDebug()<<"----------";
        turn=0;

        //        in case the bot have 3 briscola card or noneof them
        if(briscoCounter == 3 || briscoCounter== 0){
            source = deck->transfertImgSor(tempmin);
            index = searchCard(source,player2);
            qDebug()<< "l'index dans le bot"<< source;
            player2->remove(index);
            imageEmit=source;

            //        in case the bot have 2 or 1 briscola card
        }else if(briscoCounter==2 || briscoCounter==1){
            source = deck->transfertImgSor(minDefBrisco);
            index = searchCard(source,player2);
            qDebug()<< "l'index dans le bot"<< source;
            player2->remove(index);
            imageEmit=source;
        }
        turn=1;
    }

//    in case the player1 chose th hard difficulty
    if(difficulty == "Hard"){

        //        in case the bot is the first to play
       if(botTurn == 1){

//        in case the player didn't draw a briscola card and the bot also don't have it
            if(briscoCounter == 0 && cardPlayedSuit != briscoSuit){

//                in case there is a card that has bigger value then the card Played in hand
                if(playedmax != 0){
                 if(cardPlayedValue == 0){
                     source = deck->transfertImgSor(tempmin);
                     index = searchCard(source,player2);
                     player2->remove(index);
                     imageEmit=source;
                 }else if(cardPlayedValue != 0){
                     source = deck->transfertImgSor(minMax);
                     index = searchCard(source,player2);
                     player2->remove(index);
                     imageEmit=source;
                 }
                }else if(playedmax == 0){/*in case there is no card that has bigger value then the card Played in hand*/

                 source = deck->transfertImgSor(tempmin);
                 index = searchCard(source,player2);
                 player2->remove(index);
                 imageEmit=source;

                }


//        in case the player draw a briscola card and the bot have it
            }else if(briscoCounter != 0 && cardPlayedSuit == briscoSuit){
//                in case the bot has all card is briscola suit
                if(briscoCounter == 3){
                 if(cardPlayedValue == 0){
                     source = deck->transfertImgSor(tempmin);
                     index = searchCard(source,player2);
                     player2->remove(index);
                     imageEmit=source;
                 }else if(cardPlayedValue != 0){
//                     in case there is a card height then the card played
                     if(playedmax != 0){
                         source = deck->transfertImgSor(minMax);
                         index = searchCard(source,player2);
                         player2->remove(index);
                         imageEmit=source;

                     }else{/*in case there is no card height then the card played*/
                         source = deck->transfertImgSor(tempmin);
                         index = searchCard(source,player2);
                         player2->remove(index);
                         imageEmit=source;
                     }
                 }

//                in case the bot has 2 or 1 card that's belong to briscola suit
                }else if(briscoCounter ==2 || briscoCounter ==1){

                 if(cardPlayedValue == 0){

                     source = deck->transfertImgSor(minDefBrisco);
                     index = searchCard(source,player2);
                     player2->remove(index);
                     imageEmit=source;

                 }else if(cardPlayedValue != 0){
//                     in case there is a card heighest then the card played and it's not blong to briscola Suit
                     if(playedmaxB != 0){
                         source = deck->transfertImgSor(minMaxBrisco);
                         index = searchCard(source,player2);
                         player2->remove(index);
                         imageEmit=source;

                     }else{
                         source = deck->transfertImgSor(minDefBrisco);
                         index = searchCard(source,player2);
                         player2->remove(index);
                         imageEmit=source;
                     }
                 }


                }


//        in case the player draw a briscola card and the bot don't have it
            }else if(briscoCounter == 0 && cardPlayedSuit == briscoSuit ){
                source = deck->transfertImgSor(tempmin);
                index = searchCard(source,player2);
                player2->remove(index);
                imageEmit=source;

//        in case the player didn't draw a briscola card and the bot have it
            }else if(briscoCounter != 0 && cardPlayedSuit != briscoSuit ){

//                in case the bot has all card is briscola suit
                if(briscoCounter == 3){
                 source = deck->transfertImgSor(tempmin);
                 index = searchCard(source,player2);
                 player2->remove(index);
                 imageEmit=source;

//                in case the bot has 2 or 1 card that's belong to briscola suit
                }else if(briscoCounter == 1 || briscoCounter == 2){
                 if (cardPlayedValue==0){
                     source = deck->transfertImgSor(tempmin);
                     index = searchCard(source,player2);
                     player2->remove(index);
                     imageEmit=source;

                 }else if(cardPlayedValue!=0){
                     if(valueOfMinDefBris > cardPlayedValue){
                             if(brisDef){
                             source = deck->transfertImgSor(minDefBrisco);
                             index = searchCard(source,player2);
                             player2->remove(index);
                             imageEmit=source;

                         }else{
                             source = deck->transfertImgSor(minBrisco);
                             index = searchCard(source,player2);
                             player2->remove(index);
                             imageEmit=source;
                         }
                     }else if(valueOfMinDefBris <= cardPlayedValue){
                         if(playedmax != 0){

                             source = deck->transfertImgSor(minMax);
                             index = searchCard(source,player2);
                             player2->remove(index);
                             imageEmit=source;
                         }else{
                             if(playedMB == 0){

                                 source = deck->transfertImgSor(minBrisco);
                                 index = searchCard(source,player2);
                                 player2->remove(index);
                                 imageEmit=source;
                             }else{
                                 source = deck->transfertImgSor(maxBrisco);
                                 index = searchCard(source,player2);
                                 player2->remove(index);
                                 imageEmit=source;
                             }
                         }

                     }
                 }

                }
            }

            turn=2;
            qDebug() << "le bot a jouer" << imageEmit;
            qDebug() << "--------------";
        }

//    in case the player chose the easy difficulty
    }else if(difficulty == "Easy"){

       if(botTurn == 1){
            if(maxMinCounter !=0){
                source = deck->transfertImgSor(maxMin);
                index = searchCard(source,player2);
                player2->remove(index);
                imageEmit=source;
            }else{
                source = deck->transfertImgSor(tempmin);
                index = searchCard(source,player2);
                player2->remove(index);
                imageEmit=source;
            }
            turn=2;
            qDebug() << "le bot a jouer" << imageEmit;
            qDebug() << "--------------";
        }
    }








//    emit a signal that the hand has changed
    if(player2->getHand().size()!=0)
        emit handChanged(imageEmit);

//    after the bot play it switch the turn and incriment the turn
    if(turn==1 || turn == 0){
        switchTurn();
        emit turnChanged(player1Turn);
    }

    card2=toindex(imageEmit);
    if(med != 0)
        difficulty = "Medium";


    return imageEmit;
}












