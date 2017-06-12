#include "icrobotvirtualhost.h"
#include <QVector>
#include "icserialtransceiver.h"
#include "hccommparagenericdef.h"
#include <QTime>



QQueue<ICRobotTransceiverData*> ICRobotVirtualhost::keyCommandList_;

QMap<int, quint32> ICRobotVirtualhost::iStatusMap_;
QMap<int, quint32> ICRobotVirtualhost::oStatusMap_;
QMap<int, quint32> ICRobotVirtualhost::multiplexingConfigs_;
QMap<int, quint32> ICRobotVirtualhost::qkEeprom_;
QMap<int, quint32> ICRobotVirtualhost::qkStatus_;
QString ICRobotVirtualhost::hostVersion_;



#define REFRESH_COUNT_PER 43
#define REFRESH_INTERVAL 41
#define REFRESH_END ICAddr_Read_Status42
#define INIT_INTERVAL 20
#define SHORT_CMD_INTERVAL 10
ICRobotVirtualhost::ICRobotVirtualhost(uint64_t hostId, QObject *parent) :
    ICVirtualHost(hostId, parent)
{

#ifdef NEW_PLAT
    currentStatusGroup_ = 0;
    statusGroupCount_ = qCeil(qreal(ICAddr_Read_Status40 - ICAddr_Read_Status0) / REFRESH_COUNT_PER);
    sendingContinuousData_ = false;
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
    SetCommunicateInterval(REFRESH_INTERVAL);
#else
    SetCommunicateInterval(8);
#endif
    AddRefreshStatusCommand_();
    ICRobotTransceiverData * toSentFrame = ICRobotTransceiverData::FillQueryStatusCommand(kHostID,
                                                                                          ICAddr_System_Retain_2,
                                                                                          64); // read host version
    AddCommunicationFrame(toSentFrame);
}

ICRobotVirtualhost::~ICRobotVirtualhost()
{
    delete frameTransceiverDataMapper_;
    delete recvFrame_;

}

bool ICRobotVirtualhost::InitConfigsImpl(const QVector<QPair<quint32, quint32> > &configList, int startAddr)
{

}

static QVector<QVector<quint32> > formatProgramFrame(const QVector<QVector<quint32> >& data)
{
    QVector<QVector<quint32> > ret;
    QVector<quint32> oneLine;
    for(int i = 0; i < data.size(); ++i)
    {
        if(oneLine.size() + data.at(i).size() > 64)
        {
            ret.append(oneLine);
            oneLine.clear();

        }
        oneLine<<data.at(i);

    }
    ret.append(oneLine);
    return ret;
}
static QVector<QVector<quint32> > formatContinuousDataFrame(const QVector<quint32> & data)
{
    QVector<QVector<quint32> > ret;
    int splitCount = data.size() / 30;
    int left = data.size() % 30;
    int i = 0;
    for(i = 0; i < splitCount; ++i)
    {
        ret.append(data.mid(i * 30, 30));
    }
    ret.append(data.mid(i * 30, left));
    return ret;
}

void ICRobotVirtualhost::SendContinuousDataHelper(ICVirtualHostPtr hostPtr, int startAddr, const QVector<quint32> &data, int fc)
{
    ICRobotTransceiverData * toSentFrame;
    int size = data.size();
    const int length = 16;
    const int shift = 4;
    int splitCount = qCeil(size / static_cast<qreal>(length));
    QVector<quint32> toSentData;
    for(int i = 0; i != splitCount; ++i)
    {
        toSentFrame = new ICRobotTransceiverData();
        toSentFrame->SetHostID(kHostID);
        toSentFrame->SetFunctionCode(fc);
        toSentFrame->SetAddr(startAddr + (i << shift) /* *64 */);
        if( i == splitCount - 1)
        {
            toSentFrame->SetLength(size - (i << shift));
        }
        else
        {
            toSentFrame->SetLength(length);
        }
        toSentData = data.mid(i << shift, toSentFrame->GetLength());
        toSentFrame->SetData(toSentData);
        hostPtr->AddCommunicationFrame(toSentFrame);
    }
}

