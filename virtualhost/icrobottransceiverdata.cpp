#include "icrobottransceiverdata.h"
#include "icutility.h"

ICObjectPool<ICRobotTransceiverData> ICRobotTransceiverData::objectPool_;
ICRobotTransceiverData::ICRobotTransceiverData()
{
}

bool ICRobotFrameTransceiverDataMapper::FrameToTransceiverData(ICTransceiverData *recvData, const uint8_t *buffer, size_t size, const ICTransceiverData *sentData)
{
    ICRobotTransceiverData* robotRecvData = static_cast<ICRobotTransceiverData*>(recvData);
    const ICRobotTransceiverData* robotSentData = static_cast<const ICRobotTransceiverData*>(sentData);
    if(unlikely(robotRecvData == NULL))
    {
        return false;
    }

    if(robotSentData->GetFunctionCode() == FC_HC_INIT_PARA)
    {
        if(size != 16) return false;
        robotRecvData->SetHostID(buffer[0]);
        robotRecvData->SetFunctionCode(buffer[1]);
        robotRecvData->SetAddr(buffer[2] | (buffer[3] << 8));
        robotRecvData->SetLength(buffer[4] | (buffer[5] << 8));
        dataBuffer_.clear();
        int j = 6;
        for(size_t i = 0; i != robotRecvData->GetLength(); ++i)
        {
            dataBuffer_.append((buffer[j] | buffer[j + 1] << 8));
            j += 2;
        }
        robotRecvData->SetData(dataBuffer_);

//        int sentSize = TransceiverDataToFrame(tmpButter_, 16, sentData);
        if(!recvData->IsEqual(sentData)) return false;
//        if(memcmp(buffer, tmpButter_, sentSize) != 0) return false;

    }
    return true;
}

size_t ICRobotFrameTransceiverDataMapper::TransceiverDataToFrame(uint8_t *dest, size_t bufferSize, const ICTransceiverData *data)
{
    const ICRobotTransceiverData* injectionData = static_cast<const ICRobotTransceiverData*>(data);
    if(unlikely(injectionData == NULL))
    {
        return 0;
    }
    dataBuffer_ = injectionData->Data();
    if(unlikely(static_cast<int>(bufferSize) < dataBuffer_.size() + 7))
    {
        return 0;
    }
    int dI = 0;
    dest[dI++] = injectionData->HostID();
    dest[dI++] = injectionData->GetFunctionCode();
    if(injectionData->GetFunctionCode() == FC_HC_INIT_PARA)
    {
        dest[dI++] = injectionData->GetAddr() & 0x00FF;
        dest[dI++] = injectionData->GetAddr() >> 8;
        dest[dI++] = injectionData->GetLength() & 0x00FF;
        dest[dI++] = injectionData->GetLength() >> 8;
    }
//    int j = 5;
    for(int i = 0; i != dataBuffer_.size(); ++i)
    {
//        dest[dI++] = Get8BitNum(dataBuffer_.at(i), 24);
//        dest[j++] = Get8BitNum(dataBuffer_.at(i), 16);
        dest[dI++] = Get8BitNum(dataBuffer_.at(i), 0);
        dest[dI++] = Get8BitNum(dataBuffer_.at(i), 8);
    }
    uint16_t crc = ICUtility::CRC16(dest, dI);
    dest[dI++] = Get8BitNum(crc, 8);
    dest[dI++] = Get8BitNum(crc, 0);
    return dI;
}
