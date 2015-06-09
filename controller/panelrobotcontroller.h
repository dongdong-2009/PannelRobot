#ifndef PANELROBOTCONTROLLER_H
#define PANELROBOTCONTROLLER_H

#include <QObject>

class PanelRobotController : public QObject
{
    Q_OBJECT
public:
    explicit PanelRobotController(QObject *parent = 0);
    void Init();

signals:

public slots:

private:
    void InitDatabase_();
    void InitMold_();

};

#endif // PANELROBOTCONTROLLER_H
