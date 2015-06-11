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
