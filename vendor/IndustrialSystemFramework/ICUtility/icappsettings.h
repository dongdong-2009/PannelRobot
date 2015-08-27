#ifndef ICAPPSETTINGS_H
#define ICAPPSETTINGS_H

#include <QSettings>
#include <QLocale>
#include <QTime>
#ifndef Q_WS_WIN32
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#endif

class ICAppSettings: public QSettings
{
public:
    ICAppSettings();
    void SetCurrentMoldConfig(const QString& record);
    QString CurrentMoldConfig();
    QString CurrentSystemConfig();
    void SetCurrentSystemConfig(const QString& systemconfig);
    QLocale Locale();
    void SetLocale(const QLocale &locale);

    uint BacklightTime();
    void SetBacklightTime(uint minutes);

    bool IsLogoutWhenScreenSave();
    void SetLogoutWhenScreenSave(bool isLogout = true);

    uint UsedTime();
    void SetUsedTime(uint hours);

    uint TotalUsedTime();
    void SetTotalUsedTime(uint hours);
    void IncreaseTotalUsedTime();

    QString MachineCode();
    void SetMachineCode(const QString& machineCode);

    QString FactoryCode();
    void SetFactoryCode(const QString& code);

    QString ManufacturingNo();
    void SetManufacturingNo(const QString& code);

    QString ManufacturingDate();
    void SetManufacturingDate(const QString& code);


    bool KeyTone();// { return GetParameter(ProductConfig, "KeyTone", true).toBool();}
#ifndef Q_WS_WIN32
    void SetKeyTone(bool isOn);//  {SaveParameter(ProductConfig, "KeyTone", isOn);ioctl(beepFD_, 0, isOn ? 20 : 10);}
#else
    void SetKeyTone(bool isOn);//  {SaveParameter(ProductConfig, "KeyTone", isOn);}
#endif
    QString UIMainName();
    void SetUIMainName(const QString& mainName);

    QString TranslatorName();
    void SetTranslatorName(const QString& translatorName);


    static QTime StartupTime(){ return startupTime_;}
    static void SetStartupTime(const QTime& time) { startupTime_ = time;}
//    static uint Used
    const static char* UsbPath;
    const static char* QMLPath;
private:
    const static char* SystemConfigGroup;
    const static char* SessionGroup;
    const static char* LocaleGroup;

    static QTime startupTime_;
};

inline void ICAppSettings::SetCurrentMoldConfig(const QString &record)
{
    beginGroup(SessionGroup);
    setValue("CurrentRecord", record);
    endGroup();
}

inline QString ICAppSettings::CurrentMoldConfig()
{
    beginGroup(SessionGroup);
    QString ret = value("CurrentRecord", "default").toString();
    endGroup();
    return ret;
}

inline QString ICAppSettings::CurrentSystemConfig()
{
    beginGroup(SessionGroup);
    QString ret = value("CurrentSystemConfig", "default").toString();
    endGroup();
    return ret;
}

inline void ICAppSettings::SetCurrentSystemConfig(const QString &systemconfig)
{
    beginGroup(SessionGroup);
    setValue("CurrentSystemConfig", systemconfig);
    endGroup();
}

inline QLocale ICAppSettings::Locale()
{
    beginGroup(LocaleGroup);
    QLocale ret =  value("Locale", QLocale(QLocale::Chinese, QLocale::China)).toLocale();
    endGroup();
    return ret;
}

inline void ICAppSettings::SetLocale(const QLocale &locale)
{
    beginGroup(LocaleGroup);
    setValue("Locale", locale);
    endGroup();
}

inline uint ICAppSettings::BacklightTime()
{
    beginGroup(SystemConfigGroup);
    uint ret = value("BacklightTime", 5).toUInt();
    endGroup();
    return ret;
}

inline void ICAppSettings::SetBacklightTime(uint minutes)
{
    beginGroup(SystemConfigGroup);
    setValue("BacklightTime", minutes);
    endGroup();
}

