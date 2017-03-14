#include "panelrobotcontroller.h"
#include <QSqlDatabase>
#include <QMessageBox>
#include <QApplication>
#include <QVariant>
#include <QTextDocument>
#include "icappsettings.h"
//#include "icdalhelper.h"
#include "icconfigsaddr.h"
#include "parser.h"
#include "icupdatesystem.h"
#include "icutility.h"
#include "icregister.h"

#ifdef Q_WS_QWS
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/watchdog.h>
int wdFD;
int checkTime = 60;
int dummy;
#endif

static QScriptValue *getConfigRange_;

PanelRobotController* controllerInstance;
ICRange ICRobotRangeGetter(const QString& addrName)
{
    QScriptValueList args;
    args<<addrName;
    QMap<QString, QVariant> ranges = getConfigRange_->call(QScriptValue(),args).toVariant().toMap();
    QVariant minVariant = ranges.value("min");
    QVariant maxVariant = ranges.value("max");
    double min, max;
    if(minVariant.type() != QVariant::String)
        min = minVariant.toDouble();
    else
    {
        ICRange ret = ICRobotRangeGetter(minVariant.toString());
        qint32 v = controllerInstance->getConfigValue(minVariant.toString());
        ICAddrWrapperCPTR configWrapper = ICAddrWrapper::AddrStringToAddr(minVariant.toString());
        if(ret.min < 0  && (v >> (configWrapper->Size() - 1)))
        {
            v |= (-1 << configWrapper->Size());
        }
        min = v / qPow(10, configWrapper->Decimal());
    }
    if(maxVariant.type() != QVariant::String)
        max = maxVariant.toDouble();
    else
    {
        ICRange ret = ICRobotRangeGetter(maxVariant.toString());
        qint32 v = controllerInstance->getConfigValue(maxVariant.toString());
        ICAddrWrapperCPTR configWrapper = ICAddrWrapper::AddrStringToAddr(maxVariant.toString());
        if(ret.min < 0  && (v >> (configWrapper->Size() - 1)))
        {
            v |= (-1 << configWrapper->Size());
        }
        max = v / qPow(10, configWrapper->Decimal());
    }
    //    double min = (minVariant.type() == QVariant::String) ?
    //                controllerInstance->getRealConfigValue(minVariant.toString()) :
    //                minVariant.toDouble();
    //    double max = (maxVariant.type() == QVariant::String) ?
    //                controllerInstance->getRealConfigValue(maxVariant.toString()):
    //                maxVariant.toDouble();
    return ICRange(min,max,ranges.value("decimal").toInt());
    //    return ICRange();
}

PanelRobotController::PanelRobotController(QSplashScreen *splash, ICLog* logger, QObject *parent) :
    logger_(logger),
    QObject(parent),
    customSettings_("usr/customsettings.ini", QSettings::IniFormat),
    virtualKeyboard(ICRobotRangeGetter)
{
    mainView_ = NULL;
    QDir backupDir(ICAppSettings::UserPath);
    if(!backupDir.exists())
    {
#ifdef Q_WS_QWS
        backupDir.mkpath(ICAppSettings::UserPath);
#else
        QDir::current().mkdir(ICAppSettings::UserPath);
#endif
    }
    connect(this,
            SIGNAL(LoadMessage(QString)),
            splash,
            SLOT(showMessage(QString)));
    emit LoadMessage("Start");
    host_ = ICRobotVirtualhost::RobotVirtualHost();
    led_io.led=0;
    led_io_old.led=-1;
    fd=open("/dev/szhc_leds", O_WRONLY);
    setLEDStatus(0,0);
    connect(host_.data(),
            SIGNAL(NeedToInitHost()),
            SLOT(OnNeedToInitHost()));
    connect(host_.data(),
            SIGNAL(SendingContinuousData()),
            SIGNAL(sendingContinuousData()));
    connect(host_.data(),
            SIGNAL(SentContinuousData(int)),
            SIGNAL(sentContinuousData(int)));
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
    //    qDebug()<<"PanelrobotController Init:"<<engine_.hasUncaughtException();
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



    connect(&keyCheckTimer_,
            SIGNAL(timeout()),
            SLOT(OnkeyCheckTimeOut()));
    //    keyCheckTimer_.start(100);
    controllerInstance = this;

    if(ICRegister::Instance()->IsTryTimeOver())
    {
        emit tryTimeOver();
    }


#ifdef Q_WS_QWS
    screenSaver_ = new ICDefaultScreenSaver();
    ScreenFunctionObject* fo = new ScreenFunctionObject();
    screenSaver_->SetScreenFunction(fo);
    connect(fo,
            SIGNAL(ScreenSaved()),
            SIGNAL(screenSave()));
    connect(fo,
            SIGNAL(ScreenRestored()),
            SIGNAL(screenRestore()));
    QWSServer::setScreenSaver(screenSaver_);
    QWSServer::setScreenSaverBlockLevel(-1);
    connect(&watchDogTimer_, SIGNAL(timeout()),
            SLOT(OnWatchDogTimeOut()));
    wdFD = open("/dev/watchdog", O_RDWR);
    if(wdFD < 0)
    {
        qWarning("Open watchdog error\n");
    }
    else
    {
        ioctl(wdFD, WDIOC_SETTIMEOUT, &checkTime);
        int options = WDIOS_ENABLECARD	;
        ioctl(wdFD, WDIOC_SETOPTIONS, &options);
    }

    watchDogTimer_.start(20000);

#endif

    emit LoadMessage("Controller inited.");

}

void PanelRobotController::OnWatchDogTimeOut()
{
#ifdef Q_WS_QWS
    ioctl(wdFD, WDIOC_KEEPALIVE, &dummy);
#endif
}

void PanelRobotController::Init()
{
    ICAppSettings();
    InitDatabase_();
    emit LoadMessage("Database inited.");
    InitMachineConfig_();
    emit LoadMessage("Machine configs inited.");
    InitMold_();
    emit LoadMessage("Record inited.");

    //    host_->SetCommunicateDebug(true);
#ifdef COMM_DEBUG
    host_->SetCommunicateDebug(true);
    //    OnNeedToInitHost();
#endif
    //    InitMainView();
    qApp->installTranslator(&translator);
    qApp->installTranslator(&panelRoboTranslator_);
    qApp->installTranslator(&configsTranslator_);
    LoadTranslator_(ICAppSettings().TranslatorName());

    ICRobotMold::CurrentMold()->LoadMold(ICAppSettings().CurrentMoldConfig(), true);

    emit LoadMessage("Record reload.");

    //    InitUI();
    //    emit LoadMessage("Ui inited.");
    //        LoadTranslator_("HAMOUI_zh_CN.qm");
}

void PanelRobotController::InitDatabase_()
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("RobotDatabase");
    if(!db.isValid())
    {
        qCritical()<<"Open Database fail!!"<<db.lastError();
        QMessageBox::critical(NULL, QT_TR_NOOP("Error"), QT_TR_NOOP("Database is error!!" + db.lastError().text()));
    }
    if(!db.open())
    {
        qCritical("Open Database fail!!");
        QMessageBox::critical(NULL, QT_TR_NOOP("Error"), QT_TR_NOOP("Open Database fail!!" + db.lastError().text()));
    }
}

void PanelRobotController::InitMold_()
{
    ICAppSettings as;
    ICRobotMold* mold = new ICRobotMold();
    if(!mold->LoadMold(as.CurrentMoldConfig()))
    {
        qCritical("Mold Is Not Exist!!");
        QMessageBox::critical(mainView_, QT_TR_NOOP("Error"), QT_TR_NOOP("Mold Is Not Exist!!"));
    }
    ICRobotMold::SetCurrentMold(mold);
}

