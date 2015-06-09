#include "panelrobotcontroller.h"
#include <QSqlDatabase>
#include <QMessageBox>
#include "icappsettings.h"
#include "icrobotmold.h"
#include "icdalhelper.h"
#include "icrobotvirtualhost.h"

PanelRobotController::PanelRobotController(QObject *parent) :
    QObject(parent)
{
}

void PanelRobotController::Init()
{
    ICAppSettings();
    InitDatabase_();
    InitMold_();
}

void PanelRobotController::InitDatabase_()
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("RobotDatabase");
    if(!db.isValid())
    {
        qCritical("Open Database fail!!");
        QMessageBox::critical(NULL, QT_TR_NOOP("Error"), QT_TR_NOOP("Database is error!!"));
    }
    if(!db.open())
    {
        qCritical("Open Database fail!!");
        QMessageBox::critical(NULL, QT_TR_NOOP("Error"), QT_TR_NOOP("Open Database fail!!"));
    }
}

void PanelRobotController::InitMold_()
{
    ICAppSettings as;
    ICRobotMold* mold = new ICRobotMold();
    mold->ParseActionProgram(ICDALHelper::MoldActContent(as.CurrentMoldConfig()));
    ICVirtualHostPtr host = ICRobotVirtualhost::RobotVirtualHost();
    ICRobotVirtualhost::InitMold(host, mold->ProgramToDatabuffer());
    host->SetCommunicateDebug(true);
}
