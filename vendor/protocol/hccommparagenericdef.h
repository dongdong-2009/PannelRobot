/*
 * File:   hccommparagenericdef.h
 * Author: xs
 *
 * Created on June 12, 2012, 1:53 PM
 */

#ifndef HCCOMMPARAGENERICDEF_H
#define HCCOMMPARAGENERICDEF_H

#include "stdint.h"
#ifdef __cplusplus
extern "C"
{
#endif

#define STRUCE_SIZE(a,b) (b-a+1)


#define SOFTWARE_VERSION  "HC_S3_S5_NEW-0.1-0.1"

/*! \brief 参数地址枚举 */
typedef enum _ICAddr
{
    ICAddr_BeginSection, //<参数地址开头哨兵0
    /***************************************************************************************/
    // 系统保留区
    ICAddr_System_Retain_Start,
    ICAddr_System_Retain_0=1, //< 按键命令地址
    ICAddr_System_Retain_1,//< 版本号地址
    ICAddr_System_Retain_25 = 25,//< 2:升级 10：X轴原点设定； 11：Y轴原点设定；12：Z轴原点设定；
    //< 13：U轴原点设定；14：V轴原点设定；15：W轴原点设定；16：全部轴原点设定；17 保存每个轴当前位置
    //< 18：前八个显示 输出累计值；19：前8个显示 当前Z脉冲；20：前8个显示实际反馈累计值；21：前8个显示
    //< 实际位置值
    ICAddr_System_Retain_80 = 80,//< 教导参数数据长度 高8位：程序ID；低24位：程序长度
    ICAddr_System_Retain_81 = 81,//< 教导参数数据初始化
    ICAddr_System_Retain_End = 99,
    /***************************************************************************************/
    ICAddr_Adapter_Para0, //<类型:系统;名字:电机1;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para1, //<类型:系统;名字:电机1;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para2, //<类型:系统;名字:电机1;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para3, //<类型:系统;名字:电机1;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para4, //<类型:系统;名字:电机1;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para5, //<类型:系统;名字:电机1;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para6, //<类型:系统;名字:电机1;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para7, //<类型:系统;名字:电机2;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para8, //<类型:系统;名字:电机2;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para9, //<类型:系统;名字:电机2;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para10, //<类型:系统;名字:电机2;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para11, //<类型:系统;名字:电机2;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para12, //<类型:系统;名字:电机2;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para13, //<类型:系统;名字:电机2;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para14, //<类型:系统;名字:电机3;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para15, //<类型:系统;名字:电机3;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para16, //<类型:系统;名字:电机3;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para17, //<类型:系统;名字:电机3;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para18, //<类型:系统;名字:电机3;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para19, //<类型:系统;名字:电机3;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para20, //<类型:系统;名字:电机3;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para21, //<类型:系统;名字:电机4;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para22, //<类型:系统;名字:电机4;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para23, //<类型:系统;名字:电机4;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para24, //<类型:系统;名字:电机4;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para25, //<类型:系统;名字:电机4;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para26, //<类型:系统;名字:电机4;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para27, //<类型:系统;名字:电机4;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para28, //<类型:系统;名字:电机5;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para29, //<类型:系统;名字:电机5;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para30, //<类型:系统;名字:电机5;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para31, //<类型:系统;名字:电机5;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para32, //<类型:系统;名字:电机5;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para33, //<类型:系统;名字:电机5;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para34, //<类型:系统;名字:电机5;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para35, //<类型:系统;名字:电机6;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para36, //<类型:系统;名字:电机6;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para37, //<类型:系统;名字:电机6;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para38, //<类型:系统;名字:电机6;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para39, //<类型:系统;名字:电机6;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para40, //<类型:系统;名字:电机6;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para41, //<类型:系统;名字:电机6;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para42, //<类型:系统;名字:电机7;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para43, //<类型:系统;名字:电机7;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para44, //<类型:系统;名字:电机7;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para45, //<类型:系统;名字:电机7;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para46, //<类型:系统;名字:电机7;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para47, //<类型:系统;名字:电机7;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para48, //<类型:系统;名字:电机7;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para49, //<类型:系统;名字:电机8;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para50, //<类型:系统;名字:电机8;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para51, //<类型:系统;名字:电机8;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para52, //<类型:系统;名字:电机8;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para53, //<类型:系统;名字:电机8;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para54, //<类型:系统;名字:电机8;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para55, //<类型:系统;名字:电机8;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para56, //<类型:系统;名字:电机配置crc;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para57, //<类型:系统;名字:插补1最大线速度;结构:Interpolation_Config;地址:Inter_cfg;
    ICAddr_Adapter_Para58, //<类型:系统;名字:插补1最小加速时间_二次加速时间比例;结构:Interpolation_Config;地址:Inter_cfg;
    ICAddr_Adapter_Para59, //<类型:系统;名字:插补2最大线速度;结构:Interpolation_Config;地址:Inter_cfg;
    ICAddr_Adapter_Para60, //<类型:系统;名字:插补2最小加速时间_二次加速时间比例;结构:Interpolation_Config;地址:Inter_cfg;
    ICAddr_Adapter_Para61, //<类型:系统;名字:插补3最大线速度;结构:Interpolation_Config;地址:Inter_cfg;
    ICAddr_Adapter_Para62, //<类型:系统;名字:插补3最小加速时间_二次加速时间比例;结构:Interpolation_Config;地址:Inter_cfg;
    ICAddr_Adapter_Para63, //<类型:系统;名字:插补4最大线速度;结构:Interpolation_Config;地址:Inter_cfg;
    ICAddr_Adapter_Para64, //<类型:系统;名字:插补4最小加速时间_二次加速时间比例;结构:Interpolation_Config;地址:Inter_cfg;
    ICAddr_Adapter_Para65, //<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para66, //<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para67, //<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para68, //<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para69, //<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para70, //<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para71, //<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para72, //<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para73, //<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para74, //<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para75, //<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para76, //<类型:系统;名字:逻辑输出端口;结构:OUTPUT;地址:output_addr;
    ICAddr_Adapter_Para77, //<类型:系统;名字:逻辑输出端口;结构:OUTPUT;地址:output_addr;
    ICAddr_Adapter_Para78, //<类型:系统;名字:逻辑输出端口;结构:OUTPUT;地址:output_addr;
    ICAddr_Adapter_Para79, //<类型:系统;名字:逻辑输出端口;结构:OUTPUT;地址:output_addr;
    ICAddr_Adapter_Para80, //<类型:系统;名字:逻辑输出端口;结构:OUTPUT;地址:output_addr;
    ICAddr_Adapter_Para81, //<类型:系统;名字:当前延时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para82, //<类型:系统;名字:当前延时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para83, //<类型:系统;名字:当前延时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para84, //<类型:系统;名字:当前延时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para85, //<类型:系统;名字:目标延时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para86, //<类型:系统;名字:目标延时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para87, //<类型:系统;名字:目标延时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para88, //<类型:系统;名字:目标延时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para89, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para90, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para91, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para92, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para93, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para94, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para95, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para96, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para97, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para98, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para99, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para100, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para101, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para102, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para103, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para104, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para105, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para106, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para107, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para108, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para109, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para110, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para111, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para112, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para113, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para114, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para115, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para116, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para117, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para118, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para119, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para120, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para121, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para122, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para123, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para124, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para125, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para126, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para127, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para128, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para129, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para130, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para131, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para132, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para133, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para134, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para135, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para136, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para137, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para138, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para139, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para140, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para141, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para142, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para143, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para144, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para145, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para146, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para147, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para148, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para149, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para150, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para151, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para152, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para153, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para154, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para155, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para156, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para157, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para158, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para159, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para160, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para161, //<类型:系统;名字:逻辑电机对应的脉冲端口;结构:AXIS_MAP;地址:axis_map_addr;
    ICAddr_Adapter_Para162, //<类型:系统;名字:逻辑电机对应的脉冲端口;结构:AXIS_MAP;地址:axis_map_addr;
    ICAddr_Adapter_Para163, //<类型:系统;名字:逻辑电机对应的脉冲端口;结构:AXIS_MAP;地址:axis_map_addr;
    ICAddr_Adapter_Para164, //<类型:系统;名字:逻辑电机对应的脉冲端口;结构:AXIS_MAP;地址:axis_map_addr;
    ICAddr_Adapter_Para165, //<类型:系统;名字:设定速度;结构:Interpolation;地址:Interpolation_addr;
    ICAddr_Adapter_Para166, //<类型:系统;名字:设定速度;结构:Interpolation;地址:Interpolation_addr;
    ICAddr_Adapter_Para167, //<类型:系统;名字:设定速度;结构:Interpolation;地址:Interpolation_addr;
    ICAddr_Adapter_Para168, //<类型:系统;名字:设定速度;结构:Interpolation;地址:Interpolation_addr;
    ICAddr_Adapter_Para169, //<类型:系统;名字:V轴初始夹角;结构:ALPHA;地址:alpha_addr;
    ICAddr_Adapter_Para170, //<类型:系统;名字:V轴初始夹角;结构:ALPHA;地址:alpha_addr;
    ICAddr_Adapter_Para171, //<类型:系统;名字:V轴初始夹角;结构:ALPHA;地址:alpha_addr;
    ICAddr_Adapter_Para172, //<类型:系统;名字:V轴初始夹角;结构:ALPHA;地址:alpha_addr;

    ICAddr_Adapter_Para255 = 356,

    ICAddr_Mold_Para0,//<类型:模号;名字:;结构:MOLD_PRO_USE;地址:mold_use_p_addr;
//    ICAddr_Mold_Para1,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para2,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para3,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para4,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para5,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para6,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para7,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para8,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para9,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para10,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para11,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para12,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para13,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para14,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para15,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para16,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para17,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para18,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para19,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para20,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para21,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para22,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para23,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para24,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para25,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para26,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para27,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para28,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para29,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para30,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para31,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para32,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para33,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para34,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para35,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para36,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para37,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para38,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para39,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para40,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para41,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para42,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para43,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para44,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para45,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para46,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para47,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para48,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para49,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para50,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para51,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para52,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para53,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para54,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para55,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para56,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para57,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para58,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para59,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para60,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para61,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para62,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para63,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para64,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para65,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para66,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para67,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para68,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;
//    ICAddr_Mold_Para69,//<类型:模号;名字:速度;结构:MOLD_PARA;地址:mold_addr;




    ICAddr_Write_Section_End = 899, //<可写参数地址段结束哨兵

    ICAddr_Read_Status0 = 900, //<类型：状态；名字：轴1当前输出脉冲位置;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status1,       //<类型：状态；名字：轴1实际脉冲位置;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status2,       //<类型：状态；名字：轴1速度百分比_当前速度;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status3,       //<类型：状态；名字：轴1当前加速度_当前二次加速度;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status4,       //<类型：状态；名字：轴2当前输出脉冲位置;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status5,       //<类型：状态；名字：轴2实际脉冲位置;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status6,       //<类型：状态；名字：轴2速度百分比_当前速度;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status7,       //<类型：状态；名字：轴2当前加速度_当前二次加速度;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status8,       //<类型：状态；名字：轴3当前输出脉冲位置;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status9,       //<类型：状态；名字：轴3实际脉冲位置;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status10,      //<类型：状态；名字：轴3速度百分比_当前速度;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status11,      //<类型：状态；名字：轴3当前加速度_当前二次加速度;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status12,      //<类型：状态；名字：轴4当前输出脉冲位置;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status13,      //<类型：状态；名字：轴4实际脉冲位置;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status14,      //<类型：状态；名字：轴4速度百分比_当前速度;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status15,      //<类型：状态；名字：轴4当前加速度_当前二次加速度;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status16,      //<类型：状态；名字：轴5当前输出脉冲位置;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status17,      //<类型：状态；名字：轴5实际脉冲位置;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status18,      //<类型：状态；名字：轴5速度百分比_当前速度;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status19,      //<类型：状态；名字：轴5当前加速度_当前二次加速度;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status20,      //<类型：状态；名字：轴6当前输出脉冲位置;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status21,      //<类型：状态；名字：轴6实际脉冲位置;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status22,      //<类型：状态；名字：轴6速度百分比_当前速度;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status23,      //<类型：状态；名字：轴6当前加速度_当前二次加速度;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status24,      //<类型：状态；名字：轴7当前输出脉冲位置;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status25,      //<类型：状态；名字：轴7实际脉冲位置;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status26,      //<类型：状态；名字：轴7速度百分比_当前速度;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status27,      //<类型：状态；名字：轴7当前加速度_当前二次加速度;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status28,      //<类型：状态；名字：轴8当前输出脉冲位置;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status29,      //<类型：状态；名字：轴8实际脉冲位置;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status30,      //<类型：状态；名字：轴8速度百分比_当前速度;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status31,      //<类型：状态；名字：轴8当前加速度_当前二次加速度;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status32,      //<类型：状态；名字：报警;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status33,    //<类型：状态；名字：步号;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status34,    //<类型：状态；名字：步号;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status35,    //<类型：状态；名字：步号;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status36,    //<类型：状态；名字：步号;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status37,    //<类型：状态；名字：步号;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status38,    //<类型：状态；名字：步号;结构:READ_PARA;地址:read_addr;
//    ICAddr_Read_Status39,
//    ICAddr_Read_Status40,
//    ICAddr_Read_Status41,
//    ICAddr_Read_Status42,

    ICAddr_Read_Section_End = 1000, //<
    ICAddr_ErrAddr, //<错误帧用的地址
    ICAddr_NIL //<参数地址结束哨兵
} ICAddr;

/*! \brief 命令字枚举*/
typedef enum
{
    CMD_NULL, //< 无命令
    CMD_MANUAL, //< 手动命令
    CMD_AUTO, //< 自动命令
    CMD_CONFIG, //< 配置命令
    CMD_IO, // IO命令
    CMD_ORIGIN, // 原点模式

    CMD_POWER_OFF0 = 0x0100,  // 第一个逻辑电机关闭
    CMD_POWER_OFF  = 0x017F,  // 所有逻辑电机关闭
    CMD_POWER_ON0  = 0x0180,  // 第一个逻辑电机开机
    CMD_POWER_ON  = 0x01FF, // 所有逻辑电机开机

    CMD_JOG_N0     = 0x0200,    // 关节坐标系，第一个轴反向点动
    CMD_JOG_P0     = 0x0280,  // 关节坐标系，第一个轴正向点动

    CMD_JOG_PX     = 0x0300,  // 直角坐标系位置轴，X轴正向点动
    CMD_JOG_PY     = 0x0301,  // 直角坐标系位置轴，Y轴正向点动
    CMD_JOG_PZ     = 0x0302,  // 直角坐标系位置轴，Z轴正向点动
    CMD_JOG_PU     = 0x0303,  // 直角坐标系姿势轴，U轴正向点动
    CMD_JOG_PV     = 0x0304,  // 直角坐标系姿势轴，V轴正向点动
    CMD_JOG_PW     = 0x0305,  // 直角坐标系姿势轴，W轴正向点动
    CMD_JOG_PR     = 0x0306,  // 极坐标系，远离原点点动

    CMD_MOVE_POINT = 0x0310,  // 直角坐标系内点到点直线运动
    CMD_MOVE_ARC   = 0x0330,  // 直角坐标系内圆弧线运动
    CMD_GET_COORDINATE= 0x0340,  // 记录当前坐标

    CMD_JOG_NX     = 0x0380,  // 直角坐标系位置轴，X轴反向点动
    CMD_JOG_NY     = 0x0381,  // 直角坐标系位置轴，Y轴反向点动
    CMD_JOG_NZ     = 0x0382,  // 直角坐标系位置轴，Z轴反向点动
    CMD_JOG_NU     = 0x0383,  // 直角坐标系姿势轴，U轴反向点动
    CMD_JOG_NV     = 0x0384,  // 直角坐标系姿势轴，V轴反向点动
    CMD_JOG_NW     = 0x0385,  // 直角坐标系姿势轴，W轴反向点动
    CMD_JOG_NR     = 0x0386,  // 极坐标系，靠近原点点动

    CMD_FIND_ZERO0 = 0x0400,  // 第一个逻辑轴，找零
    CMD_FIND_ZERO  = 0x047F,  // 所有逻辑轴，同时找零

    CMD_GO_HOME0   = 0x0500,  // 第一个逻辑轴，回零点
    CMD_GO_HOME    = 0x057F,  // 所有逻辑轴，同时回零点

    CMD_STOP0      = 0x0600,  // 立即停止第一个逻辑轴相关的运动- 回零、找零等
    CMD_STOP       = 0x067F,  // 立即停止所有逻辑轴的运动- 回零、找零等
    CMD_SLOW_STOP0 = 0x0680,  // 减速停止第一个逻辑轴相关的运动- 回零、找零等
    CMD_SLOW_STOP  = 0x06FF,  // 减速停止所有逻辑轴的运动- 回零、找零等

    CMD_RUN_LENGTH_P0 = 0x0700, // 第一个逻辑轴-运行正向测试脉冲，带一个参数- 正脉冲数
    CMD_RUN_LENGTH_N0 = 0x0780, // 第一个逻辑轴-运行反向测试脉冲，带一个参数- 正脉冲数

    CMD_IO_OUT_P0  = 0x0800,  // 第一个IO端口输出高
    CMD_IO_OUT_N0  = 0x0900,    // 第一个IO端口输出低


    CMD_KEY_RUN      = 0x0A00,//< 启动命令
    CMD_KEY_STOP     = 0x0A01,//< 停止命令
    CMD_KEY_ORIGIN   = 0x0A02,//< 原点命令
    CMD_KEY_RETURN   = 0x0A03,//< 复归命令
    CMD_KEY_UP       = 0x0A04,//< 上命令
    CMD_KEY_DOWN     = 0x0A05,//< 下命令


    CMD_USE_HOST_PARA     = 0x1000,//< 选择使用主机参数
    CMD_USE_HANDCTRL_PARA     = 0x1001,//< 选择使用手控参数
    CMD_INVALID = 0x7FFF

} DATA_CMD;


/*! \brief 教导动作功能码枚举*/
typedef enum
{
	F_CMD_NULL,
	F_CMD_SYNC_START,     //< 同步功能开始
	F_CMD_SYNC_END,       //< 同步功能结束
	F_CMD_SINGLE,         //< 单轴动作 电机ID 位置 速度  延时
	F_CMD_CoordinatePoint,//< 坐标点运动 坐标（X，Y，Z） 速度  延时
	F_CMD_SINGLE_POINT,   //< 单轴按点位动作 电机ID 位置 速度  延时
	F_CMD_LINE2D_MOVE_POINT,   //< 2轴按点位直线运动 坐标（X，Y） 速度  延时
	F_CMD_LINE3D_MOVE_POINT,   //< 3轴按点位直线运动 坐标（X，Y，Z） 速度  延时


    F_CMD_PROGRAM_JUMP0=10000,   //< 程序无条件跳转 跳转步号
    F_CMD_PROGRAM_JUMP1,   //< 程序跳转 跳转步号 跳转命令（ON/OFF） 跳转条件
    F_CMD_PROGRAM_JUMP2,   //< 程序跳转 跳转步号 跳转命令（>/</==）跳转位置
//    F_CMD_PROGRAM_JUMP3,   //< 程序跳转 跳转步号
//    F_CMD_PROGRAM_JUMP4,   //< 程序跳转 跳转步号

    F_CMD_NOTES = 50000,   //< 注释该行教导程序
	F_CMD_END=60000//< 动作结束

}FunctionCmd;

typedef enum
{
    ALARM_NULL = 0,
    ALARM_NOT_INIT, //<名字：未初始化完
    ALARM_AXIS_CFG_DIFF, //<名字：主机轴配置和手控轴配置不同
    ALARM_AXIS_CFG_ERR, //<名字：主机轴配置参数错误
    ALARM_OUT_OF_MEMORY_ERR, //<名字：内存不足
    ALARM_TEACH_DATA_ANALYTICAL_ERR, //<名字：教导数据解析错误
    ALARM_TEACH_DATA_EDIT_ERR, //<名字：教导数据编辑错误

    ALARM_AXIS_RUN_ERR = 100,//<名字：轴1运动失败
    ALARM_AXIS2_RUN_ERR,//<名字：轴2运动失败
    ALARM_AXIS3_RUN_ERR,//<名字：轴3运动失败
    ALARM_AXIS4_RUN_ERR,//<名字：轴4运动失败
    ALARM_AXIS5_RUN_ERR,//<名字：轴5运动失败
    ALARM_AXIS6_RUN_ERR,//<名字：轴6运动失败
    ALARM_AXIS_SPEED_SET_ERR = 110,//<名字：轴1速度设定错误
    ALARM_AXIS2_SPEED_SET_ERR,//<名字：轴2速度设定错误
    ALARM_AXIS3_SPEED_SET_ERR,//<名字：轴3速度设定错误
    ALARM_AXIS4_SPEED_SET_ERR,//<名字：轴4速度设定错误
    ALARM_AXIS5_SPEED_SET_ERR,//<名字：轴5速度设定错误
    ALARM_AXIS6_SPEED_SET_ERR,//<名字：轴6速度设定错误
    ALARM_AXIS_OVER_SPEED_ERR = 120,//<名字：轴1运动过速
    ALARM_AXIS2_OVER_SPEED_ERR,//<名字：轴2运动过速
    ALARM_AXIS3_OVER_SPEED_ERR,//<名字：轴3运动过速
    ALARM_AXIS4_OVER_SPEED_ERR,//<名字：轴4运动过速
    ALARM_AXIS5_OVER_SPEED_ERR,//<名字：轴5运动过速
    ALARM_AXIS6_OVER_SPEED_ERR //<名字：轴6运动过速
}ALARM_ADDR;

/*******************************************************************************/
static const uint32_t axis_cfg_addr[] = {
    ICAddr_Adapter_Para0, //<类型：系统；名字：电机1；结构：Axis_Config；地址：axis_cfg_addr；
    ICAddr_Adapter_Para56, //<类型：系统；名字：；结构：Axis_Config；地址：axis_cfg_addr；
};

typedef struct {  //<192 + 14X8 = 304
    uint32_t length;           //<类型：系统；名字：臂长/半径；精度：3;单位：mm；
    uint32_t ppc;              //<类型：系统；名字：每转脉冲数；精度：0;单位：num；
    uint32_t soft_limit_p;     //<类型：系统；名字：正向软极限；精度：3;单位：mm；
    uint32_t soft_limit_n;     //<类型：系统；名字：负向软极限；精度：3;单位：mm；
    uint32_t limit_p:8;        //<类型：系统；名字：正向极限输入；精度：0;单位：；
    uint32_t limit_n:8;        //<类型：系统；名字：负向极限输入；精度：0;单位：；
    uint32_t origin:8;         //<类型：系统；名字：原点输入；精度：0;单位：；
    uint32_t reserve0:8;       //<类型：系统；名字：预留；精度：0;单位：；
    uint16_t reserve1;         //<类型：系统；名字：预留；精度：0;单位：；
    uint16_t max_speed;        //<类型：系统；名字：最高转速RPM；精度：1;单位：rpm；
    uint16_t min_acc_time;     //<类型：系统；名字：最小加速时间毫秒；精度：3;单位：s；
    uint16_t sratio;           //<类型：系统；名字：二次加速时间比例；精度：3;单位：；
}Axis_Config0;

typedef struct {
    Axis_Config0 para[8];
    uint32_t crc;//<类型:系统;名字:电机配置crc;精度：0;单位：；
}Axis_Config1;


typedef union {
    Axis_Config1 para;
    uint32_t all[STRUCE_SIZE(ICAddr_Adapter_Para0, ICAddr_Adapter_Para56)];
}Axis_Config;


static const uint32_t Inter_cfg[] = {
    ICAddr_Adapter_Para57, //<类型：模号；名字：电机1臂长/半径；结构：Axis_Config0；地址：axis_cfg_addr；
    ICAddr_Adapter_Para64, //<类型：系统；名字：；结构：Axis_Config0；地址：axis_cfg_addr；
};
typedef struct {  //<类型:系统;最多 4组插补，目前仅用第1组   //<- 312+6X4 = 336
    uint32_t max_speed;   //<类型：系统；名字：最大线速度；精度：3;单位：mm/s；
    uint16_t min_acc_time;  //<类型：系统；名字：最小加速时间；精度：3;单位：ms；
    uint16_t sratio;    //<类型：系统；名字：二次加速时间比例；精度：3;单位：；
}Interpolation_Config0;

typedef struct {  //<类型:系统;最多 4组插补，目前仅用第1组   //<- 312+6X4 = 336
  Interpolation_Config0 inter_cfg[4];
}Interpolation_Config1;

typedef union {
    Interpolation_Config1 para;
    uint32_t all[STRUCE_SIZE(ICAddr_Adapter_Para57, ICAddr_Adapter_Para64)];
} Interpolation_Config;


typedef struct {  //<336 + 8X8 = 400
    uint32_t position;   //<类型：状态；名字：当前输出脉冲位置；精度：0;单位：；
    uint32_t pulse_in;   //<类型：状态；名字：实际脉冲位置；精度：0;单位：；
    uint32_t speed_percent:16;  //<类型：状态；名字：速度百分比；精度：0;单位：；
    uint32_t cur_speed:16;   //<类型：状态；名字：当前速度；精度：0;单位：；
    uint32_t cur_acc:16;   //<类型：状态；名字：当前加速度；精度：0;单位：；
    uint32_t cur_sacc:16;   //<类型：状态；名字：当前二次加速度；精度：0;单位：；
} Axis_Data;



typedef union {  //<336 + 8X8 = 400
    struct{
        uint32_t step0:16;//<类型：状态；名字：主程序当前步号；精度：0;单位：；
        uint32_t step1:16;//<类型：状态；名字：子程序1当前步号；精度：0;单位：；
        uint32_t step2:16;//<类型：状态；名字：子程序2当前步号；精度：0;单位：；
        uint32_t step3:16;//<类型：状态；名字：子程序3当前步号；精度：0;单位：；
        uint32_t step4:16;//<类型：状态；名字：子程序4当前步号；精度：0;单位：；
        uint32_t step5:16;//<类型：状态；名字：子程序5当前步号；精度：0;单位：；
        uint32_t step6:16;//<类型：状态；名字：子程序6当前步号；精度：0;单位：；
        uint32_t step7:16;//<类型：状态；名字：子程序7当前步号；精度：0;单位：；
        uint32_t step8:16;//<类型：状态；名字：子程序8当前步号；精度：0;单位：；
        uint32_t step9:16;//<类型：状态；名字：预留；精度：0;单位：；
    }s;
    uint16_t all[10];
    uint32_t all_32[5];
} STEP;


static const uint32_t Interpolation_addr[] = {
    ICAddr_Adapter_Para165, //<类型：模号；名字：电机1臂长/半径；结构：Axis_Config0；地址：axis_cfg_addr；
    ICAddr_Adapter_Para168, //<类型：系统；名字：；结构：Axis_Config0；地址：axis_cfg_addr；
};
typedef struct {  //<400 + 6X4 = 424
    uint16_t speed_percent;   //<类型：系统；名字：设定速度；精度：3;单位：mm/s；
} Interpolation0;

typedef struct {
    Interpolation0 p[8];   //<类型：系统；名字：设定速度；精度：3;单位：mm/s；
} InterpolationStruct;

typedef union {
    InterpolationStruct para;
    uint32_t all[STRUCE_SIZE(ICAddr_Adapter_Para165, ICAddr_Adapter_Para168)];
} Interpolation;


static const uint32_t input_addr[] = {
    ICAddr_Adapter_Para65, //<类型：模号；名字：电机1臂长/半径；结构：Axis_Config0；地址：axis_cfg_addr；
    ICAddr_Adapter_Para75, //<类型：系统；名字：；结构：Axis_Config0；地址：axis_cfg_addr；
};
typedef struct {  //<400 + 6X4 = 424
    uint16_t in0;   //<类型：系统；名字：输入点；精度：0;单位：；
    uint16_t in1;   //<类型：系统；名字：输入点；精度：0;单位：；
    uint16_t in2;   //<类型：系统；名字：输入点；精度：0;单位：；
    uint16_t in3;   //<类型：系统；名字：输入点；精度：0;单位：；
    uint16_t in4;   //<类型：系统；名字：输入点；精度：0;单位：；
    uint16_t in5;   //<类型：系统；名字：输入点；精度：0;单位：；
    uint16_t in6;   //<类型：系统；名字：输入点；精度：0;单位：；
    uint16_t in7;   //<类型：系统；名字：输入点；精度：0;单位：；
    uint16_t in8;   //<类型：系统；名字：输入点；精度：0;单位：；
    uint16_t in9;   //<类型：系统；名字：输入点；精度：0;单位：；
    uint16_t in10;   //<类型：系统；名字：输入点；精度：0;单位：；
    uint16_t in11;   //<类型：系统；名字：输入点；精度：0;单位：；
    uint16_t in12;   //<类型：系统；名字：输入点；精度：0;单位：；
    uint16_t in13;   //<类型：系统；名字：输入点；精度：0;单位：；
    uint16_t in14;   //<类型：系统；名字：输入点；精度：0;单位：；
    uint16_t in15;   //<类型：系统；名字：输入点；精度：0;单位：；
    uint16_t in16;   //<类型：系统；名字：输入点；精度：0;单位：；
    uint16_t in17;   //<类型：系统；名字：输入点；精度：0;单位：；
    uint16_t in18;   //<类型：系统；名字：输入点；精度：0;单位：；
    uint16_t in19;   //<类型：系统；名字：输入点；精度：0;单位：；
    uint16_t in20;   //<类型：系统；名字：输入点；精度：0;单位：；
    uint16_t in21;   //<类型：系统；名字：输入点；精度：0;单位：；
} INPUT0;

typedef struct{
  INPUT0 p;
}INPUTStruct;

typedef union {
    INPUTStruct para;
//    uint32_t all_para[sizeof(INPUT0)/2];
    uint32_t all[STRUCE_SIZE(ICAddr_Adapter_Para65, ICAddr_Adapter_Para75)];
} INPUT;



static const uint32_t output_addr[] = {
    ICAddr_Adapter_Para76, //<类型：模号；名字：电机1臂长/半径；结构：Axis_Config0；地址：axis_cfg_addr；
    ICAddr_Adapter_Para80, //<类型：系统；名字：；结构：Axis_Config0；地址：axis_cfg_addr；
};
typedef struct {  //<400 + 6X4 = 424
    uint16_t out0;   //<类型：系统；名字：输出点；精度：0;单位：；
    uint16_t out1;   //<类型：系统；名字：输出点；精度：0;单位：；
    uint16_t out2;   //<类型：系统；名字：输出点；精度：0;单位：；
    uint16_t out3;   //<类型：系统；名字：输出点；精度：0;单位：；
    uint16_t out4;   //<类型：系统；名字：输出点；精度：0;单位：；
    uint16_t out5;   //<类型：系统；名字：输出点；精度：0;单位：；
    uint16_t out6;   //<类型：系统；名字：输出点；精度：0;单位：；
    uint16_t out7;   //<类型：系统；名字：输出点；精度：0;单位：；
    uint16_t out8;   //<类型：系统；名字：输出点；精度：0;单位：；
    uint16_t out9;   //<类型：系统；名字：输出点；精度：0;单位：；
} OUTPUT0;

typedef struct{
  OUTPUT0 p;
}OutPutStruct;


typedef union {
    OutPutStruct para;
//    uint32_t all_para[sizeof(OUTPUT0)/2];
    uint32_t all[STRUCE_SIZE(ICAddr_Adapter_Para76, ICAddr_Adapter_Para80)];
} OUTPUT;

static const uint32_t system_addr[] = {
    ICAddr_System_Retain_0,
    ICAddr_System_Retain_End //<类型：模号；名字：；结构：SYSTEM_PARA；地址：system_addr；
};
typedef struct {
  uint32_t internal[100];
}INTERNAL0;

typedef union {
  INTERNAL0 para;
    uint32_t all[STRUCE_SIZE(ICAddr_BeginSection, ICAddr_System_Retain_End)];
} INTERNAL;


static const uint32_t system_reserve_addr[] = {
    ICAddr_Adapter_Para81,
    ICAddr_Adapter_Para160 //<类型：模号；名字：；结构：SYSTEM_PARA；地址：system_addr；
};
typedef struct {
  //    uint16_t delay_current[8];  //<类型:系统;当前延时时间 - 32-39 - 单位-10毫秒
  //    uint16_t delay_target[8];   //<类型:系统;目标延时时间 - 40-47 - 单位-10毫秒
  //    uint16_t timer_current[40];  //<类型:系统;当前定时时间 - 48-87 - 单位-10毫秒
  //    uint16_t timer_target[40];  //<类型:系统;目标定时时间 - 88-127 - 单位-10毫秒
  //    uint32_t counter_current[16];  //<类型:系统;当前计数值 - 128-159
  //    uint32_t counter_target[16];  //类型:系统;<目标计数值 - 160-191
  uint32_t Reserve0[4];    //<类型:系统;名字:当前延时时间; 单位:ms
  uint32_t Reserve1[4];    //<类型:系统;名字:目标延时时间; 单位:ms
  uint32_t Reserve2[20];   //<类型:系统;名字:当前定时时间; 单位:ms
  uint32_t Reserve3[20];   //<类型:系统;名字:目标定时时间; 单位:ms
  uint32_t Reserve4[16];   //<类型:系统;名字:当前计数值;   单位:ms
  uint32_t Reserve5[16];   //<类型:系统;名字:目标计数值;   单位:ms
}RESERVE0;

typedef struct{
    RESERVE0 p;
}ReverseStruct;

typedef union {
    ReverseStruct para;
    uint32_t all[STRUCE_SIZE(ICAddr_Adapter_Para81, ICAddr_Adapter_Para160)];
} RESERVE;


static const uint32_t axis_map_addr[] = {
    ICAddr_Adapter_Para161,
    ICAddr_Adapter_Para164 //<类型：模号；名字：；结构：SYSTEM_PARA；地址：system_addr；
};

typedef struct{
  uint16_t a0;//<类型：系统；名字：逻辑电机对应的脉冲端口；精度：0;单位：；
  uint16_t a1;//<类型：系统；名字：逻辑电机对应的脉冲端口；精度：0;单位：；
  uint16_t a2;//<类型：系统；名字：逻辑电机对应的脉冲端口；精度：0;单位：；
  uint16_t a3;//<类型：系统；名字：逻辑电机对应的脉冲端口；精度：0;单位：；
  uint16_t a4;//<类型：系统；名字：逻辑电机对应的脉冲端口；精度：0;单位：；
  uint16_t a5;//<类型：系统；名字：逻辑电机对应的脉冲端口；精度：0;单位：；
  uint16_t a6;//<类型：系统；名字：逻辑电机对应的脉冲端口；精度：0;单位：；
  uint16_t a7;//<类型：系统；名字：逻辑电机对应的脉冲端口；精度：0;单位：；
}AXIS_MAP0;

typedef struct{
  AXIS_MAP0 p;
}AXIS_MAPStruct;

typedef union {
    AXIS_MAPStruct para;
    uint32_t all[STRUCE_SIZE(ICAddr_Adapter_Para161, ICAddr_Adapter_Para164)];
} AXIS_MAP;


static const uint32_t alpha_addr[] = {
    ICAddr_Adapter_Para169,
    ICAddr_Adapter_Para172 //<类型：模号；名字：；结构：SYSTEM_PARA；地址：system_addr；
};

typedef struct{
  uint16_t alpha0;//<类型：系统；名字：设定初始夹角；精度：3;单位：度；
  uint16_t alpha1;//<类型：系统；名字：设定初始夹角；精度：3;单位：度；
  uint16_t alpha2;//<类型：系统；名字：设定初始夹角；精度：3;单位：度；
  uint16_t alpha3;//<类型：系统；名字：设定初始夹角；精度：3;单位：度；
  uint16_t alpha4;//<类型：系统；名字：设定初始夹角；精度：3;单位：度；
  uint16_t alpha5;//<类型：系统；名字：设定初始夹角；精度：3;单位：度；
  uint16_t alpha6;//<类型：系统；名字：设定初始夹角；精度：3;单位：度；
  uint16_t alpha7;//<类型：系统；名字：设定初始夹角；精度：3;单位：度；
}ALPHA0;

typedef struct{
    ALPHA0 p;
}ALPHAStruct;

typedef union {
    ALPHAStruct para;
    uint32_t all[STRUCE_SIZE(ICAddr_Adapter_Para169, ICAddr_Adapter_Para172)];
} ALPHA;



//
//typedef struct{
//  uint32_t s_r[ICAddr_Adapter_Para255 - ICAddr_Adapter_Para171];
//}SYSTEM_RESERVE0;
//typedef union {
//  SYSTEM_RESERVE0 para;
//    uint32_t all[STRUCE_SIZE(ICAddr_Adapter_Para171,ICAddr_Adapter_Para255)];
//}SYSTEM_RESERVE;
//

static const uint32_t mold_use_p_addr[] = {
    ICAddr_Mold_Para0,
    ICAddr_Mold_Para0 //<类型：模号；名字：；结构：SYSTEM_PARA；地址：system_addr；
};
typedef union{
    struct{
        uint32_t main_p:1;//<类型：模号；名字：主程序使用；精度：0;单位：；
        uint32_t sub1:1;//<类型：模号；名字：子程序1使用；精度：0;单位：；
        uint32_t sub2:1;//<类型：模号；名字：子程序2使用；精度：0;单位：；
        uint32_t sub3:1;//<类型：模号；名字：子程序3使用；精度：0;单位：；
        uint32_t sub4:1;//<类型：模号；名字：子程序4使用；精度：0;单位：；
        uint32_t sub5:1;//<类型：模号；名字：子程序5使用；精度：0;单位：；
        uint32_t sub6:1;//<类型：模号；名字：子程序6使用；精度：0;单位：；
        uint32_t sub7:1;//<类型：模号；名字：子程序7使用；精度：0;单位：；
        uint32_t sub8:1;//<类型：模号；名字：子程序8使用；精度：0;单位：；
        uint32_t re:23;//<类型：模号；名字：备用；精度：0;单位：；
    }bit;
    uint32_t a;
}MOLD_PRO_USE;

typedef struct{
    MOLD_PRO_USE use_p;
}MOLD_PARAStruct;


typedef union {
    MOLD_PARAStruct para;
    uint32_t all[STRUCE_SIZE(ICAddr_Mold_Para0,ICAddr_Write_Section_End)];
}MOLD_PARA;


static const uint32_t read_addr[] = {
    ICAddr_Read_Status0,
    ICAddr_Read_Status38 //<类型：模号；名字：；结构：SYSTEM_PARA；地址：system_addr；
};
typedef struct{
    Axis_Data axis_data[8];
    uint32_t alarm;//<类型：状态；名字：当前报警；精度：0;单位：；
    STEP step;
    uint32_t origin:1;//<类型：状态；名字：原点信号；精度：0;单位：；
    uint32_t mode:4;//<类型：状态；名字：当前模式；精度：0;单位：；
    uint32_t reserve0:29;//<类型：状态；名字：预留；精度：0;单位：；
}READ_PARA0;

typedef union {
    READ_PARA0 para;
    uint32_t all[ICAddr_Read_Section_End - ICAddr_Read_Status0];
} READ_PARA;

/**----------------------------------------------------------------------------------**/
typedef struct {  //最多8组电机，目前仅用前3组
    INTERNAL sys;//<类型：内部；名字：系统自用；
    Axis_Config axis_config;
    Interpolation_Config interpolation_config;
    INPUT din;     //<类型:系统;逻辑输入端口 - 0-21
    OUTPUT dout;    //<类型:系统;逻辑输出端口 - 22-31
    RESERVE Reserve;
    AXIS_MAP axis_map;    //<类型:系统;逻辑电机对应的脉冲端口 - 304-311
    Interpolation interpolation;//<类型：系统；名字：；精度：3;单位：
    ALPHA alpha;  //<类型：系统；名字：设定初始夹角；精度：3;单位：度；
    uint32_t p[ICAddr_Adapter_Para255-ICAddr_Adapter_Para172];
        MOLD_PARA m;//< 模号参数
//    uint32_t m_r[ICAddr_Write_Section_End - ICAddr_Adapter_Para255];
    READ_PARA read;
} PARA_Struct;



typedef struct _ADAPTER_PARA_{
    PARA_Struct P;
} ADAPTER_PARA;


typedef union _ALL_PARA_
{
    ADAPTER_PARA d;
    uint16_t all_16[sizeof(ADAPTER_PARA)];
    uint32_t all[sizeof(ADAPTER_PARA)/2];
} ALL_PARA;


extern ALL_PARA* all_para;
#ifdef __cplusplus
}
#endif

#endif /* HCCOMMPARAGENERICDEF_H */