bool ICRobotVirtualhost::SendMold(ICVirtualHostPtr hostPtr, const QVector<QVector<quint32> >&data)
{
#ifdef NEW_PLAT
    AddWriteConfigCommand(hostPtr, ICAddr_System_Retain_80, 0x80000000);
    QVector<QVector<quint32> > formattedData = formatProgramFrame(data);
    for(int i = 0; i < formattedData.size(); ++i)
    {
        AddWriteConfigCommand(hostPtr, ICAddr_System_Retain_80, formattedData.at(i).size());
        SendContinuousDataHelper(hostPtr, 0, formattedData.at(i));
    }
    AddWriteConfigCommand(hostPtr, ICAddr_System_Retain_81, 1);
    return true;


#else
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
#endif
}


bool ICRobotVirtualhost::SendMoldSub(ICVirtualHostPtr hostPtr, int which, const QVector<QVector<quint32> > &data)
{
#ifdef NEW_PLAT
    AddWriteConfigCommand(hostPtr, ICAddr_System_Retain_80, 0x80000000 | ((which) << 24));
    QVector<QVector<quint32> > formattedData = formatProgramFrame(data);
    for(int i = 0; i < formattedData.size(); ++i)
    {
        AddWriteConfigCommand(hostPtr, ICAddr_System_Retain_80, formattedData.at(i).size() | ((which) << 24));
        SendContinuousDataHelper(hostPtr, 0, formattedData.at(i));
    }
//    qDebug()<<"Send:"<<which<<formattedData;
    AddWriteConfigCommand(hostPtr, ICAddr_System_Retain_81, 1);
    //    AddWriteConfigCommand(hostPtr, ICAddr_System_Retain_80, (data.size() | ((which) << 24)));
    //    SendContinuousDataHelper(hostPtr, 0, data);
    return true;
#else
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
#endif
}

bool ICRobotVirtualhost::SendMoldCounterDef(ICVirtualHostPtr hostPtr, const QVector<quint32> &data)
{
    ICRobotTransceiverData *toSentFrame = new ICRobotTransceiverData();
    toSentFrame->SetAddr(ICAddr_System_Retain_8);
    toSentFrame->SetHostID(kHostID);
    toSentFrame->SetFunctionCode(FunctionCode_WriteAddr);
    toSentFrame->SetData(data);
    toSentFrame->SetLength(data.size());
    hostPtr->AddCommunicationFrame(toSentFrame);
    return true;
}

bool ICRobotVirtualhost::sendMoldToolCoordDef(ICVirtualHostPtr hostPtr,const QVector<quint32> & data)
{
    ICRobotTransceiverData *toSentFrame = new ICRobotTransceiverData();
    toSentFrame->SetAddr(ICAddr_System_Retain_20);
    toSentFrame->SetHostID(kHostID);
    toSentFrame->SetFunctionCode(FunctionCode_WriteAddr);
    toSentFrame->SetData(data);
    toSentFrame->SetLength(data.size());
    hostPtr->AddCommunicationFrame(toSentFrame);
    return true;
}

bool ICRobotVirtualhost::sendMoldToolCalibrationDef(ICVirtualHostPtr hostPtr,const QVector<quint32> & data)
{
    ICRobotTransceiverData *toSentFrame = new ICRobotTransceiverData();
    toSentFrame->SetAddr(ICAddr_System_Retain_62);
    toSentFrame->SetHostID(kHostID);
    toSentFrame->SetFunctionCode(FunctionCode_WriteAddr);
    toSentFrame->SetData(data);
    toSentFrame->SetLength(data.size());
    hostPtr->AddCommunicationFrame(toSentFrame);
    return true;
}

