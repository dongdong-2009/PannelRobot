#include "icrobotvirtualhost.h"
#include <QVector>
#include "icserialtransceiver.h"
#include "vendor/protocol/hccommparagenericdef.h"

QQueue<ICRobotTransceiverData*> ICRobotVirtualhost::keyCommandList_;

ICRobotVirtualhost::ICRobotVirtualhost(uint64_t hostId, QObject *parent) :
    ICVirtualHost(hostId, parent)
{
#ifdef NEW_PLAT
    currentStatusGroup_ = ICAddr_Read_Status0;
#else
    currentStatusGroup_ = 0;
#endif
    recvFrame_ = new ICRobotTransceiverData();
    recvFrame_->SetHostID(kHostID);
    frameTransceiverDataMapper_ = new ICRobotFrameTransceiverDataMapper();
    InitStatusMap_();
    InitStatusFormatorMap_();
    ICSerialTransceiver::Instance()->StartCommunicate();
    ICSerialTransceiver::Instance()->SetFrameTransceiverDataMapper(frameTransceiverDataMapper_);
    SetTransceiver(ICSerialTransceiver::Instance());
#ifdef NEW_PLAT
    SetCommunicateInterval(25);
#else
    SetCommunicateInterval(8);
#endif
    AddRefreshStatusCommand_();
}

bool ICRobotVirtualhost::InitConfigsImpl(const QVector<QPair<quint32, quint32> > &configList, int startAddr)
{

}

bool ICRobotVirtualhost::InitMold(ICVirtualHostPtr hostPtr, const QVector<quint32> &data)
{
    if(data.size() % 4 != 0) return false;
    ICRobotTransceiverData * toSentFrame;
    QVector<quint32> tempDataBuffer;
    int startAddr = 0;
    for(int i = 0; i < data.size(); i +=4)
    {
        tempDataBuffer = data.mid(i, 4);
        toSentFrame = ICRobotTransceiverData::FillActInitCommand(kHostID,
                                                                 startAddr++,
                                                                 tempDataBuffer);

        hostPtr->AddCommunicationFrame(toSentFrame);

        i +=4;
        tempDataBuffer = data.mid(i, 4);
        toSentFrame = ICRobotTransceiverData::FillActInitCommand(kHostID,
                                                                 startAddr++,
                                                                 tempDataBuffer);
        hostPtr->AddCommunicationFrame(toSentFrame);
    }
    return true;
}

bool ICRobotVirtualhost::InitMoldFnc(ICVirtualHostPtr hostPtr, const QVector<quint32> &data)
{
    QVector<quint32> fnc = data;
    const int count = fnc.size();
    if(count % 4 != 0)
    {
        for(int i = 0; i != 4 - (count % 4); ++i)
        {
            fnc.append(0);
        }
    }
    ICRobotTransceiverData * toSentFrame;
    QVector<quint32> tempDataBuffer;
    int startAddr = 0;
    for(int i = 0; i < fnc.size(); i +=4)
    {
        tempDataBuffer = fnc.mid(i, 4);
        toSentFrame = ICRobotTransceiverData::FillFncInitCommand(kHostID,
                                                                 startAddr,
                                                                 tempDataBuffer);
        hostPtr->AddCommunicationFrame(toSentFrame);
        ++startAddr;

    }
    return true;
}

bool ICRobotVirtualhost::InitMoldSub(ICVirtualHostPtr hostPtr, const QVector<QVector<quint32> > &data)
{
    QVector<quint32> sub;
    ICRobotTransceiverData * toSentFrame;
    QVector<quint32> tempDataBuffer;
    int startAddr = 0;
    for(int j = 0; j != data.size(); ++j)
    {
        sub = data.at(j);
        if(sub.size() % 4 != 0) return false;
        startAddr = 0;
        for(int i = 0; i < data.size(); i +=4)
        {
            tempDataBuffer = sub.mid(i, 4);
            toSentFrame = ICRobotTransceiverData::FillSubInitCommand(kHostID,
                                                                     j,
                                                                     startAddr++,
                                                                     tempDataBuffer);

            hostPtr->AddCommunicationFrame(toSentFrame);

            i +=4;
            tempDataBuffer = sub.mid(i, 4);
            toSentFrame = ICRobotTransceiverData::FillSubInitCommand(kHostID,
                                                                     j,
                                                                     startAddr++,
                                                                     tempDataBuffer);
            hostPtr->AddCommunicationFrame(toSentFrame);
        }
    }
    return true;
}

