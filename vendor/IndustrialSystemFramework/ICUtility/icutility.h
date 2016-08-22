#ifndef ICUTILITY_H
#define ICUTILITY_H

#include <QString>
#include <stdint.h>
#include <QDir>
#include <qmath.h>
#include "ICUtility_global.h"

class ICUTILITYSHARED_EXPORT ICUtility {
public:
	/**
	 * 屏保图片路径
	 */
    static const QString ScreenSaverImgPath;
	/**
	 * 屏保进程副本锁文件路径
	 */
    static const QString ScreenSaverInstanceLockFile;
	static bool LockFile(int fd);
	static bool LockFile(const QString& file);
    static uint16_t CRC16(const uint8_t* buffer, size_t size);
    static uint CountOneInNumber(uint x);
    static int readn(int fd, uint8_t* ptr, size_t n);
    static int writen(int fd, const uint8_t* ptr, size_t n);
    static int Register(const QString& code, const QString& machineCode);
    static bool IsUsbAttached();
    static int ConvertFontPointSizeToEmbedded(int desktopPointSize);
    const static int RefreshTime = 20;
    static int doubleToInt(double v, int decimal)
    {
        double toAdd = (v < 0 ? -1 : 1) * 5  / qPow(10, decimal + 1);
        return (v + toAdd) * qPow(10, decimal);
    }
    static bool DeleteDirectory(const QString &path)
    {
        if (path.isEmpty())
            return false;

        QDir dir(path);
        if(!dir.exists())
            return true;

        dir.setFilter(QDir::AllEntries | QDir::NoDotAndDotDot);
        QFileInfoList fileList = dir.entryInfoList();
        foreach (QFileInfo fi, fileList)
        {
            if (fi.isFile())
                fi.dir().remove(fi.fileName());
            else
                DeleteDirectory(fi.absoluteFilePath());
        }
        return dir.rmpath(dir.absolutePath());
    }

private:
    static uint8_t crcTableLo_[256];
    static uint8_t crcTableHi_[256];

    ICUtility();
};

inline uint ICUtility::CountOneInNumber(uint x)
{
    const uint MASK1 = 0x55555555;
    const uint MASK2 = 0x33333333;
    const uint MASK4 = 0x0F0F0F0F;
    const uint MASK8 = 0x00FF00FF;
    const uint MASK16 = 0x0000FFFF;

    x = (x & MASK1) + (x >> 1 & MASK1);
    x = (x & MASK2) + (x >> 2 & MASK2);
    x = (x & MASK4) + (x >> 4 & MASK4);
    x = (x & MASK8) + (x >> 8 & MASK8);
    x = (x & MASK16) + (x >> 16 & MASK16);
    return x;
}

inline bool ICUtility::IsUsbAttached()
{
#ifdef Q_WS_QWS
    QDir dir("/proc/scsi/usb-storage");
    return !(dir.entryList(QDir::Files).isEmpty());
#else
    return QDir::current().exists("./fakeUSB");
#endif
}

inline int ICUtility::ConvertFontPointSizeToEmbedded(int desktopPointSize)
{
    return desktopPointSize << 2 / 3;
}

#endif // ICUTILITY_H