bool ICRobotVirtualhost::sendIOBarnLogicDef(ICVirtualHostPtr hostPtr,const QVector<quint32> & data)
{
    ICRobotTransceiverData *toSentFrame = new ICRobotTransceiverData();
    toSentFrame->SetAddr(ICAddr_System_Retain_60);
    toSentFrame->SetHostID(kHostID);
    toSentFrame->SetFunctionCode(FunctionCode_WriteAddr);
    toSentFrame->SetData(data);
    toSentFrame->SetLength(data.size());
    hostPtr->AddCommunicationFrame(toSentFrame);
    return true;
}

bool ICRobotVirtualhost::SendMoldCountersDef(ICVirtualHostPtr hostPtr, const QVector<QVector<quint32> > &data)
{
    for(int i = 0; i < data.size(); ++i)
    {
        SendMoldCounterDef(hostPtr, data.at(i));
    }
    return true;

}

bool ICRobotVirtualhost::SendExternalDatas(ICVirtualHostPtr hostPtr, int externalID, const QVector<quint32> &data)
{
    AddWriteConfigCommand(hostPtr, ICAddr_System_Retain_82, 0x80000000 | ((externalID) << 16));
    QVector<QVector<quint32> > formattedData = formatContinuousDataFrame(data);
    for(int i = 0; i < formattedData.size(); ++i)
    {
        AddWriteConfigCommand(hostPtr, ICAddr_System_Retain_82, formattedData.at(i).size() | ((externalID) << 16));
        SendContinuousDataHelper(hostPtr, 0, formattedData.at(i), FunctionCode_WriteStack);
    }
    AddWriteConfigCommand(hostPtr, ICAddr_System_Retain_83, 1);

    return true;
}

bool ICRobotVirtualhost::FixProgram(ICVirtualHostPtr hostPtr, int which, int row, int step, const QVector<quint32> &data)
{
    QVector<quint32> toSent;
    toSent<<which<<row<<step;
    toSent += data;
    ICRobotTransceiverData * toSentFrame =  new ICRobotTransceiverData();
    toSentFrame->SetHostID(kHostID);
    toSentFrame->SetFunctionCode(FunctionCode_EditTeach);
    toSentFrame->SetAddr(0);
    toSentFrame->SetLength(toSent.size());
    toSentFrame->SetData(toSent);
    hostPtr->AddCommunicationFrame(toSentFrame);
    return true;
}

#ifdef NEW_PLAT
static bool PairLess(const QPair<int, quint32>& l, const QPair<int, quint32>& r)
{
    return l.first < r.first;
}

bool ICRobotVirtualhost::InitConfigHelper(ICVirtualHostPtr hostPtr, const QList<QPair<int, quint32> > &vp)
{
    QList<QPair<int, quint32> > configs = vp;
    if(configs.isEmpty()) return true;
    qSort(configs.begin(), configs.end(), PairLess);
    int st = 1;
    QMap<int, int> startIndexToSize;
    int sa = configs.at(0).first;
    st = 1;
    int addr = sa;
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
    return true;
}

bool ICRobotVirtualhost::InitMoldFnc(ICVirtualHostPtr hostPtr, const QList<QPair<int, quint32> > &vp)
{
    return InitConfigHelper(hostPtr, vp);
}