void PanelRobotController::InitMachineConfig_()
{
    ICSuperSettings as;
    ICMachineConfig* machineConfig = new ICMachineConfig();
    machineConfig->LoadMachineConfig(as.CurrentSystemConfig());
    ICMachineConfig::setCurrentMachineConfig(machineConfig);
    //    OnNeedToInitHost();
}

void PanelRobotController::OnNeedToInitHost()
{
    if(!valveDefineJSON_.isEmpty())
    {
        initValveDefines(valveDefineJSON_);
    }
    ICRobotMoldPTR mold = ICRobotMold::CurrentMold();
    ICRobotVirtualhost::SendMoldCountersDef(host_, mold->CountersToHost());
    ICRobotVirtualhost::SendMold(host_, mold->ProgramToDataBuffer(ICRobotMold::kMainProg));
    //    QVector<QVector<quint32> > subsBuffer;
    for(int i = 1; i <= ICRobotMold::kSub8Prog; ++i)
    {
        //        subsBuffer.append(mold->ProgramToDataBuffer(i));
        ICRobotVirtualhost::SendMoldSub(host_, i, mold->ProgramToDataBuffer(i));
    }
    ICMachineConfigPTR machineConfig = ICMachineConfig::CurrentMachineConfig();
#ifdef NEW_PLAT
    ICRobotVirtualhost::InitMoldFnc(host_,mold->BareMachineConfigs());
    ICRobotVirtualhost::InitMachineConfig(host_,machineConfig->BareMachineConfigs());
#else
    ICRobotVirtualhost::InitMoldFnc(host_,mold->MoldFncsBuffer());
    ICRobotVirtualhost::InitMachineConfig(host_,machineConfig->MachineConfigsBuffer());
#endif
    emit needToInitHost();
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

void PanelRobotController::sendKnobCommandToHost(int knob)
{
    if(knob == CMD_AUTO)
    {
        modifyConfigValue(ICAddr_System_Retain_11, ICRobotMold::CurrentMold()->CheckSum());
    }
    modifyConfigValue(ICAddr_System_Retain_1, knob);
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
    ICRange range = ICRobotRangeGetter(addr);
    if((range.min < 0) && (v >> (configWrapper->Size() - 1)))
    {
        v |= ((-1) << configWrapper->Size());
    }
    return QString::number(qint32(v) / qPow(10, configWrapper->Decimal()),
                           'f',
                           configWrapper->Decimal());

}

void PanelRobotController::setConfigValue(const QString &addr, const QString &v)
{
    ICAddrWrapperCPTR configWrapper = ICAddrWrapper::AddrStringToAddr(addr);
    if(configWrapper == NULL) return;
    qDebug()<<"PanelRobotController::setConfigValue"<<addr<<v;
    quint32 intV = AddrStrValueToInt(configWrapper, v);
    ICAddrWrapperValuePair p = qMakePair<ICAddrWrapperCPTR, quint32>(configWrapper, intV);
    if(configWrapper->AddrType() == ICAddrWrapper::kICAddrTypeMold)
    {
        moldFncModifyCache_.append(p);
    }
    if(configWrapper->AddrType() == ICAddrWrapper::kICAddrTypeSystem)
    {
        machineConfigModifyCache_.append(p);
    }
    qDebug()<<"PanelRobotController::setConfigValue"<<p.first->ToString()<<p.second;

    //    qDebug()<<moldFncModifyCache_;
}

void PanelRobotController::syncConfigs()
{
#ifdef NEW_PLAT
    if(!moldFncModifyCache_.isEmpty())
    {
        ICRobotMoldPTR mold = ICRobotMold::CurrentMold();
        QList<QPair<int, quint32> > addrVals = mold->SetMoldFncs(moldFncModifyCache_);
        ICRobotVirtualhost::SendConfigs(host_, addrVals);
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

QString PanelRobotController::records() const
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
#ifdef Q_WS_QWS
    close(wdFD);
#endif
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
            settings.sync();
#ifdef Q_WS_QWS
            ::system("reboot");
#endif
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
#ifdef Q_WS_QWS
    qml.cdUp();
#endif
    qml.cd(ICAppSettings().UIMainName());
    if(!qml.exists("translations"))
    {
        InitMainView();
        return false;
    }
    qml.cd("translations");
    if(!qml.exists(name))
    {
        InitMainView();
        return false;
    }
    QString nameStr = name.left(6);
    bool ret;
    if(nameStr != "HAMOUI"){
        ret = translator.load(qml.filePath("HAMOUI_zh_CN.qm" ));
    }
    else
        ret = translator.load(qml.filePath(name));
    QString language = getCustomSettings("Language", "CN");
    if(language == "CN"){
        panelRoboTranslator_.load(":/PanelRobot_zh_CN.qm");
        configsTranslator_.load(qml.filePath("configs_zh_CN.qm"));
    }
    else{
        panelRoboTranslator_.load(":/PanelRobot_en_US.qm");
        configsTranslator_.load(qml.filePath("configs_en_US.qm"));
    }
    InitMainView();
    return ret;
}

void PanelRobotController::InitMainView()
{
    if(mainView_ != NULL)
    {
        //        mainView_->setAttribute(Qt::WA_DeleteOnClose, true);
        mainView_->close();
        //        mainView_->deleteLater();
        //        delete mainView_;
    }
    emit LoadMessage("Initing ui...");
    qDebug("Init MainView");
    mainView_ = new QtQuick1ApplicationViewer;
//    virtualKeyboard.setParent(mainView_);
    comboBoxView_.setParent(mainView_);
//    virtualKeyboard.hide();
    comboBoxView_.hide();
    mainView_->rootContext()->setContextProperty("panelRobotController", this);
    mainView_->rootContext()->setContextProperty("virtualKeyboard", &virtualKeyboard);
    mainView_->rootContext()->setContextProperty("comboBoxView", &comboBoxView_);
    mainView_->addImportPath(QLatin1String("modules"));
    mainView_->setOrientation(QtQuick1ApplicationViewer::ScreenOrientationAuto);
#ifdef Q_WS_QWS
    mainView_->setWindowFlags(Qt::FramelessWindowHint);
#endif
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
    //    QLocale locale(QLocale::Chinese, QLocale::China);
    //    qDebug()<<locale.name();
    appDir.cd(uiMain);
    //    qDebug()<<appDir.filePath("main.qml");
    emit LoadMessage(appDir.filePath("main.qml"));
    mainView_->setMainQmlFile(appDir.filePath("main.qml"));
    mainView_->showExpanded();

}

QString scanHelper(const QString& filter, const QString &path = ICAppSettings::UsbPath, QDir::Filters filters = QDir::NoFilter)
{
    QDir usb(path);
    QStringList updaters = usb.entryList(QStringList()<<filter, filters);
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

QString PanelRobotController::scanUSBUpdaters(const QString &filter) const
{
    return scanHelper(QString("%1*.bfe").arg(filter));
}

QString PanelRobotController::scanUpdaters(const QString &filter, int mode) const
{
    if(mode == 1)
        return scanUSBUpdaters(filter);
    return scanUserDir("updaters", QString("%1*.bfe").arg(filter));
}

void PanelRobotController::startUpdate(const QString &updater, int mode)
{
    ICUpdateSystem us;
    if(mode == 0)
        us.SetPacksDir(ICAppSettings().UsbPath);
    else
        us.SetPacksDir(QString(ICAppSettings().UserPath) + "/updaters");
    host_->StopCommunicate();
    system("mkdir updatehost/");
    hostUpdateFinishedWatcher_.addPath("updatehost");
    connect(&hostUpdateFinishedWatcher_, SIGNAL(directoryChanged(QString)), this, SLOT(OnHostUpdateFinished(QString)));
    mainView_->hide();
#ifdef Q_WS_QWS
    int flags;
    flags = WDIOS_DISABLECARD;
    ioctl(wdFD, WDIOC_SETOPTIONS, &flags);
#endif
    us.StartUpdate(updater);
#ifdef Q_WS_QWS
    flags = WDIOS_ENABLECARD;
    ioctl(wdFD, WDIOC_SETOPTIONS, &flags);
#endif

}

QString PanelRobotController::backupUpdater(const QString &updater)
{
    QDir dir(ICAppSettings::UserPath);
    if(!dir.exists("updaters"))
    {
        dir.mkdir("updaters");
    }
    dir.cd("updaters");
    QString bf = updater;
    QString bfNew = bf;
    bfNew = bfNew.insert(bfNew.size()-8,"_");
    bfNew = bfNew.insert(bfNew.size()-8,QDateTime::currentDateTime().toString("yyyyMMddhhmmss"));

//    qDebug()<<bf;
    if(dir.exists(bf))
    {
        QFile::remove(dir.absoluteFilePath(bf));
    }
    QDir usbDir(ICAppSettings::UsbPath);
    QFile::copy(usbDir.absoluteFilePath(bf), dir.absoluteFilePath(bfNew));
    return bf;
}

void PanelRobotController::modifyConfigValue(int addr, int value)
{
    ICRobotVirtualhost::AddWriteConfigCommand(host_, addr, value);
}

void PanelRobotController::modifyConfigValue(const QString &addr, const QString& value)
{
    ICAddrWrapperCPTR configWrapper = ICAddrWrapper::AddrStringToAddr(addr);
    if(configWrapper == NULL) return;
    quint32 intV = AddrStrValueToInt(configWrapper, value);
    quint32 tosend;
    if(configWrapper->AddrType() == ICAddrWrapper::kICAddrTypeMold)
    {
        tosend = ICRobotMold::CurrentMold()->CacheMoldFnc(configWrapper, intV);
    }
    if(configWrapper->AddrType() == ICAddrWrapper::kICAddrTypeSystem)
    {
        tosend = ICMachineConfig::CurrentMachineConfig()->CacheMachineConfig(configWrapper, intV);
    }
    ICRobotVirtualhost::AddWriteConfigCommand(host_, configWrapper->BaseAddr(), tosend);
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
        //        quint32 tmp = getConfigValue(result.at(i).toString());
        sum += getConfigValue(result.at(i).toString());
        //        sum += tmp;
    }
    return (-sum) & 0xFFFF;
    //     return sum;
}

void PanelRobotController::loadHostMachineConfigs()
{
    ICRobotVirtualhost::AddReadConfigCommand(host_, s_rw_0_32_3_100.BaseAddr(), 28);
    ICRobotVirtualhost::AddReadConfigCommand(host_, 128, 28);
    ICRobotVirtualhost::AddReadConfigCommand(host_, 156, 30);
    connect(host_.data(),
            SIGNAL(QueryFinished(int , const QVector<quint32>& )),
            this,
            SLOT(OnQueryStatusFinished(int, const QVector<quint32>&)),
            Qt::UniqueConnection);
}

void PanelRobotController::OnQueryStatusFinished(int addr, const QVector<quint32> &v)
{
    if(addr == 24)
    {
        readedConfigValues_.insert(addr, v.at(0));
        disconnect(host_.data(),
                   SIGNAL(QueryFinished(int , const QVector<quint32>& )),
                   this,
                   SLOT(OnQueryStatusFinished(int, const QVector<quint32>&)));
    }
    else if(addr == 51)
    {
        QKCmdData qkData;
        qkData.all = v.at(0);
//        qDebug()<<"qkData"<<qkData.all;
        if(qkData.b.cmd == 0)
        {
            ICRobotVirtualhost::AddReadConfigCommand(host_, 51, 1);
        }
        else
        {
            readedConfigValues_.insert(addr, v.at(0));
            disconnect(host_.data(),
                       SIGNAL(QueryFinished(int , const QVector<quint32>& )),
                       this,
                       SLOT(OnQueryStatusFinished(int, const QVector<quint32>&)));
//            qDebug()<<"readQKConfigFinished"<<qkData.all;
            emit readQKConfigFinished(qkData.all);
        }
    }
    else if(addr < ICAddr_Read_Status0)
    {
        QList<QPair<int, quint32> > tmp;
        for(int i = 0; i < v.size(); ++i)
        {
            tmp.append(qMakePair<int , quint32>(addr + i, v.at(i)));
        }
        ICMachineConfigPTR mc = ICMachineConfig::CurrentMachineConfig();
        mc->SetBareMachineConfigs(tmp);
        qDebug()<<v;
    }
    if(addr == 156)
    {
        QList<QPair<int, quint32> > tmp;
        for(int i = 0; i < v.size(); ++i)
        {
            tmp.append(qMakePair<int , quint32>(addr + i, v.at(i)));
        }
        ICMachineConfigPTR mc = ICMachineConfig::CurrentMachineConfig();
        mc->SetBareMachineConfigs(tmp);
        qDebug()<<"addr156:"<<addr<<v;
        disconnect(host_.data(),
                   SIGNAL(QueryFinished(int , const QVector<quint32>& )),
                   this,
                   SLOT(OnQueryStatusFinished(int, const QVector<quint32>&)));
        emit machineConfigChanged();
    }
    //    if(!isAutoMode() && (addr >=  ICAddr_Read_Status0))
    //    {

    //    }
}

void PanelRobotController::OnkeyCheckTimeOut()
{
    ICRobotVirtualhost::ClearKeyCommandQueue(host_);
    keyCheckTimer_.stop();
}

static QStringList stepAddrs = QStringList()<<"c_ro_0_16_0_933"
                                           <<"c_ro_16_16_0_933"
                                          <<"c_ro_0_16_0_934"
                                         <<"c_ro_16_16_0_934"
                                        <<"c_ro_0_16_0_935"
                                       <<"c_ro_16_16_0_935"
                                      <<"c_ro_0_16_0_936"
                                     <<"c_ro_16_16_0_936"
                                    <<"c_ro_0_16_0_937";

QString PanelRobotController::hostStepToUILines(int which, int step) const
{
    if(which >= stepAddrs.size()) return "";
    QPair<int, QList<int> > stepInfo = ICRobotMold::CurrentMold()->RunningStepToProgramLine(which,
                                                                                            step);
    QList<int> steps = stepInfo.second;

    //    if(steps.isEmpty()) return "";
    QString ret = "[";
    for(int i = 0; i < steps.size(); ++i)
    {
        ret += QString("%1,").arg(steps.at(i));
    }

    if(!steps.isEmpty())ret.chop(1);
    ret += "]";
    ret = QString("{\"moduleID\":%1, \"steps\":\"%2\", \"hostStep\":%3, \"programIndex\":%4}")
            .arg(stepInfo.first).arg(ret).arg(step).arg(which);
    return ret;
}

QString PanelRobotController::currentRunningActionInfo(int which) const
{
    return hostStepToUILines(which, statusValue(stepAddrs.at(which)));
}

bool PanelRobotController::fixProgramOnAutoMode(int which, int module, int line, const QString &lineContent)
{
    QPair<int, int> stepInfo;
    if(module >= 0)
    {
        for(int i = 0; i < ICRobotMold::kSubEnd; ++i)
        {
            ICMoldItem item = ICRobotMold::CurrentMold()->SingleLineCompile(i, module, line, lineContent,stepInfo);
            if(item.isEmpty()) continue;

            qDebug()<<"fixProgramOnAutoMode:"<<i<<" "<<module<<ICRobotVirtualhost::FixProgram(host_, i, stepInfo.first, stepInfo.second, item);

        }
        return true;
    }
    ICMoldItem item = ICRobotMold::CurrentMold()->SingleLineCompile(which, module, line, lineContent,stepInfo);
    qDebug()<<"fixProgramOnAutoMode"<<item<<stepInfo;
    return ICRobotVirtualhost::FixProgram(host_, which, stepInfo.first, stepInfo.second, item);
}

QString PanelRobotController::scanUSBBackupPackages(const QString& filter) const
{
    return scanHelper(QString("%1*.tar").arg(filter));
}

int PanelRobotController::exportRobotMold(const QString &molds, const QString& name) const
{
    QJson::Parser parser;
    bool ok;
    QVariantList result = parser.parse (molds.toUtf8(), &ok).toList();
    int ret = 0;
    if(!ok)
    {
        ret = MoldMaintainRet::kME_InvalidMolds;
        return ret;
    }
    ICRecordInfos records = ICRobotMold::RecordInfos();
    QMap<QString, int> recordMap;
    for(int i = 0; i < records.size(); ++i)
    {
        recordMap.insert(records.at(i).recordName(), i);
    }
    for(int i = 0; i < result.size(); ++i)
    {
        if(!recordMap.contains(result.at(i).toString())){
            ret = MoldMaintainRet::kME_InvalidMolds;
            return ret;
        }
    }
#ifdef WIN32
    QDir::current().mkdir("temp");
    QDir dir = QDir("temp");
#else
    QDir dir = QDir::temp();
#endif
    dir.mkdir(name);
    dir.cd(name);
    QFile file;
    QStringList toWrite;
    QString moldName;
    for(int i = 0; i < result.size(); ++i)
    {
        moldName = result.at(i).toString();
        toWrite = ICRobotMold::ExportMold(moldName);
#ifdef Q_WS_QWS
        moldName = moldName.toUtf8();
#endif
        file.setFileName(dir.absoluteFilePath(moldName + ".act"));
        if(file.open(QFile::WriteOnly))
        {
            QStringList acts = toWrite.mid(0, 11);
            file.write(acts.join("\n").toUtf8());
            file.close();
        }
        file.setFileName(dir.absoluteFilePath(moldName + ".fnc"));
        if(file.open(QFile::WriteOnly))
        {
            QString fnc = toWrite.at(11);
            file.write(fnc.toLatin1());
            file.close();
        }
        file.setFileName(dir.absoluteFilePath(moldName + ".counters"));
        if(file.open(QFile::WriteOnly))
        {
            QString counters = toWrite.at(12);
            file.write(counters.toUtf8());
            file.close();
        }
        file.setFileName(dir.absoluteFilePath(moldName + ".variables"));
        if(file.open(QFile::WriteOnly))
        {
            QString variables = toWrite.at(13);
            file.write(variables.toUtf8());
            file.close();
        }
    }
    if(!ICUtility::IsUsbAttached())
    {
        ret = MoldMaintainRet::kME_USBNotFound;
        return ret;
    }
#ifdef WIN32
    QString cmd = QString("cd %1 && ..\\tar -cf %2.tar %2 && move /y %2.tar %3 && del /q %2 && rd /q %2").arg("temp")
            .arg(name)
            .arg(QDir("temp").relativeFilePath(QString("../%1").arg(ICAppSettings::UsbPath)));
#else
    QString cmd = QString("cd %1 && tar -cf %2.tar %2 && mv %2.tar %3 && rm -r %2").arg(QDir::tempPath())
            .arg(name)
            .arg(QDir::current().absoluteFilePath(ICAppSettings::UsbPath));
#endif
    qDebug()<<cmd;
//    QMessageBox::information(NULL, "tip", cmd.toUtf8());
    ::system(cmd.toUtf8());

#ifndef Q_WS_WIN32
    ::sync();
#endif
    return ret;
}

QString PanelRobotController::viewBackupPackageDetails(const QString &package) const
{
#ifdef WIN32
    QDir::current().mkdir("temp");
    QString tarPath = QDir::current().relativeFilePath(QString("%1/%2").arg(ICAppSettings::UsbPath).arg(package));
    QDir temp = QDir("temp");
#else
    QString tarPath = QDir(ICAppSettings::UsbPath).absoluteFilePath(package);
    QDir temp = QDir::temp();
#endif
    QString packageDirName = package;
    packageDirName.chop(4);
    if(!temp.exists(packageDirName))
    {
        ::system(QString("tar -xf %1 -C %2").arg(tarPath).arg(temp.path()).toUtf8());
    }
    temp.cd(packageDirName);
    QStringList molds = temp.entryList(QStringList()<<"*.act");
#ifdef Q_WS_QWS
    QByteArray ret = "[";
#else
    QString ret = "[";
#endif
    QString m;
    for(int i = 0; i != molds.size(); ++i)
    {
        m = molds.at(i);
        m.chop(4);
        ret.append(QString("\"%1\",").arg(m));
    }
    if(molds.size() != 0)
        ret.chop(1);
    ret.append("]");
#ifdef Q_WS_QWS
    return QString::fromUtf8(ret);
#else
    return ret;
#endif
}

QString PanelRobotController::importRobotMold(const QString &molds, const QString& backupPackage)
{
    QJson::Parser parser;
    bool ok;
    QVariantList result = parser.parse (molds.toUtf8(), &ok).toList();
    QString ret = "[";
    if(!ok)
    {
        return ret;
    }
#ifdef WIN32
    QDir temp = QDir("temp");
#else
    QDir temp = QDir::temp();
#endif
    QString backupDirName = backupPackage;
    backupDirName.chop(4);
    temp.cd(backupDirName);
    QFile file;
    QString moldName;
    QStringList moldInfo;
    QString actContent;
    RecordDataObject imported;
    for(int i = 0; i < result.size(); ++i)
    {
        moldName = result.at(i).toString();
        moldInfo.clear();
#ifdef Q_WS_QWS
        moldName = moldName.toUtf8();
#endif
//        QMessageBox::information(NULL, "tip", moldName, temp.absoluteFilePath(moldName + ".act"));
        file.setFileName(temp.absoluteFilePath(moldName + ".act"));
        if(file.open(QFile::ReadOnly))
        {
            actContent = QString::fromUtf8(file.readAll());
            qDebug()<<"IMPOrt:"<<i<<file.fileName()<<actContent;
            file.close();
            moldInfo.append(actContent.split("\n", QString::SkipEmptyParts));
        }
        file.setFileName(temp.absoluteFilePath(moldName + ".fnc"));
        if(file.open(QFile::ReadOnly))
        {
            moldInfo.append(file.readAll());
            file.close();
        }
        file.setFileName(temp.absoluteFilePath(moldName + ".counters"));
        if(file.open(QFile::ReadOnly))
        {
            moldInfo.append(QString::fromUtf8(file.readAll()));
            file.close();
        }

        file.setFileName(temp.absoluteFilePath(moldName + ".variables"));
        if(file.open(QFile::ReadOnly))
        {
            moldInfo.append(QString::fromUtf8(file.readAll()));
            file.close();
        }
#ifdef Q_WS_QWS
        moldName = result.at(i).toString();
#endif
        qDebug()<<"imp"<<moldName<<moldInfo;
        imported = ICRobotMold::ImportMold(moldName, moldInfo);
        //        if(imported.errNumber() == ICRobotMold::kRecordErr_None)
        //        {
        ret.append(imported.toJSON() + ",");
        //        }
    }
    if(ret.endsWith(","))
    {
        ret.chop(1);
    }
    return ret + "]";
}

bool PanelRobotController::setCurrentTranslator(const QString &name)
{
    QMessageBox box;
    box.setText("Language Chaning...");
    box.show();
    //    qApp->processEvents();
    qApp->processEvents();

    ICAppSettings().SetTranslatorName(name);
    return LoadTranslator_(name);
}

static ValveItem VariantToValveItem(const QVariantMap& v)
{
    ValveItem ret;
    ret.id = v.value("id").toUInt();
    ret.type = v.value("type").toUInt();
    ret.y1Board = v.value("y1Board").toUInt();
    ret.y2Board = v.value("y2Board").toUInt();
    ret.y1Point = v.value("y1Point").toUInt();
    ret.y2Point = v.value("y2Point").toUInt();
    ret.x1Board = v.value("x1Board").toUInt();
    ret.x2Board = v.value("x2Board").toUInt();
    ret.x1Point = v.value("x1Point").toUInt();
    ret.x2Point = v.value("x2Point").toUInt();
    ret.status = 0;
    ret.x1Dir = v.value("x1Dir").toUInt();
    ret.x2Dir = v.value("x2Dir").toUInt();
    ret.time = v.value("time").toDouble() * 10;
    ret.autoCheck = v.value("autoCheck").toInt();
    return ret;
}

void PanelRobotController::setYStatus(const QString &defineJson, bool isOn)
{
    QJson::Parser parser;
    bool ok;
    QVariant result = parser.parse(defineJson.toUtf8(), &ok);
    if(!ok)
    {
        return;
    }
    ValveItem vi = VariantToValveItem(result.toMap());
    vi.status = isOn;
    ICRobotVirtualhost::SendYControlCommand(host_, vi);
}

void PanelRobotController::initValveDefines(const QString &defineJson)
{
    QJson::Parser parser;
    bool ok;
    QVariantList result = parser.parse(defineJson.toUtf8(), &ok).toList();
    if(!ok)
    {
        return;
    }
    QList<ValveItem> vIs;
    for(int i = 0; i < result.size(); ++i)
    {
        vIs.append(VariantToValveItem(result.at(i).toMap()));
    }
    valveDefineJSON_ = defineJson;
    ICRobotVirtualhost::InitValveDefines(host_, vIs);
}

void PanelRobotController::logTestPoint(int type, const QString &axisDataJSON)
{
    QJson::Parser parser;
    bool ok;
    QVariantList result = parser.parse(axisDataJSON.toUtf8(), &ok).toList();
    if(!ok)
    {
        return;
    }
    if(result.length() != 6) return;
    QList<quint32> axisData;
    for(int i = 0; i < result.size(); ++i)
    {
        axisData.append(ICUtility::doubleToInt(result.at(i).toDouble(), 3));
    }
    ICRobotVirtualhost::LogTestPoint(host_, type, axisData);
}

void PanelRobotController::OnHostUpdateFinished(QString)
{
    qDebug("finised");
    disconnect(&hostUpdateFinishedWatcher_, SIGNAL(directoryChanged(QString)), this, SLOT(OnHostUpdateFinished(QString)));
#ifdef QT5
#else
    mainView_->repaint();
#endif
    mainView_->show();
    qApp->processEvents();
    host_->StartCommunicate();
    hostUpdateFinishedWatcher_.removePath("updatehost");
    system("rm -r updatehost");
}

bool PanelRobotController::saveCounterDef(quint32 id, const QString &name, quint32 current, quint32 target)
{
    if(!isInAuto())
        ICRobotVirtualhost::SendMoldCounterDef(host_, QVector<quint32>()<<id<<target<<current);
    //    else
    //    {
    //        QVariantList c = ICRobotMold::CurrentMold()->GetCounter(id);
    //        if(c.isEmpty()) return false;
    //        if(c.last() != target)
    //            ICRobotVirtualhost::SendMoldCounterDef(host_, QVector<quint32>()<<id<<target<<current);
    //    }
    return ICRobotMold::CurrentMold()->CreateCounter(id, name, current, target);
}

bool PanelRobotController::saveCounterCurrent(quint32 id, const QString &name, quint32 current, quint32 target)
{
    return ICRobotMold::CurrentMold()->CreateCounter(id, name, current, target);
}

void PanelRobotController::sendToolCoord(int id,const QString& data)
{
    QJson::Parser parser;
    bool ok;
    QVariantList result = parser.parse(data.toUtf8(), &ok).toList();
    if(!ok)
        return;
    QVector<quint32> tmp;
    tmp.append(id);
    for(int i=0;i<result.size();i++)
        tmp.append(ICUtility::doubleToInt(result.at(i).toDouble(), 3));
    ICRobotVirtualhost::sendMoldToolCoordDef(host_,tmp);
}

bool PanelRobotController::delCounterDef(quint32 id)
{
    return ICRobotMold::CurrentMold()->DeleteCounter(id);
}

QString PanelRobotController::counterDefs() const
{
    QVector<QVariantList> counters = ICRobotMold::CurrentMold()->Counters();
    QString ret = "[";
    for(int i = 0; i < counters.size(); ++i)
    {
        ret += (QString("[%1, \"%2\", %3, %4]").arg(counters.at(i).at(0).toUInt())
                .arg(counters.at(i).at(1).toString()).arg(counters.at(i).at(2).toUInt())
                .arg(counters.at(i).at(3).toUInt()));
        ret += ",";
    }
    if(!counters.isEmpty())
    {
        ret.chop(1);
    }
    ret += "]";
    return ret;
}

bool PanelRobotController::saveVariableDef(quint32 id, const QString& name, const QString& unit, quint32 val, quint32 decimal)
{
    return ICRobotMold::CurrentMold()->CreateVariables(id, name, unit, val, decimal);
}

bool PanelRobotController::delVariableDef(quint32 id)
{
    return ICRobotMold::CurrentMold()->DeleteVariable(id);
}

QString PanelRobotController::variableDefs() const
{
    QVector<QVariantList> varialbes = ICRobotMold::CurrentMold()->Variables();
    QString ret = "[";
    for(int i = 0; i < varialbes.size(); ++i)
    {
        ret += (QString("[%1, \"%2\", \"%3\", %4, %5]").arg(varialbes.at(i).at(0).toUInt())
                .arg(varialbes.at(i).at(1).toString()).arg(varialbes.at(i).at(2).toString())
                .arg(varialbes.at(i).at(3).toInt())
                .arg(varialbes.at(i).at(4).toUInt()));
        ret += ",";
    }
    if(!varialbes.isEmpty())
    {
        ret.chop(1);
    }
    ret += "]";
    return ret;
}

QVector<QVariantList> PanelRobotController::ParseCounters(const QString &counters)
{
    QVector<QVariantList> ret;
    if(counters.isEmpty()) return ret;
    QJson::Parser parser;
    bool ok;
    QVariantList result = parser.parse(counters.toUtf8(), &ok).toList();
    if(!ok)
        return ret;
    QVariantList tmp;
    QVariantMap r;
    for(int i = 0; i < result.size(); ++i)
    {
        r = result.at(i).toMap();
        tmp<<r.value("id")<<r.value("name")<<r.value("current")<<r.value("target");
        ret.append(tmp);
    }
    return ret;
}

QVector<QVariantList> PanelRobotController::ParseVariables(const QString &variables)
{
    QVector<QVariantList> ret;
    if(variables.isEmpty()) return ret;
    QJson::Parser parser;
    bool ok;
    QVariantList result = parser.parse(variables.toUtf8(), &ok).toList();
    if(!ok)
        return ret;
    QVariantList tmp;
    QVariantMap r;
    for(int i = 0; i < result.size(); ++i)
    {
        r = result.at(i).toMap();
        tmp<<r.value("id")<<r.value("name")<<r.value("unit")<<r.value("val")<<r.value("decimal");
        ret.append(tmp);
    }
    return ret;
}

void PanelRobotController::manualRunProgram(const QString& program,
                                            const QString& stacks,
                                            const QString& counters,
                                            const QString& variables,
                                            const QString& functions,
                                            int channel,
                                            bool sendKeyNow)
{
    bool isok;
    QMap<int, StackInfo> compliedStacks = ICRobotMold::ParseStacks(stacks, isok);
    QVector<QVariantList> compliedCounters = ParseCounters(counters);
    QVector<QVariantList> compliedVariables = ParseVariables(variables);
    QMap<int, CompileInfo> compliedFunctions = ICRobotMold::ParseFunctions(functions,
                                                                           isok,
                                                                           compliedStacks,
                                                                           compliedCounters,
                                                                           compliedVariables);

    int err;
    CompileInfo compliedProgram = ICRobotMold::Complie(program,
                                                       compliedStacks,
                                                       compliedCounters,
                                                       compliedVariables,
                                                       compliedFunctions,
                                                       err);
    if(err)
        return;
    if(!compliedCounters.isEmpty())
        ICRobotVirtualhost::SendMoldCountersDef(host_,ICRobotMold::CountersToHost(compliedCounters));
    ICRobotVirtualhost::SendMoldSub(host_, channel, compliedProgram.ProgramToBareData());
    //    sendKeyCommandToHost(CMD_MANUAL_START1 + channel);
    if(sendKeyNow)
        ICRobotVirtualhost::SendKeyCommand(CMD_MANUAL_START1 + channel);

}

QString PanelRobotController::checkProgram(const QString &program, const QString &stacks, const QString &counters, const QString &variables, const QString &functions)
{
    bool isok;
    QMap<int, StackInfo> compliedStacks = ICRobotMold::ParseStacks(stacks, isok);
    QVector<QVariantList> compliedCounters = ParseCounters(counters);
    QVector<QVariantList> compliedVariables = ParseVariables(variables);
    QMap<int, CompileInfo> compliedFunctions = ICRobotMold::ParseFunctions(functions,
                                                                           isok,
                                                                           compliedStacks,
                                                                           compliedCounters,
                                                                           compliedVariables);

    int err;
    CompileInfo compliedProgram = ICRobotMold::Complie(program,
                                                       compliedStacks,
                                                       compliedCounters,
                                                       compliedVariables,
                                                       compliedFunctions,
                                                       err);
    return ErrInfoToJSON(compliedProgram.ErrInfo());
}

QImage ImageToGray( QImage image )
{
    //    int height = image.height();
    //    int width = image.width();
    QImage ret = image.convertToFormat(QImage::Format_Indexed8);
    ret.setColorCount(256);
    for(int i = 0; i < 256; i++)
    {
        ret.setColor(i, qRgba(i, i, i, qAlpha(ret.color(i))));
    }
    //    switch(image.format())
    //    {
    //    case QImage::Format_Indexed8:
    //        for(int i = 0; i < height; i ++)
    //        {
    //            const uchar *pSrc = (uchar *)image.constScanLine(i);
    //            uchar *pDest = (uchar *)ret.scanLine(i);
    //            memcpy(pDest, pSrc, width);
    //        }
    //        break;
    //    case QImage::Format_RGB32:
    //    case QImage::Format_ARGB32:
    //    case QImage::Format_ARGB32_Premultiplied:
    //        for(int i = 0; i < height; i ++)
    //        {
    //            const QRgb *pSrc = (QRgb *)image.constScanLine(i);
    //            uchar *pDest = (uchar *)ret.scanLine(i);

    //            for( int j = 0; j < width; j ++)
    //            {
    //                pDest[j] = qGray(pSrc[j]);
    //            }
    //        }
    //        break;
    //    }
    return ret;
}

QString PanelRobotController::disableImage(const QString &enabledImage)
{
    QString localFile = QUrl(enabledImage).toLocalFile();
    if(!QFile::exists(localFile))
        return "";
    int formatStart = localFile.lastIndexOf(".");
    QStringList nameAndFormat;
    nameAndFormat.append(localFile.mid(0, formatStart));
    nameAndFormat.append(localFile.mid(formatStart + 1));
    QString ret = QString("%1_disable.%2").arg(nameAndFormat.at(0)).arg(nameAndFormat.at(1));
    if(QFile::exists(ret))
        return ret;
    QImage p(localFile);
    p = ImageToGray(p);
    p.save(ret);
    return ret;
}

void PanelRobotController::sendExternalDatas(const QString& dsData)
{
    QJson::Parser parser;
    bool ok;
    qDebug()<<"sendExternalDatas"<<dsData;
    QVariantMap result = parser.parse (dsData.toLatin1(), &ok).toMap();
    if(!ok) return;
    int hostID = result.value("hostID").toInt();
    QVariantList ds= result.value("dsData").toList();
    QVector<quint32> toSendData;
    QVariantMap posData;
    for(int i = 0; i < ds.size(); ++i)
    {
        posData = ds.at(i).toMap();
        toSendData<<ICUtility::doubleToInt(posData.value("m0").toDouble(),3)
                 <<ICUtility::doubleToInt(posData.value("m1").toDouble(),3)
                <<ICUtility::doubleToInt(posData.value("m2").toDouble(),3)
               <<ICUtility::doubleToInt(posData.value("m3").toDouble(),3)
              <<ICUtility::doubleToInt(posData.value("m4").toDouble(),3)
             <<ICUtility::doubleToInt(posData.value("m5").toDouble(),3);
    }
    if(ds.size() != 0)
        ICRobotVirtualhost::SendExternalDatas(host_, hostID, toSendData);
}

void PanelRobotController::setWatchDogEnabled(bool en)
{

#ifdef Q_WS_QWS
    int flags;
    if(en)
    {
        flags = WDIOS_ENABLECARD;
        ioctl(wdFD, WDIOC_SETTIMEOUT, &checkTime);
    }
    else
    {
        flags = WDIOS_DISABLECARD;
    }
    ioctl(wdFD, WDIOC_SETOPTIONS, &flags);
#endif

}

QString PanelRobotController::getPictures() const
{
    QDir usb(ICAppSettings::UsbPath);
    if(!usb.exists("HCUpdate_pic")) return "[]";
    usb.cd("HCUpdate_pic");
    QStringList updaters = usb.entryList(QStringList()<<"*.png");
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

QString PanelRobotController::getPicturesPath(const QString& picName) const
{
    QDir usb(ICAppSettings::UsbPath);
    if(!usb.exists("HCUpdate_pic")) return "";
    usb.cd("HCUpdate_pic");
    return usb.absoluteFilePath(picName);
}

void PanelRobotController::copyPicture(const QString &picName, const QString& to) const
{
    QDir usb(ICAppSettings::UsbPath);
    if(!usb.exists("HCUpdate_pic")) return;
    usb.cd("HCUpdate_pic");
    ICAppSettings settings;
    QString uiMain = settings.UIMainName();
    QDir appDir = QDir::current();
    appDir.cd(uiMain);
    appDir.cd("images");
    ::system(QString("cp %1 %2 -f").arg(usb.absoluteFilePath(picName))
             .arg(appDir.absoluteFilePath(to)).toLatin1());
    ::system("sync");
}


QString PanelRobotController::scanUserDir(const QString &path, const QString &filter) const
{
    QDir dir(ICAppSettings::UserPath);
    if(!dir.exists(path))
        return "[]";
    dir.cd(path);
    QStringList toSearch = dir.entryList(QStringList()<<filter);
    QString ret = "[";
    for(int i = 0; i != toSearch.size(); ++i)
    {
        ret.append(QString("\"%1\",").arg(toSearch.at(i)));
    }
    if(toSearch.size() != 0)
        ret.chop(1);
    ret.append("]");
    return ret;
}

QString PanelRobotController::backupHMIBackup(const QString& backupName, const QString& sqlData) const
{
    QDir dir(ICAppSettings::UserPath);
    if(!dir.exists("hmibps"))
    {
        dir.mkdir("hmibps");
    }
    dir.cd("hmibps");
    QString utf8BackupName = backupName;
    QString bf = utf8BackupName + ".hmi.hcdb";
    if(dir.exists(bf.toUtf8()))
    {
        QFile::remove(dir.absoluteFilePath(bf.toUtf8()));
    }
    dir.mkdir(utf8BackupName.toUtf8());
    dir.cd(utf8BackupName.toUtf8());
    QFile sql(dir.absoluteFilePath("hmi.sql"));
    if(sql.open(QFile::WriteOnly))
    {
        sql.write(sqlData.toUtf8());
        sql.close();
    }
    QFile::copy("usr/customsettings.ini", dir.absoluteFilePath("customsettings.ini"));
    QFile::copy("sysconfig/PanelRobot.ini", dir.absoluteFilePath("PanelRobot.ini"));
    dir.cdUp();
    ::system(QString("cd %1 && tar -zcvf - %2 | openssl des3 -salt -k szhcSZHCGaussCheng | dd of=%2.hmi.hcdb")
             .arg(dir.absolutePath()).arg(utf8BackupName).toUtf8());

    ICUtility::DeleteDirectory(dir.absoluteFilePath(utf8BackupName.toUtf8()));
    return utf8BackupName + ".hmi.hcdb";
}

QString PanelRobotController::restoreHMIBackup(const QString &backupName, int mode)
{
    QString dirPath = (mode == 0 ? QString(ICAppSettings::UserPath) + "/hmibps" : ICAppSettings::UsbPath);
    QDir dir(dirPath);
    if(!dir.exists(backupName.toUtf8())) return "";
    ::system(QString("cd %2 && dd if=%1 | openssl des3 -d -k szhcSZHCGaussCheng | tar zxf -").arg(backupName).arg(dir.absolutePath()).toUtf8());
    QString backupDirName = backupName;
    backupDirName.chop(9);
    QDir backupDir(dir.absoluteFilePath(backupDirName.toUtf8()));
    QFile sqlData(backupDir.absoluteFilePath("hmi.sql"));
    sqlData.open(QFile::ReadOnly);
    QString ret = QString::fromUtf8(sqlData.readAll());
    sqlData.close();
    QFile::remove("usr/customsettings.ini");
    QFile::remove("sysconfig/PanelRobot.ini");
    QFile::copy(backupDir.absoluteFilePath("customsettings.ini"), "usr/customsettings.ini");
    QFile::copy(backupDir.absoluteFilePath("PanelRobot.ini"), "sysconfig/PanelRobot.ini");
    ::system(QString("rm -r %1").arg(backupDir.absolutePath()).toUtf8());
    ::system("sync");
    return ret;
}

QString PanelRobotController::backupMRBackup(const QString &backupName) const
{
    QDir dir(ICAppSettings::UserPath);
    if(!dir.exists("mrbps"))
    {
        dir.mkdir("mrbps");
    }
    dir.cd("mrbps");
    QString bf = backupName + ".mr.hcdb";
    if(dir.exists(bf.toUtf8()))
    {
        QFile::remove(dir.absoluteFilePath(bf.toUtf8()));
    }
    dir.mkdir(backupName.toUtf8());
    dir.cd(backupName.toUtf8());
    QFile::copy("RobotDatabase", dir.absoluteFilePath("RobotDatabase"));
    dir.cdUp();
    ::system(QString("cd %1 && tar -zcvf - %2 | openssl des3 -salt -k szhcSZHCGaussCheng | dd of=%2.mr.hcdb")
             .arg(dir.absolutePath()).arg(backupName).toUtf8());
    ICUtility::DeleteDirectory(dir.absoluteFilePath(backupName.toUtf8()));
    return backupName + ".mr.hcdb";

}

void PanelRobotController::restoreMRBackup(const QString &backupName, int mode)
{
    QString dirPath = (mode == 0 ? QString(ICAppSettings::UserPath) + "/mrbps" : ICAppSettings::UsbPath);
    QDir dir(dirPath);
    if(!dir.exists(backupName.toUtf8())) return;
    ::system(QString("cd %2 && dd if=%1 | openssl des3 -d -k szhcSZHCGaussCheng | tar zxf -").arg(backupName).arg(dir.absolutePath()).toUtf8());
    QString backupDirName = backupName;
    backupDirName.chop(8);
    QDir backupDir(dir.absoluteFilePath(backupDirName.toUtf8()));
    QFile::remove("RobotDatabase");
    QFile::copy(backupDir.absoluteFilePath("RobotDatabase"), "RobotDatabase");
    ::system(QString("rm -rf %1").arg(backupDir.absolutePath()).toUtf8());

}


QString PanelRobotController::makeGhost(const QString &ghostName, const QString& hmiSqlData) const
{
    QDir dir(ICAppSettings::UserPath);
    if(!dir.exists("ghosts"))
    {
        dir.mkdir("ghosts");
    }
    dir.cd("ghosts");
    QString bf = ghostName + ".ghost.hcdb";
    if(dir.exists(bf.toUtf8()))
    {
        QFile::remove(dir.absoluteFilePath(bf.toUtf8()));
    }
    QFile sql("hmi.sql");
    if(sql.open(QFile::WriteOnly))
    {
        sql.write(hmiSqlData.toUtf8());
        sql.close();
    }
    ::system(QString("tar -zcvf - %1 | openssl des3 -salt -k szhcSZHCGaussCheng | dd of=%2")
             .arg(QDir::current().absolutePath())
             .arg(dir.absoluteFilePath(ghostName + ".ghost.hcdb")).toUtf8());
    return ghostName + ".ghost.hcdb";
}

QString PanelRobotController::restoreGhost(const QString& backupName, int mode)
{
    QString dirPath = (mode == 0 ? QString(ICAppSettings::UserPath) + "/ghosts" : ICAppSettings::UsbPath);
    QDir dir(dirPath);
    if(!dir.exists(backupName.toUtf8())) return "";
    ::system(QString("cd %2 && dd if=%1 | openssl des3 -d -k szhcSZHCGaussCheng | tar zxf - -C /")
             .arg(backupName)
             .arg(dir.absolutePath()).toUtf8());
    QFile sql("hmi.sql");
    QString ret;
    if(sql.open(QFile::ReadOnly))
    {
        ret = QString::fromUtf8(sql.readAll());
        sql.close();
    }
    return ret;
}

QString PanelRobotController::newRecord(const QString &name, const QString &initProgram, const QString &subPrograms)
{
    QJson::Parser parser;
    bool ok;
    QVariantList result = parser.parse (subPrograms.toUtf8(), &ok).toList();
    QStringList subs;
    if(ok)
    {
        for(int i = 0; i < result.size(); ++i)
        {
            subs.append(result.at(i).toString());
        }
    }
    return ICRobotMold::NewRecord(name, initProgram, baseFncs_, subs).toJSON();
}

QString PanelRobotController::readRecord(const QString &name) const
{
    QStringList content = ICRobotMold::ExportMold(name);
    return QString("[%1]").arg(content.join(","));
}

bool PanelRobotController::loadRecord(const QString &name)
{
    ICRobotMoldPTR mold = ICRobotMold::CurrentMold();
    QMap<int, StackInfo> stacks = mold->GetStackInfos();
    bool ret =  mold->LoadMold(name);
    if(ret)
    {
        ret = ICRobotVirtualhost::SendMoldCountersDef(host_, mold->CountersToHost());
        ret = sendMainProgramToHost();
        if(ret)
        {
            for(int i = ICRobotMold::kSub1Prog; i <= ICRobotMold::kSub8Prog; ++i)
            {
                ret = sendSubProgramToHost(i);
                if(!ret)
                {
                    break;
                }
            }
        }
        if(ret)
        {
            ret =ICRobotVirtualhost::InitMoldFnc(host_,mold->BareMachineConfigs());
        }

#ifndef Q_WS_QWS
        ret = true;
#endif
        ICAppSettings as;
        as.SetCurrentMoldConfig(name);

        QMap<int, StackInfo>::const_iterator p = stacks.constBegin();
        StackInfo si;
        bool ok;
        while(p != stacks.constEnd())
        {
            si = mold->GetStackInfo(p.key(), ok);
            if(!ok || si.posData.isEmpty())
            {
                ICRobotVirtualhost::SendExternalDatas(host_, p.key(), si.posData);
            }
            ++p;
        }

        emit moldChanged();
        modifyConfigValue(ICAddr_System_Retain_11, ICRobotMold::CurrentMold()->CheckSum());

    }

    return ret;
}

QString PanelRobotController::scanHMIBackups(int mode) const
{
    if(mode == 1)
        return scanHelper("*.hmi.hcdb");
    return scanUserDir("hmibps", "*.hmi.hcdb");
}

QString PanelRobotController::scanMachineBackups(int mode) const
{
    if(mode == 1)
        return scanHelper("*.mr.hcdb");
    return scanUserDir("mrbps", "*.mr.hcdb");

}

QString PanelRobotController::scanGhostBackups(int mode) const
{
    if(mode == 1)
        return scanHelper("*.ghost.hcdb");
    return scanUserDir("ghosts", "*.ghost.hcdb");
}

int exportBackupHelper(const QString& backupName, const QString& path)
{
    QDir dir(ICAppSettings::UserPath);
    if(!dir.cd(path)) return -1;
    if(!dir.exists(backupName.toUtf8())) return -1;
    if(!ICUtility::IsUsbAttached()) return -2;
    //    qDebug()<<dir.absoluteFilePath(backupName.toUtf8())<<QDir(ICAppSettings::UsbPath).absoluteFilePath(backupName)<<QDir(ICAppSettings::UsbPath).absoluteFilePath(backupName.toUtf8());
    if(QFile::copy(dir.absoluteFilePath(backupName.toUtf8()), QDir(ICAppSettings::UsbPath).absoluteFilePath(backupName.toUtf8())))
    {
#ifdef  Q_WS_QWS
        ::sync();
#endif
        return 0;
    }
    return -3;
}

int PanelRobotController::exportHMIBackup(const QString &backupName) const
{
    return exportBackupHelper(backupName, "hmibps");
}

int PanelRobotController::exportMachineBackup(const QString &backupName) const
{
    return exportBackupHelper(backupName, "mrbps");
}

int PanelRobotController::exportGhost(const QString &backupName) const
{
    return exportBackupHelper(backupName, "ghosts");
}

int PanelRobotController::exportUpdater(const QString &updaterName) const
{
    return exportBackupHelper(updaterName, "updaters");
}

void deleteBackupHelper(const QString& subPath, const QString &backupName, int mode)
{
    QString dirPath = (mode == 0 ? QString(ICAppSettings::UserPath) + "/" + subPath : ICAppSettings::UsbPath);
    QDir dir(dirPath);
    if(!dir.exists(backupName.toUtf8())) return;
    QFile::remove(dir.absoluteFilePath(backupName.toUtf8()));
}

void PanelRobotController::deleteHIMBackup(const QString &backupName, int mode)
{
    deleteBackupHelper("hmibps", backupName, mode);
}

void PanelRobotController::deleteMRBackup(const QString &backupName, int mode)
{
    deleteBackupHelper("mrbps", backupName, mode);
}

void PanelRobotController::deleteGhost(const QString &backupName, int mode)
{
    deleteBackupHelper("ghosts", backupName, mode);
}

void PanelRobotController::deleteUpdater(const QString &updater, int mode)
{
    deleteBackupHelper("updaters", updater, mode);
}

void PanelRobotController::registerCustomProgramAction(const QString &actionDefine)
{
    QJson::Parser parser;
    bool ok;
    QVariantMap ret = parser.parse(actionDefine.toLatin1(), &ok).toMap();
    if(ok)
    {
        ICCustomActionParseDefine cpd;
        QVariantList items = ret.value("seq").toList();
        QVariantMap item;
        for(int i = 0; i < items.size(); ++i)
        {
            item = items.at(i).toMap();
            cpd.append(qMakePair(item.value("item").toString(), item.value("decimal").toInt()));
        }
        ICRobotMold::RegisterCustomAction(ret.value("actionID").toInt(), cpd);
    }
}

int PanelRobotController::registerUseTime(const QString &fc, const QString &mC, const QString &rcCode)
{
    int ret = ICRegister::Register(fc, mC, rcCode);
    if(ret < 0) return ret;
    ICRegister::Instance()->SetUseTime(ret);
    return ret;
}

QString PanelRobotController::generateMachineCode() const
{
    return ICRegister::GenerateMachineCode();
}

int PanelRobotController::restUseTime() const
{
    return ICRegister::Instance()->LeftUseTime();
}

bool PanelRobotController::isTryTimeOver() const
{
    return ICRegister::Instance()->IsTryTimeOver();
}

void PanelRobotController::setRestUseTime(int hour)
{
    ICRegister::Instance()->SetUseTime(hour);
}

void PanelRobotController::writeQKConfig(int axis, int addr, int data, bool ep)
{
    QKCmdData qkData;
    qkData.b.cmd = ep ? 3 : 1;
    qkData.b.id = axis;
    qkData.b.addr = addr;
    qkData.b.data = data;
    modifyConfigValue(50, qkData.all);

}


void PanelRobotController::readQKConfig(int axis, int addr, bool ep)
{
    QKCmdData qkData;
    qkData.b.cmd = ep ? 4 : 2;
    qkData.b.id = axis;
    qkData.b.addr = addr;
    modifyConfigValue(50, qkData.all);
    ICRobotVirtualhost::AddReadConfigCommand(host_, 51, 1);
    connect(host_.data(),
            SIGNAL(QueryFinished(int , const QVector<quint32>& )),
            this,
            SLOT(OnQueryStatusFinished(int, const QVector<quint32>&)),
            Qt::UniqueConnection);
}

QString PanelRobotController::scanUSBFiles(const QString &filter) const
{
    return scanHelper(QString("%1").arg(filter), ICAppSettings::UsbPath, QDir::Files);
}

QString PanelRobotController::usbFileContent(const QString &fileName, bool isTextOnly) const
{
    QString filePath = QDir(ICAppSettings::UsbPath).absoluteFilePath(fileName);
    QFile f(filePath);
    QByteArray ret;
    if(f.open(isTextOnly ? (QFile::ReadOnly | QFile::Text) : QFile::ReadOnly))
    {
//        ret.resize(f.size());
//        f.read(ret.data(), f.size());
        ret = f.readAll();
        f.close();
        if(isTextOnly)
        {
            if(ret.contains(char(0)))
                ret = "";
        }
    }
    return QString(ret);
}

bool PanelRobotController::writeUsbFile(const QString& fileName, const QString& content)
{
    QString filePath = QDir(ICAppSettings::UsbPath).absoluteFilePath(fileName);
    QFile f(filePath);

    if(!f.open(QIODevice::WriteOnly | QIODevice::Text))
        return 0;

    QTextStream txtOutput(&f);
    QTextDocument contentText;
    contentText.setHtml(content);
    txtOutput << contentText.toPlainText() << endl;
    f.close();
    return 1;
}


