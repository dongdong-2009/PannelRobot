#include "qtquick1applicationviewer.h"
#include <QApplication>
#include <QDeclarativeContext>
#include "panelrobotcontroller.h"
#include "icvirtualkeyboard.h"

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

//    QDeclarativeEngine::addImportPath(QLatin1String("qml/ICCustomElement"));
    QtQuick1ApplicationViewer viewer;
//    viewer.engine()->addImportPath(QLatin1String("qml/ICCustomElement"));
    viewer.rootContext()->setContextProperty("panelRobotController", &robotController);
    viewer.rootContext()->setContextProperty("virtualKeyboard", &virtualKeyboard);
    viewer.addImportPath(QLatin1String("modules"));
//    viewer.addImportPath(QLatin1String("/home/gausscheng/workprojects/PanelRobot/qml/ICCustomElement"));
    viewer.setOrientation(QtQuick1ApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/PanelRobot/main.qml"));
#ifdef Q_WS_QWS
    viewer.setWindowFlags(Qt::FramelessWindowHint);
#endif

    viewer.showExpanded();

    return app.exec();
}
