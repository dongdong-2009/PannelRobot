#ifndef ICROBOTVIRTUALHOST_H
#define ICROBOTVIRTUALHOST_H

#include "icvirtualhost.h"
#include <qmath.h>
#include <QQueue>
#include <QList>
#include "icrobottransceiverdata.h"
#include "icparameterscache.h"
#include "icconfigsaddr.h"

union ValveItem{
    struct{
        quint32 id: 8;
        quint32 type: 3;
        quint32 y1Board: 3;
        quint32 y1Point: 6;
        quint32 y2Board: 3;
        quint32 y2Point: 6;
        quint32 x1Board: 3;
        quint32 x1Point: 6;
        quint32 x2Board: 3;
        quint32 x2Point: 6;
        quint32 status: 1;
        quint32 x1Dir:1;
        quint32 x2Dir:1;
        quint32 time:14;
    };
    quint32 all[2];
    QVector<quint32> toDataBuf() const
    {
        QVector<quint32> ret;
        ret<<(all[0])<<(all[1]);
        return ret;
    }
};


class ICRobotVirtualhost : public ICVirtualHost
{
    Q_OBJECT
public:
#ifndef NEW_PLAT
    enum ICActionCommand
    {
        CMD_NULL            = 0x0,      //无命令
        CMD_TurnAuto        = 0x80,     //转自动
        CMD_TurnManual      = 0x81,     //转手动
        CMD_TurnStop        = 0x82,     //转停止
        CMD_TurnTeach       = 0x83,     //转教导
        CMD_TurnZero        = 0x84,     //原点
        CMD_TurnRet         = 0x85,     //复归
        CMD_TurntchSub0     = 0x90,     //转教导巨集0
        CMD_TurntchSub1     = 0x91,     //转教导巨集1
        CMD_TurntchSub2     = 0x92,     //转教导巨集2
        CMD_TurntchSub3     = 0x93,     //转教导巨集3
        CMD_TurntchSub4     = 0x94,     //转教导巨集4
        CMD_TurntchSub5     = 0x95,     //转教导巨集5
        CMD_TurntchSub6     = 0x96,     //转教导巨集6
        CMD_TurntchSub7     = 0x97,     //转教导巨集7
        CMD_TurntchSub8     = 0x98,     //转教导

        CMD_Action          = 0x40,     //动作类

        CMD_TestDone        = 0x20,     //测试结束
        CMD_TestX           = 0x21,     //测试X轴脉冲
        CMD_TestY           = 0x22,     //测试Y轴脉冲
        CMD_TestZ           = 0x23,     //测试Z轴脉冲
        CMD_TestxRev        = 0x2c,     //测试X轴反向
        CMD_TestzRev        = 0x2d,     //测试Z轴反向
        CMD_TestyRev        = 0x2e,
        CMD_TestClr         = 0x24,     //清测试脉冲

        CMD_X1SubLmt        = 0x25,
        CMD_X1AddLmt        = 0x26,
        CMD_Y1SubLmt        = 0x27,
        CMD_Y1AddLmt        = 0x28,
        CMD_ZSubLmt         = 0x29,
        CMD_ZAddLmt         = 0x2a,

        CMD_TuneMold        = 0x30,
        CMD_GoOn            = 0x31,
        CMD_GiveUp          = 0x32,

        CMD_X2SubLmt        = 0x35,
        CMD_X2AddLmt        = 0x36,
        CMD_Y2SubLmt        = 0x37,
        CMD_Y2AddLmt        = 0x38,

        CMD_TestX2          = 0x39,     //测试X轴脉冲
        CMD_TestY2          = 0x3a,     //测试Y轴脉冲
        CMD_TestZ2          = 0x3b,     //测试Z轴脉冲
        CMD_TestX2Rev       = 0x3c,     //测试X轴反向
        CMD_TestY2Rev       = 0x3d,     //测试Z轴反向
        CMD_TestZ2Rev       = 0x3e,

        CMD_TestA           = 0x50,     //测试X轴脉冲
        CMD_TestB           = 0x51,     //测试Y轴脉冲
        CMD_TestC           = 0x52,     //测试Z轴脉冲
        CMD_TestARev        = 0x53,     //测试X轴反向
        CMD_TestBRev        = 0x54,     //测试Z轴反向
        CMD_TestCRev        = 0x55,

