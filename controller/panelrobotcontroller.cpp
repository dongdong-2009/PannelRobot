#include "panelrobotcontroller.h"
#include <QSqlDatabase>
#include <QMessageBox>
#include <QApplication>
#include "icappsettings.h"
#include "icmachineconfig.h"
//#include "icdalhelper.h"
#include "icconfigsaddr.h"
#include "parser.h"
#include "icupdatesystem.h"

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

    LoadTranslator_(ICAppSettings().TranslatorName());
//    LoadTranslator_("HAMOUI_zh_CN.qm");
    qApp->installTranslator(&translator);
}

void PanelRobotController::Init()
{
    ICAppSettings();
    InitDatabase_();
    InitMold_();
    InitMachineConfig_();
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
#ifdef NEW_PLAT
    ICRobotVirtualhost::SendKeyCommand(key);
#else
    ICRobotVirtualhost::SendKeyCommand(key);
#endif

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
    emit moldChanged();
}

QString PanelRobotController::usbDirs()
{
    QDir usb(ICAppSettings::UsbPath);
    if(!usb.exists())
        return QString();
    QStringList dirs = usb.entryList(QDir::Dirs | QDir::NoDotAndDotDot);
    for(int i = 0; i != dirs.size(); ++i)
    {
        dirs[i] = QString("\"%1\"").arg(dirs.at(i));
    }
    QString ret = QString("[%1]").arg(dirs.join(","));
    return ret;
}

QString PanelRobotController::localUIDirs()
{
    QDir qml(ICAppSettings::QMLPath);
    if(!qml.exists())
        return QString();
    QStringList dirs = qml.entryList(QDir::Dirs | QDir::NoDotAndDotDot);
    for(int i = 0; i != dirs.size(); ++i)
    {
        dirs[i] = QString("\"%1\"").arg(dirs.at(i));
    }
    QString ret = QString("[%1]").arg(dirs.join(","));
    return ret;
}

void PanelRobotController::setToRunningUIPath(const QString &dirname)
{
    QDir qml(ICAppSettings::QMLPath);
    if(qml.exists(dirname))
    {
        qml.cd(dirname);
        if(qml.exists("main.qml"))
        {
            ICAppSettings settings;
            settings.SetUIMainName(qml.path());
        }
    }
}

bool PanelRobotController::changeTranslator(const QString &translatorName)
{
    if(LoadTranslator_(translatorName))
    {
        SaveTranslatorName_(translatorName);
        return true;
    }
    return false;
}

void PanelRobotController::SaveTranslatorName_(const QString &name)
{
    ICAppSettings().SetTranslatorName(name);
}

bool PanelRobotController::LoadTranslator_(const QString &name)
{
    QDir qml(ICAppSettings::QMLPath);
    qml.cd(ICAppSettings().UIMainName());
    if(!qml.exists("translations")) return false;
    qml.cd("translations");
    if(!qml.exists(name)) return false;
    return translator.load(qml.filePath(name));
}

QString PanelRobotController::scanUSBUpdaters(const QString &filter)
{
    QDir usb(ICAppSettings::UsbPath);
    QStringList updaters = usb.entryList(QStringList()<<QString("%1*.bfe").arg(filter));
    QString ret = "[";
    for(int i = 0; i != updaters.size(); ++i)
    {
        ret.append(QString("\"%1\",").arg(updaters.at(i)));
    }
    if(updaters.size() != 0)
        ret.chop(1);
    ret.append("]");
    return ret;
}

void PanelRobotController::startUpdate(const QString &updater)
{
    ICUpdateSystem us;
    us.StartUpdate(updater);
}
