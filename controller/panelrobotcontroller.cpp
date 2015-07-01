#include "panelrobotcontroller.h"
#include <QSqlDatabase>
#include <QMessageBox>
#include "icappsettings.h"
#include "icmachineconfig.h"
//#include "icdalhelper.h"
#include "icconfigsaddr.h"
#include "parser.h"

static QScriptValue *getConfigRange_;


ICRange ICRobotRangeGetter(const QString& addrName)
{
    QScriptValueList args;
    args<<addrName;
    QMap<QString, QVariant> ranges = getConfigRange_->call(QScriptValue(),args).toVariant().toMap();
    return ICRange(ranges.value("min").toDouble(),ranges.value("max").toDouble(),ranges.value("decimal").toInt());
}

PanelRobotController::PanelRobotController(QObject *parent) :
    QObject(parent)
{
    host_ = ICRobotVirtualhost::RobotVirtualHost();
    connect(host_.data(),
            SIGNAL(NeedToInitHost()),
            SLOT(OnNeedToInitHost()));
    isMoldFncsChanged_ = false;
    isMachineConfigsChanged_ = false;
    axisDefine_ = new ICAxisDefine();
    qmlRegisterType<ICAxisDefine>("com.szhc.axis", 1, 0, "ICAxisDefine");

    // get ConfigDefines from js
#ifdef Q_WS_QWS
    QString scriptFileName("qml/PanelRobot/configs/ConfigDefines.js");
#else
    QString scriptFileName("../qml/PanelRobot/configs/ConfigDefines.js");
#endif
    QFile scriptFile(scriptFileName);
    scriptFile.open(QIODevice::ReadOnly);
    QString scriptContent = scriptFile.readAll();
    scriptFile.close();
    scriptContent = scriptContent.remove(0, sizeof(".pragma library"));
    engine_.evaluate(scriptContent, scriptFileName);
    qDebug()<<engine_.hasUncaughtException();
    configRangeGetter_ = engine_.evaluate("getConfigRange");
    getConfigRange_ = &configRangeGetter_;
    ICAddrWrapperList moldAddrs = ICAddrWrapper::MoldAddrs();
    ICParametersCache pc;
    for(int i = 0; i != moldAddrs.size(); ++i)
    {
        pc.UpdateConfigValue(moldAddrs.at(i), 0);
    }
    QVariantMap fncDefaultValues = engine_.evaluate("fncDefaultValues").toVariant().toMap();
    QVariantMap::const_iterator p = fncDefaultValues.constBegin();
    while(p != fncDefaultValues.constEnd())
    {
        ICAddrWrapperCPTR cptr = ICAddrWrapper::AddrStringToAddr(p.key());
        if(cptr == NULL)
        {
            ++p;
            continue;
        }
        pc.UpdateConfigValue(cptr, static_cast<quint32>(p.value().toDouble() * qPow(10, cptr->Decimal())));
        ++p;
    }
    baseFncs_ = pc.ToPairList();
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
    else if(!machineConfigModifyCache_.isEmpty())
    {
        ICMachineConfigPTR machineConfig = ICMachineConfig::CurrentMachineConfig();
        machineConfig->SetMachineConfigs(machineConfigModifyCache_);
        machineConfigModifyCache_.clear();
        ICRobotVirtualhost::InitMachineConfig(host_, machineConfig->MachineConfigsBuffer());
    }
}

QString PanelRobotController::records()
{
    QString content;
    ICRecordInfos infos = ICRobotMold::RecordInfos();
    for(int i = 0; i != infos.size(); ++i )
    {
        content += infos.at(i).toJSON() + ",";
    }
    content.chop(1);
    QString ret = QString("[%1]").arg(content);
    return ret;
}
PanelRobotController::~PanelRobotController()
{
    delete axisDefine_;
}

ICAxisDefine* PanelRobotController::axisDefine()
{
    ICMachineConfigPTR mptr = ICMachineConfig::CurrentMachineConfig();
    axisDefine_->setS1Axis(static_cast<ICAxisDefine::AxisType>(mptr->MachineConfig(&s_rw_0_2_0_83)));
    axisDefine_->setS2Axis(static_cast<ICAxisDefine::AxisType>(mptr->MachineConfig(&s_rw_2_2_0_83)));
    axisDefine_->setS3Axis(static_cast<ICAxisDefine::AxisType>(mptr->MachineConfig(&s_rw_4_2_0_83)));
    axisDefine_->setS4Axis(static_cast<ICAxisDefine::AxisType>(mptr->MachineConfig(&s_rw_6_2_0_83)));
    axisDefine_->setS5Axis(static_cast<ICAxisDefine::AxisType>(mptr->MachineConfig(&s_rw_8_2_0_83)));
    axisDefine_->setS6Axis(static_cast<ICAxisDefine::AxisType>(mptr->MachineConfig(&s_rw_10_2_0_83)));
    axisDefine_->setS7Axis(static_cast<ICAxisDefine::AxisType>(mptr->MachineConfig(&s_rw_12_2_0_83)));
    axisDefine_->setS8Axis(static_cast<ICAxisDefine::AxisType>(mptr->MachineConfig(&s_rw_14_2_0_83)));
    return axisDefine_;

}

void PanelRobotController::OnConfigRebase(QString)
{
    emit needToUpdateConfigs();
}
