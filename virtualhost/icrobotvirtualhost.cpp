#include "icrobotvirtualhost.h"
#include <QVector>
#include "icserialtransceiver.h"

#define SYS_INIT_ADDR_HEADER 0xC000

ICRobotVirtualhost::ICRobotVirtualhost(uint64_t hostId, QObject *parent) :
    ICVirtualHost(hostId, parent)
{
    recvFrame_ = new ICRobotTransceiverData();
    recvFrame_->SetHostID(kHostID);
    frameTransceiverDataMapper_ = new ICRobotFrameTransceiverDataMapper();
    InitStatusMap_();
    InitStatusFormatorMap_();
    ICSerialTransceiver::Instance()->StartCommunicate();
    ICSerialTransceiver::Instance()->SetFrameTransceiverDataMapper(frameTransceiverDataMapper_);
    SetTransceiver(ICSerialTransceiver::Instance());
    SetCommunicateInterval(15);
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
   for(int i = 0; i < data.size(); i +=8)
    {
       tempDataBuffer = data.mid(i * 4, 4);
        toSentFrame = ICRobotTransceiverData::FillActInitCommand(kHostID,
                                                                startAddr++,
                                                                tempDataBuffer);

        hostPtr->AddCommunicationFrame(toSentFrame);

        i +=4;
        tempDataBuffer = data.mid(i * 4, 4);
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
        tempDataBuffer = fnc.mid(i * 4, 4);
        toSentFrame->FillFncInitCommand(kHostID,
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
    if(recvRet_ == false && !recvFrame_->IsError())
    {
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

        if(IsCommunicateDebug())
        {
            qDebug()<<"Read:"<<Transceiver()->LastReadFrame();
            qDebug()<<"Write:"<<Transceiver()->LastWriteFrame();
//            emit CommunicateErrChecked();
        }
        queue_.DeQueue();
    }
    if(queue_.IsEmpty())
    {
       return;
    }
    Transceiver()->Write(queue_.Head());
}
