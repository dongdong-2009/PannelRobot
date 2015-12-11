#include <QApplication>
#include "panelrobotcontroller.h"


int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setOrganizationName("SZHC");
    app.setApplicationName("RobotPanel");


    PanelRobotController robotController;
    robotController.Init();

    return app.exec();
}
