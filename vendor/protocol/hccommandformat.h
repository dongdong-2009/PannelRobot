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

#define FRAME_HEAD_SIZE 5                    //<֡ͷ��С
#define FRAME_LENGTH_POS FRAME_HEAD_SIZE - 1 //<֡����λ��
#define FRAME_DATA_LENGTH   64               //<����ݳ���
#define FRAME_CRC_LENGTH    2
#define FRAME_MAX_SIZE FRAME_HEAD_SIZE + (FRAME_DATA_LENGTH << 2) + 2
#define FRAME_MIN_SIZE FRAME_HEAD_SIZE + FRAME_CRC_LENGTH
/*! \brief �����붨��
 */
typedef enum _FunctionCode
{
    FunctionCode_BeginSection   = 0x49,     //<�����뿪ʼλ
	FunctionCode_ReadAddr       = 0x50,     //<����ֵַ
	FunctionCode_WriteAddr      = 0x51,     //<д��ֵַ
    FunctionCode_DebugReadAddr  = 0x52,     //<���ڲ�����������ʱʹ��
    FunctionCode_DebugWriteAddr = 0x53,     //<д�ڲ�����������ʱʹ��
    FunctionCode_ReadDiffAddr       = 0x54,     //<����ε�ֵַ
    FunctionCode_WriteDiffAddr      = 0x55,     //<д��ε�ֵַ
	FunctionCode_WriteTeach      = 0x56,     //<д�̵�����
    FunctionCode_EditTeach      = 0x57,     //<�༭�̵�����
	FunctionCode_Err            = 0x60,     //<ͨ�Ŵ���
    FunctionCode_NIL                        //<���������λ
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
