#ifndef PANELROBOTCONTROLLER_H
#define PANELROBOTCONTROLLER_H

#include <QObject>
#include "icrobotmold.h"
#include "icrobotvirtualhost.h"

class PanelRobotController : public QObject
{
    Q_OBJECT
public:
    explicit PanelRobotController(QObject *parent = 0);
    ~PanelRobotController();
    void Init();

    Q_INVOKABLE bool isInputOn(int index) const { return host_->IsInputOn(index);}
    Q_INVOKABLE bool isOutputOn(int index) const { return host_->IsOutputOn(index);}
    Q_INVOKABLE void sendKeyCommandToHost(int key);
    Q_INVOKABLE quint32 getConfigValue(const QString& addr);
    Q_INVOKABLE void setConfigValue(const QString& addr, const QString& v);
    Q_INVOKABLE void syncConfigs();
    Q_INVOKABLE QList<QObject*> records();

signals:

public slots:
    void OnNeedToInitHost();

private:
    void InitDatabase_();
    void InitMold_();
    void InitMachineConfig_();

    quint32 AddrStrValueToInt(ICAddrWrapperCPTR addr, const QString& value)
    {
        double v = value.toDouble();
        v *= qPow(10, addr->Decimal());
        return v;
    }

    ICVirtualHostPtr host_;
    bool isMoldFncsChanged_;
    bool isMachineConfigsChanged_;
    ICAddrWrapperValuePairList moldFncModifyCache_;
    ICAddrWrapperValuePairList machineConfigModifyCache_;
    QList<QObject*> recordDatas_;

};

#endif // PANELROBOTCONTROLLER_H
