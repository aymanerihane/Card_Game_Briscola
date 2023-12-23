import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
ApplicationWindow  {
    id: window
    visible: true
    title: qsTr("briscola")
    width: 640
    height: 600
    minimumWidth : 640
    minimumHeight: 600
//    SoundEffect
    SoundEffect{
         id:draw
         source: "sounds/draw.wav"
     }
    SoundEffect{
        id:butt
        source: "sounds/butt.wav"
    }
    SoundEffect{
        id:playerScore
        source: "sounds/playerScore.wav"
    }
    SoundEffect{
        id:botScore
        source: "sounds/botScore.wav"
    }
    SoundEffect {
        id: fire
        source: "sounds/fire.wav"
        loops: SoundEffect.Infinite
    }
    SoundEffect {
        id: guitar
        source: "sounds/guitar.wav"
        loops: SoundEffect.Infinite
    }
    SoundEffect{
        id:dist
        source: "sounds/destSound.wav"
    }
    SoundEffect{
        id:winS
        source: "sounds/winner.wav"
    }
    SoundEffect{
        id:lose1
        source: "sounds/lose3.wav"
    }
    SoundEffect{
        id:lose2
        source: "sounds/you_lose.wav"
    }

//    global variable
    property int first : 0 /*counter for the first distribute*/
    property int last : 0 /*counter for the last distribute*/
    property int firstNewGame : 0 /*counter to know if isn't the first game*/
    property int hightScore : 0 /*hight score variable*/
    property int scorePlayer1 : 0 /*player score variable*/
    property int scorePlayer2 : 0 /*bot score variable*/

    Component.onCompleted:{
//        set music at the begining
        guitar.play();
        fire.play();
        fire.volume= 1;
        guitar.volume=0.5;
        butt.volume=0.2;
//        mask bot card
        card11.visible=true;
        card33.visible=true;
        card22.visible=true;
        playerTwo.opacity=0.5;
        card111.visible=false;
        card222.visible=false;
        card333.visible=false;
//        update the hight score once the game is running
        hightScore=gameControl.hightScore();
    }

//    button of fullscreen or windowed
    Image{
        id: full
        source : "cards/fullScreen.png"
        height: 40
        width : 40
        z:99
        Behavior on scale {NumberAnimation { duration: 100 }}
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(full.source == "cards/minimize.png"){
                    window.visibility = "Windowed";
                    full.source = "cards/fullScreen.png";
                }else{
                    window.visibility = "FullScreen";
                    full.source = "cards/minimize.png";
                }
            }
            onEntered: {full.scale= 1.3}
            onExited: {full.scale = 1;}
        }
    }

    Rectangle { /*the game page*/
        id: table
        visible: false
        width: parent.width
        height: parent.height
        z: -3
        Image{
            id:tableBgc
            anchors.fill: parent
            source: "cards/bgc.jpg"
        }
        Rectangle{
            id: playerCards
            width: parent.width * 0.5
            height: 150
            color: "transparent"
            radius: 20
            border.color: "#fff"
            border.width : 3
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 20
            Connections{
                target: gameControl
                function onTurnChanged(player1Turn){/*respond to signal onturnChanged*/
                    console.log("turn is: "+player1Turn);
//                    check the turn and give permission to the player to play if it's his turn and play bot if is not the player turn'
                    if(player1Turn == true){
                        playerCards.opacity = 1
                        playerTwo.opacity = 0.5;
                        turn1.visible= true;
                        turn2.visible= false;
                        mouse1.enabled = true;
                        mouse2.enabled = true;
                        mouse3.enabled = true;
                    }else if(player1Turn == false){
                        botAPlayy.start();/*start the timer botAPlayy*/
                        playerCards.opacity = 0.5;
                        playerTwo.opacity = 1;
                        turn1.visible= false;
                        turn2.visible= true;
                        mouse1.enabled = false;
                        mouse2.enabled = false;
                        mouse3.enabled = false;
                    }
                }
            }
            Timer { /*timer of bot play in case the bot play first*/
                id: botAPlayy
                interval: 2000 // 2 seconds
                onTriggered: {
                    if(Player2.getHand().lenght!=0){ /*in case the bot still have a card in his hand*/
                        gameControl.botPlay(0); /*use the function botPlay with a paraqmetre 0 so the bit play first*/
                        draw.play(); /*use a drw music*/
                    }
                }
            }

            Rectangle{ /*turn icon*/
                id: turn1
                width : 20
                height : 20
                radius: 180
                color: "red"
                visible: true
                Text{
                    text:"TURN"
                    color: "#000"
                    font.pixelSize: 7
                    z:4
                    anchors.centerIn: parent
                }
            }

            Grid {/* player card in hand*/
                anchors.centerIn: parent
                columns: 3
                spacing: 8
                    Image {
                        id: card
                        width: 90
                        height: 130
                        z:4
                        Behavior on scale {NumberAnimation { duration: 200 }}
                        MouseArea{
                            id: mouse1
                            width: parent.width
                            height: parent.height
                            onEntered: {card.scale= 0.5}
                            onExited: {card.scale = 1;}
                            onClicked: {
                                if(Deck.isEmp(Deck.getDeck()) != 0){ /*in case the deck isn't empty */
                                    if(card3.source != "" && card2.source != "" && card.source != "" ){/*is not possible to play a card when the player have less then 3 card*/
                                        battle.source = card.source; /*the card is placed to the battle */
                                        gameControl.play(card.source); /*call the function play with the card played*/
                                        card.source = ""; /*delete source image from hand*/
                                        draw.play(); /*use the sound effect of draw*/
                                    }
                                }else{ /*in case the deck is empty the player can playe even if he have less then 3 cards*/
                                    battle.source = card.source;
                                    gameControl.play(card.source);
                                    card.source = "";
                                    draw.play();
                                }
                            }
                        }
                    }
                    Image {
                        id: card2
                        width: 90
                        height: 130
                        z:4
                        Behavior on scale {NumberAnimation { duration: 200 }}
                        MouseArea{
                            id : mouse2
                            width: parent.width
                            height: parent.height
                            onEntered: {card2.scale= 0.5}
                            onExited: {card2.scale = 1;}
                            onClicked: {
                                if(Deck.isEmp(Deck.getDeck()) != 0){
                                    if(card3.source != "" && card.source != "" && card2.source != "" ){
                                        battle.source = card2.source;
                                        gameControl.play(card2.source);
                                        draw.play();
                                        card2.source = "";
                                    }
                                }else{

                                    battle.source = card2.source;
                                    gameControl.play(card2.source);
                                    draw.play();
                                    card2.source = "";
                                }
                            }
                        }
                    }
                    Image {
                        id: card3
                        width: 90
                        height: 130
                        z:4
                        Behavior on scale {NumberAnimation { duration: 200 }}
                        MouseArea{
                            id: mouse3
                            width: parent.width
                            height: parent.height
                            onEntered: {card3.scale= 0.5}
                            onExited: {card3.scale = 1;}
                            onClicked: {
                                if(Deck.isEmp(Deck.getDeck()) != 0){
                                    if(card.source != "" && card2.source != "" && card3.source != "" ){
                                        gameControl.play(card3.source);
                                        battle.source = card3.source;
                                        card3.source = "";
                                        draw.play();
                                    }
                                }else{
                                    gameControl.play(card3.source);
                                    battle.source = card3.source;
                                    card3.source = "";
                                    draw.play();
                            }
                        }
                    }
                }
            }
        }

        Rectangle{ /*bot hand*/
            id: playerTwo
            width: parent.width * 0.5
            height: 150
            color: "transparent"
            radius: 20
            border.color: "#fff"
            border.width : 3
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20
            Rectangle{ /*icon of turn*/
                id: turn2
                width : 20
                height : 20
                radius: 180
                color: "red"
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                visible: false
                Text{
                    text:"TURN"
                    color: "#000"
                    font.pixelSize: 7
                    z:4
                    anchors.centerIn: parent
                }
            }
            Grid  { /*card in hand*/
                anchors.centerIn: parent
                columns: 3
                spacing: 8
                Image {
                    id: card11
                    width: 90
                    height: 130
                    Connections {
                        target: gameControl
                        function onHandChanged(imageEmit) { /*response of the hand changed signal*/
                            if(gameControl.getTurn() == false && Player2.getHand().lenght!=0){/*in case the first grid have the same card that has played*/
                                let img = Deck.transfertImgSor(imageEmit);
                                if (card11.source == imageEmit) {
                                    card11.source = ""; /*delete the card played*/
                                    card111.source = ""; /*delete the card played*/
                                    battle2.source = imageEmit; /*add the card played to battle*/
                                    draw.play();
                                }
                            }
                        }
                    }

                }
                Image {
                    id: card22
                    width: 90
                    height: 130
                    Connections {
                        target: gameControl
                        function onHandChanged(imageEmit) {
                            if(gameControl.getTurn() == false && Player2.getHand().lenght!=0){
                                let img = Deck.transfertImgSor(imageEmit);
                                if (card22.source == imageEmit) {
                                    card22.source = "";
                                    card222.source = "";
                                    battle2.source = imageEmit;
                                    draw.play();
                                }
                            }
                        }
                    }
                }
                Image {
                    id: card33
                    width: 90
                    height: 130
                    Connections {
                        target: gameControl
                        function onHandChanged(imageEmit) {
                            if(gameControl.getTurn() == false && Player2.getHand().lenght!=0){
                                let img = Deck.transfertImgSor(imageEmit);
                                if (card33.source == imageEmit) {
                                    card33.source = "";
                                    card333.source = "";
                                    battle2.source = imageEmit;
                                    draw.play();
                                }
                            }
                        }
                    }
                }
            }
//            a grid that hide the bot cards
        Grid  {
            anchors.centerIn: parent
            columns: 3
            spacing: 8
            Image {
                id:card111
                source: "cards/back2.png"
                width: 90
                height: 130
            }
            Image {
                id:card222
                source: "cards/back2.png"
                width: 90
                height: 130
            }
            Image {
                id:card333
                source: "cards/back2.png"
                width: 90
                height: 130
            }
        }
        }

        Text { /*the number of card in deck*/
            id: numberOfDeckCards
            color: "#fff"
            anchors.bottom: cards.top
            anchors.horizontalCenter: cards.horizontalCenter
            text : "number of cards: 40"
            Connections{
                target: Deck
                function onLenghtChanged(lenghtt){ /*responde of the card lenght changed signal*/
                    numberOfDeckCards.text = "number of cards: " + lenghtt;
                }
            }
        }

        Rectangle{ /*deck rectangle*/
            id: cards
            width: 120
            height: 170
            color: "transparent"
            radius: 20
            border.color: "#fff"
            border.width : 3
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 20
            Image { /*briscol image card*/
                id: briscola
                anchors.centerIn: parent;
                source: ""
                width: 90
                height: 130
                transform:[Translate { y: -30 },Rotation { origin.x: 45; origin.y: 65; angle: 90 }]
            }
            Image { /*the deck image*/
                id: deckImage
                anchors.centerIn: parent;
                source: "cards/back2.png"
                width: 90
                height: 130
            }
            MouseArea{
                id: cardsMouse
                width : parent.width
                height : parent.height
                Connections{
                    target: gameControl
                    function onClearBattle(turn) { /*respond of clear battle signal*/
                        if(turn == 0){
                            disctribute.start(); /*start the timer disctribute*/
                            clearBattle1.start();   /*start the timer clearBattle1*/
                        }
                    }
                }
                Timer { /*timer that clear the battle */
                    id: clearBattle1
                    interval: 1500 //1.5 seconds
                    onTriggered: {
                        battle.source= "";
                        battle2.source = "";
                    }
                }
                Timer { /*timer that disctribute cards */
                    id: disctribute
                    interval: 1000 // 1 seconds
                    onTriggered: {
                        let size = Deck.sizeOfDeck(); /*the size of deck*/
                        let indexOfBrisco = gameControl.toindex(briscola.source); /*the index of briscola card*/
                        if(size > 1){ /*in case the size of deck >1*/
                            if (card.source == "") {/*in case the card grid source is empty the card will distribute the this grid*/
                                card.source = Player1.sourceImage(Deck.getCard());
                            } else if (card2.source == "" ) {
                                card2.source = Player1.sourceImage(Deck.getCard());
                            } else if (card3.source == "") {
                                card3.source = Player1.sourceImage(Deck.getCard());
                            }

                            if (card11.source == "") {
                                card11.source = Player2.sourceImage(Deck.getCard());
                                card111.source = "cards/back2.png";
                            } else if (card22.source == "" ) {
                                card22.source = Player2.sourceImage(Deck.getCard());
                                card222.source = "cards/back2.png";
                            } else if (card33.source == "") {
                                card33.source = Player2.sourceImage(Deck.getCard());
                                card333.source = "cards/back2.png";
                            }

                        }else if(size == 1 && last == 0){ /*in case the size of deck is equal 1*/
                            if(gameControl.getTurn()==true){  /*in case it's the player turn briscola card will add to player hand and the 1 card in deck will go to bot hand*/
                                if (card2.source == "") {
                                    card2.source = briscola.source;
                                    Player1.sourceImage(indexOfBrisco);
                                    briscola.opacity = 0.4;
                                    deckImage.visible = false;
                                } else if (card.source == "") {
                                    card.source = briscola.source;
                                    Player1.sourceImage(indexOfBrisco);
                                    briscola.opacity = 0.4;
                                    deckImage.visible = false;
                                } else if (card3.source == "") {
                                    card3.source = briscola.source;
                                    Player1.sourceImage(indexOfBrisco);
                                    briscola.opacity = 0.4;
                                    deckImage.visible = false;
                                }

                                if (card11.source == "") {
                                    card11.source = Player2.sourceImage(Deck.getCard());
                                    card111.source = "cards/back2.png";
                                } else if (card22.source == "" ) {
                                    card22.source = Player2.sourceImage(Deck.getCard());
                                    card222.source = "cards/back2.png";
                                } else if (card33.source == "") {
                                    card33.source = Player2.sourceImage(Deck.getCard());
                                    card333.source = "cards/back2.png";
                                }


                            }else if(gameControl.getTurn()==false){ /*in case it's the bot turn briscola card will add to bot hand and the 1 card in deck will go to player hand*/
                                if (card22.source == "") {
                                    card22.source = briscola.source;
                                    Player2.sourceImage(indexOfBrisco);
                                    card222.source = "cards/back2.png";
                                    briscola.opacity = 0.4;
                                    deckImage.visible = false;
                               } else if (card11.source == "") {
                                    card11.source = briscola.source;
                                    Player2.sourceImage(indexOfBrisco);
                                    card111.source = "cards/back2.png";
                                    briscola.opacity = 0.4;
                                    deckImage.visible = false;
                               } else if (card33.source != "") {
                                    card33.source = briscola.source;
                                    Player2.sourceImage(indexOfBrisco);
                                    card333.source = "cards/back2.png";
                                    briscola.opacity = 0.4;
                                    deckImage.visible = false;
                               }
                                if (card.source == "") {
                                    card.source = Player1.sourceImage(Deck.getCard());
                                } else if (card2.source == "" ) {
                                    card2.source = Player1.sourceImage(Deck.getCard());
                                } else if (card3.source == "") {
                                    card3.source = Player1.sourceImage(Deck.getCard());
                                }

                            }
                            last++;
                        }
                    }
                }
                onClicked:{
                    let isPlayer1Turn = gameControl.getTurn();
                    let botHand = Player2.getHand().lenght; /*the size of bot hand*/
//                    set the volume of music and sounds
                    if(sound.source=="cards/soundsButt.png"){
                        playerScore.volume=1;
                        botScore.volume=1;
                        draw.volume=1;
                        dist.volume=1;
                    }else if(sound.source=="cards/soundsButtMuted.png"){
                        playerScore.volume=0;
                        botScore.volume=0;
                        draw.volume=0;
                        dist.volume=0;
                    }
                    if (first == 0) {
                        dist.play(); /*play the distribute sound effect*/
                        briscola.source = Deck.briscola(Deck.getCard()); /*get a new briscola card randomly*/
                        // Distribute cards for the first time 3 cards for each player
                        card.source = Player1.sourceImage(Deck.getCard());
                        card2.source = Player1.sourceImage(Deck.getCard());
                        card3.source = Player1.sourceImage(Deck.getCard());
                        card11.source = Player2.sourceImage(Deck.getCard());
                        card22.source = Player2.sourceImage(Deck.getCard());
                        card33.source = Player2.sourceImage(Deck.getCard());
                        card111.source="cards/back2.png";
                        card222.source="cards/back2.png";
                        card333.source="cards/back2.png";
                        first++; /*incriment the first property so it will not distribute 3 card again fir each player*/
                    }
                }

            }
        }
        Rectangle{

            width: 290
            height: 180
            color: "transparent"
            radius: 20
            border.color: "#fff"
            border.width : 3
            anchors.centerIn: parent

            Grid{
                anchors.centerIn: parent
                columns: 2
                spacing: 8
                Image { /*card played by player1*/
                    id: battle
                    width: 110
                    height: 160
                    Rectangle{
                        anchors.fill: parent
                        color: "transparent"
                        border.color: "grey"
                        border.width : 2
                        radius: 5
                        Text {
                            text: qsTr("Player 1")
                            anchors.centerIn: parent
                            color: "grey"
                            font.weight: 700
                            font.wordSpacing: 8
                        }
                    }
                }
                Image {/*card played by bot*/
                    id: battle2
                    width: 110
                    height: 160
                    Rectangle{
                        anchors.fill: parent
                        color: "transparent"
                        border.color: "grey"
                        radius: 5
                        border.width : 2
                        Text {
                            text: qsTr("Player 2")
                            anchors.centerIn: parent
                            color: "grey"
                            font.weight: 700
                            font.wordSpacing: 8
                        }
                    }
                }
            }
        }
        Image{ /*score of bot*/
            source: "cards/scoreRetated.png"
            width: 100
            height: 100
            anchors.top : playerTwo.top
            anchors.right : playerCards.left
            anchors.rightMargin: 10
            Text {
                color: "#000"
                anchors.centerIn: parent
                id: score2
                text: ""+scorePlayer2
                Connections{
                    target: Score
                    function onScore2Changed(sco){ /*respond to score2 changed signal*/
                        scorePlayer2 = sco; /*set the new score the scorePlayer2 varibale*/
                        botScore.play(); /*play sound of score added to bot*/
                    }
                }
            }
            Text {
                color: "#000"
                font.pixelSize: 9
                anchors.bottom: score2.top
                font.underline: true
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Score \nBot:")

            }

        }
        Image{ /*player score*/
            source: "cards/score.png"
            width: 100
            height: 100
            anchors.top : playerCards.bottom
            transform:[Translate { y: -100 }]
            anchors.left : playerCards.right
            anchors.leftMargin: 10
            Text {
                id: score1
                color: "#000"
                anchors.centerIn: parent
                text: ""+scorePlayer1
                Connections{
                    target: Score
                    function onScore1Changed(sco){ /*respond to score1 changed signal*/
                        scorePlayer1 = sco; /*set the new score the scorePlayer1 varibale*/
                        playerScore.play(); /*play sound of score added to player1*/
                    }
                }
            }
            Text {
                color: "#000"
                font.pixelSize: 9
                font.underline: true
                anchors.bottom: score1.top
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Score \nPlayer1:")

            }

        }

        Rectangle{ /*guide value of cards*/
            id: v
            width: 90
            height: 190
            color: "white"
            y: window.height/2-40
            x: window.width-90
            Image {
                width: 90
                height: 190
                anchors.centerIn: parent
                source: "cards/cardValue.png"
            }
        }
    }


    Rectangle { /*start page*/
        id: newGame
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        z:10
        Image{ /*backGround of this page*/
            id: bgc
            anchors.fill: parent
            source: "cards/bgc.jpg"
            Image{
                anchors.bottom: parent.bottom
                anchors.right:  parent.right
                width:300
                height: 300
                source: "cards/logo.png"
            }
            AnimatedImage{
                id: spraks
                scale: 1.5
                source: "cards/spraks.gif"
                anchors.bottom: parent.bottom
                anchors.right: parent.right
            }
            AnimatedImage{
                id: spraks2
                scale: 1.5
                source: "cards/spraks.gif"
                anchors.bottom: parent.bottom
                anchors.left: parent.left
            }
            AnimatedImage{
                id: spraks3
                scale: 2
                source: "cards/spraks.gif"
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                visible: false
            }
            Text{ /*the highest score the player 1 havet ever*/
                color: "#fff"
                anchors.bottom: parent.bottom
                font.pixelSize: 20
                font.weight: 700
                anchors.left: parent.left
                text: "Hight Score: "+hightScore;
                Connections{
                    target: gameControl
                    function onHightScorechanged(hightSc){ /*respond to hight score changed signal*/
                        hightScore=hightSc; /*set the new hightSc to hightScore variable*/
                    }
                }
            }

            Rectangle{ /*welcome and bottun*/
                id: contain
                color: "transparent"
                width: welcom.width
                height: welcom.height
                anchors.horizontalCenter: parent.horizontalCenter
                Column{
                    spacing: 8
                    anchors.top : parent.top
                    Image{
                        id: welcom
                        source: "cards/welcome.png"
                        width:  457
                        height: 324
                        states: [State {name: "smallScreen"
                                    when: window.height < 800
                                    PropertyChanges { target: welcom; height: 200 ; width: 300}
                                    PropertyChanges { target: ngame; height: 70 ; width: 200}
                                    PropertyChanges { target: tuto; height: 70 ; width: 200}
                                    PropertyChanges { target: settings; height: 70 ; width: 200}
                                    PropertyChanges { target: music; height: 40 ; width: 40}
                                    PropertyChanges { target: sound; height: 40 ; width: 40}
                                    PropertyChanges { target: easy; height: 70 ; width: 200}
                                    PropertyChanges { target: hard; height: 70 ; width: 200}
                                    PropertyChanges { target: medium; height: 70 ; width: 200}},
                                State {name: "normalScreen"
                                    when: window.height >= 800
                                    PropertyChanges { target: welcom; height: 324 ; width: 457}
                                    PropertyChanges { target: ngame; height: 100 ; width: 300}
                                    PropertyChanges { target: tuto; height: 100 ; width: 300}
                                    PropertyChanges { target: settings; height: 100 ; width: 300}
                                    PropertyChanges { target: spraks; scale: 1.5}
                                    PropertyChanges { target: spraks2; scale: 1.5}
                                    PropertyChanges { target: spraks3; visible: true}
                                    PropertyChanges { target: music; height: 60 ; width: 60}
                                    PropertyChanges { target: easy; height: 100 ; width: 300}
                                    PropertyChanges { target: hard; height: 100 ; width: 300}
                                    PropertyChanges { target: medium; height: 100 ; width: 300}
                                    PropertyChanges { target: sound; height: 60 ; width: 60}}]
                        transitions: [
                            Transition {from: "*"
                                to: "smallScreen"
                                NumberAnimation { properties: "height"; duration: 500 }},
                            Transition {from: "*"
                                to: "normalScreen"
                                NumberAnimation { properties: "height"; duration: 500 }}]
                    }
                    Column{ /*button*/
                        spacing: 28
                        transform:[Translate { x: (contain.width - ngame.width)/2; y: 50 }]
                        Image{ /*new game button*/
                            id: ngame
                            source : "cards/newGame.png"
                            height: 150
                            width : 300
                            Behavior on scale {NumberAnimation { duration: 200 }}
                            MouseArea{
                                anchors.fill: parent
                                onClicked: { /*initialize all setting and variable*/
//                                    qml variable
                                    butt.play();
                                    deckImage.visible=true;
                                    gridS.visible=true;
                                    playerScore.volume=0;
                                    botScore.volume=0;
                                    ngame.visible= false;
                                    settings.visible= false;
                                    tuto.visible= false;
                                    easy.visible= true;
                                    medium.visible= true;
                                    hard.visible= true;
                                    numberOfDeckCards.text ="number of cards: 40";
                                    card.source="";
                                    card2.source="";
                                    card3.source="";
                                    card11.source="";
                                    card22.source="";
                                    card33.source="";
                                    card111.source="";
                                    card222.source="";
                                    card333.source="";
                                    battle.source= "";
                                    battle2.source = "";
                                    briscola.source = "";
//                                    back-end varibale
                                    Player1.clearHand(Player1.getHand());
                                    Player2.clearHand(Player2.getHand());
                                    Score.clearScore();
                                    gameControl.setTurnDouble(0);
                                    gameControl.setTurn(true);
                                    if(firstNewGame!=0){
                                        Deck.setupDeck();
                                    }
                                    first = 0;
                                    last = 0;
                                    briscola.opacity=1;
                                    firstNewGame++;


                                }
                                onEntered: {ngame.scale= 1.3}
                                onExited: {ngame.scale = 1;}

                            }

                        }
                        Image{ /*tuto button*/
                            id: tuto
                            source : "cards/tutoButt.png"
                            height: 100
                            width : 300
                            Behavior on scale {NumberAnimation { duration: 100 }}
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {tutoPage.visible= true;butt.play();;}
                                onEntered: {tuto.scale= 1.3}
                                onExited: {tuto.scale = 1;}
                            }
                        }

                        Rectangle{ /*backGround change button*/
                            id: settings
                            color: "transparent"
                            height: 100
                            width : 300
                            Grid{
                                columns: 4
                                spacing: 10
                                anchors.centerIn: parent
                                Rectangle{ /*defaut backGround*/
                                    width: 40
                                    height: 40
                                    Image {
                                        source: "cards/bgc.jpg"
                                        anchors.fill: parent
                                        MouseArea{
                                            width: parent.width
                                            height: parent.height
                                            onClicked: {bgc.source="cards/bgc.jpg";
                                                butt.play();
                                                bgc.source="cards/bgc.jpg";
                                                tableBgc.source="cards/bgc.jpg";
                                                spraks.visible=true;
                                                spraks2.visible=true;
                                                spraks3.visible=true;
                                            }
                                        }
                                    }

                                }
                                Rectangle{/*purple backGround*/
                                    width: 40
                                    height: 40
                                    color: "#280137"
                                    radius: 5
                                    border.color: "#fff"
                                    border.width : 2
                                    MouseArea{
                                        width: parent.width
                                        height: parent.height
                                        onClicked: {bgc.source="";
                                            butt.play();
                                            bgc.source="";
                                            tableBgc.source="";
                                            table.color= "#280137";
                                            newGame.color= "#280137";
                                            spraks.visible=false;
                                            spraks2.visible=false;
                                            spraks3.visible=false;
                                        }
                                    }
                                }
                                Rectangle{/*blue backGround*/
                                    width: 40
                                    height: 40
                                    color: "#000137"
                                    radius: 5
                                    border.color: "#fff"
                                    border.width : 2
                                    MouseArea{
                                        width: parent.width
                                        height: parent.height
                                        onClicked: {bgc.source="";
                                            butt.play();
                                            bgc.source="";
                                            tableBgc.source="";
                                            table.color= "#000137";
                                            newGame.color= "#000137";
                                            spraks.visible=false;
                                            spraks2.visible=false;
                                            spraks3.visible=false;
                                        }
                                    }
                                }
                                Rectangle{/*green backGround*/
                                    width: 40
                                    height: 40
                                    color: "#014421"
                                    radius: 5
                                    border.color: "#fff"
                                    border.width : 2
                                    MouseArea{
                                        width: parent.width
                                        height: parent.height
                                        onClicked: {
                                            butt.play();
                                            bgc.source="";
                                            tableBgc.source="";
                                            table.color= "#014421";
                                            newGame.color= "#014421";
                                            spraks.visible=false;
                                            spraks2.visible=false;
                                            spraks3.visible=false;
                                        }
                                    }
                                }
                            }
                        }
                        Image{ /*easy mode button*/
                            id: easy
                            visible: false
                            source : "cards/facile.png"
                            height: 150
                            width : 300
                            Behavior on scale {NumberAnimation { duration: 200 }}
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    table.visible = true;
                                    newGame.visible = false;
                                    gameControl.setDifficulty("Easy");
                                    butt.play();
                                }
                                onEntered: {easy.scale= 1.3}
                                onExited: {easy.scale = 1;}
                            }
                        }
                        Image{ /*medium mode button*/
                            id: medium
                            visible: false
                            source : "cards/medium.png"
                            height: 100
                            width : 300
                            Behavior on scale {NumberAnimation { duration: 100 }}
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    table.visible = true;
                                    newGame.visible = false;
                                    gameControl.setDifficulty("Medium");
                                    butt.play();
                                }
                                onEntered: {medium.scale= 1.3}
                                onExited: {medium.scale = 1;}
                            }
                        }
                        Image{ /*hard mode button*/
                            id: hard
                            visible: false
                            source : "cards/hard.png"
                            height: 100
                            width : 300
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    table.visible = true;
                                    newGame.visible = false;
                                    gameControl.setDifficulty("Hard");
                                    butt.play();
                                }
                                onEntered: {hard.scale= 1.3}
                                onExited: {hard.scale = 1;}
                            }
                        }

                        Grid{ /*sound and music button*/
                            anchors.horizontalCenter: parent.horizontalCenter
                            columns: 2
                            spacing: 50
                            Image{ /*music button*/
                                id: music
                                source : "cards/musicButt.png"
                                height: 40
                                width : 40
                                Behavior on scale {NumberAnimation { duration: 100 }}
                                MouseArea{
                                    z:5
                                    anchors.fill: parent
                                    onClicked: {
                                        if(music.source == "cards/musicButt.png"){
                                            music.source = "cards/musicButtMuet.png";
                                            musicGame.source = "cards/musicButtMuet.png";
                                            fire.volume= 0;
                                            guitar.volume=0;
                                        }else{
                                            music.source = "cards/musicButt.png";
                                            musicGame.source = "cards/musicButt.png";
                                            fire.volume= 1;
                                            guitar.volume=0.5;
                                        }
                                    }
                                    onEntered: {music.scale= 1.3}
                                    onExited: {music.scale = 1;}
                                }
                            }
                            Image{ /*sound button*/
                                id: sound
                                source : "cards/soundsButt.png"
                                height: 40
                                width : 40
                                Behavior on scale {NumberAnimation { duration: 100 }}
                                MouseArea{
                                    z:5
                                    anchors.fill: parent
                                    onClicked: {
                                        if(sound.source == "cards/soundsButt.png"){
                                            sound.source = "cards/soundsButtMuted.png";
                                            soundgame.source = "cards/soundsButtMuted.png";
                                            draw.volume=0;
                                            playerScore.volume=0;
                                            botScore.volume=0;
                                            butt.volume=0;
                                        }else{
                                            sound.source = "cards/soundsButt.png";
                                            soundgame.source = "cards/soundsButt.png";
                                            draw.volume=1;
                                            playerScore.volume=1;
                                            botScore.volume=1;
                                            butt.volume=0.2;
                                        }
                                    }
                                    onEntered: {sound.scale= 1.3}
                                    onExited: {sound.scale = 1;}
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle{ /*winner or loser page*/
        id: win
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        visible: false
        Image{
            id: winImage
            fillMode: Image.PreserveAspectCrop
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
        }
        AnimatedImage{
            id: winnn
            width: parent.width
            height: parent.height
            source: "cards/winnn.gif"
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            visible: false
        }
        Connections{
            target: gameControl
            function onWinnerDetected(){ /*respond the winner ditected signal*/
                let whoWin = gameControl.getWhoWin(); /*if who win = 1 (win) if = 2 (lose) if = 0 (egalite)*/
                if(whoWin == 1){
                    winImage.source= "cards/win.png";
                    winS.play();
                    winnn.visible=true;
                }else if(whoWin == 2){
                    winImage.source= "cards/lose.png";
                    lose1.play();
                    lose2.play();
                }
                win.visible= true
                table.visible= false
            }
        }
        Image{ /*show score of player1*/
            id:imgscore
            source: "cards/score.png"
            width: 100
            height: 100
            transform:[Translate { y: -100; x:-100 }]
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom : parent.bottom
            anchors.leftMargin: 10
            Text {
                id: score11
                color: "#000"
                anchors.centerIn: parent
                text: ""+scorePlayer1
                Connections{
                    target: Score
                    function onScore1Changed(sco){
                        scorePlayer1 = sco;
                    }
                }
            }
            Text {
                color: "#000"
                font.pixelSize: 9
                font.underline: true
                anchors.bottom: score11.top
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Score \nPlayer1:")
            }
        }

        Image{/*show score of bot*/
            source: "cards/score.png"
            width: 100
            height: 100
            y: imgscore.y-100
            anchors.left : imgscore.right
            anchors.leftMargin: 10
            Text {
                id:score22
                color: "#000"
                anchors.centerIn: parent
                text: ""+scorePlayer2
                Connections{
                    target: Score
                    function onScore2Changed(sco){
                        scorePlayer2 = sco;
                    }
                }
            }
            Text {
                color: "#000"
                font.pixelSize: 9
                font.underline: true
                anchors.bottom: score22.top
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Score \nBot:")

            }
        }
    }
    Grid{ /*button in side*/
        id:gridS
        anchors.right:parent.right
        anchors.rightMargin: 10
        anchors.topMargin: 10
        rows: 6
        spacing: 10
        visible: false
        z:100
        Image{ /*music button*/
            id: musicGame
            source : "cards/musicButt.png"
            height: 40
            width : 40
            Behavior on scale {NumberAnimation { duration: 100 }}
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(musicGame.source == "cards/musicButt.png"){
                        musicGame.source = "cards/musicButtMuet.png";
                        music.source = "cards/musicButtMuet.png";
                        fire.volume= 0;
                        guitar.volume=0;

                    }else{
                        musicGame.source = "cards/musicButt.png";
                        music.source = "cards/musicButt.png";
                        fire.volume= 1;
                        guitar.volume=0.5;
                    }
                }
                onEntered: {musicGame.scale= 1.3}
                onExited: {musicGame.scale = 1;}
            }
        }
        Image{ /*sound button*/
            id: soundgame
            source : "cards/soundsButt.png"
            height: 40
            width : 40
            Behavior on scale {NumberAnimation { duration: 100 }}
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(soundgame.source == "cards/soundsButt.png"){
                        soundgame.source = "cards/soundsButtMuted.png";
                        sound.source = "cards/soundsButtMuted.png";
                        draw.volume=0;
                        playerScore.volume=0;
                        botScore.volume=0;
                        butt.volume=0;
                    }else{
                        soundgame.source = "cards/soundsButt.png";
                        sound.source = "cards/soundsButt.png";
                        draw.volume=1;
                        playerScore.volume=1;
                        botScore.volume=1;
                        butt.volume=0.2;
                    }
                }
                onEntered: {soundgame.scale= 1.3}
                onExited: {soundgame.scale = 1;}
            }
        }
        Image{ /*backGround button*/
            id: settingsB
            source : "cards/parrametreButt.png"
            height: 40
            width : 40
            Behavior on scale {NumberAnimation { duration: 100 }}
            MouseArea{
                anchors.fill: parent
                onClicked: {settingsB.visible=false;settingCo.visible=true;butt.play();}
                onEntered: {settingsB.scale= 1.3}
                onExited: {settingsB.scale = 1;}
            }
        }
        Grid{ /*options for the backGround button*/
            id:settingCo
            visible: false
            rows: 4
            spacing: 10
            Rectangle{
                width: 40
                height: 40
                Image {
                    source: "cards/bgc.jpg"
                    anchors.fill: parent
                    MouseArea{
                        width: parent.width
                        height: parent.height
                        onClicked: {
                            bgc.source="cards/bgc.jpg";
                            tableBgc.source="cards/bgc.jpg";
                            settingsB.visible=true;
                            settingCo.visible=false;
                            spraks.visible=true;
                            spraks2.visible=true;
                            spraks3.visible=true;
                            spraks1.visible=true;
                            spraks22.visible=true;
                            spraks33.visible=true;
                            butt.play();
                        }
                    }
                }
            }

            Rectangle{
                width: 40
                height: 40
                color: "#280137"
                radius: 5
                border.color: "#fff"
                border.width : 2
                MouseArea{
                    width: parent.width
                    height: parent.height
                    onClicked: {
                        bgc.source="";
                        tableBgc.source="";
                        table.color= "#280137";
                        newGame.color= "#280137";
                        settingsB.visible=true;
                        settingCo.visible=false;
                        spraks.visible=false;
                        spraks2.visible=false;
                        spraks3.visible=false;
                        butt.play();
                    }
                }
            }
            Rectangle{
                width: 40
                height: 40
                color: "#000137"
                radius: 5
                border.color: "#fff"
                border.width : 2
                MouseArea{
                    width: parent.width
                    height: parent.height
                    onClicked: {
                        bgc.source="";
                        tableBgc.source="";
                        table.color= "#000137";
                        newGame.color= "#000137";
                        settingsB.visible=true;
                        settingCo.visible=false;
                        spraks.visible=false;
                        spraks2.visible=false;
                        spraks3.visible=false;
                        butt.play();
                    }
                }
            }
            Rectangle{
                width: 40
                height: 40
                color: "#014421"
                radius: 5
                border.color: "#fff"
                border.width : 2
                MouseArea{
                    width: parent.width
                    height: parent.height
                    onClicked: {
                        bgc.source="";
                        tableBgc.source="";
                        table.color= "#014421";
                        newGame.color= "#014421";
                        settingsB.visible=true;
                        settingCo.visible=false;
                        spraks.visible=false;
                        spraks2.visible=false;
                        spraks3.visible=false;
                        butt.play();
                    }
                }
            }
        }
        Image{ /*home button*/
            id: help
            source : "cards/help.png"
            height: 40
            width : 40
            Behavior on scale { NumberAnimation { duration: 100 }}
            MouseArea{
                anchors.fill: parent
                onClicked: {tutoPage.visible= true;butt.play();winnn.visible=false;}
                onEntered: {help.scale= 1.3;}
                onExited: {help.scale = 1;}
            }
        }

        Image{ /*home button*/
            id: home
            source : "cards/home.png"
            height: 40
            width : 40
            Behavior on scale { NumberAnimation { duration: 100 }}
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    table.visible=false;
                    gridS.visible=false;
                    win.visible=false;
                    newGame.visible=true;
                    ngame.visible= true;
                    settings.visible= true;
                    tuto.visible= true;
                    easy.visible= false;
                    medium.visible= false;
                    hard.visible= false;
                    butt.play();
                }
                onEntered: {home.scale= 1.3;}
                onExited: {home.scale = 1;}
            }
        }

    }
    Item { /*tuto page*/
        id: tutoPage
        width: parent.width
        height: parent.height
        z: 98
        visible: false
        Rectangle { /*overlay*/
            color: "#000"
            width: parent.width
            height: parent.height
            opacity: 0.5
        }

        ListView {
            id:wall1
            anchors.centerIn: parent
            width: 540
            height: 500
            clip: true
            opacity: 1

            model: ListModel {
                ListElement { source: "cards/tuto1.jpg" }
                ListElement { source: "cards/tuto2.jpg" }
                ListElement { source: "cards/tuto3.jpg" }
            }

            delegate: Item {
                width: wall1.width
                height: 950
                Image {
                    anchors.fill: parent
                    source: model.source
                }
            }
        }
        Image{ /*close tuto page button*/
            id: close1
            source : "cards/close.png"
            height: 40
            width : 40
            x:wall1.width-5
            y:wall1.y+5
            z:5
            MouseArea{
                width: parent.width
                height: parent.height
                onClicked: {tutoPage.visible=false;butt.play();}
                onEntered: {close1.scale= 1.3}
                onExited: {close1.scale = 1;}
            }
        }
    }
}
