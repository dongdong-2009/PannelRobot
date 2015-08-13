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

#ifdef NEW_PLAT
static bool PairLess(const QPair<int, quint32>& l, const QPair<int, quint32>& r)
{
    return l.first < r.first;
}
bool ICRobotVirtualhost::InitMachineConfig(ICVirtualHostPtr hostPtr, const QList<QPair<int, quint32> > &vp)
{
    QList<QPair<int, quint32> > configs = vp;
    qSort(configs.begin(), configs.end(), PairLess);
    int st = 1;
    QMap<int, int> startIndexToSize;
    int sa = configs.at(0).first;
    st = 1;
    int addr;
    for(int i = 1; i != configs.size(); ++i)
    {
        if(st == 1)
        {
            addr = sa;
        }
        if(configs.at(i).first - sa > 1)
        {
            startIndexToSize.insert(addr, st);
            st = 1;
            sa = configs.at(i).first;
            startIndexToSize.insert(sa, st);
            addr = sa;
            continue;
        }
        ++sa;
        ++st;
    }
    startIndexToSize.insert(addr, st);
    QMap<int, int>::iterator p = startIndexToSize.begin();
    QVector<quint32> tempDataBuffer;
    QList<QPair<int, quint32> > midConfigs;
    ICRobotTransceiverData *data;
    while(p != startIndexToSize.end())
    {
        //        int size = configs.size();
        int size = p.value();
        const int length = 16;
        const int shift = 4;
        int splitCount = qCeil(size / static_cast<qreal>(length));
        for(int i = 0; i != splitCount; ++i)
        {
            data = new ICRobotTransceiverData();
            data->SetHostID(kHostID);
            data->SetFunctionCode(FunctionCode_WriteAddr);
            data->SetAddr(static_cast<ICAddr>(p.key() + (i << shift)) /* *64 */);
            if( i == splitCount - 1)
            {
                data->SetLength(size - (i << shift));
            }
            else
            {
                data->SetLength(length);
            }
            midConfigs = configs.mid(i << shift, data->GetLength());
            tempDataBuffer.clear();
            for(int j = 0; j != midConfigs.size(); ++j)
            {
                tempDataBuffer.append(midConfigs.at(j).second);
            }
            data->SetData(tempDataBuffer);
            hostPtr->AddCommunicationFrame(data);
        }
        configs = configs.mid(size);
        ++p;
    }

    data = new ICRobotTransceiverData(kHostID,
                                      FunctionCode_WriteAddr,
                                      ICAddr_Write_Section_End,
                                      1,
                                      ICRobotTransceiverData::ICTransceiverDataBuffer()<<1);
    hostPtr->AddCommunicationFrame(data);

    return true;
}

#else
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
#endif

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
//                qDebug()<<statusDataTmp_.at(i);
            }
            if(HostStatusValue(&c_ro_0_32_0_932) == ALARM_NOT_INIT)
            {
//                qDebug()<<"statusDataTmp_.at(i)";
                emit NeedToInitHost();
            }
            if(statusDataTmp_.at(33) == ALARM_NOT_INIT)
            {
                emit NeedToInitHost();
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
#ifdef NEW_PLAT
    return false;
#else
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
#endif

}

bool ICRobotVirtualhost::IsOutputOnImpl(int index) const
{
#ifdef NEW_PLAT
    return false;
#else
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
#endif
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

void ICRobotVirtualhost::SendConfigs(ICVirtualHostPtr hostPtr, const  QList<QPair<int, quint32> >&addVals)
{
    QPair<int, quint32> tmp;
    for(int i = 0; i != addVals.size(); ++i)
    {
        tmp = addVals.at(i);
        AddWriteConfigCommand(hostPtr, tmp.first, tmp.second);
    }
}
