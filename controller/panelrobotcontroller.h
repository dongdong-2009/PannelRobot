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

    void OnNeedToInitHost();

private:
    void InitDatabase_();
    void InitMold_();
    void InitMachineConfig_();
    ICVirtualHostPtr host_;


};

#endif // PANELROBOTCONTROLLER_H
