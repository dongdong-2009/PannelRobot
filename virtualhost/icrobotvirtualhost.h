#ifndef ICROBOTVIRTUALHOST_H
#define ICROBOTVIRTUALHOST_H

#include "icvirtualhost.h"
#include <qmath.h>
#include "icrobottransceiverdata.h"
#include "icparameterscache.h"
#include "icconfigsaddr.h"

class ICRobotVirtualhost : public ICVirtualHost
{
    Q_OBJECT
public:
    enum ICStatus
    {
        Status,
        Step,
        Sub0,
        Sub1,
        Sub2,
        Sub3,
        ActL,
        ActH,
        ClipL,
        ClipH,
        Time,
        X1Pos,
        Y1Pos,
        ZPos,
        X2Pos,
        Y2Pos,
        APos,
        BPos,
        CPos,
        S,
        Input0,
        Input1,
        Output0,
        Output1,
        EuIn,
        EuOut,
        ErrCode,
        DbgX0,
        DbgX1,
        DbgY0,
        DbgY1,
        DbgZ0,
        DbgZ1,
        DbgP0,
        DbgP1,
        DbgQ0,
        DbgQ1,
        DbgA0,
        DbgA1,
        DbgB0,
        DbgB1,
        DbgC0,
        DbgC1,
        AxisLastPos1,
        AxisLastPos2,

        StatusCount
    };
    explicit ICRobotVirtualhost(uint64_t hostId, QObject* parent = 0);
    static ICVirtualHostPtr RobotVirtualHost()
    {
       return ICVirtualHostManager::GetVirtualHost<ICRobotVirtualhost>(1);
    }

    virtual QByteArray HostStatus(const ICAddrWrapper* addr) const
    {
        int v = statusCache_.ConfigValue(addr);
        return QByteArray::number(v / qPow(10, addr->Decimal()), 'f', addr->Decimal());
    }
    virtual quint32 HostStatusValue(const ICAddrWrapper* addr) const
    {
        return statusCache_.ConfigValue(addr);
    }

protected:
    void InitStatusFormatorMap_(){}
    void InitStatusMap_();
    bool InitConfigsImpl(const QVector<QPair<quint32, quint32> >& configList, int startAddr);
    bool IsInputOnImpl(int index) const;
    bool IsOutputOnImpl(int index) const;
    void CommunicateImpl();
    QBitArray AlarmsImpl() const { return QBitArray();}

public:
    static bool InitMold(ICVirtualHostPtr hostPtr, const QVector<quint32>& data);
    static bool InitMoldFnc(ICVirtualHostPtr hostPtr, const QVector<quint32>& data);
    static bool InitMoldSub(ICVirtualHostPtr hostPtr, const QVector<QVector<quint32> >& data);
    static bool InitMachineConfig(ICVirtualHostPtr hostPtr, const QVector<quint32>& data);

signals:
    void CommunicateError(int errorCode);
    void NeedToInitHost();

public slots:

private:
    void AddRefreshStatusCommand_();
    int currentStatusGroup_;
    QVector<quint32> statusDataTmp_;
    int startIndex_;

private:
    bool recvRet_;
    ICRobotTransceiverData* recvFrame_;
    ICFrameTransceiverDataMapper* frameTransceiverDataMapper_;
//    QBitArray alarmBits_;
//    static ICAddr beginAddrs_;
//    static uint length_;
//    static bool restartFlag_;
//    QMap<int, quint32> statusValueMap_;
////    QMap<ICAddr, HostStatusFormator> statusFormatorMap_;
    ICParametersCache statusCache_;
    const static int kHostID = 1;
//    int conjectionCommErrCount_;

};

#endif // ICROBOTVIRTUALHOST_H
