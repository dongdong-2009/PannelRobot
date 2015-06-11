#ifndef PANELROBOTCONTROLLER_H
#define PANELROBOTCONTROLLER_H

#include <QObject>
#include "icrobotvirtualhost.h"


class PanelRobotController : public QObject
{
    Q_OBJECT
public:
    explicit PanelRobotController(QObject *parent = 0);
    void Init();

signals:

public slots:

    Q_INVOKABLE bool isInputOn(int index) const { return host_->IsInputOn(index);}
    Q_INVOKABLE bool isOutputOn(int index) const { return host_->IsOutputOn(index);}

    void OnNeedToInitHost();

private:
    void InitDatabase_();
    void InitMold_();
    void InitMachineConfig_();
    ICVirtualHostPtr host_;


};

#endif // PANELROBOTCONTROLLER_H