bool ICRobotVirtualhost::InitMachineConfig(ICVirtualHostPtr hostPtr, const QList<QPair<int, quint32> > &vp)
{
    //    QList<QPair<int, quint32> > configs = vp;
    //    qSort(configs.begin(), configs.end(), PairLess);
    //    int st = 1;
    //    QMap<int, int> startIndexToSize;
    //    int sa = configs.at(0).first;
    //    st = 1;
    //    int addr;
    //    for(int i = 1; i != configs.size(); ++i)
    //    {
    //        if(st == 1)
    //        {
    //            addr = sa;
    //        }
    //        if(configs.at(i).first - sa > 1)
    //        {
    //            startIndexToSize.insert(addr, st);
    //            st = 1;
    //            sa = configs.at(i).first;
    //            startIndexToSize.insert(sa, st);
    //            addr = sa;
    //            continue;
    //        }
    //        ++sa;
    //        ++st;
    //    }
    //    startIndexToSize.insert(addr, st);
    //    QMap<int, int>::iterator p = startIndexToSize.begin();
    //    QVector<quint32> tempDataBuffer;
    //    QList<QPair<int, quint32> > midConfigs;
    ICRobotTransceiverData *data;
    //    while(p != startIndexToSize.end())
    //    {
    //        //        int size = configs.size();
    //        int size = p.value();
    //        const int length = 16;
    //        const int shift = 4;
    //        int splitCount = qCeil(size / static_cast<qreal>(length));
    //        for(int i = 0; i != splitCount; ++i)
    //        {
    //            data = new ICRobotTransceiverData();
    //            data->SetHostID(kHostID);
    //            data->SetFunctionCode(FunctionCode_WriteAddr);
    //            data->SetAddr(static_cast<ICAddr>(p.key() + (i << shift)) /* *64 */);
    //            if( i == splitCount - 1)
    //            {
    //                data->SetLength(size - (i << shift));
    //            }
    //            else
    //            {
    //                data->SetLength(length);
    //            }
    //            midConfigs = configs.mid(i << shift, data->GetLength());
    //            tempDataBuffer.clear();
    //            for(int j = 0; j != midConfigs.size(); ++j)
    //            {
    //                tempDataBuffer.append(midConfigs.at(j).second);
    //            }
    //            data->SetData(tempDataBuffer);
    //            hostPtr->AddCommunicationFrame(data);
    //        }
    //        configs = configs.mid(size);
    //        ++p;
    //    }
    InitConfigHelper(hostPtr, vp);

    data = new ICRobotTransceiverData(kHostID,
                                      FunctionCode_WriteAddr,
                                      ICAddr_Write_Section_End,
                                      1,
                                      ICRobotTransceiverData::ICTransceiverDataBuffer()<<1);
    hostPtr->AddCommunicationFrame(data);

    return true;
}

#else
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

//QTime testTime;
//int oldTime;

