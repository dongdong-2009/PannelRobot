#include "icupdatesystem.h"
#include <stdlib.h>
#include <errno.h>
#include <QDebug>

ICUpdateSystem::ICUpdateSystem():
    unpackCmd_("decrypt.sh")
{
    SetPacksDir("/mnt/udisk/HCUpdate");
}

QStringList ICUpdateSystem::ScanUpdatePacks() const
{
    return packPath_.entryList(QStringList()<<ScanPattern(), QDir::Files);
}

QString ICUpdateSystem::PackProfile(const QString &packName)
{
    QFile readMe(packPath_.absoluteFilePath(packName + "_README"));
    if(readMe.open(QFile::ReadOnly))
    {
        return QString::fromUtf8(readMe.readAll());
    }
    return QString();
}

bool ICUpdateSystem::StartUpdate(const QString &packName)
{
    if(packPath_.exists(packName))
    {
        QFile file(packPath_.absoluteFilePath(packName));
        QString tmpFile = QDir::temp().absoluteFilePath(packName);
        system(QString("rm " + tmpFile).toLatin1());
        if(file.copy(tmpFile))
        {
            system((unpackCmd_ + " " + tmpFile).toLatin1());
            tmpFile.chop(4);
            system(QString("cd %1 && tar -xf %2").arg(QDir::tempPath()).arg(tmpFile).toLatin1());
            tmpFile.chop(4);
            return system(QString("cd %1 && chmod +x ./UpdateSystem.sh &&./UpdateSystem.sh").arg(QDir::temp().absoluteFilePath(tmpFile)).toLatin1()) > 0;
        }
    }
    return false;
}
