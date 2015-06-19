#include "panelrobotcontroller.h"
#include <QSqlDatabase>
#include <QMessageBox>
#include "icappsettings.h"
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
    isMoldFncsChanged_ = false;
    isMachineConfigsChanged_ = false;
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

void PanelRobotController::sendKeyCommandToHost(int key)
{
    ICRobotVirtualhost::SendKeyCommand(key);
}

quint32 PanelRobotController::getConfigValue(const QString &addr)
{
    ICAddrWrapperCPTR configWrapper = ICAddrWrapper::AddrStringToAddr(addr);
    if(configWrapper == NULL) return 0;
    if(configWrapper->AddrType() == ICAddrWrapper::kICAddrTypeMold)
    {
        return ICRobotMold::CurrentMold()->MoldFnc(configWrapper);
    }
    if(configWrapper->AddrType() == ICAddrWrapper::kICAddrTypeSystem)
    {
        return ICMachineConfig::CurrentMachineConfig()->MachineConfig(configWrapper);
    }
    if(configWrapper->AddrType() == ICAddrWrapper::kICAddrTypeCrafts)
    {
        host_->HostStatusValue(configWrapper);
    }
    return 0;
}

void PanelRobotController::setConfigValue(const QString &addr, const QString &v)
{
    ICAddrWrapperCPTR configWrapper = ICAddrWrapper::AddrStringToAddr(addr);
    if(configWrapper == NULL) return;
    ICAddrWrapperValuePair p = qMakePair<ICAddrWrapperCPTR, quint32>(configWrapper, AddrStrValueToInt(configWrapper, v));
    if(configWrapper->AddrType() == ICAddrWrapper::kICAddrTypeMold)
    {
        moldFncModifyCache_.append(p);
    }
    if(configWrapper->AddrType() == ICAddrWrapper::kICAddrTypeSystem)
    {
        machineConfigModifyCache_.append(p);
    }
//    qDebug()<<moldFncModifyCache_;
}

void PanelRobotController::syncConfigs()
{
    if(!moldFncModifyCache_.isEmpty())
    {
        ICRobotMoldPTR mold = ICRobotMold::CurrentMold();
        mold->SetMoldFncs(moldFncModifyCache_);
        moldFncModifyCache_.clear();
        ICRobotVirtualhost::InitMoldFnc(host_,mold->MoldFncsBuffer());
    }
}