        CMD_PulseA          = 0x60,     //脉冲命令A
        CMD_PulseB          = 0x61,     //脉冲命令B
    };

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
#endif
    explicit ICRobotVirtualhost(uint64_t hostId, QObject* parent = 0);
    ~ ICRobotVirtualhost();

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

    static void SendConfigs(ICVirtualHostPtr hostPtr, const QList<QPair<int, quint32> >& vals);


protected:
    void InitStatusFormatorMap_(){}
    void InitStatusMap_();
    bool InitConfigsImpl(const QVector<QPair<quint32, quint32> >& configList, int startAddr);
    bool IsInputOnImpl(int index) const;
    bool IsOutputOnImpl(int index) const;
    void CommunicateImpl();
    QBitArray AlarmsImpl() const { return QBitArray();}

public:
    static bool SendMold(ICVirtualHostPtr hostPtr, const QVector<QVector<quint32> > &data);
    static bool SendMoldSub(ICVirtualHostPtr hostPtr, int which, const QVector<QVector<quint32> > &data);
    static bool SendMoldCountersDef(ICVirtualHostPtr hostPtr, const QVector<QVector<quint32> > & data);
    static bool SendMoldCounterDef(ICVirtualHostPtr hostPtr, const QVector<quint32> & data);
    static bool FixProgram(ICVirtualHostPtr hostPtr, int which, int row, int step, const QVector<quint32>& data);
    static void AddWriteConfigCommand(ICVirtualHostPtr hostPtr, int config, int value);

    static void AddReadConfigCommand(ICVirtualHostPtr hostPtr, int startAddr, int size); // max size 32

#ifdef NEW_PLAT
    static void SendKeyCommand(int cmd);
    static void ClearKeyCommandQueue(ICVirtualHostPtr hostPtr) {keyCommandList_.clear();hostPtr->ClearCommunicationQueue();}
    static bool InitMachineConfig(ICVirtualHostPtr hostPtr, const QList<QPair<int, quint32> >& vp);
    static bool InitMoldFnc(ICVirtualHostPtr hostPtr, const QList<QPair<int, quint32> >& vp);
//    static void AddReadHostConfigsCommand(ICVirtualHostPtr hostPtr);

#else
    static bool InitMoldSub(ICVirtualHostPtr hostPtr, const QVector<QVector<quint32> >& data);
    static bool InitMachineConfig(ICVirtualHostPtr hostPtr, const QVector<quint32>& data);
    static bool InitMoldFnc(ICVirtualHostPtr hostPtr, const QVector<quint32>& data);
    static void SendKeyCommand(int key, int cmd = CMD_Action , int act = 0, int sum = 0);
#endif
    static quint32 IStatus(int boardID) { return iStatusMap_.value(boardID, 0);}
    static quint32 OStatus(int boardID) { return oStatusMap_.value(boardID, 0);}
    static void SendYControlCommand(ICVirtualHostPtr hostPtr , ValveItem item);
    static void InitValveDefines(ICVirtualHostPtr hostPtr, const QList<ValveItem>& valveDefines);
    static void SendValveItemToHost(ICVirtualHostPtr hostPtr, ValveItem item);
    static QString HostVersion() { return hostVersion_;}
    static void LogTestPoint(ICVirtualHostPtr hostPtr, int type, QList<quint32> axisData);
    static quint32 MultiplexingConfig(int addr) { return multiplexingConfigs_.value(addr);}
signals:
    void CommunicateError(int errorCode);
    void NeedToInitHost();
    void QueryFinished(int addr, const QVector<quint32>& v);

public slots:

private:
#ifdef NEW_PLAT
    static bool InitConfigHelper(ICVirtualHostPtr hostPtr, const QList<QPair<int, quint32> > &vp);
#endif
    static void SendContinuousDataHelper(ICVirtualHostPtr hostPtr, int startAddr, const QVector<quint32> &data);
    void AddRefreshStatusCommand_();
    int currentStatusGroup_;
    int currentStatusGroupLength_;
    int statusGroupCount_;
    QVector<quint32> statusDataTmp_;
    int startIndex_;
    static QMap<int, quint32> iStatusMap_;
    static QMap<int, quint32> oStatusMap_;
    static QMap<int, quint32> multiplexingConfigs_;
    static QQueue<ICRobotTransceiverData*> keyCommandList_;
    static QString hostVersion_;

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
