#include <QApplication>
#include "panelrobotcontroller.h"
#include "icsplashscreen.h"
#include <QDebug>
#include "iclog.h"

ICLog iclog("RobotPanel.debuglog", 10 * 1024);

void appMessageOutput(QtMsgType type, const char *msg)
{
    iclog.MessageOutput(type, msg);
}

int main(int argc, char *argv[])
{
//    iclog.SetMaxSpace(10*1024);
    iclog.Log("App Run");
    qInstallMsgHandler(appMessageOutput);
    QApplication app(argc, argv);
    app.setOrganizationName("SZHC");
    app.setApplicationName("RobotPanel");

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
    appDir.cd(uiMain);
    appDir.cd("images");

    qDebug()<<appDir.exists("startup_page.png");
    QPixmap splashPixmap(appDir.filePath("startup_page.png"));
    ICSplashScreen *splash= new ICSplashScreen(splashPixmap, SW_VER);
    splash->SetRange(0, 7);
    splash->show();
    PanelRobotController robotController(splash, &iclog);
    robotController.Init();
    splash->finish(robotController.MainView());
    delete splash;

    return app.exec();
}
