#ifndef ICROBOTTRANSCEIVERDATA_H
#define ICROBOTTRANSCEIVERDATA_H

#include "ichctransceiverdata.h"
#include "vendor/protocol/hccommandformat.h"
#include "vendor/protocol/hccommparagenericdef.h"

#ifndef NEW_PLAT
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
#endif

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

    virtual bool IsQuery() const { return GetFunctionCode() == FunctionCode_ReadAddr;}
    static ICRobotTransceiverData* FillActInitCommand(uint8_t hostID,
                           uint addr,
                           const ICTransceiverDataBuffer& data)
    {
#ifdef NEW_PLAT
        return NULL;
#else
        return new ICRobotTransceiverData(hostID,
                                          FC_HC_INIT_PARA,
                                          addr | 0X4000,
                                          data.size(),
                                          data);
#endif
    }

    static ICRobotTransceiverData* FillFncInitCommand(uint8_t hostID,
                           uint addr,
                           const ICTransceiverDataBuffer& data)
    {
#ifdef NEW_PLAT
        return NULL;
#else
        return new ICRobotTransceiverData(hostID,
                                          FC_HC_INIT_PARA,
                                          addr | 0X8000,
                                          data.size(),
                                          data);
#endif
    }

    static ICRobotTransceiverData* FillSubInitCommand(uint8_t hostID,
                                                      uint group,
                                                      uint addr,
                           const ICTransceiverDataBuffer& data)
    {
#ifdef NEW_PLAT
        return NULL;
#else
        return new ICRobotTransceiverData(hostID,
                                          FC_HC_INIT_PARA,
                                          (group << 8) | addr,
                                          data.size(),
                                          data);
#endif
    }


    static ICRobotTransceiverData* FillMachineConfigInitCommand(uint8_t hostID,
                           uint addr,
                           const ICTransceiverDataBuffer& data)
    {
#ifdef NEW_PLAT
        return NULL;
#else
        return new ICRobotTransceiverData(hostID,
                                          FC_HC_INIT_PARA,
                                          addr | 0XC000,
                                          data.size(),
                                          data);
#endif
    }

    static ICRobotTransceiverData* FillQueryStatusCommand(uint8_t hostID,
                           uint addr)
    {
#ifdef NEW_PLAT
        return new ICRobotTransceiverData(hostID,
                                          FunctionCode_ReadAddr,
                                          addr,
                                          16,
                                          ICTransceiverDataBuffer());
#else
        return new ICRobotTransceiverData(hostID,
                                          FC_HC_QUERY_STATUS,
                                          addr,
                                          4,
                                          ICTransceiverDataBuffer());

#endif
    }

    static ICRobotTransceiverData* FillKeyCommand(uint8_t hostID,
                                                  int cmd,
                                                  int key,
                                                  int act,
                                                  int sum)
    {
#ifdef NEW_PLAT
        return new ICRobotTransceiverData(hostID,
                                          FunctionCode_WriteAddr,
                                          ICAddr_System_Retain_0,
                                          1,
                                          ICTransceiverDataBuffer()<<cmd);
#else
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
#endif
    }

    static ICRobotTransceiverData* FillWriteConfigCommand(uint8_t hostID,
                                                          int addr,
                                                          int value)
    {
#ifdef NEW_PLAT
        return new ICRobotTransceiverData(hostID,
                                          FunctionCode_WriteAddr,
                                          addr,
                                          1,
                                          ICTransceiverDataBuffer()<<value);
#else
#endif
    }

    virtual bool IsError() const { return (GetFunctionCode() & 0x80) > 0;}

#ifdef NEW_PLAT
    virtual int ErrorCode() const
    {
        if(!IsError()) return 0;
        return Data().at(0);
    }
    virtual int MaxFrameLength() const { return 256;}
//    void SetErrorCode(int ec) { Data().append(ec); }
#else
    virtual int ErrorCode() const { return GetAddr() & 0xFF;}
    void SetErrorCode(int ec) { SetAddr(ec);}
    virtual int MaxFrameLength() const { return 16;}
#endif

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
//    virtual int NeedToRecvLength(const ICTransceiverData* sentData) const;
#ifdef NEW_PLAT
    size_t FrameMinSize() const { return FRAME_MIN_SIZE;}
    int NeedToRecvLength(const ICTransceiverData* sentData) const;
#else
    bool FrameToTransceiverData(ICTransceiverData *recvData, const uint8_t *buffer, size_t size, const ICTransceiverData *sentData);
    size_t TransceiverDataToFrame(uint8_t *dest, size_t bufferSize, const ICTransceiverData *data);
    size_t FrameMinSize() const { return 4;}
#endif
private:
    uint8_t tmpButter_[16];
};

inline bool ICRobotFrameTransceiverDataMapper::IsFunctionCodeValid(int fc) const
{
#ifdef NEW_PLAT
    return (fc == FunctionCode_ReadAddr) ||
            (fc == FunctionCode_ReadDiffAddr) ||
            (fc == FunctionCode_WriteAddr) ||
            (fc == FunctionCode_WriteDiffAddr) ||
            (fc == FunctionCode_Err);
#else
    return (fc == FC_HC_QUERY_STATUS) ||
            (fc == FC_HC_INIT_PARA);
#endif
}

inline bool ICRobotFrameTransceiverDataMapper::IsFunctionAddrValid(int addr, int fc) const
{
#ifdef NEW_PLAT
    switch(fc)
       {
       case FunctionCode_ReadAddr:
       case FunctionCode_ReadDiffAddr:
           return ((addr > ICAddr_BeginSection) && (addr < ICAddr_Read_Section_End))||
                   (addr == ICAddr_System_Retain_1);
       case FunctionCode_WriteAddr:
           return (addr > ICAddr_BeginSection);
       case FunctionCode_Err:
           return addr == ICAddr_ErrAddr;
       default:
           return false;
       }
#else
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
#endif
}

inline int ICRobotFrameTransceiverDataMapper::GetAddrFromBuffer(const uint8_t *buffer) const
{
#ifdef NEW_PLAT
    return static_cast<ICAddr>((buffer[2] << 8) | buffer[3]);
#else
    //    return static_cast<ICAddr>((buffer[2] << 8) | buffer[3]);
    Q_UNUSED(buffer)
    return 0;
#endif
}

inline size_t ICRobotFrameTransceiverDataMapper::GetBufferDataLength(const uint8_t *buffer) const
{
#ifdef NEW_PLAT
    return buffer[FRAME_LENGTH_POS] << 2;
#else
    Q_UNUSED(buffer)
//    return buffer[FRAME_LENGTH_POS] << 2;
    return 0;
#endif
}

#endif // ICROBOTTRANSCEIVERDATA_H