void ICRobotVirtualhost::CommunicateImpl()
{
    recvRet_ = Transceiver()->Read(recvFrame_, queue_.Head());
    if(recvRet_ == false || recvFrame_->IsError())
    {
        int ec = recvFrame_->ErrorCode();
        emit CommunicateError(ec);
        IncreaseCommunicateErrCount();
        if(CommunicateErrCount() > 50)
        {
            statusCache_.UpdateConfigValue(&c_ro_0_32_0_932, 9);
        }
#ifdef NEW_PLAT
        //        if(ec == FunctionCode_EditTeach)
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
#ifdef TEST_STEP
            statusCache_.UpdateConfigValue(&c_ro_0_16_0_933, rand() % 10);
#endif
#ifdef TEST_ALARM
            statusCache_.UpdateConfigValue(&c_ro_0_32_0_932, rand() % 5);

#endif
            //            emit CommunicateErrChecked();
        }
        if((queue_.Head()->IsQuery()) && (recvFrame_->GetAddr() >= ICAddr_Read_Status0))
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
    if(likely(recvRet_ && !recvFrame_->IsError()))
    {
        if(recvFrame_->IsQuery())
        {
#ifdef NEW_PLAT
            statusDataTmp_ = recvFrame_->Data();
            startIndex_ = recvFrame_->GetAddr();
            if(startIndex_ == ICAddr_System_Retain_2)
            {
                ICHCTransceiverData::ICTransceiverDataBuffer temp = recvFrame_->Data();
                hostVersion_.clear();
                for(int i = 0; i < temp.size(); ++i)
                {
                    if(temp.at(i)==0)break;
                    hostVersion_.append(char(temp.at(i)&0Xff));
                    hostVersion_.append(char((temp.at(i)>>8)&0Xff)) ;
                    hostVersion_.append(char((temp.at(i)>>16)&0Xff)) ;
                    hostVersion_.append(char((temp.at(i)>>24)&0Xff));
                }

            }
            else
            {
                for(int i = 0; i != statusDataTmp_.size(); ++i)
                {
                    statusCache_.UpdateConfigValue(startIndex_++, statusDataTmp_.at(i));
                    //                qDebug()<<statusDataTmp_.at(i);
                }
                if(HostStatusValue(&c_ro_1_4_0_938) != CMD_AUTO)
                {
                    multiplexingConfigs_.insert(ICAddr_Read_Status33, statusDataTmp_.at(ICAddr_Read_Status33 - recvFrame_->GetAddr()));
                    multiplexingConfigs_.insert(ICAddr_Read_Status34, statusDataTmp_.at(ICAddr_Read_Status34 - recvFrame_->GetAddr()));
                }
                multiplexingConfigs_.insert(statusDataTmp_.at(ICAddr_Read_Status41 - recvFrame_->GetAddr()),
                                            statusDataTmp_.at(ICAddr_Read_Status42 - recvFrame_->GetAddr()));

                if(currentStatusGroup_ == 0)
                {
                    int boardID = HostStatusValue(&c_ro_5_3_0_938);
                    iStatusMap_.insert(boardID, HostStatusValue(&c_ro_0_32_0_939));
                    oStatusMap_.insert(boardID, HostStatusValue(&c_ro_0_32_0_940));
                }
                if((currentStatusGroup_ == (statusGroupCount_ - 1)) ||
                        (recvFrame_->GetAddr() < ICAddr_Read_Status0))
                {
                    emit QueryFinished(recvFrame_->GetAddr(), statusDataTmp_);
                }
                static int oldAlarm = -1;
                if(oldAlarm != HostStatusValue(&c_ro_0_32_0_932))
                {
                    oldAlarm = HostStatusValue(&c_ro_0_32_0_932);
                    if(oldAlarm == ALARM_NOT_INIT)
                    {
                        //                qDebug()<<"statusDataTmp_.at(i)";
                        //                    SetCommunicateInterval(INIT_INTERVAL);
                        emit NeedToInitHost();
                        ICRobotTransceiverData * toSentFrame = ICRobotTransceiverData::FillQueryStatusCommand(kHostID,
                                                                                                              ICAddr_System_Retain_2,
                                                                                                              64); // read host version
                        AddCommunicationFrame(toSentFrame);
                    }
                }
                //            currentStatusGroup_ = ICAddr_Read_Status0;

                currentStatusGroup_++;
                currentStatusGroup_ %= statusGroupCount_;
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
    }
    else if(recvFrame_->IsQkQueryEeprom())
    {
        statusDataTmp_ = recvFrame_->Data();
        startIndex_ = recvFrame_->GetAddr();
        if(statusDataTmp_.size())
        {
            int i,j;
            int dataLength16 = statusDataTmp_.at(0)&0xffff;
            if(dataLength16)
            {
                qkEeprom_.insert(startIndex_++,statusDataTmp_.at(0)>>16);
            }
            for(i=1,j=1;i < dataLength16;i+=2,j++)
            {
                qkEeprom_.insert(startIndex_++,statusDataTmp_.at(j)&0xFFFF);
                if(i+1 < dataLength16){
                    qkEeprom_.insert(startIndex_++,statusDataTmp_.at(j)>>16);
                }
            }
            if(startIndex_ == ((3<<8)+SP_Addr_InitElecAng110+1))
            {
//                qDebug() << qkEeprom_;
                emit QueryQkEepromFinished();
                qkEeprom_.insert(SP_Addr_ReadReady,1);
            }
        }
    }
    else if(recvFrame_->IsQkQueryStatus())
    {
        statusDataTmp_ = recvFrame_->Data();
        startIndex_ = recvFrame_->GetAddr();
        if(statusDataTmp_.size())
        {
            int i,j;
            int dataLength16 = statusDataTmp_.at(0)&0xffff;
            if(dataLength16)
            {
                qkStatus_.insert(startIndex_++,statusDataTmp_.at(0)>>16);
            }
            for(i=1,j=1;i < dataLength16;i+=2,j++)
            {
                qkStatus_.insert(startIndex_++,statusDataTmp_.at(j)&0xFFFF);
                if(i+1 < dataLength16){
                    qkStatus_.insert(startIndex_++,statusDataTmp_.at(j)>>16);
                }
            }
//            qDebug() << qkStatus_;
        }
    }
    else if(unlikely(recvFrame_->GetAddr() >= ICAddr_System_Retain_80 &&
            recvFrame_->GetAddr() <= ICAddr_System_Retain_83 && !recvFrame_->IsQkWrite()))
    {
        if(!sendingContinuousData_)
        {
            sendingContinuousData_ = true;
            sendingDataTime_.restart();
            emit SendingContinuousData();
        }
    }
    ClearCommunicateErrCount();
    queue_.DeQueue();
}
if(!keyCommandList_.isEmpty())
{
    //    SetCommunicateInterval(SHORT_CMD_INTERVAL);
    //    int ct = testTime.restart();
    //    if(qAbs(oldTime - ct) > 5 || ct > 100)
    //    {
    //        qDebug()<<"time:"<<ct;
    //        oldTime = ct;
    //    }
    AddCommunicationFrame(keyCommandList_.dequeue());
    AddRefreshStatusCommand_();
    //        qDebug("keycommand");
}
if(queue_.IsEmpty())
{
    AddRefreshStatusCommand_();
    if(sendingContinuousData_)
    {
        sendingContinuousData_ = false;
        emit SentContinuousData(sendingDataTime_.elapsed());
    }
    //    if(likely(CommunicateInterval() != REFRESH_INTERVAL))
    //        SetCommunicateInterval(REFRESH_INTERVAL);
    //        return;
}
const ICRobotTransceiverData* toSend = static_cast<const ICRobotTransceiverData*>(queue_.Head());
Transceiver()->Write(toSend);
#ifdef COMM_DEBUG
if(!toSend->IsQuery())
{
    qDebug()<<"toSend:"<<toSend->ToString();
}
#endif
SetCommunicateInterval(toSend->IsQuery()?REFRESH_INTERVAL:(toSend->GetLength() + 5));
}

void ICRobotVirtualhost::AddRefreshStatusCommand_()
{
    int length = 0;
    int startAddr = currentStatusGroup_ * REFRESH_COUNT_PER + ICAddr_Read_Status0;
    if(currentStatusGroup_ == statusGroupCount_ - 1)
    {
        length = REFRESH_END - startAddr + 1;
    }
    else
    {
        length = REFRESH_COUNT_PER;
    }
    ICRobotTransceiverData * toSentFrame = ICRobotTransceiverData::FillQueryStatusCommand(kHostID,
                                                                                          startAddr,
                                                                                          length);
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

void ICRobotVirtualhost::AddReadConfigCommand(ICVirtualHostPtr hostPtr, int startAddr, int size)
{
    //    currentStatusGroup_ = startAddr;
    if(size > 32) return;
    ICRobotTransceiverData * toSentFrame = new ICRobotTransceiverData(kHostID,
                                                                      FunctionCode_ReadAddr,
                                                                      startAddr,
                                                                      size,
                                                                      ICRobotTransceiverData::ICTransceiverDataBuffer());
    hostPtr->AddCommunicationFrame(toSentFrame);

}

void ICRobotVirtualhost::AddReadQkConfigCommand(ICVirtualHostPtr hostPtr, int startAddr, int size,bool isEeprom)
{
    if(size > 64) return;
    ICRobotTransceiverData * toSentFrame = new ICRobotTransceiverData(kHostID,
                                                                      (isEeprom?FunctionCode_QKServoParaReadEeprom:FunctionCode_QKServoParaReadMemory),
                                                                      startAddr,
                                                                      (size+1)/2+(size+1)%2,
                                                                      ICRobotTransceiverData::ICTransceiverDataBuffer()<<size);
    hostPtr->AddCommunicationFrame(toSentFrame);
}

void ICRobotVirtualhost::SendYControlCommand(ICVirtualHostPtr hostPtr, ValveItem item)
{
    ICRobotTransceiverData *toSentFrame = new ICRobotTransceiverData();
    toSentFrame->SetHostID(kHostID);
    toSentFrame->SetFunctionCode(FunctionCode_WriteAddr);
    toSentFrame->SetAddr(ICAddr_System_Retain_3);
    toSentFrame->SetLength(2);

    toSentFrame->SetData(item.toDataBuf());
    hostPtr->AddCommunicationFrame(toSentFrame);
}

void ICRobotVirtualhost::InitValveDefines(ICVirtualHostPtr hostPtr, const QList<ValveItem> &valveDefines)
{
    for(int i = 0; i < valveDefines.size(); ++i)
        SendValveItemToHost(hostPtr, valveDefines.at(i));
}

void ICRobotVirtualhost::SendValveItemToHost(ICVirtualHostPtr hostPtr, ValveItem item)
{
    if(item.type == 0) return;
    ICRobotTransceiverData *toSentFrame = new ICRobotTransceiverData();
    toSentFrame->SetHostID(kHostID);
    toSentFrame->SetFunctionCode(FunctionCode_WriteAddr);
    toSentFrame->SetAddr(ICAddr_System_Retain_7);
    toSentFrame->SetLength(2);

    qDebug()<<"valveItem"<<item.toDataBuf();
    toSentFrame->SetData(item.toDataBuf());
    hostPtr->AddCommunicationFrame(toSentFrame);
}

void ICRobotVirtualhost::LogTestPoint(ICVirtualHostPtr hostPtr, int type, QList<quint32> axisData)
{
    if(axisData.size() != 6) return;
    ICRobotTransceiverData *toSentFrame = new ICRobotTransceiverData();
    toSentFrame->SetHostID(kHostID);
    toSentFrame->SetFunctionCode(FunctionCode_WriteAddr);
    toSentFrame->SetAddr(ICAddr_System_Retain_30);
    toSentFrame->SetLength(7);

    ICHCTransceiverData::ICTransceiverDataBuffer db;
    db<<type<<axisData.at(0)<<axisData.at(1)<<axisData.at(2)<<axisData.at(3)<<axisData.at(4)
     <<axisData.at(5);
    toSentFrame->SetData(db);
    hostPtr->AddCommunicationFrame(toSentFrame);
}

void ICRobotVirtualhost::WriteQkPara(ICVirtualHostPtr hostPtr, int addr, QVector<quint32> qkData)
{
    if(qkData.size()>32) return;
    ICRobotTransceiverData *toSentFrame = new ICRobotTransceiverData();
    toSentFrame->SetAddr(addr);
    toSentFrame->SetHostID(kHostID);
    toSentFrame->SetFunctionCode(FunctionCode_QKServoParaWriteMemory);
    toSentFrame->SetData(qkData);
    toSentFrame->SetLength(qkData.size());
    hostPtr->AddCommunicationFrame(toSentFrame);
}

void ICRobotVirtualhost::WriteQkEeprom(ICVirtualHostPtr hostPtr, int addr, QVector<quint32> qkData)
{
    if(qkData.size()>32) return;
    ICRobotTransceiverData *toSentFrame = new ICRobotTransceiverData();
    toSentFrame->SetAddr(addr);
    toSentFrame->SetHostID(kHostID);
    toSentFrame->SetFunctionCode(FunctionCode_QKServoParaWriteEeprom);
    toSentFrame->SetData(qkData);
    toSentFrame->SetLength(qkData.size());
    hostPtr->AddCommunicationFrame(toSentFrame);
}