bool ICRobotVirtualhost::InitMachineConfig(ICVirtualHostPtr hostPtr, const QVector<quint32> &data)
{
    QVector<quint32> fnc = data;
    const int count = fnc.size();
    if(count % 4 != 0)
    {
        for(int i = 0; i != 4 - (count % 4); ++i)
        {
            fnc.append(0);
        }
    }
    ICRobotTransceiverData * toSentFrame;
    QVector<quint32> tempDataBuffer;
    int startAddr = 0;
    for(int i = 0; i < fnc.size(); i +=4)
    {
        tempDataBuffer = fnc.mid(i, 4);
        toSentFrame = ICRobotTransceiverData::FillMachineConfigInitCommand(kHostID,
                                                                           startAddr,
                                                                           tempDataBuffer);
        hostPtr->AddCommunicationFrame(toSentFrame);
        ++startAddr;

    }
    return true;
}

void ICRobotVirtualhost::CommunicateImpl()
{
    recvRet_ = Transceiver()->Read(recvFrame_, queue_.Head());
    if(recvRet_ == false || recvFrame_->IsError())
    {
        int ec = recvFrame_->ErrorCode();
        emit CommunicateError(ec);
#ifdef NEW_PLAT
#else
        if(ec == COMMEC_NeedToInit)
        {
            emit NeedToInitHost();
        }
#endif
        if(IsCommunicateDebug())
        {
            qDebug()<<"Read:"<<Transceiver()->LastReadFrame();
            qDebug()<<"Write:"<<Transceiver()->LastWriteFrame();
            qDebug()<<"\n";
            //            emit CommunicateErrChecked();
        }
        if(queue_.Head()->IsQuery())
        {
            queue_.DeQueue();
        }
        ////        IncreaseCommunicateErrCount();
        //        ++conjectionCommErrCount_;
        //        if(conjectionCommErrCount_ > 50)
        //        {
        //            alarmBits_.setBit(ALARM_COMMUNICATION_ANOMALY, 1);
        //            //            queue_.Clear();
        //        }
        //        if(conjectionCommErrCount_ < 2)
        //        {
        //            return;
        //        }
    }
    if(unlikely(IsCommunicateDebug()))
    {
        //        emit ReadyCommunicate();
    }
    if(likely(recvRet_ && !recvFrame_->IsError()))
        //    if(1)
    {
//        if(IsCommunicateDebug())
//        {
//            qDebug()<<"Read:"<<Transceiver()->LastReadFrame();
//            ICHCTransceiverData::ICTransceiverDataBuffer temp = recvFrame_->Data();
//            int k = temp.size();
//            QString v;
//            for(int i=0;i<k;i++)
//            {
//                if(temp.at(i)==0)break;
//                v.append(char(temp.at(i)&0Xff));
//                v.append(char((temp.at(i)>>8)&0Xff)) ;
//                v.append(char((temp.at(i)>>16)&0Xff)) ;
//                v.append(char((temp.at(i)>>24)&0Xff));
//            }
//            qDebug()<<"Version:"<< v;
//            qDebug()<<"Write:"<<Transceiver()->LastWriteFrame();
//            //            emit CommunicateErrChecked();
//        }
        if(recvFrame_->IsQuery())
        {
#ifdef NEW_PLAT
            statusDataTmp_ = recvFrame_->Data();
            startIndex_ = ICAddr_Read_Status0;
            for(int i = 0; i != statusDataTmp_.size(); ++i)
            {
                statusCache_.UpdateConfigValue(startIndex_++, statusDataTmp_.at(i));
            }
            currentStatusGroup_ = ICAddr_Read_Status0;
//            currentStatusGroup_ = ICAddr_System_Retain_0+1;
//            ++currentStatusGroup_;
//            currentStatusGroup_ %= 11;
#else
            statusDataTmp_ = recvFrame_->Data();
            startIndex_ = currentStatusGroup_ * 4;
            for(int i = 0; i != statusDataTmp_.size(); ++i)
            {
                statusCache_.UpdateConfigValue(startIndex_++, statusDataTmp_.at(i));
            }
            ++currentStatusGroup_;
            currentStatusGroup_ %= 11;
#endif
        }
        queue_.DeQueue();
    }
    if(!keyCommandList_.isEmpty())
    {
        AddCommunicationFrame(keyCommandList_.dequeue());
        AddRefreshStatusCommand_();
    }
    if(queue_.IsEmpty())
    {
        AddRefreshStatusCommand_();
        //        return;
    }
    Transceiver()->Write(queue_.Head());
}

