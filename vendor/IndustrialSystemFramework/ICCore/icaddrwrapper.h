#ifndef ICADDR_H
#define ICADDR_H

#include <QtGlobal>
#include <QStringList>
#include <QMap>
#include <QPair>
#include <QDebug>
#include "ICCore_global.h"

class ICCORESHARED_EXPORT ICAddrWrapper
{
public:
    enum ICAddrType
    {
        kICAddrTypeNoUse,//<预留
        kICAddrTypeCrafts,//<状态
        kICAddrTypeMold,//<模号
        kICAddrTypeSystem,//<系统
        kICAddrTypeBadAddr//<错误
    };

    enum ICAddrPermission
    {
        kICAddrPermissionNone,//<无
        kICAddrPermissionReadOnly,//<只读
        kICAddrPermissionWriteOnly,//<只写
        kICAddrPermissionRW //<可读可写
    };

    ICAddrWrapper();
    ICAddrWrapper(int type, int perm, int startPos, int size, int baseAddr, int decimal=0, const QString &unit = QString());

    ICAddrType AddrType() const { return static_cast<ICAddrType>(addr_.addrType);}
    ICAddrPermission AddrPermission() const { return static_cast<ICAddrPermission>(addr_.perm);}
    int StartPos() const { return addr_.startPos;}
    int Size() const { return addr_.size;}
    int BaseAddr() const { return addr_.baseAddr;}
    int Decimal() const { return addr_.decimal;}
    QString Unit() const { return unit_;}

    QString ToString() const;

    static void UpdateBaseAddrValue(const ICAddrWrapper* addr, uint value, uint *baseValue)
    {
        int sp = addr->StartPos();
        *baseValue &= ~(((quint64(2) << (addr->Size() - 1)) - 1) << sp);
        *baseValue |= value << sp;
    }

    static quint32 UpdateBaseAddrValue(const ICAddrWrapper *addr, uint value, uint baseValue)
    {
        int sp = addr->StartPos();
        baseValue &= ~(((quint64(2) << (addr->Size() - 1)) - 1) << sp);
        baseValue |= value << sp;
        return baseValue;
    }

    static quint32 ExtractValueByAddr(const ICAddrWrapper* addr, uint baseValue)
    {
        baseValue = baseValue >> addr->StartPos();
//        quint32 mask = ((quint64(2) << (addr->Size() - 1)) - 1);
        baseValue &= ((quint64(2) << (addr->Size() - 1)) - 1);
//        baseValue &= mask;
        return baseValue;
    }

    static const ICAddrWrapper* AddrStringToAddr(const QString& str)
    {
#ifdef Q_OS_WIN
        return addrStringToAddrMap_->value(str, NULL);
#else
        if(!addrStringToAddrMap_.contains(str))
        {
            QStringList items = str.split("_");
            if(items.size() != 6) return NULL;
            int type = kICAddrTypeNoUse;
            if(items.at(0) == "c")
                type = kICAddrTypeCrafts;
            else if(items.at(0) == "m")
                type = kICAddrTypeMold;
            else if(items.at(0) == "s")
                type = kICAddrTypeSystem;
            int perm = kICAddrPermissionNone;
            if(items.at(1) == "ro")
                perm = kICAddrPermissionReadOnly;
            else if(items.at(1) == "rw")
                perm = kICAddrPermissionRW;
            ICAddrWrapper* wrapper = new ICAddrWrapper(type, perm, items.at(2).toInt(),
                                                       items.at(3).toInt(),items.at(5).toInt(),
                                                       items.at(4).toInt());
            addrStringToAddrMap_.insert(str, wrapper);
        }
        return addrStringToAddrMap_.value(str, NULL);
#endif
    }

    static QList<const ICAddrWrapper*> MoldAddrs()
    {
#ifdef Q_OS_WIN
        return *moldAddrs_;
#else
        return moldAddrs_;
#endif
    }
    static QList<int> MoldComboAddrs()
    {
#ifdef Q_OS_WIN
        return *moldComboAddrs_;
#else
        return moldComboAddrs_;
#endif
    }
    static QList<int> SystemComboAddrs()
    {
#ifdef Q_OS_WIN
        return *systemComboAddrs_;
#else
        return systemComboAddrs_;
#endif
    }
private:
    typedef union{
    struct  {
        uint addrType:3;
        uint perm:2;
        uint startPos:5;
        uint size:6;
        uint baseAddr:14;
        uint decimal:2;
        };
        uint orginAddr;
    }AddrUnion;
    AddrUnion addr_;
    QString unit_;
    const static int ICADDR_BIT_WIDTH = 32;
    const static int ICADDR_TYPE_BIT_WIDTH = 3;
    const static int ICADDR_PERM_BIT_WIDTH = 2;
    const static int ICADDR_START_POS_BIT_WIDTH = 5;
    const static int ICADDR_SIZE_BIT_WIDTH = 6;
    const static int ICADDR_BASE_ADDR_BIT_WIDTH = 14;


#ifdef Q_OS_WIN
    static QMap<QString, const ICAddrWrapper*> *addrStringToAddrMap_;
    static QList<const ICAddrWrapper*> *moldAddrs_;
    static QList<const ICAddrWrapper*> *systemAddrs_;
    static QList<int> *moldComboAddrs_;
    static QList<int> *systemComboAddrs_;
    static QList<const ICAddrWrapper*> *statusAddrs_;
#else
    static QStringList typeStringList_;
    static QStringList permissionStringList_;
    static QMap<QString, const ICAddrWrapper*> addrStringToAddrMap_;
    static QList<const ICAddrWrapper*> moldAddrs_;
    static QList<int> moldComboAddrs_;
    static QList<int> systemComboAddrs_;
    static QList<const ICAddrWrapper*> systemAddrs_;
    static QList<const ICAddrWrapper*> statusAddrs_;
#endif


};

typedef const ICAddrWrapper* ICAddrWrapperCPTR ;
typedef QList<const ICAddrWrapper*> ICAddrWrapperList;
typedef QMap<QString, const ICAddrWrapper*> ICAddrWrapperMapper;
typedef QPair<ICAddrWrapperCPTR, quint32> ICAddrWrapperValuePair;
typedef QList<ICAddrWrapperValuePair> ICAddrWrapperValuePairList;

#endif // ICADDR_H
