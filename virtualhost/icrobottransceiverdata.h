#ifndef ICROBOTTRANSCEIVERDATA_H
#define ICROBOTTRANSCEIVERDATA_H

#include "ichctransceiverdata.h"

#define CMDPULSEA			0x60
#define CMDPULSEB           0x61
#define CMDTURNAUTO			0x80
#define CMDTURNMANUAL		0x81
#define CMDTURNSTOP			0x82
#define CMDTURNTEACH		0x83
#define CMDTURNZERO			0x84
#define CMDTURNRET			0x85
#define CMDTURNTCHSUB0		0x90
#define CMDTURNTCHSUB1		0x91
#define CMDTURNTCHSUB2		0x92
#define CMDTURNTCHSUB3		0x93
#define CMDTURNTCHSUB4		0x94
#define CMDTURNTCHSUB5		0x95
#define CMDTURNTCHSUB6		0x96
#define CMDTURNTCHSUB7		0x97
#define CMDTURNTCHSUB8		0x98
#define CMDTEACH			0x33	//教导回传
#define CMDGETAXISCONFIG    0x99
#define CMDSELECTCONFIG     0x9a

enum FunctionCode{
    FC_HC_QUERY_STATUS = 0x02,
    FC_HC_INIT_PARA    = 0x06,
    FC_HC_COMMAND      = 0x40

};

enum CommErrorCode{
    COMMEC_NeedToInit = 0x16,
    COMMEC_WrongFrameFormat = 0x50,
    COMMEC_CRCNoEqual = 0x51,

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


    static ICRobotTransceiverData* FillMachineConfigInitCommand(uint8_t hostID,
                           uint addr,
                           const ICTransceiverDataBuffer& data)
    {
        return new ICRobotTransceiverData(hostID,
                                          FC_HC_INIT_PARA,
                                          addr | 0XC000,
                                          data.size(),
                                          data);
    }

    static ICRobotTransceiverData* FillQueryStatusCommand(uint8_t hostID,
                           uint addr)
    {
        return new ICRobotTransceiverData(hostID,
                                          FC_HC_QUERY_STATUS,
                                          addr,
                                          4,
                                          ICTransceiverDataBuffer());
    }

    static ICRobotTransceiverData* FillKeyCommand(uint8_t hostID,
                                                  int cmd,
                                                  int key,
                                                  int act,
                                                  int sum)
    {
        int addr = cmd;
        int l;
        switch(cmd)
        {
        case CMDPULSEA:
        case CMDPULSEB:
        {
            addr |= (key & 0xFF) << 8;
            l = key >> 8;
        }
            break;
        case CMDTURNTEACH:
        case CMDTURNAUTO:
        case CMDTURNTCHSUB0:
        case CMDTURNTCHSUB1:
        case CMDTURNTCHSUB2:
        case CMDTURNTCHSUB3:
        case CMDTURNTCHSUB4:
        case CMDTURNTCHSUB5:
        case CMDTURNTCHSUB6:
        case CMDTURNTCHSUB7:
        case CMDTURNTCHSUB8:
        {
            addr |= (act & 0x00FF) << 8;
            l = sum & 0x00FF;
        }
            break;
        default:
        {
            addr |= (key & 0xFF) << 8;
            l = 0;
        }
        }

        return new ICRobotTransceiverData(hostID,
                                          FC_HC_COMMAND,
                                          addr,
                                          l,
                                          ICTransceiverDataBuffer());
    }


    virtual bool IsError() const { return (GetFunctionCode() & 0x80) > 0;}
    virtual int MaxFrameLength() const { return 16;}
    virtual int ErrorCode() const { return GetAddr() & 0xFF;}
    void SetErrorCode(int ec) { SetAddr(ec);}

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
        return addr >= 0 && addr <= 44;
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