void ICRobotVirtualhost::AddRefreshStatusCommand_()
{
    ICRobotTransceiverData * toSentFrame = ICRobotTransceiverData::FillQueryStatusCommand(kHostID,
                                                                                          currentStatusGroup_);
    AddCommunicationFrame(toSentFrame);
}

void ICRobotVirtualhost::InitStatusMap_()
{
#ifdef NEW_PLAT
    const int count = ICAddr_Read_Section_End - ICAddr_Read_Status0;
    for(int i = 0; i != count; ++i)
    {
        statusCache_.UpdateConfigValue(ICAddr_Read_Status0 + i, 0);
    }
#else
    for(int i = 0; i != StatusCount; ++i)
    {
        statusCache_.UpdateConfigValue(i, 0);
    }
#endif
}

bool ICRobotVirtualhost::IsInputOnImpl(int index) const
{
    if(index < 16)
    {
        quint32 temp = 1 << index;
        return HostStatusValue(&c_r_0_16_0_20) & temp;
    }
    else if(index < 32)
    {
        quint32 temp = 1 << (index - 16);
        return HostStatusValue(&c_r_0_16_0_21) & temp;
    }
    else
    {
        quint32 temp = 1 << (index - 32);
        return HostStatusValue(&c_r_0_16_0_19) & temp;
    }
    return false;

}

bool ICRobotVirtualhost::IsOutputOnImpl(int index) const
{
    if(index < 16)
    {
        quint32 temp = 1 << index;
        return HostStatusValue(&c_r_0_16_0_22) & temp;
    }
    else if(index < 32)
    {
        quint32 temp = 1 << (index - 16);
        return HostStatusValue(&c_r_0_16_0_23) & temp;
    }
    return false;
}

#ifdef NEW_PLAT
void ICRobotVirtualhost::SendKeyCommand(int cmd)
{
    ICRobotTransceiverData * toSentFrame = ICRobotTransceiverData::FillKeyCommand(kHostID,
                                                                                  cmd,
                                                                                  0,
                                                                                  0,
                                                                                  0);
    keyCommandList_.append(toSentFrame);
}
#else
void ICRobotVirtualhost::SendKeyCommand(int cmd, int key, int act, int sum)
{
    ICRobotTransceiverData * toSentFrame = ICRobotTransceiverData::FillKeyCommand(kHostID,
                                                                                  cmd,
                                                                                  key,
                                                                                  act,
                                                                                  sum);
    keyCommandList_.append(toSentFrame);
}
#endif

void ICRobotVirtualhost::AddWriteConfigCommand(ICVirtualHostPtr hostPtr, int addr, int value)
{
    ICRobotTransceiverData * toSentFrame = ICRobotTransceiverData::FillWriteConfigCommand(kHostID,
                                                                                          addr,
                                                                                          value);
    hostPtr->AddCommunicationFrame(toSentFrame);
}
