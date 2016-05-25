#include <QApplication>
#include <QDir>
#include "panelrobotcontroller.h"
#include "icsplashscreen.h"
#include <QDebug>
#include <QIcon>
#include "iclog.h"

ICLog iclog("RobotPanel.debuglog", 1024 * 1024);

#ifdef QT5
void appMessageOutput(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    iclog.MessageOutput(type, msg.toUtf8());
}
#else
void appMessageOutput(QtMsgType type, const char *msg)
{
    iclog.MessageOutput(type, msg);
}
#endif

int main(int argc, char *argv[])
{
//    iclog.SetMaxSpace(10*1024);
    iclog.Log("App Run");
#ifdef QT5
    qInstallMessageHandler(appMessageOutput);
#else
    qInstallMsgHandler(appMessageOutput);
#endif
    QApplication app(argc, argv);
    app.setOrganizationName("SZHC");
    app.setApplicationName("RobotPanel");
    app.setWindowIcon(QPixmap(":/resources/logo_icon.png"));

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
#ifndef QT5
    splash->finish(robotController.MainView());
#endif
    delete splash;

    return app.exec();
}
