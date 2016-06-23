/*This program was designed and written by Leon Harvey */

#include <QApplication>
#include <QQmlApplicationEngine>
#include <mp_interface.h>
#include <QtQml>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    qmlRegisterType<mpInterface>("cpp_interface_module", 1, 0, "Cpp_interface");
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    return app.exec();
}

