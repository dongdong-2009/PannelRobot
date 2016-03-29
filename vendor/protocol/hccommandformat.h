/*
 * File:   hccommandformat.h
 * Author: gausscheng
 *
 * Created on June 11, 2012, 3:45 PM
 */

#ifndef HCCOMMANDFORMAT_H
#define HCCOMMANDFORMAT_H

#ifdef __cplusplus
extern "C"
  {
#endif

#define FRAME_HEAD_SIZE 5                    //<帧头大小
#define FRAME_LENGTH_POS FRAME_HEAD_SIZE - 1 //<帧长度位置
#define FRAME_DATA_LENGTH   64               //<最长数据长度
#define FRAME_CRC_LENGTH    2
#define FRAME_MAX_SIZE FRAME_HEAD_SIZE + (FRAME_DATA_LENGTH << 2) + 2
#define FRAME_MIN_SIZE FRAME_HEAD_SIZE + FRAME_CRC_LENGTH
/*! \brief 功能码定义
 */
typedef enum _FunctionCode
{
    FunctionCode_BeginSection   = 0x49,     //<功能码开始位
	FunctionCode_ReadAddr       = 0x50,     //<读地址值
	FunctionCode_WriteAddr      = 0x51,     //<写地址值
    FunctionCode_DebugReadAddr  = 0x52,     //<读内部变量，测试时使用
    FunctionCode_DebugWriteAddr = 0x53,     //<写内部变量，测试时使用
    FunctionCode_ReadDiffAddr       = 0x54,     //<读多段地址值
    FunctionCode_WriteDiffAddr      = 0x55,     //<写多段地址值
	FunctionCode_WriteTeach      = 0x56,     //<写教导程序
    FunctionCode_EditTeach      = 0x57,     //<编辑教导程序
    FunctionCode_WriteStack      = 0x58,     //<写不规则堆叠信息
    FunctionCode_EditStack      = 0x59,     //<编辑不规则堆叠信息
	FunctionCode_Err            = 0x60,     //<通信错误
    FunctionCode_NIL                        //<功能码结束位
} FunctionCode;

typedef enum _ICComErr
{
    ICComErr_LessThanHeadSize,
    ICComErr_LessThanTotalSize,
    ICComErr_WrongFunctionCode,
    ICComErr_WrongAddr,
    ICComErr_WrongLengthValue,
    ICComErr_DataAndLengthDifferent,
    ICComErr_CheckCRCError,
    ICComErr_IDError,
    ICComErr_Count
}ICComErr;

#define HC_PARA_BeginSection        0u
#define HC_PARA_SIZE                2048u
#define HC_PARA_WRITE_SECTION_SIZE  1536u
#define HC_PARA_READ_SECTION_SIZE   (HC_PARA_SIZE - HC_PARA_WRITE_SECTION_SIZE)
#define HC_PARA_WRITE_SECTION_End   (HC_PARA_BeginSection + HC_PARA_WRITE_SECTION_SIZE)
#define HC_PARA_NIL                 (HC_PARA_BeginSection + HC_PARA_SIZE)

#ifdef __cplusplus
  }
#endif
#endif//#ifndef HCCOMMANDFORMAT_H
