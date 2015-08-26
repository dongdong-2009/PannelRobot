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

PanelRobotController* controllerInstance;
ICRange ICRobotRangeGetter(const QString& addrName)
{
    QScriptValueList args;
    args<<addrName;
    QMap<QString, QVariant> ranges = getConfigRange_->call(QScriptValue(),args).toVariant().toMap();
    QVariant minVariant = ranges.value("min");
    QVariant maxVariant = ranges.value("max");
    double min = (minVariant.type() == QVariant::String) ?
                controllerInstance->getRealConfigValue(minVariant.toString()) :
                minVariant.toDouble();
    double max = (maxVariant.type() == QVariant::String) ?
                controllerInstance->getRealConfigValue(maxVariant.toString()):
                maxVariant.toDouble();
    return ICRange(min,max,ranges.value("decimal").toInt());
//    return ICRange();
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
    ICAppSettings settings;
    QString uiMain = settings.UIMainName();

    QString scriptFileName(QString("%1/configs/ConfigDefines.js").arg(uiMain));
//#ifdef Q_WS_QWS
//#else
//    QString scriptFileName(QString("../%1/configs/ConfigDefines.js"));
//#endif
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

    connect(&keyCheckTimer_,
            SIGNAL(timeout()),
            SLOT(OnkeyCheckTimeOut()));
//    keyCheckTimer_.start(100);
    controllerInstance = this;
}

void PanelRobotController::Init()
{
    ICAppSettings();
    InitDatabase_();
    InitMold_();
    InitMachineConfig_();
    host_->SetCommunicateDebug(true);
#ifdef Q_WS_X11
    OnNeedToInitHost();
#endif
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
//    OnNeedToInitHost();
}

void PanelRobotController::OnNeedToInitHost()
{
    ICRobotMoldPTR mold = ICRobotMold::CurrentMold();
    ICRobotVirtualhost::SendMold(host_, mold->ProgramToDataBuffer(ICRobotMold::kMainProg));
    ICRobotVirtualhost::InitMoldFnc(host_,mold->MoldFncsBuffer());
//    QVector<QVector<quint32> > subsBuffer;
    for(int i = 1; i <= ICRobotMold::kSub8Prog; ++i)
    {
//        subsBuffer.append(mold->ProgramToDataBuffer(i));
        ICRobotVirtualhost::SendMoldSub(host_, i, mold->ProgramToDataBuffer(i));
    }
    ICMachineConfigPTR machineConfig = ICMachineConfig::CurrentMachineConfig();
#ifdef NEW_PLAT
    ICRobotVirtualhost::InitMachineConfig(host_,machineConfig->BareMachineConfigs());
#else
    ICRobotVirtualhost::InitMachineConfig(host_,machineConfig->MachineConfigsBuffer());
#endif
}

void PanelRobotController::sendKeyCommandToHost(int key)
{
#ifdef NEW_PLAT
    ICRobotVirtualhost::SendKeyCommand(key);
    keyCheckTimer_.start(100);
#else
    ICRobotVirtualhost::SendKeyCommand(key);
#endif

}

