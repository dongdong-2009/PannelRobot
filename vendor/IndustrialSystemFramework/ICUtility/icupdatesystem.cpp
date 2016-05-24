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
         QDir tmpDir = QDir::temp();
         QString tmpFile = tmpDir.absoluteFilePath(packName);
         system(QString("rm " + tmpFile).toAscii());
         if(file.copy(tmpFile))
         {
             system((unpackCmd_ + " " + tmpFile).toAscii());
             QStringList tars = tmpDir.entryList(QStringList()<<"*.tar");
             if(tars.isEmpty()) return false;
             tmpFile = tmpDir.absoluteFilePath(tars.at(0));
             system(QString("rm -r %1/HCUpdateTmp").arg(QDir::tempPath()).toLatin1());
             system(QString("mkdir -p %1/HCUpdateTmp && cd %1 && tar -xf %2 -C %1/HCUpdateTmp").arg(QDir::tempPath()).arg(tmpFile).toLatin1());
             tmpDir.cd("HCUpdateTmp");
             QStringList tarDirs = tmpDir.entryList(QStringList()<<"HC*");
             if(tarDirs.isEmpty()) return false;
             tmpDir.cdUp();
             tmpFile = tmpDir.absoluteFilePath("HCUpdateTmp/" + tarDirs.at(0));
             system(QString("chmod 777 %1/ -R").arg(tmpFile).toLatin1());
             system(QString("cd %1 && ./UpdateSystem.sh").arg(tmpFile).toLatin1());
             system(QString("rm %1/*.tar").arg(QDir::tempPath()).toLatin1());
             return true;
         }
     }
     return false;

}
