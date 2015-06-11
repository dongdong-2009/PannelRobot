#ifndef ICROBOTVIRTUALHOST_H
#define ICROBOTVIRTUALHOST_H

#include "icvirtualhost.h"
#include "icrobottransceiverdata.h"

class ICRobotVirtualhost : public ICVirtualHost
{
    Q_OBJECT
public:
    explicit ICRobotVirtualhost(uint64_t hostId, QObject* parent = 0);
    static ICVirtualHostPtr RobotVirtualHost()
    {
       return ICVirtualHostManager::GetVirtualHost<ICRobotVirtualhost>(1);
    }

    virtual QByteArray HostStatus(const ICAddrWrapper* addr) const { return QByteArray();}
    virtual quint32 HostStatusValue(const ICAddrWrapper* addr) const { return 0;}

protected:
    void InitStatusFormatorMap_(){}
    void InitStatusMap_(){}
    bool InitConfigsImpl(const QVector<QPair<quint32, quint32> >& configList, int startAddr);
    bool IsInputOnImpl(int index) const { return true;}
    bool IsOutputOnImpl(int index) const { return true;}
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
    const static int kHostID = 1;
//    int conjectionCommErrCount_;

};

#endif // ICROBOTVIRTUALHOST_H
