#ifndef PANELROBOTCONTROLLER_H
#define PANELROBOTCONTROLLER_H

#include <QObject>
#include "icrobotmold.h"
#include "icrobotvirtualhost.h"
#include <QtDeclarative>
#include <QScriptEngine>
#include <QSharedPointer>
#include "icdatatype.h"
#include "icparameterscache.h"


extern ICRange ICRobotRangeGetter(const QString& addrName);

typedef union{
struct {
    unsigned    s1 : 2;
    unsigned    s2 : 2;
    unsigned    s3  : 2;
    unsigned    s4 : 2;
    unsigned    s5 : 2;
    unsigned    s6  : 2;
    unsigned    s7  : 2;
    unsigned    s8  : 2;
    unsigned    rev: 16;
}b;
quint32 a;
}AxisDefineData;

class ICAxisDefine:public QObject
{
    Q_OBJECT
    Q_ENUMS(AxisName)
    Q_ENUMS(AxisType)
    Q_PROPERTY(AxisType s1Axis READ s1Axis WRITE setS1Axis NOTIFY s1AxisChanged)
    Q_PROPERTY(AxisType s2Axis READ s2Axis WRITE setS2Axis NOTIFY s2AxisChanged)
    Q_PROPERTY(AxisType s3Axis READ s3Axis WRITE setS3Axis NOTIFY s3AxisChanged)
    Q_PROPERTY(AxisType s4Axis READ s4Axis WRITE setS4Axis NOTIFY s4AxisChanged)
    Q_PROPERTY(AxisType s5Axis READ s5Axis WRITE setS5Axis NOTIFY s5AxisChanged)
    Q_PROPERTY(AxisType s6Axis READ s6Axis WRITE setS6Axis NOTIFY s6AxisChanged)
    Q_PROPERTY(AxisType s7Axis READ s7Axis WRITE setS7Axis NOTIFY s7AxisChanged)
    Q_PROPERTY(AxisType s8Axis READ s8Axis WRITE setS8Axis NOTIFY s8AxisChanged)

signals:
    void s1AxisChanged(int);
    void s2AxisChanged(int);
    void s3AxisChanged(int);
    void s4AxisChanged(int);
    void s5AxisChanged(int);
    void s6AxisChanged(int);
    void s7AxisChanged(int);
    void s8AxisChanged(int);
public:
    ICAxisDefine(){}
    enum AxisName
    {
        S1Axis,
        S2Axis,
        S3Axis,
        S4Axis,
        S5Axis,
        S6Axis,
        S7Axis,
        S8Axis
    };
    enum AxisType
    {
        NoUse,
        Servo,
        Pneumatic,
        Reserve
    };

    AxisType s1Axis() const{ return static_cast<AxisType>(data_.b.s1);}
    void setS1Axis(AxisType type) { data_.b.s1 = type;}
    AxisType s2Axis() const{ return static_cast<AxisType>(data_.b.s2);}
    void setS2Axis(AxisType type) { data_.b.s2 = type;}
    AxisType s3Axis() const{ return static_cast<AxisType>(data_.b.s3);}
    void setS3Axis(AxisType type) { data_.b.s3 = type;}
    AxisType s4Axis() const{ return static_cast<AxisType>(data_.b.s4);}
    void setS4Axis(AxisType type) { data_.b.s4 = type;}
    AxisType s5Axis() const{ return static_cast<AxisType>(data_.b.s5);}
    void setS5Axis(AxisType type) { data_.b.s5 = type;}
    AxisType s6Axis() const{ return static_cast<AxisType>(data_.b.s6);}
    void setS6Axis(AxisType type) { data_.b.s6 = type;}
    AxisType s7Axis() const{ return static_cast<AxisType>(data_.b.s7);}
    void setS7Axis(AxisType type) { data_.b.s7 = type;}
    AxisType s8Axis() const{ return static_cast<AxisType>(data_.b.s8);}
    void setS8Axis(AxisType type) { data_.b.s8 = type;}

    int getAxisDefine(int which)
    {
        return (data_.a >> (which << 1)) & 3;
    }
    void setAxisDefine(int which, int mode)
    {
        data_.a &= ~(3 << (which << 1));
        data_.a |= (mode << (which << 1));
    }

private:
    AxisDefineData data_;
};

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
    Q_INVOKABLE QString records();
    Q_INVOKABLE ICAxisDefine* axisDefine();
    Q_INVOKABLE QString newRecord(const QString& name, const QString& initProgram)
    {
        return ICRobotMold::NewRecord(name, initProgram, baseFncs_).toJSON();
    }
    Q_INVOKABLE bool deleteRecord(const QString& name)
    {
        return ICRobotMold::DeleteRecord(name);
    }
    Q_INVOKABLE bool loadRecord(const QString& name)
    {
        ICRobotMoldPTR mold = ICRobotMold::CurrentMold();
        bool ret =  mold->LoadMold(name);
        if(ret) emit moldChanged();
        return ret;
    }

    Q_INVOKABLE int saveMainProgram(const QString& program)
    {
        return ICRobotMold::CurrentMold()->SaveMold(ICRobotMold::kMainProg, program);
    }

    Q_INVOKABLE int saveSubProgram(int which, const QString& program)
    {
        if(which < ICRobotMold::kSub1Prog ||
                which > ICRobotMold::kSub8Prog)
            return -1;
        return ICRobotMold::CurrentMold()->SaveMold(which, program);
    }

    Q_INVOKABLE QString mainProgram() const
    {
        return ICRobotMold::CurrentMold()->MainProgram();
    }

    Q_INVOKABLE QString subProgram(int which) const
    {
        if(which < ICRobotMold::kSub1Prog ||
                which > ICRobotMold::kSub8Prog)
            return QString();
        return ICRobotMold::CurrentMold()->SubProgram(which);
    }
    Q_INVOKABLE QString usbDirs();
    Q_INVOKABLE QString localUIDirs();
    Q_INVOKABLE void setToRunningUIPath(const QString& dirname);
    Q_INVOKABLE bool changeTranslator(const QString& translatorName);


signals:
//    void currentMoldChanged(QString);
//    void currentMachineConfigChanged(QString);
    void moldChanged();
public slots:
    void OnNeedToInitHost();
    void OnConfigRebase(QString);

private:
    void InitDatabase_();
    void InitMold_();
    void InitMachineConfig_();
    bool LoadTranslator_(const QString& name);
    void SaveTranslatorName_(const QString& name);

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
    ICAxisDefine *axisDefine_;
    QList<QPair<int, quint32> > baseFncs_;
    QScriptEngine engine_;
    QScriptValue configRangeGetter_;
    QTranslator translator;
};

#endif // PANELROBOTCONTROLLER_H
