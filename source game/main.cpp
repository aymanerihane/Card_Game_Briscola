#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "player.h"
#include "deck.h"
#include "gamecontroler.h"
#include "score.h"
#include <QIcon>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QIcon icon(":/logoGame.png");
    QPixmap pixmap=icon.pixmap(QSize(64,64));
    app.setWindowIcon(QIcon(pixmap));
    QQmlApplicationEngine engine;

    // Create instances of Card and Deck
    Deck deck;
    Player player1(&deck);
    Player player2(&deck);
    Score score(&deck);
    GameControler control(&deck,&player1,&player2,&score);

    // Set context properties for QML
    engine.rootContext()->setContextProperty("Player1", &player1);
    engine.rootContext()->setContextProperty("Player2", &player2);
    engine.rootContext()->setContextProperty("Deck", &deck);
    engine.rootContext()->setContextProperty("Score", &score);
    engine.rootContext()->setContextProperty("gameControl", &control);


    // Load the QML file
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    // Start the application event loop
    return app.exec();
}