inline bool ICAppSettings::IsLogoutWhenScreenSave()
{
    beginGroup(SystemConfigGroup);
    bool ret = value("IsLogoutWhenScreenSave", true).toBool();
    endGroup();
    return ret;
}

inline void ICAppSettings::SetLogoutWhenScreenSave(bool isLogout)
{
    beginGroup(SystemConfigGroup);
    setValue("IsLogoutWhenScreenSave", isLogout);
    endGroup();
}

inline uint ICAppSettings::UsedTime()
{
    beginGroup(SystemConfigGroup);
    uint ret = value("UsedTime", 0).toUInt();
    endGroup();
    return ret;
}

inline void ICAppSettings::SetUsedTime(uint hours)
{
    beginGroup(SystemConfigGroup);
    setValue("UsedTime", hours);
    endGroup();
}

inline uint ICAppSettings::TotalUsedTime()
{
    beginGroup(SessionGroup);
    uint ret = value("TotalUsedTime", 0).toUInt();
    endGroup();
    return ret;
}

inline void ICAppSettings::SetTotalUsedTime(uint hours)
{
    beginGroup(SessionGroup);
    setValue("TotalUsedTime", hours);
    endGroup();
}

inline void ICAppSettings::IncreaseTotalUsedTime()
{
    SetTotalUsedTime(TotalUsedTime() + 1);
}

inline QString ICAppSettings::MachineCode()
{
    beginGroup(SessionGroup);
    QString ret = value("MachineCode", "").toString();
    endGroup();
    return ret;
}

inline void ICAppSettings::SetMachineCode(const QString &machineCode)
{
    beginGroup(SessionGroup);
    setValue("MachineCode", machineCode);
    endGroup();
}

inline QString ICAppSettings::FactoryCode()
{
    beginGroup(SessionGroup);
    QString ret = value("FactoryCode", "123456").toString();
    endGroup();
    return ret;
}

inline void ICAppSettings::SetFactoryCode(const QString &code)
{
    beginGroup(SessionGroup);
    setValue("FactoryCode", code);
    endGroup();
}

inline QString ICAppSettings::ManufacturingNo()
{
    beginGroup(SessionGroup);
    QString ret = value("ManufacturingNo", "").toString();
    endGroup();
    return ret;
}

inline void ICAppSettings::SetManufacturingNo(const QString &code)
{
    beginGroup(SessionGroup);
    setValue("ManufacturingNo", code);
    endGroup();
}

inline QString ICAppSettings::ManufacturingDate()
{
    beginGroup(SessionGroup);
    QString ret = value("ManufacturingDate", "").toString();
    endGroup();
    return ret;
}

inline void ICAppSettings::SetManufacturingDate(const QString &code)
{
    beginGroup(SessionGroup);
    setValue("ManufacturingDate", code);
    endGroup();
}

inline bool ICAppSettings::KeyTone()
{
    beginGroup(SessionGroup);
    bool ret = value("KeyTone", true).toBool();
    endGroup();
    return ret;
}

inline void ICAppSettings::SetKeyTone(bool isOn)
{
    beginGroup(SessionGroup);
    setValue("KeyTone", isOn);
    endGroup();
#ifndef Q_WS_WIN32
    int beepFD = open("/dev/szhc_beep", O_WRONLY);
    ioctl(beepFD, 0, isOn ? 20 : 10);
    close(beepFD);
#endif

}

inline void ICAppSettings::SetUIMainName(const QString &mainName)
{
    beginGroup(SessionGroup);
    setValue("UIMainName", mainName);
    endGroup();
}

inline QString ICAppSettings::UIMainName()
{
    beginGroup(SessionGroup);
    QString ret = value("UIMainName", "").toString();
    endGroup();
    return ret;
}

inline void ICAppSettings::SetTranslatorName(const QString& trName)
{
    beginGroup(SessionGroup);
    setValue("TranslatorName", trName);
    endGroup();
}

inline QString ICAppSettings::TranslatorName()
{
    beginGroup(SessionGroup);
    QString ret = value("TranslatorName", "").toString();
    endGroup();
    return ret;
}


#endif // ICAPPSETTINGS_H
