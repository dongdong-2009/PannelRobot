#ifndef ICMACHINECONFIG_H
#define ICMACHINECONFIG_H

#include <QSharedPointer>
#include "icparameterscache.h"

class ICMachineConfig;

typedef QSharedPointer<ICMachineConfig> ICMachineConfigPTR;

class ICMachineConfig
{
public:
    ICMachineConfig();
    static ICMachineConfigPTR CurrentMachineConfig()
    {
        return current_;
    }
    static void setCurrentMachineConfig(ICMachineConfig* mold)
    {
        current_ = ICMachineConfigPTR(mold);
    }

    bool LoadMachineConfig(const QString& name);

    QVector<quint32> MachineConfigsBuffer() const
    {
        return configCache_.SequenceDataList();
    }

    quint32 MachineConfig(ICAddrWrapperCPTR addr)
    {
        return configCache_.ConfigValue(addr);
    }

    QList<QPair<int, quint32> > SetMachineConfigs(const ICAddrWrapperValuePairList values);

    QList<QPair<int, quint32> > BareMachineConfigs() const;

    void SetBareMachineConfigs(const QList<QPair<int, quint32> >& configValPairs);
private:
    static ICMachineConfigPTR current_;
    QString configName_;
    ICParametersCache configCache_;
};

#endif // ICMACHINECONFIG_H
