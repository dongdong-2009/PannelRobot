#include "qtquick1applicationviewer.h"
#include <QApplication>
#include <QDeclarativeContext>
#include "panelrobotcontroller.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setOrganizationName("SZHC");
    app.setApplicationName("RobotPanel");

    PanelRobotController robotController;
    robotController.Init();

    QtQuick1ApplicationViewer viewer;
    viewer.rootContext()->setContextProperty("panelRobotController", &robotController);
    viewer.addImportPath(QLatin1String("modules"));
    viewer.setOrientation(QtQuick1ApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/PanelRobot/main.qml"));
#ifdef Q_WS_QWS
    viewer.setWindowFlags(Qt::FramelessWindowHint);
#endif

    viewer.showExpanded();

    return app.exec();
}