quint32 PanelRobotController::getConfigValue(const QString &addr) const
{
    ICAddrWrapperCPTR configWrapper = ICAddrWrapper::AddrStringToAddr(addr);
    if(configWrapper == NULL)
    {
        qWarning()<<addr<<"is invalid";
        return 0;
    }
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

QString PanelRobotController::getConfigValueText(const QString &addr) const
{
    ICAddrWrapperCPTR configWrapper = ICAddrWrapper::AddrStringToAddr(addr);
    if(configWrapper == NULL)
    {
        qWarning()<<addr<<"is invalid";
        return QString();
    }
    quint32 v = getConfigValue(addr);
    return QString::number(v / qPow(10, configWrapper->Decimal()),
                           'f',
                           configWrapper->Decimal());

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
#ifdef NEW_PLAT
    if(!moldFncModifyCache_.isEmpty())
    {
        ICRobotMoldPTR mold = ICRobotMold::CurrentMold();
        mold->SetMoldFncs(moldFncModifyCache_);
        moldFncModifyCache_.clear();
    }
    else if(!machineConfigModifyCache_.isEmpty())
    {
        ICMachineConfigPTR machineConfig = ICMachineConfig::CurrentMachineConfig();
        QList<QPair<int, quint32> > addrVals = machineConfig->SetMachineConfigs(machineConfigModifyCache_);
        ICRobotVirtualhost::SendConfigs(host_, addrVals);
        machineConfigModifyCache_.clear();
    }
#else
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
#endif
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
#ifdef NEW_PLAT
    axisDefine_->setS1Axis(ICAxisDefine::Servo);
    axisDefine_->setS2Axis(ICAxisDefine::Servo);
    axisDefine_->setS3Axis(ICAxisDefine::Servo);
    axisDefine_->setS4Axis(ICAxisDefine::Servo);
    axisDefine_->setS5Axis(ICAxisDefine::Servo);
    axisDefine_->setS6Axis(ICAxisDefine::Servo);
//    axisDefine_->setS1Axis(ICAxisDefine::Servo);

    return axisDefine_;
#else
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
#endif

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
    us.SetPacksDir(ICAppSettings().UsbPath);
    host_->StopCommunicate();
    us.StartUpdate(updater);

}

void PanelRobotController::modifyConfigValue(int addr, int value)
{
    ICRobotVirtualhost::AddWriteConfigCommand(host_, addr, value);
}

int PanelRobotController::statusValue(const QString& addr) const
{
    ICAddrWrapperCPTR configWrapper = ICAddrWrapper::AddrStringToAddr(addr);
    if(configWrapper == NULL) return 0;
    return host_->HostStatusValue(configWrapper);
}

QString PanelRobotController::statusValueText(const QString &addr) const
{
    ICAddrWrapperCPTR configWrapper = ICAddrWrapper::AddrStringToAddr(addr);
    if(configWrapper == NULL) return "*";
    return QString(host_->HostStatus(configWrapper));
}

int PanelRobotController::configsCheckSum(const QString &addrs) const
{
    QJson::Parser parser;
    bool ok;
    QVariantList result = parser.parse (addrs.toLatin1(), &ok).toList();
    if(!ok) return 0;
    quint32 sum = 0;
    for(int i = 0; i != result.size(); ++i)
    {
        sum += getConfigValue(result.at(i).toString());
    }
    return (-sum) & 0xFFFF;
//     return sum;
}

void PanelRobotController::loadHostMachineConfigs()
{
    ICRobotVirtualhost::AddReadConfigCommand(host_, s_rw_0_32_3_100.BaseAddr(), 28);
    ICRobotVirtualhost::AddReadConfigCommand(host_, 128, 28);
    connect(host_.data(),
            SIGNAL(QueryFinished(int , const QVector<quint32>& )),
            this,
            SLOT(OnQueryStatusFinished(int, const QVector<quint32>&)),
            Qt::UniqueConnection);
}

void PanelRobotController::OnQueryStatusFinished(int addr, const QVector<quint32> &v)
{
    if(addr < ICAddr_Read_Status0)
    {
        QList<QPair<int, quint32> > tmp;
        for(int i = 0; i < v.size(); ++i)
        {
            tmp.append(qMakePair<int , quint32>(addr + i, v.at(i)));
        }
        ICMachineConfigPTR mc = ICMachineConfig::CurrentMachineConfig();
        mc->SetBareMachineConfigs(tmp);
    }
    if(addr == 128)
    {
        disconnect(host_.data(),
                SIGNAL(QueryFinished(int , const QVector<quint32>& )),
                this,
                SLOT(OnQueryStatusFinished(int, const QVector<quint32>&)));
    }
}

void PanelRobotController::OnkeyCheckTimeOut()
{
    ICRobotVirtualhost::ClearKeyCommandQueue(host_);
    keyCheckTimer_.stop();
}
