#include "ickeyboardplugin.h"
#include "ickeyboardhandler.h"

#include <QDebug>


ICKeyboardPlugin::ICKeyboardPlugin(QObject *parent) :
    QKbdDriverPlugin(parent)
{
}

QWSKeyboardHandler* ICKeyboardPlugin::create(const QString &driverName, const QString &deviceName)
{
    qDebug()<<"Create"<<driverName<<deviceName;
    if(driverName.toLower() == QString("ICKeyboardPlugin").toLower())
        return new ICKeyboardHandler(deviceName);
    else
        return NULL;
}

QStringList ICKeyboardPlugin::keys() const
{
    return QStringList()<<"ICKeyboardPlugin";
}

Q_EXPORT_PLUGIN2(ICKeyboardPlugin, ICKeyboardPlugin)
