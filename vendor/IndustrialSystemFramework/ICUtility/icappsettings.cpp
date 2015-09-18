#include "icappsettings.h"
#include <QDir>


const char* ICAppSettings::SystemConfigGroup = "SystemConfig";
const char* ICAppSettings::SessionGroup = "Session";
const char* ICAppSettings::LocaleGroup = "Locale";
#ifndef Q_WS_QWS
const char* ICAppSettings::UsbPath = "fakeUSB";
#else
const char* ICAppSettings::UsbPath = "/mnt/udisk";
#endif
#ifdef Q_WS_X11
const char* ICAppSettings::QMLPath("../qml");
#else
const char* ICAppSettings::QMLPath("qml");
#endif
QTime ICAppSettings::startupTime_;
ICAppSettings::ICAppSettings():
    QSettings("sysconfig/PanelRobot.ini",QSettings::IniFormat)
{
}
