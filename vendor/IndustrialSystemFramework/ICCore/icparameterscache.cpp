#include "icparameterscache.h"

//QHash<uint, quint32> ICParametersCache::configsCache_;
//QHash<uint, QVariant> ICParametersCache::localStatusCache_;
//QHash<uint, quint32> ICParametersCache::specialValueConfigsCache_;
//QList<AddrValueChangeHandler> ICParametersCache::observes_;
ICParametersCache::ICParametersCache()
{
}


void ICParametersCache::SyncConfigsAddrValueCache()
{
    return;
//     QVector<QPair<quint32, quint32> > tmp = ICDALHelper::GetAllMoldConfig(ICAppSettings().CurrentMoldConfig()) +
//            ICDALHelper::GetAllSystemConfig(ICAppSettings().CurrentSystemConfig());
//    for(int i = 0; i != tmp.size(); ++i)
//    {
//        configsCache_.insert(tmp.at(i).first, tmp.at(i).second);
//    }
}

bool ICParametersCache::IsSpecialConfig(uint addr, quint32 value) const
{
    if(!specialValueConfigsCache_.contains(addr))
    {
        return false;
    }
    return specialValueConfigsCache_.value(addr) == value;
}

void ICParametersCache::UpdateConfigValue(uint addr, quint32 value)
{
     configsCache_.insert(addr, value);
     for(int i = 0; i != observes_.size(); ++i)
     {
         observes_.at(i)(addr, value);
     }
     SetLocalStatus(kIsConfigsModified, true);
}

void ICParametersCache::UpdateConfigValue(ICAddrWrapperCPTR addr, quint32 value)
{
    quint32 v = OriginConfigValue(addr);
    ICAddrWrapper::UpdateBaseAddrValue(addr, value, &v);
    configsCache_.insert(addr->BaseAddr(), v);
    for(int i = 0; i != observes_.size(); ++i)
    {
        observes_.at(i)(addr->BaseAddr(), value);
    }
    SetLocalStatus(kIsConfigsModified, true);
}

QVector<quint32> ICParametersCache::SequenceDataList() const
{
    QList<uint> keys = configsCache_.keys();
    qSort(keys);
    QVector<quint32> ret;
    for(int i = 0; i != keys.size(); ++i)
    {
        ret.append(configsCache_.value(keys.at(i)));
    }
    return ret;
}
