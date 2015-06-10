#ifndef ICROBOTTRANSCEIVERDATA_H
#define ICROBOTTRANSCEIVERDATA_H

#include "ichctransceiverdata.h"

enum FunctionCode{
    FC_HC_QUERY_STATUS = 0x02,
    FC_HC_INIT_PARA    = 0x06
};

class ICRobotTransceiverData : public ICHCTransceiverData
{
public:
    typedef QVector<quint32> ICTransceiverDataBuffer;
    ICRobotTransceiverData();
    ICRobotTransceiverData(
            uint8_t hostID,
            FunctionCode fc,
            uint addr,
            uint16_t length,
            const ICTransceiverDataBuffer& data = ICTransceiverDataBuffer())
        :ICHCTransceiverData(hostID, fc, addr, length, data){}

    virtual bool IsQuery() const { return GetFunctionCode() == FC_HC_QUERY_STATUS;}
    static ICRobotTransceiverData* FillActInitCommand(uint8_t hostID,
                           uint addr,
                           const ICTransceiverDataBuffer& data)
    {
        return new ICRobotTransceiverData(hostID,
                                          FC_HC_INIT_PARA,
                                          addr | 0X4000,
                                          data.size(),
                                          data);
    }

    static ICRobotTransceiverData* FillFncInitCommand(uint8_t hostID,
                           uint addr,
                           const ICTransceiverDataBuffer& data)
    {
        return new ICRobotTransceiverData(hostID,
                                          FC_HC_INIT_PARA,
                                          addr | 0X8000,
                                          data.size(),
                                          data);
    }

    static ICRobotTransceiverData* FillSubInitCommand(uint8_t hostID,
                                                      uint group,
                                                      uint addr,
                           const ICTransceiverDataBuffer& data)
    {
        return new ICRobotTransceiverData(hostID,
                                          FC_HC_INIT_PARA,
                                          (group << 8) | addr,
                                          data.size(),
                                          data);
    }



    virtual bool IsError() const { return (GetFunctionCode() & 0x80) == 1;}
    virtual int MaxFrameLength() const { return 16;}

    //    ~ICInjectionMachineTransceiverData()
    //    {
    //        objectPool_.FreeData(this);
    //        --newCount_;
    //    }

    void* operator new(size_t size)
    {
        Q_UNUSED(size)
        //        ++newCount_;
        return objectPool_.MallocData();
    }

    void operator delete(void* p)
    {
        objectPool_.FreeData(p);
        //        --newCount_;
    }

private:
    static ICObjectPool<ICRobotTransceiverData> objectPool_;
};

class ICRobotFrameTransceiverDataMapper : public ICHCFrameTransceiverDataMapper
{
public:
    ICRobotFrameTransceiverDataMapper():ICHCFrameTransceiverDataMapper() {
    }
    bool IsFunctionCodeValid(int fc) const;
    bool IsFunctionAddrValid(int addr, int fc) const;
    int GetAddrFromBuffer(const uint8_t* buffer) const;
    size_t GetBufferDataLength(const uint8_t* buffer) const;
    size_t FrameMinSize() const { return 4;}
//    virtual int NeedToRecvLength(const ICTransceiverData* sentData) const;
    bool FrameToTransceiverData(ICTransceiverData *recvData, const uint8_t *buffer, size_t size, const ICTransceiverData *sentData);
    size_t TransceiverDataToFrame(uint8_t *dest, size_t bufferSize, const ICTransceiverData *data);
private:
    uint8_t tmpButter_[16];
};

inline bool ICRobotFrameTransceiverDataMapper::IsFunctionCodeValid(int fc) const
{
    return (fc == FC_HC_INIT_PARA) ||
            (fc == FC_HC_QUERY_STATUS);
}

inline bool ICRobotFrameTransceiverDataMapper::IsFunctionAddrValid(int addr, int fc) const
{
    switch(fc)
    {
    case FC_HC_INIT_PARA:
    {
        int addrH = addr >> 8;
        return (addrH == 0xC0) || (addrH == 0x40) || (addrH == 0x80) ||
                (addrH >=0 && addrH < 8);
    }
    case FC_HC_QUERY_STATUS:
        return true;
    default:
        return false;
    }
}

inline int ICRobotFrameTransceiverDataMapper::GetAddrFromBuffer(const uint8_t *buffer) const
{
//    return static_cast<ICAddr>((buffer[2] << 8) | buffer[3]);
    Q_UNUSED(buffer)
    return 0;
}

inline size_t ICRobotFrameTransceiverDataMapper::GetBufferDataLength(const uint8_t *buffer) const
{
    Q_UNUSED(buffer)
//    return buffer[FRAME_LENGTH_POS] << 2;
    return 0;
}

#endif // ICROBOTTRANSCEIVERDATA_H
