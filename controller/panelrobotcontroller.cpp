#include "panelrobotcontroller.h"
#include <QSqlDatabase>
#include <QMessageBox>
#include "icappsettings.h"
#include "icrobotmold.h"
#include "icmachineconfig.h"
//#include "icdalhelper.h"
#include "icconfigsaddr.h"

PanelRobotController::PanelRobotController(QObject *parent) :
    QObject(parent)
{
    host_ = ICRobotVirtualhost::RobotVirtualHost();
    connect(host_.data(),
            SIGNAL(NeedToInitHost()),
            SLOT(OnNeedToInitHost()));
}

void PanelRobotController::Init()
{
    ICAppSettings();
    InitDatabase_();
    InitMold_();
    InitMachineConfig_();
    host_->SetCommunicateDebug(false);
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

}

void PanelRobotController::InitMachineConfig_()
{
    ICAppSettings as;
    ICMachineConfig* machineConfig = new ICMachineConfig();
    machineConfig->LoadMachineConfig(as.CurrentSystemConfig());
    ICMachineConfig::setCurrentMachineConfig(machineConfig);
}

void PanelRobotController::OnNeedToInitHost()
{
    ICRobotMoldPTR mold = ICRobotMold::CurrentMold();
    ICRobotVirtualhost::InitMold(host_, mold->ProgramToDataBuffer(ICRobotMold::kMainProg));
    ICRobotVirtualhost::InitMoldFnc(host_,mold->MoldFncsBuffer());
    QVector<QVector<quint32> > subsBuffer;
    for(int i = 1; i <= ICRobotMold::kSub8Prog; ++i)
    {
        subsBuffer.append(mold->ProgramToDataBuffer(i));
    }
    ICRobotVirtualhost::InitMoldSub(host_, subsBuffer);
    ICMachineConfigPTR machineConfig = ICMachineConfig::CurrentMachineConfig();
    ICRobotVirtualhost::InitMachineConfig(host_,machineConfig->MachineConfigsBuffer());

}
