#include "panelrobotcontroller.h"
#include <QSqlDatabase>
#include <QMessageBox>
#include "icappsettings.h"
#include "icrobotmold.h"
//#include "icdalhelper.h"
#include "icconfigsaddr.h"

PanelRobotController::PanelRobotController(QObject *parent) :
    QObject(parent)
{
    host_ = ICRobotVirtualhost::RobotVirtualHost();
}

void PanelRobotController::Init()
{
    ICAppSettings();
    InitDatabase_();
    InitMold_();
    qDebug()<<m_rw_0_4_17.Decimal();
    qDebug()<<moldFncs;
    host_->SetCommunicateDebug(true);
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
    mold->LoadMold(as.CurrentMoldConfig());
    ICRobotMold::SetCurrentMold(mold);
    ICRobotVirtualhost::InitMold(host_, mold->ProgramToDataBuffer());
    ICRobotVirtualhost::InitMoldFnc(host_,mold->MoldFncsBuffer());
}
