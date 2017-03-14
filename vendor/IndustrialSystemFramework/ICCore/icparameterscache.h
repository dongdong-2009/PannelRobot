#ifndef ICPARAMETERSCACHE_H
#define ICPARAMETERSCACHE_H

#include <QHash>
#include <QVariant>
#include <QVector>
#include "icoptimize.h"
#include "icaddrwrapper.h"
#include "ICCore_global.h"


typedef void (*AddrValueChangeHandler) (uint addr, quint32 value);

class ICCORESHARED_EXPORT ICParametersCache
{
public:
    enum {
        kIsConfigsModified = 0,
        kIsReadAllStatus
    };
    ICParametersCache();
    void SyncConfigsAddrValueCache();
    void ClearConfigsAddrValueCache() {configsCache_.clear();}
    quint32 OriginConfigValue(const ICAddrWrapper* addr) const;
    quint32 ConfigValue(const ICAddrWrapper* addr) const;
    void UpdateConfigValue(uint addr, quint32 value);
    void UpdateConfigValue(ICAddrWrapperCPTR, quint32 value);


    QVariant LocalStatus(uint addr) const { return localStatusCache_.value(addr, 0);}
    void SetLocalStatus(uint addr, QVariant value) { localStatusCache_.insert(addr, value);}
    void AddSpecialConfig(uint addr, quint32 value) { specialValueConfigsCache_.insert(addr, value);}
    bool IsSpecialConfig(uint addr, quint32 value) const;

    void AttachAddrValueChangeHandler(AddrValueChangeHandler handler) { observes_.append(handler);}
    void RemoveAddrValueChangeHandler(AddrValueChangeHandler handler) { observes_.removeOne(handler);}

    QVector<quint32> SequenceDataList() const;

    QList<QPair<int, quint32> > ToPairList(const QList<int>& addrs) const
    {
        QHash<uint, quint32>::const_iterator p = configsCache_.begin();
        QList<QPair<int, quint32> > ret;
        while(p != configsCache_.end())
        {
            if(addrs.contains(p.key()))
                ret.append(qMakePair(static_cast<int>(p.key()), p.value()));
            ++p;
        }
        return ret;
    }

private:
    QHash<uint, quint32> configsCache_;
    QHash<uint, QVariant> localStatusCache_;
    QHash<uint, quint32> specialValueConfigsCache_;
    QList<AddrValueChangeHandler> observes_;
};

inline quint32 ICParametersCache::OriginConfigValue(const ICAddrWrapper *addr) const
{
    if(unlikely(addr == 0))
    {
        return 0;
    }
    uint baseAddr = addr->BaseAddr();
    if(likely(configsCache_.contains(baseAddr)))
    {
        return configsCache_.value(baseAddr);
    }
    return 0;
//    quint32 ret = ICDALHelper::GetConfigValue(addr);
//    configsCache_.insert(baseAddr, ret);
//    return ret;
}

inline quint32 ICParametersCache::ConfigValue(const ICAddrWrapper *addr) const
{
    if(unlikely(addr == NULL)) return 0;
    quint32 ret = OriginConfigValue(addr);
    return ICAddrWrapper::ExtractValueByAddr(addr, ret);

}



#endif // ICPARAMETERSCACHE_H
