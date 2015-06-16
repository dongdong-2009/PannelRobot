#include "icrobotvirtualhost.h"
#include <QVector>
#include "icserialtransceiver.h"

QQueue<ICRobotTransceiverData*> ICRobotVirtualhost::keyCommandList_;

ICRobotVirtualhost::ICRobotVirtualhost(uint64_t hostId, QObject *parent) :
    ICVirtualHost(hostId, parent)
{
    currentStatusGroup_ = 0;
    recvFrame_ = new ICRobotTransceiverData();
    recvFrame_->SetHostID(kHostID);
    frameTransceiverDataMapper_ = new ICRobotFrameTransceiverDataMapper();
    InitStatusMap_();
    InitStatusFormatorMap_();
    ICSerialTransceiver::Instance()->StartCommunicate();
    ICSerialTransceiver::Instance()->SetFrameTransceiverDataMapper(frameTransceiverDataMapper_);
    SetTransceiver(ICSerialTransceiver::Instance());
    SetCommunicateInterval(8);
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
        if(ec == COMMEC_NeedToInit)
        {
            emit NeedToInitHost();
        }
        if(IsCommunicateDebug())
        {
            qDebug()<<"Read:"<<Transceiver()->LastReadFrame();
            qDebug()<<"Write:"<<Transceiver()->LastWriteFrame();
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
        //            qDebug()<<"Write:"<<Transceiver()->LastWriteFrame();
        //            //            emit CommunicateErrChecked();
        //        }
        if(recvFrame_->IsQuery())
        {
            statusDataTmp_ = recvFrame_->Data();
            startIndex_ = currentStatusGroup_ * 4;
            for(int i = 0; i != statusDataTmp_.size(); ++i)
            {
                statusCache_.UpdateConfigValue(startIndex_++, statusDataTmp_.at(i));
            }
            ++currentStatusGroup_;
            currentStatusGroup_ %= 11;
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
    for(int i = 0; i != StatusCount; ++i)
    {
        statusCache_.UpdateConfigValue(i, 0);
    }
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

void ICRobotVirtualhost::SendKeyCommand(int cmd, int key, int act, int sum)
{
    ICRobotTransceiverData * toSentFrame = ICRobotTransceiverData::FillKeyCommand(kHostID,
                                                                                  cmd,
                                                                                  key,
                                                                                  act,
                                                                                  sum);
    keyCommandList_.append(toSentFrame);
}
