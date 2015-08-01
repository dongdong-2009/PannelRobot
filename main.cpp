#include "qtquick1applicationviewer.h"
#include <QApplication>
#include <QDeclarativeContext>
#include <QDir>
#include "panelrobotcontroller.h"
#include "icvirtualkeyboard.h"
#include "icappsettings.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setOrganizationName("SZHC");
    app.setApplicationName("RobotPanel");
//    app.setInputContext(new ICInputContext());
//#ifdef Q_WS_QWS
//    qwsServer->setCurrentInputMethod(new ICInputContext());
//#endif

    PanelRobotController robotController;
    robotController.Init();
    ICVirtualKeyboard virtualKeyboard(ICRobotRangeGetter);

    QtQuick1ApplicationViewer viewer;
    viewer.rootContext()->setContextProperty("panelRobotController", &robotController);
    viewer.rootContext()->setContextProperty("virtualKeyboard", &virtualKeyboard);
    viewer.addImportPath(QLatin1String("modules"));
    viewer.setOrientation(QtQuick1ApplicationViewer::ScreenOrientationAuto);
    ICAppSettings settings;
    QString uiMain = settings.UIMainName();
    QDir appDir = QDir::current();
    if(uiMain.isEmpty() || !appDir.exists(uiMain))
    {
#ifdef Q_WS_QWS
        uiMain = "Init";
#else
        uiMain = "../Init";
#endif
    }
//    QLocale locale(QLocale::Chinese, QLocale::China);
//    qDebug()<<locale.name();
    appDir.cd(uiMain);
    qDebug()<<appDir.filePath("main.qml");
    viewer.setMainQmlFile(appDir.filePath("main.qml"));
#ifdef Q_WS_QWS
    viewer.setWindowFlags(Qt::FramelessWindowHint);
#endif

    viewer.showExpanded();

    return app.exec();
}
