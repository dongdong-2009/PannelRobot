#include "icaddrwrapper.h"

#ifdef Q_OS_WIN
QMap<QString, const ICAddrWrapper*>* ICAddrWrapper::addrStringToAddrMap_;
QList<const ICAddrWrapper*>* ICAddrWrapper::moldAddrs_;
QList<const ICAddrWrapper*>* ICAddrWrapper::systemAddrs_;
QList<const ICAddrWrapper*>* ICAddrWrapper::statusAddrs_;
#else
QStringList ICAddrWrapper::typeStringList_(QStringList()<<"n"<<"c"<<"m"<<"s"<<"b");
QStringList ICAddrWrapper::permissionStringList_(QStringList()<<"n"<<"ro"<<"wo"<<"rw");
QMap<QString, const ICAddrWrapper*> ICAddrWrapper::addrStringToAddrMap_;
QList<const ICAddrWrapper*> ICAddrWrapper::moldAddrs_;
QList<const ICAddrWrapper*> ICAddrWrapper::systemAddrs_;
QList<const ICAddrWrapper*> ICAddrWrapper::statusAddrs_;
#endif



ICAddrWrapper::ICAddrWrapper()
{
}

ICAddrWrapper::ICAddrWrapper(int type, int perm, int startPos, int size, int baseAddr, int decimal, const QString &unit)
{
#ifdef Q_OS_WIN
    if(addrStringToAddrMap_ == NULL)
    {
        addrStringToAddrMap_ = new QMap<QString, const ICAddrWrapper*>();
    }
    if(moldAddrs_ == NULL)
    {
        moldAddrs_ = new QList<const ICAddrWrapper*>();
    }
    if(systemAddrs_ == NULL)
        systemAddrs_ = new QList<const ICAddrWrapper*>();
    if(statusAddrs_ == NULL)
        statusAddrs_ = new QList<const ICAddrWrapper*>();
#endif

    if(type < kICAddrTypeNoUse ||
            type > kICAddrTypeBadAddr ||
            perm < kICAddrPermissionNone ||
            type > kICAddrPermissionRW ||
            startPos < 0 ||
            startPos >= ICADDR_BIT_WIDTH ||
            size < 0 ||
            size > ICADDR_BIT_WIDTH) type = kICAddrTypeBadAddr;
//    addr_.orginAddr = 0;
    addr_.addrType = type;
    addr_.perm = perm;
    addr_.startPos = startPos;
    addr_.size = size;
    addr_.baseAddr = baseAddr;
    addr_.decimal = decimal;
    unit_ = unit;
#ifdef Q_OS_WIN
    addrStringToAddrMap_->insert(this->ToString(), this);
    if(type == kICAddrTypeMold)
        moldAddrs_->append(this);
    else if(type == kICAddrTypeSystem)
        systemAddrs_->append(this);
    else if(type == kICAddrTypeCrafts)
        statusAddrs_->append(this);
#else
    addrStringToAddrMap_.insert(this->ToString(), this);
    if(type == kICAddrTypeMold)
        moldAddrs_.append(this);
    else if(type == kICAddrTypeSystem)
        systemAddrs_.append(this);
    else if(type == kICAddrTypeCrafts)
        statusAddrs_.append(this);
#endif
}

QString ICAddrWrapper::ToString() const
{
#ifdef Q_OS_WIN
    const static QStringList typeStringList_(QStringList()<<"n"<<"c"<<"m"<<"s"<<"b");
    const static QStringList permissionStringList_(QStringList()<<"n"<<"ro"<<"wo"<<"rw");
#endif
    return QString("%1_%2_%3_%4_%5_%6")
            .arg(typeStringList_.at(AddrType()))
            .arg(permissionStringList_.at(AddrPermission()))
            .arg(StartPos())
            .arg(Size())
            .arg(Decimal())
            .arg(BaseAddr());
}

