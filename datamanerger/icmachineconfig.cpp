#include "icmachineconfig.h"
#include "icdalhelper.h"

ICMachineConfigPTR ICMachineConfig::current_;
ICMachineConfig::ICMachineConfig()
{
}

bool ICMachineConfig::LoadMachineConfig(const QString &name)
{
    configName_ = name;
    QVector<QPair<quint32, quint32> > configs = ICDALHelper::GetAllSystemConfig(name);
    for(int i = 0; i != configs.size(); ++i)
    {
        configCache_.UpdateConfigValue(configs.at(i).first, configs.at(i).second);
    }
    return true;
}

void ICMachineConfig::SetMachineConfigs(const ICAddrWrapperValuePairList values)
{
    QList<QPair<int, quint32> >baseValues;
    ICAddrWrapperValuePair tmp;
    for(int i = 0; i != values.size(); ++i)
    {
        tmp = values.at(i);
        configCache_.UpdateConfigValue(tmp.first, tmp.second);

        baseValues.append(qMakePair(tmp.first->BaseAddr(), configCache_.OriginConfigValue(tmp.first)));
    }
    ICDALHelper::UpdateMachineConfigValues(baseValues, configName_);
}
