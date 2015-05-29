#include "qtquick1applicationviewer.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QtQuick1ApplicationViewer viewer;
    viewer.addImportPath(QLatin1String("modules"));
    viewer.setOrientation(QtQuick1ApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/PanelRobot/main.qml"));
#ifdef Q_WS_QWS
    viewer.setWindowFlags(Qt::FramelessWindowHint);
#endif

    viewer.showExpanded();

    return app.exec();
}
