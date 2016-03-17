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

#define DEBUG_TEST  0 //< 测试


#define STRUCE_SIZE(a,b) (b-a+1)


#define SOFTWARE_VERSION  "HC_S3_S5_NEW-0.1-0.2"

/*! \brief 参数地址枚举 */
typedef enum _ICAddr
{
    ICAddr_BeginSection, //<参数地址开头哨兵0
    /***************************************************************************************/
    // 系统保留区
    ICAddr_System_Retain_Start,
    ICAddr_System_Retain_0=1, //< 按键命令地址
    ICAddr_System_Retain_1,//< 版本号地址
    ICAddr_System_Retain_2,//< 手动IO操作
    ICAddr_System_Retain_3,//< 手动IO操作
    ICAddr_System_Retain_4,//< 手动IO操作
    ICAddr_System_Retain_5,//< 手动IO操作
    ICAddr_System_Retain_6,//< 定义IO操作
    ICAddr_System_Retain_7,//< 定义计数器 id;//< 计数器ID target_cnt;//< 计数器当前值 cnt;//< 计数器当前值
    ICAddr_System_Retain_15 = 15,//< 自动运行自定义启动程序
    ICAddr_System_Retain_16 = 16,//< 自动运行自定义启动步号
    ICAddr_System_Retain_17 = 17,//< 1：自动进入单步运行模式，单步运行停止；2：单步运行启动；
    ICAddr_System_Retain_23 = 23,//< 电机正反转测试脉冲数
    ICAddr_System_Retain_24 = 24,//< 手动关节运动和直线运动切换 0：关节；30：直线
    ICAddr_System_Retain_25 = 25,//< 2:升级
    ICAddr_System_Retain_26 = 26,//< 0:关节坐标显示；1：输出累计值；2：反馈累计值;3:轨迹速度;4:脉冲容差;5:脉冲测试显示
    ICAddr_System_Retain_27 = 27,//< 手轮定义参数
    ICAddr_System_Retain_30 = 30,//< 手动记录坐标类型 0：直线起点位置；1：直线终点位置
                                 //< 10：弧线起点位置；11：弧线中间点位置；12：弧线终点位置
                                 //< 后面带6轴坐标值
    ICAddr_System_Retain_40 = 40,//< // 自定义轴动作1 低16位为电机选择位：1为选中；高16位为选中电机正反转设定位：0为反转，1为正转；
    ICAddr_System_Retain_41= 41,//<  // 自定义轴动作2 低16位为电机选择位：1为选中；高16位为选中电机正反转设定位：0为反转，1为正转；
    ICAddr_System_Retain_42= 42,//<  // 自定义轴动作3 低16位为电机选择位：1为选中；高16位为选中电机正反转设定位：0为反转，1为正转；
    ICAddr_System_Retain_43= 43,//<  // 自定义轴动作4 低16位为电机选择位：1为选中；高16位为选中电机正反转设定位：0为反转，1为正转；
    ICAddr_System_Retain_44= 44,//<  // 自定义轴动作5 低16位为电机选择位：1为选中；高16位为选中电机正反转设定位：0为反转，1为正转；
    ICAddr_System_Retain_45= 45,//<  // 自定义轴动作6 低16位为电机选择位：1为选中；高16位为选中电机正反转设定位：0为反转，1为正转；
    ICAddr_System_Retain_46= 46,//<  // 自定义轴动作7 低16位为电机选择位：1为选中；高16位为选中电机正反转设定位：0为反转，1为正转；
    ICAddr_System_Retain_47= 47,//<  // 自定义轴动作8 低16位为电机选择位：1为选中；高16位为选中电机正反转设定位：0为反转，1为正转；
    ICAddr_System_Retain_48= 48,//<  // 自定义轴动作9 低16位为电机选择位：1为选中；高16位为选中电机正反转设定位：0为反转，1为正转；
    ICAddr_System_Retain_49= 49,//<  // 自定义轴动作10 低16位为电机选择位：1为选中；高16位为选中电机正反转设定位：0为反转，1为正转；
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
    ICAddr_Adapter_Para56, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para57, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para58, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para59, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para60, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para61, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para62, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para63, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para64, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para65, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para66, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para67, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para68, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para69, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para70, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para71, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para72, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para73, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para74, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para75, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para76, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para77, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para78, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para79, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para80, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para81, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para82, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para83, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para84, //<类型:系统;名字:机械结构;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para85, //<类型:系统;名字:电机配置crc;结构:Axis_Config;地址:axis_cfg_addr;
    ICAddr_Adapter_Para86, //<类型:系统;名字:插补1最大线速度;结构:Interpolation_Config;地址:Inter_cfg;
    ICAddr_Adapter_Para87, //<类型:系统;名字:插补1最小加速时间_二次加速时间比例;结构:Interpolation_Config;地址:Inter_cfg;
    ICAddr_Adapter_Para88, //<类型:系统;名字:插补2最大线速度;结构:Interpolation_Config;地址:Inter_cfg;
    ICAddr_Adapter_Para89, //<类型:系统;名字:插补2最小加速时间_二次加速时间比例;结构:Interpolation_Config;地址:Inter_cfg;
    ICAddr_Adapter_Para90, //<类型:系统;名字:插补3最大线速度;结构:Interpolation_Config;地址:Inter_cfg;
    ICAddr_Adapter_Para91, //<类型:系统;名字:插补3最小加速时间_二次加速时间比例;结构:Interpolation_Config;地址:Inter_cfg;
    ICAddr_Adapter_Para92, //<类型:系统;名字:插补4最大线速度;结构:Interpolation_Config;地址:Inter_cfg;
    ICAddr_Adapter_Para93, //<类型:系统;名字:插补4最小加速时间_二次加速时间比例;结构:Interpolation_Config;地址:Inter_cfg;
    ICAddr_Adapter_Para94, //<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para95, //<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para96, //<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para97, //<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para98, //<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para99, //<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para100,//<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para101,//<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para102,//<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para103,//<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para104,//<类型:系统;名字:逻辑输入端口;结构:INPUT;地址:input_addr;
    ICAddr_Adapter_Para105,//<类型:系统;名字:逻辑输出端口;结构:OUTPUT;地址:output_addr;
    ICAddr_Adapter_Para106,//<类型:系统;名字:逻辑输出端口;结构:OUTPUT;地址:output_addr;
    ICAddr_Adapter_Para107,//<类型:系统;名字:逻辑输出端口;结构:OUTPUT;地址:output_addr;
    ICAddr_Adapter_Para108,//<类型:系统;名字:逻辑输出端口;结构:OUTPUT;地址:output_addr;
    ICAddr_Adapter_Para109,//<类型:系统;名字:逻辑输出端口;结构:OUTPUT;地址:output_addr;
    ICAddr_Adapter_Para110,//<类型:系统;名字:容差设定;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para111, //<类型:系统;名字:当前延时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para112, //<类型:系统;名字:当前延时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para113, //<类型:系统;名字:当前延时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para114, //<类型:系统;名字:目标延时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para115, //<类型:系统;名字:目标延时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para116, //<类型:系统;名字:目标延时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para117, //<类型:系统;名字:目标延时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para118, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para119, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para120, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para121, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para122, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para123, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para124, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para125, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para126, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para127, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para128, //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para129,  //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para130,  //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para131,  //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para132,  //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para133,  //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para134,  //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para135,  //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para136,  //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para137,  //<类型:系统;名字:当前定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para138, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para139, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para140, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para141, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para142, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para143, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para144, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para145, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para146, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para147, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para148, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para149, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para150, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para151, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para152, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para153, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para154, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para155, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para156, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para157, //<类型:系统;名字:目标定时时间;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para158, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para159, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para160, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para161, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para162, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para163, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para164, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para165, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para166, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para167, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para168, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para169, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para170, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para171, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para172, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para173, //<类型:系统;名字:当前计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para174, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para175, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para176, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para177, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para178, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para179, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para180, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para181, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para182, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para183, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para184, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para185, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para186, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para187, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para188, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para189, //<类型:系统;名字:目标计数值;结构:RESERVE;地址:system_reserve_addr;
    ICAddr_Adapter_Para190, //<类型:系统;名字:逻辑电机对应的脉冲端口;结构:AXIS_MAP;地址:axis_map_addr;
    ICAddr_Adapter_Para191, //<类型:系统;名字:逻辑电机对应的脉冲端口;结构:AXIS_MAP;地址:axis_map_addr;
    ICAddr_Adapter_Para192, //<类型:系统;名字:逻辑电机对应的脉冲端口;结构:AXIS_MAP;地址:axis_map_addr;
    ICAddr_Adapter_Para193, //<类型:系统;名字:逻辑电机对应的脉冲端口;结构:AXIS_MAP;地址:axis_map_addr;
    ICAddr_Adapter_Para194, //<类型:系统;名字:设定速度;结构:Interpolation;地址:Interpolation_addr;
    ICAddr_Adapter_Para195, //<类型:系统;名字:设定速度;结构:Interpolation;地址:Interpolation_addr;
    ICAddr_Adapter_Para196, //<类型:系统;名字:设定速度;结构:Interpolation;地址:Interpolation_addr;
    ICAddr_Adapter_Para197, //<类型:系统;名字:设定速度;结构:Interpolation;地址:Interpolation_addr;
    ICAddr_Adapter_Para198, //<类型:系统;名字:V轴初始夹角;结构:ALPHA;地址:alpha_addr;
    ICAddr_Adapter_Para199, //<类型:系统;名字:V轴初始夹角;结构:ALPHA;地址:alpha_addr;
    ICAddr_Adapter_Para200, //<类型:系统;名字:V轴初始夹角;结构:ALPHA;地址:alpha_addr;
    ICAddr_Adapter_Para201, //<类型:系统;名字:V轴初始夹角;结构:ALPHA;地址:alpha_addr;
    ICAddr_Adapter_Para255 = 356,

    ICAddr_Mold_Para0,//<类型:模号;名字:;结构:MOLD_PRO_USE;地址:mold_use_p_addr;
    ICAddr_Mold_Para1, //<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para2, //<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para3, //<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para4, //<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para5, //<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para6, //<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para7, //<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para8, //<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para9, //<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para10,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para11,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para12,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para13,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para14,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para15,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para16,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para17,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para18,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para19,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para20,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para21,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para22,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para23,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para24,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para25,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para26,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para27,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para28,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para29,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para30,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para31,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para32,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para33,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para34,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para35,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
    ICAddr_Mold_Para36,//<类型:模号;名字:;结构:MOLD_P;地址:mold_p_addr;
//    ICAddr_Mold_Para37,//<类型:模号;名字:速度MOLD_PPARAmold_p_addraddr;
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
    ICAddr_Read_Status39,    //<类型：状态；名字：步号;结构:READ_PARA;地址:read_addr;
    ICAddr_Read_Status40,    //<类型：状态；名字：步号;结构:READ_PARA;地址:read_addr;
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
    CMD_RETURN, // 复归模式

    CMD_MANUAL_STOP = 0x0050,  // 手动运行停止
    CMD_MANUAL_START1        ,  // 手动运行主程序
    CMD_MANUAL_START2        ,  // 手动运行子程序1
    CMD_MANUAL_START3        ,  // 手动运行子程序2
    CMD_MANUAL_START4        ,  // 手动运行子程序3
    CMD_MANUAL_START5        ,  // 手动运行子程序4
    CMD_MANUAL_START6        ,  // 手动运行子程序5
    CMD_MANUAL_START7        ,  // 手动运行子程序6
    CMD_MANUAL_START8        ,  // 手动运行子程序7
    CMD_MANUAL_START9        ,  // 手动运行子程序8
    CMD_MANUAL_START10        ,  // 手动运行程序9
    CMD_MANUAL_START11        ,  // 手动运行程序10
    CMD_MANUAL_START12        ,  // 手动运行程序11
    CMD_MANUAL_START13        ,  // 手动运行程序12
    CMD_MANUAL_START14        ,  // 手动运行程序13
    CMD_MANUAL_START15        ,  // 手动运行程序14
    CMD_MANUAL_START16        ,  // 手动运行程序15
    CMD_MANUAL_START17        ,  // 手动运行程序16
    CMD_MANUAL_START18        ,  // 手动运行程序17
    CMD_MANUAL_START19        ,  // 手动运行程序18
    CMD_MANUAL_START20        ,  // 手动运行程序19

    CMD_POWER_OFF0 = 0x0100,  // 第一个逻辑电机关闭
    CMD_POWER_OFF  = 0x017F,  // 所有逻辑电机关闭
    CMD_POWER_ON0  = 0x0180,  // 第一个逻辑电机开机
    CMD_POWER_ON  = 0x01FF, // 所有逻辑电机开机

    CMD_WHEEL_JOG_P0     = 0x0200,  // 手轮正转
    CMD_WHEEL_JOG_N0             ,  // 手轮反转

    CMD_JOG_PX     = 0x0300,  // 直角坐标系位置轴，X轴正向点动
    CMD_JOG_PY     = 0x0301,  // 直角坐标系位置轴，Y轴正向点动
    CMD_JOG_PZ     = 0x0302,  // 直角坐标系位置轴，Z轴正向点动
    CMD_JOG_PU     = 0x0303,  // 直角坐标系姿势轴，U轴正向点动
    CMD_JOG_PV     = 0x0304,  // 直角坐标系姿势轴，V轴正向点动
    CMD_JOG_PW     = 0x0305,  // 直角坐标系姿势轴，W轴正向点动
    CMD_JOG_PR     = 0x0306,  // 极坐标系，远离原点点动

    /*手动*/
    CMD_LINE_TO_START_POINT= 0x0310,  // 直线运动到起点坐标
    CMD_LINE_TO_END_POINT,  // 直线运动到终点坐标
    CMD_JOINT_TO_START_POINT,          // 关节运动到起点坐标
    CMD_JOINT_TO_END_POINT,            // 关节运动到终点坐标
    CMD_RELATIVE_LINE_TO_START_POINT,  // 相对直线运动正方向
    CMD_RELATIVE_LINE_TO_END_POINT,    // 相对直线运动反方向
    CMD_RELATIVE_JOINT_TO_START_POINT, // 相对关节运动正方向
    CMD_RELATIVE_JOINT_TO_END_POINT,   // 相对关节运动反方向
    /*教导*/
    CMD_TEACH_LINE_TO_START_POINT,           // 直线运动到起点坐标
    CMD_TEACH_LINE_TO_END_POINT,             // 直线运动到终点坐标
    CMD_TEACH_JOINT_TO_START_POINT,          // 关节运动到起点坐标
    CMD_TEACH_JOINT_TO_END_POINT,            // 关节运动到终点坐标
    CMD_TEACH_RELATIVE_LINE_TO_START_POINT,  // 相对直线运动正方向
    CMD_TEACH_RELATIVE_LINE_TO_END_POINT,    // 相对直线运动反方向
    CMD_TEACH_RELATIVE_JOINT_TO_START_POINT, // 相对关节运动正方向
    CMD_TEACH_RELATIVE_JOINT_TO_END_POINT,   // 相对关节运动反方向
    /*手动*/
    CMD_ARC_TO_START_POINT= 0x0330,  // 弧线运动往终点坐标方向
    CMD_ARC_TO_END_POINT,  // 弧线运动往终点坐标反方向
    /*教导*/
    CMD_TEACH_ARC_TO_START_POINT,  // 弧线运动往终点坐标方向
    CMD_TEACH_ARC_TO_END_POINT,  // 弧线运动往终点坐标反方向
    CMD_ROUTE_STOP = 0x033F,  // 轨迹运动停止
    CMD_GET_COORDINATE= 0x0340,  // 记录当前坐标

    CMD_TEST_CLEAR      = 0x034F,  // 清除当前所有测试脉冲
    CMD_TEST_JOG_PX     = 0x0350,  // 测试X轴正向运动
    CMD_TEST_JOG_PY     = 0x0351,  // 测试Y轴正向运动
    CMD_TEST_JOG_PZ     = 0x0352,  // 测试Z轴正向运动
    CMD_TEST_JOG_PU     = 0x0353,  // 测试U轴正向运动
    CMD_TEST_JOG_PV     = 0x0354,  // 测试V轴正向运动
    CMD_TEST_JOG_PW     = 0x0355,  // 测试W轴正向运动
    CMD_TEST_JOG_NX     = 0x0360,  // 测试X轴反向运动
    CMD_TEST_JOG_NY     = 0x0361,  // 测试Y轴反向运动
    CMD_TEST_JOG_NZ     = 0x0362,  // 测试Z轴反向运动
    CMD_TEST_JOG_NU     = 0x0363,  // 测试U轴反向运动
    CMD_TEST_JOG_NV     = 0x0364,  // 测试V轴反向运动
    CMD_TEST_JOG_NW     = 0x0365,  // 测试W轴反向运动

    CMD_CUSTOM_JOG1     = 0x0370,  // 自定义轴动作1
    CMD_CUSTOM_JOG2             ,  // 自定义轴动作2
    CMD_CUSTOM_JOG3             ,  // 自定义轴动作3
    CMD_CUSTOM_JOG4             ,  // 自定义轴动作4
    CMD_CUSTOM_JOG5             ,  // 自定义轴动作5
    CMD_CUSTOM_JOG6             ,  // 自定义轴动作6
    CMD_CUSTOM_JOG7             ,  // 自定义轴动作7
    CMD_CUSTOM_JOG8             ,  // 自定义轴动作8
    CMD_CUSTOM_JOG9             ,  // 自定义轴动作9
    CMD_CUSTOM_JOG10            ,  // 自定义轴动作10

    CMD_JOG_NX     = 0x0380,  // 直角坐标系位置轴，X轴反向点动
    CMD_JOG_NY     = 0x0381,  // 直角坐标系位置轴，Y轴反向点动
    CMD_JOG_NZ     = 0x0382,  // 直角坐标系位置轴，Z轴反向点动
    CMD_JOG_NU     = 0x0383,  // 直角坐标系姿势轴，U轴反向点动
    CMD_JOG_NV     = 0x0384,  // 直角坐标系姿势轴，V轴反向点动
    CMD_JOG_NW     = 0x0385,  // 直角坐标系姿势轴，W轴反向点动
    CMD_JOG_NR     = 0x0386,  // 极坐标系，靠近原点点动

//    CMD_JOG_NR     = 0x0386,  // 极坐标系，靠近原点点动

    CMD_FIND_ZERO0 = 0x0400,  // 第一个逻辑轴，找零

    CMD_SET_ZERO0  = 0x0410,  // X轴原点设定
    CMD_SET_ZERO1  = 0x0411,  // y轴原点设定
    CMD_SET_ZERO2  = 0x0412,  // z轴原点设定
    CMD_SET_ZERO3  = 0x0413,  // u轴原点设定
    CMD_SET_ZERO4  = 0x0414,  // v轴原点设定
    CMD_SET_ZERO5  = 0x0415,  // w轴原点设定
    CMD_SET_ZERO   = 0x0416,  // 全部轴原点设定
    CMD_REM_POS    = 0x0417,  // 保存每个轴当前位置
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


typedef enum
{
    /*手动设定位置*/
    LINE_START_POINT,   //< 直线起点位置
    LINE_END_POINT,     //< 直线终点位置
    AUTO_START_POINT,   //< 关节坐标起点位置
    AUTO_END_POINT,     //< 关节坐标终点位置
    RELATIVE_LINE_START_POINT,   //< 直线相对移动位置
    RELATIVE_AUTO_END_POINT,     //< 关节坐标相对移动位置
    /*教导页面位置*/
    TEACH_LINE_START_POINT,   //< 直线起点位置
    TEACH_LINE_END_POINT,     //< 直线终点位置
    TEACH_AUTO_START_POINT,   //< 关节坐标起点位置
    TEACH_AUTO_END_POINT,     //< 关节坐标终点位置
    TEACH_RELATIVE_LINE_START_POINT,   //< 直线相对移动位置
    TEACH_RELATIVE_AUTO_END_POINT,     //< 关节坐标相对移动位置
    /*手动设定位置*/
    ARC_START_POINT=30, //< 弧线起点位置
    ARC_MID_POINT,      //< 弧线中间点位置
    ARC_END_POINT,      //< 弧线终点位置
    /*教导页面位置*/
    TEACH_ARC_START_POINT, //< 弧线起点位置
    TEACH_ARC_MID_POINT,      //< 弧线中间点位置
    TEACH_ARC_END_POINT,      //< 弧线终点位置
}MANUAL_ACTION_PARA;

/*! \brief 教导动作功能码枚举*/
typedef enum
{
	F_CMD_NULL,
	F_CMD_SYNC_START,     //< 同步功能开始
	F_CMD_SYNC_END,       //< 同步功能结束
    F_CMD_SINGLE,         //< 单轴动作 电机ID 位置 速度  延时
    //< 关节坐标点运动 第电机ID使能（按位使能第0位：X使能；第1位：Y使能；～第5位：W使能）
    //< 坐标（X，Y，Z,U,V,W） 速度 延时
	F_CMD_JOINT_MOVE_POINT,
	//< 直线坐标偏移位置（X，Y，Z） 速度  延时
	F_CMD_LINE_RELATIVE,
	F_CMD_LINE2D_MOVE_POINT,   //< 2轴按点位直线运动 坐标（X，Y） 速度  延时
	F_CMD_LINE3D_MOVE_POINT,   //< 3轴按点位直线运动 坐标（X，Y，Z） 速度  延时
    F_CMD_ARC3D_MOVE_POINT,   //< 按点位弧线运动 目标坐标（X，Y，Z）经过点（X，Y，Z） 速度  延时
    F_CMD_MOVE_POSE,   //< 运动目标姿势 姿势（X，Y，Z） 速度  延时
    F_CMD_LINE3D_MOVE_POSE,   //< 3轴按点位直线运动带目标姿势 坐标（X，Y，Z）姿势（X，Y，Z） 速度  延时
    //< 关节坐标偏移位置（X，Y，Z,U,V,W） 速度  延时
    F_CMD_JOINT_RELATIVE,

    F_CMD_ARC3D_MOVE,   //< 整圆运动 目标坐标（X，Y，Z）经过点（X，Y，Z） 速度  延时

    F_CMD_IO_INPUT = 100,   //< IO点输入等待 类型（EUIO，IO，M） IO点 等待 等待时间
    /**************************************************************************/
    /* IO点输出
     * 类型（EUIO，0~3:IO板，4～6：M值，7：EUIO；8：单头阀或者双头阀；9：停止检测；10：开始检测）
     * IO点 当类型为8～10时候为阀ID
     * 输出状态  当类型为8～10时候不用
     * 输出延时  当类型为8～10时候不用
     */
    F_CMD_IO_OUTPUT = 200,
    /*************************************************************************
     *
     *stack：
     *order:5; 顺序 0:X->Y->Z;1:X->Z->Y;2:Y->X->Z;3:Y->Z->X;4:Z->X->Y;5:Z->Y->X
     *x_dir:1; x轴方向 0：反方向；1正方向；
     *y_dir:1; y轴方向 0：反方向；1正方向；
     *z_dir:1; z轴方向 0：反方向；1正方向；
     *type:8;  堆叠类型
     *binding_counter:1;  是否绑定计数器ID，0未绑定；1绑定
     *counter_id:15;  绑定计数器ID
     *
     *
     *
     *xpos;  X坐标  0.001精度
     *ypos;  Y坐标  0.001精度
     *zpos;  Z坐标  0.001精度
     *xpos_p;  X坐标  0.001精度
     *ypos_p;  Y坐标  0.001精度
     *zpos_p;  Z坐标  0.001精度
     *speed; 速度  0.01精度
     *x; X轴间距  0.001精度
     *y; Y轴间距  0.001精度
     *z; Z轴间距  0.001精度
     *nx; X轴个数  0精度
     *ny; Y轴个数  0精度
     *nz; Z轴个数  0精度
     *stack;
     *xspace;//< 装箱X轴间距
     *yspace;//< 装箱Y轴间距
     *xbox;//< 装箱X轴个数
     *ybox;//< 装箱Y轴个数
     *boxspeed;//< 装箱速度
     *boxstack;//< 装箱参数
    */
    F_CMD_STACK0 = 300,//< 堆叠
    /***************************************************************************/
    /*
     * id:计数器ID
     * cnt:计数次数
     */
    F_CMD_COUNTER = 400,//< 计数器
    /***************************************************************************/
    /*
     * id:计数器ID
     * cnt:计数次数
     */
    F_CMD_COUNTER_CLEAR = 401,//< 计数器清零
    /***************************************************************************/
    /*
     * id:报警ID 自定义报警ID从5000开始到10000；
     */
    F_CMD_TEACH_ALARM = 500,//< 报警教导
    /***************************************************************************/

    F_CMD_PROGRAM_JUMP0=10000,   //< 程序无条件跳转 跳转步号
    F_CMD_PROGRAM_JUMP1,   //< 程序跳转 跳转步号 跳转类型（IO板类型） 延迟时间（0.1S） 检测对象（0输入；1输出） 检测ID 检测状态（0：OFF；1：ON）
    F_CMD_PROGRAM_JUMP2,   //< 计数器跳转 跳转步号 计数器ID 清零操作（0：不自动清零；1：到达计数时候自动清零）跳转方式（0：没达到目标数跳转；1达到目标数跳转）
    F_CMD_PROGRAM_CALL0 = 20000,   //< 程序调用 调用步号  返回步号
    F_CMD_PROGRAM_CALL_BACK,   //< 程序调用
//    F_CMD_PROGRAM_JUMP4,   //< 程序跳转 跳转步号

    /***************************************************************************/
    F_CMD_FINE_ZERO = 30000, //<  教导寻找原点： 轴ID 类型 速度 延时

    /***************************************************************************/
    F_CMD_NOTES = 50000,   //< 注释该行教导程序
    F_CMD_FLAG = 59999,    //<跳转标志
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
    ALARM_EMERGENCY_STOP,//<名字：紧急停止
    ALARM_AUTO_JUMP_ERR, //<名字：自动运行跳转错误
    ALARM_LINK_HOST_FAIL, //<名字：连接主机失败
    ALARM_PROGRAM_ERR, //<名字：教导程序错误
    ALARM_CFG_STORAGE_ERR, //<名字：配置参数存储失败
    ALARM_MAHCINE_SET_ERR, //<名字：机型设定错误

    ALARM_AXIS1_ALARM_ERR = 90,//<名字：电机1报警
    ALARM_AXIS2_ALARM_ERR,//<名字：电机2报警
    ALARM_AXIS3_ALARM_ERR,//<名字：电机3报警
    ALARM_AXIS4_ALARM_ERR,//<名字：电机4报警
    ALARM_AXIS5_ALARM_ERR,//<名字：电机5报警
    ALARM_AXIS6_ALARM_ERR, //<名字：电机6报警

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
    ALARM_AXIS6_OVER_SPEED_ERR, //<名字：轴6运动过速
    ALARM_AXIS1_SOFT_LIMIT_P = 130,//<名字：轴1正极限报警
    ALARM_AXIS2_SOFT_LIMIT_P,//<名字：轴2正极限报警
    ALARM_AXIS3_SOFT_LIMIT_P,//<名字：轴3正极限报警
    ALARM_AXIS4_SOFT_LIMIT_P,//<名字：轴4正极限报警
    ALARM_AXIS5_SOFT_LIMIT_P,//<名字：轴5正极限报警
    ALARM_AXIS6_SOFT_LIMIT_P,//<名字：轴6正极限报警
    ALARM_AXIS1_SOFT_LIMIT_N = 140,//<名字：轴1负极限报警
    ALARM_AXIS2_SOFT_LIMIT_N,//<名字：轴2负极限报警
    ALARM_AXIS3_SOFT_LIMIT_N,//<名字：轴3负极限报警
    ALARM_AXIS4_SOFT_LIMIT_N,//<名字：轴4负极限报警
    ALARM_AXIS5_SOFT_LIMIT_N,//<名字：轴5负极限报警
    ALARM_AXIS6_SOFT_LIMIT_N,//<名字：轴6负极限报警
    ALARM_ERROR_SERVO1_WARP = 150,//<名字：轴1偏差过大
    ALARM_ERROR_SERVO2_WARP,//<名字：轴2偏差过大
    ALARM_ERROR_SERVO3_WARP,//<名字：轴3偏差过大
    ALARM_ERROR_SERVO4_WARP,//<名字：轴4偏差过大
    ALARM_ERROR_SERVO5_WARP,//<名字：轴5偏差过大
    ALARM_ERROR_SERVO6_WARP,//<名字：轴6偏差过大
    ALARM_AXIS1_ACC_LIMIT = 160,//<名字：轴1加速度报警
    ALARM_AXIS2_ACC_LIMIT,//<名字：轴2加速度报警
    ALARM_AXIS3_ACC_LIMIT,//<名字：轴3加速度报警
    ALARM_AXIS4_ACC_LIMIT,//<名字：轴4加速度报警
    ALARM_AXIS5_ACC_LIMIT,//<名字：轴5加速度报警
    ALARM_AXIS6_ACC_LIMIT,//<名字：轴6加速度报警
    ALARM_AXIS1_POINT_LIMIT_P = 170,//<名字：轴1正极限信号报警
    ALARM_AXIS2_POINT_LIMIT_P,//<名字：轴2正极限信号报警
    ALARM_AXIS3_POINT_LIMIT_P,//<名字：轴3正极限信号报警
    ALARM_AXIS4_POINT_LIMIT_P,//<名字：轴4正极限信号报警
    ALARM_AXIS5_POINT_LIMIT_P,//<名字：轴5正极限信号报警
    ALARM_AXIS6_POINT_LIMIT_P,//<名字：轴6正极限信号报警
    ALARM_AXIS1_POINT_LIMIT_N = 180,//<名字：轴1负极限信号报警
    ALARM_AXIS2_POINT_LIMIT_N,//<名字：轴2负极限信号报警
    ALARM_AXIS3_POINT_LIMIT_N,//<名字：轴3负极限信号报警
    ALARM_AXIS4_POINT_LIMIT_N,//<名字：轴4负极限信号报警
    ALARM_AXIS5_POINT_LIMIT_N,//<名字：轴5负极限信号报警
    ALARM_AXIS6_POINT_LIMIT_N,//<名字：轴6负极限信号报警

    ALARM_AXIS1_NOT_SET_ORIGIN = 190,//<名字：轴1原点信号未设定
    ALARM_AXIS2_NOT_SET_ORIGIN,//<名字：轴2原点信号未设定
    ALARM_AXIS3_NOT_SET_ORIGIN,//<名字：轴3原点信号未设定
    ALARM_AXIS4_NOT_SET_ORIGIN,//<名字：轴4原点信号未设定
    ALARM_AXIS5_NOT_SET_ORIGIN,//<名字：轴5原点信号未设定
    ALARM_AXIS6_NOT_SET_ORIGIN,//<名字：轴6原点信号未设定

    ALARM_ROUTE_ACTION_FAIL = 200,//<名字：轨迹运动失败
    ALARM_ROUTE_LINE_P1_NOTSET,//<名字：手动直线轨迹运动起始坐标未设定
    ALARM_ROUTE_LINE_P2_NOTSET,//<名字：手动直线轨迹运动终点坐标未设定
    ALARM_JOINT_P1_NOTSET,//<名字：手动关节运动起始坐标未设定
    ALARM_JOINT_P2_NOTSET,//<名字：手动关节运动终点坐标未设定
    ALARM_RELATIVE_LP_NOTSET,//<名字：手动直线相对移动坐标未设定
    ALARM_RELATIVE_JP_NOTSET,//<名字：手动关节相对移动坐标未设定
    ALARM_TEACH_ROUTE_LINE_P1_NOTSET,//<名字：教导直线轨迹运动起始坐标未设定
    ALARM_TEACH_ROUTE_LINE_P2_NOTSET,//<名字：教导直线轨迹运动终点坐标未设定
    ALARM_TEACH_JOINT_P1_NOTSET,//<名字：教导关节运动起始坐标未设定
    ALARM_TEACH_JOINT_P2_NOTSET,//<名字：教导关节运动终点坐标未设定
    ALARM_TEACH_RELATIVE_LP_NOTSET,//<名字：教导直线相对移动坐标未设定
    ALARM_TEACH_RELATIVE_JP_NOTSET,//<名字：教导关节相对移动坐标未设定
    ALARM_ROUTE_ARC_P1_NOTSET,//<名字：手动弧线轨迹运动起点坐标未设定
    ALARM_ROUTE_ARC_P2_NOTSET,//<名字：手动弧线轨迹运动中间点坐标未设定
    ALARM_ROUTE_ARC_P3_NOTSET,//<名字：手动弧线轨迹运动终点坐标未设定
    ALARM_TEACH_ROUTE_ARC_P1_NOTSET,//<名字：教导弧线轨迹运动起点坐标未设定
    ALARM_TEACH_ROUTE_ARC_P2_NOTSET,//<名字：教导弧线轨迹运动中间坐标未设定
    ALARM_TEACH_ROUTE_ARC_P3_NOTSET,//<名字：教导弧线轨迹运动终点坐标未设定

    ALARM_SETROUTESPEED_FAIL,//<名字：轨迹运动速度设定失败
    ALARM_ROUTE_ACC_ERR,//<名字：轨迹规划失败

    ALARM_COUNTER_NOT_DEFINE = 300,//<名字：计数器未定义
    ALARM_IO_ERR_START = 2048,    //<名字：IO报警起始地址
    ALARM_IO_ERR_END = 4095,    //<名字：IO报警结束地址 目前最多只到3583

    ALARM_TEACH_START = 5000,//<名字：自定义报警开始
    ALARM_TEACH_END = 10000, //<名字：自定义报警结束
}ALARM_ADDR;

typedef enum
{
    INCREMENTAL_ENCODER,       //<名字：增量型编码器
    ABSOLUTE_VALUE_ENCODER,    //<名字：绝对值编码器
}ENCODER_TYPE;
typedef enum
{
    Inovancwe,       //<名字：汇川伺服
    ASDA,            //<名字：台达伺服
    panasonic,       //<名字：松下伺服
}SERVO_VENDER;
typedef enum
{
    READ_TYPE_PULSER,       //<名字：绝对值脉冲读取方式
    READ_TYPE_SERIAL,       //<名字：绝对值串口读取方式
    READ_TYPE_CAN,       //<名字：绝对值CAN口读取方式
}ENCODER_READ_TYPE;


typedef enum
{
    JOINT1,       //< 关节1
    JOINT2,       //< 关节2
    JOINT3,       //< 关节3
    JOINT4,       //< 关节4
    JOINT5,       //< 关节5
    JOINT6,       //< 关节6

    LINEX,       //< 世界坐标X
    LINEY,       //< 世界坐标Y
    LINEZ,       //< 世界坐标Z

    POSU,       //< 姿势U
    POSV,       //< 姿势V
    POSW,       //< 姿势W

}HANDWHEEL_TYPE;

typedef enum
{
    LENTH1,       //< 手轮最小单位长度
    LENTH2,       //< 手轮最小单位长度X2
    LENTH3,       //< 手轮最小单位长度X5
    LENTH4,       //< 手轮最小单位长度X10
    LENTH5,       //< 手轮最小单位长度X20
    LENTH6,       //< 手轮最小单位长度X50
    LENTH7,       //< 手轮最小单位长度X100

}HANDWHEEL_LENTH;

typedef union {
    struct{
        uint32_t type:8;//< 类型
        uint32_t lenth:8;//< 单位长度
        uint32_t res:15;//< 预留
        uint32_t en:1;//< 使能
    }bit;
    uint32_t hand;
}HANDWHEEL;

/*******************************************************************************/
static const uint32_t axis_cfg_addr[] = {
    ICAddr_Adapter_Para0, //<类型：系统；名字：电机1；结构：Axis_Config；地址：axis_cfg_addr；
    ICAddr_Adapter_Para85, //<类型：系统；名字：；结构：Axis_Config；地址：axis_cfg_addr；
};
typedef struct {  //<192 + 14X8 = 304
    uint32_t length;           //<类型：系统；名字：臂长/半径；精度：3;单位：mm；
    uint32_t ppc:16;           //<类型：系统；名字：每转脉冲数；精度：0;单位：num；
    uint32_t gratio:16;        //<类型：系统；名字：减速比；精度：0;单位：num；
    uint32_t soft_limit_p:16;  //<类型：系统；名字：正向软极限；精度：0;单位：度；
    uint32_t soft_limit_n:16;  //<类型：系统；名字：负向软极限；精度：0;单位：度；
    uint32_t type:4;           //<类型：系统；名字：编码器类型；精度：0;单位：；
    uint32_t vender:4;         //<类型：系统；名字：厂家；精度：0;单位：；
    uint32_t read_type:4;      //<类型：系统；名字：绝对值读取方式；精度：0;单位：；
    uint32_t res:20;           //<类型：系统；名字：预留；精度：0;单位：；
    uint32_t limit_p:8;        //<类型：系统；名字：正向极限输入；精度：0;单位：；
    uint32_t limit_n:8;        //<类型：系统；名字：负向极限输入；精度：0;单位：；
    uint32_t origin:8;         //<类型：系统；名字：原点输入；精度：0;单位：；
    uint32_t atype:4;          //<类型：系统；名字：轴类型；精度：0;单位：；
    uint32_t reserve1:4;       //<类型：系统；名字：预留；精度：0;单位：；
    uint16_t reserve2;         //<类型：系统；名字：预留；精度：0;单位：；
    uint16_t max_speed;        //<类型：系统；名字：最高转速RPM；精度：1;单位：rpm；
    uint16_t min_acc_time;     //<类型：系统；名字：最小加速时间毫秒；精度：3;单位：s；
    uint16_t sratio;           //<类型：系统；名字：二次加速时间比例；精度：3;单位：；
}Axis_Config0;

typedef struct {

    uint32_t as1 : 8; //<类型:系统;名字:第一段的时间百分比;精度:0;单位: ;
    uint32_t as2 : 8; //<类型:系统;名字:第三段的时间百分比;精度:0;单位: ;
    uint32_t ds1 : 8; //<类型:系统;名字:第一段的时间百分比;精度:0;单位: ;
    uint32_t ds2 : 8; //<类型:系统;名字:第三段的时间百分比;精度:0;单位: ;

    uint32_t as : 16; //<类型:系统;名字:加速度设定;精度:3;单位:um/ms/ms;
    uint32_t ds : 16; //<类型:系统;名字:减速度设定;精度:3;单位:um/ms/ms;

    uint32_t max : 16; //<类型:系统;名字:最大加速度设定;精度:3;单位:mm/ms;
    uint32_t res : 16; //<类型:系统;名字:预留;精度:0;单位:mm/ms;
}RAcc;

typedef struct {
    Axis_Config0 para[8];
    uint32_t x;      //<类型:系统;名字:一轴圆心在基坐标系中的X位置;精度:3;单位:mm;
    uint32_t y;      //<类型:系统;名字:一轴圆心在基坐标系中的Y位置;精度:3;单位:mm;
    uint32_t z;      //<类型:系统;名字:二轴圆心在基坐标系中的Z位置;精度:3;单位:mm;
    uint32_t L12;    //<类型:系统;名字:二轴圆心在二轴Z向上与一轴圆心的距离;精度:3;单位:mm;
    uint32_t L23;    //<类型:系统;名字:三轴圆心在三轴Z向上与二轴圆心的距离;精度:3;单位:mm;
    uint32_t L24;    //<类型:系统;名字:四轴圆心在四轴Z向上与二轴圆心的距离;精度:3;单位:mm;
    uint32_t L34a;   //<类型:系统;名字:四轴圆心在四轴Z向上与三轴圆心的距离A;精度:3;单位:mm;
    uint32_t L34b;   //<类型:系统;名字:四轴圆心在四轴Z向上与三轴圆心的距离B;精度:3;单位:mm;
    uint32_t L56;    //<类型:系统;名字:六轴圆心在六轴Z向上与五轴圆心的距离;精度:3;单位:mm;
    RAcc a;   //<类型:系统;名字:加速时S加速;
    uint32_t res[17]; //<类型:系统;名字:预留;精度:0;单位:;
    uint32_t crc;//<类型:系统;名字:电机配置crc;精度：0;单位：；
}Axis_Config1;


typedef union {
    Axis_Config1 para;
    uint32_t all[STRUCE_SIZE(ICAddr_Adapter_Para0, ICAddr_Adapter_Para85)];
}Axis_Config;


static const uint32_t Inter_cfg[] = {
    ICAddr_Adapter_Para86, //<类型：模号；名字：电机1臂长/半径；结构：Axis_Config0；地址：axis_cfg_addr；
    ICAddr_Adapter_Para93, //<类型：系统；名字：；结构：Axis_Config0；地址：axis_cfg_addr；
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
    uint32_t all[STRUCE_SIZE(ICAddr_Adapter_Para86, ICAddr_Adapter_Para93)];
} Interpolation_Config;


typedef struct {  //<336 + 8X8 = 400
    uint32_t position;   //<类型：状态；名字：当前输出脉冲位置；精度：3;单位：；
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
    struct{
        uint32_t m0:16;//<类型：状态；名字：手动1；精度：1;单位：；
        uint32_t m1:16;//<类型：状态；名字：手动2；精度：1;单位：；
        uint32_t m2:16;//<类型：状态；名字：手动3；精度：1;单位：；
        uint32_t m3:16;//<类型：状态；名字：手动4；精度：1;单位：；
        uint32_t m4:16;//<类型：状态；名字：手动5；精度：1;单位：；
        uint32_t m5:16;//<类型：状态；名字：手动6；精度：1;单位：；
        uint32_t m6:16;//<类型：状态；名字：手动7；精度：1;单位：；
        uint32_t m7:16;//<类型：状态；名字：手动8；精度：1;单位：；
        uint32_t m8:16;//<类型：状态；名字：手动9；精度：1;单位：；
        uint32_t m9:16;//<类型：状态；名字：手动10；精度：1;单位：；
    }m;
    uint16_t all[10];
    uint32_t all_32[5];
} STEP;


static const uint32_t Interpolation_addr[] = {
    ICAddr_Adapter_Para194, //<类型：模号；名字：电机1臂长/半径；结构：Axis_Config0；地址：axis_cfg_addr；
    ICAddr_Adapter_Para197, //<类型：系统；名字：；结构：Axis_Config0；地址：axis_cfg_addr；
};
typedef struct {  //<400 + 6X4 = 424
    uint16_t speed_percent;   //<类型：系统；名字：设定速度；精度：1;单位：mm/s；
} Interpolation0;

typedef struct {
    Interpolation0 p[8];   //<类型：系统；名字：设定速度；精度：1;单位：mm/s；
} InterpolationStruct;

typedef union {
    InterpolationStruct para;
    uint32_t all[STRUCE_SIZE(ICAddr_Adapter_Para194, ICAddr_Adapter_Para197)];
} Interpolation;


static const uint32_t input_addr[] = {
    ICAddr_Adapter_Para94, //<类型：模号；名字：电机1臂长/半径；结构：Axis_Config0；地址：axis_cfg_addr；
    ICAddr_Adapter_Para104, //<类型：系统；名字：；结构：Axis_Config0；地址：axis_cfg_addr；
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
    uint32_t all[STRUCE_SIZE(ICAddr_Adapter_Para94, ICAddr_Adapter_Para104)];
} INPUT;



static const uint32_t output_addr[] = {
    ICAddr_Adapter_Para105, //<类型：模号；名字：电机1臂长/半径；结构：Axis_Config0；地址：axis_cfg_addr；
    ICAddr_Adapter_Para109, //<类型：系统；名字：；结构：Axis_Config0；地址：axis_cfg_addr；
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
    uint32_t all[STRUCE_SIZE(ICAddr_Adapter_Para105, ICAddr_Adapter_Para109)];
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
    ICAddr_Adapter_Para110,
    ICAddr_Adapter_Para189 //<类型：模号；名字：；结构：SYSTEM_PARA；地址：system_addr；
};
typedef struct {
  //    uint16_t delay_current[8];  //<类型:系统;当前延时时间 - 32-39 - 单位-10毫秒
  //    uint16_t delay_target[8];   //<类型:系统;目标延时时间 - 40-47 - 单位-10毫秒
  //    uint16_t timer_current[40];  //<类型:系统;当前定时时间 - 48-87 - 单位-10毫秒
  //    uint16_t timer_target[40];  //<类型:系统;目标定时时间 - 88-127 - 单位-10毫秒
  //    uint32_t counter_current[16];  //<类型:系统;当前计数值 - 128-159

  uint32_t elapse_tol; //<类型：系统；名字：容差设定；精度：0;单位：；
  uint32_t Reserve2[27];   //<类型:系统;名字:当前定时时间; 单位:ms
  uint32_t Reserve3[20];   //<类型:系统;名字:目标定时时间; 单位:ms
  uint32_t Reserve4[16];   //<类型:系统;名字:当前计数值;   单位:ms
  uint32_t Reserve5[16];   //<类型:系统;名字:目标计数值;   单位:ms
}RESERVE0;

typedef struct{
    RESERVE0 p;
}ReverseStruct;

typedef union {
    ReverseStruct para;
    uint32_t all[STRUCE_SIZE(ICAddr_Adapter_Para110, ICAddr_Adapter_Para189)];
} RESERVE;


static const uint32_t axis_map_addr[] = {
    ICAddr_Adapter_Para190,
    ICAddr_Adapter_Para193 //<类型：模号；名字：；结构：SYSTEM_PARA；地址：system_addr；
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
    uint32_t all[STRUCE_SIZE(ICAddr_Adapter_Para190, ICAddr_Adapter_Para193)];
} AXIS_MAP;


static const uint32_t alpha_addr[] = {
    ICAddr_Adapter_Para198,
    ICAddr_Adapter_Para201 //<类型：模号；名字：；结构：SYSTEM_PARA；地址：system_addr；
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
    uint32_t all[STRUCE_SIZE(ICAddr_Adapter_Para198, ICAddr_Adapter_Para201)];
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
        uint32_t install:1;//<类型：模号；名字：安装工具坐标；精度：0;单位：；
        uint32_t re:22;//<类型：模号；名字：备用；精度：0;单位：；
    }bit;
    uint32_t a;
}MOLD_PRO_USE;


static const uint32_t mold_p_addr[] = {
    ICAddr_Mold_Para1,
    ICAddr_Mold_Para36 //<类型：模号；名字：；结构：MOLD_PARA；地址：mold_p_addr；
};
typedef union{
    struct{
        uint32_t X1;//<类型：模号；名字：X1脉冲；精度：0;单位：；
        uint32_t Y1;//<类型：模号；名字：Y1脉冲；精度：0;单位：；
        uint32_t Z1;//<类型：模号；名字：Z1脉冲；精度：0;单位：；
        uint32_t U1;//<类型：模号；名字：U1脉冲；精度：0;单位：；
        uint32_t V1;//<类型：模号；名字：V1脉冲；精度：0;单位：；
        uint32_t W1;//<类型：模号；名字：W1脉冲；精度：0;单位：；
        uint32_t X2;//<类型：模号；名字：X2脉冲；精度：0;单位：；
        uint32_t Y2;//<类型：模号；名字：Y2脉冲；精度：0;单位：；
        uint32_t Z2;//<类型：模号；名字：Z2脉冲；精度：0;单位：；
        uint32_t U2;//<类型：模号；名字：U2脉冲；精度：0;单位：；
        uint32_t V2;//<类型：模号；名字：V2脉冲；精度：0;单位：；
        uint32_t W2;//<类型：模号；名字：W2脉冲；精度：0;单位：；
        uint32_t X3;//<类型：模号；名字：X3脉冲；精度：0;单位：；
        uint32_t Y3;//<类型：模号；名字：Y3脉冲；精度：0;单位：；
        uint32_t Z3;//<类型：模号；名字：Z3脉冲；精度：0;单位：；
        uint32_t U3;//<类型：模号；名字：U3脉冲；精度：0;单位：；
        uint32_t V3;//<类型：模号；名字：V3脉冲；精度：0;单位：；
        uint32_t W3;//<类型：模号；名字：W3脉冲；精度：0;单位：；
        uint32_t X4;//<类型：模号；名字：X4脉冲；精度：0;单位：；
        uint32_t Y4;//<类型：模号；名字：Y4脉冲；精度：0;单位：；
        uint32_t Z4;//<类型：模号；名字：Z4脉冲；精度：0;单位：；
        uint32_t U4;//<类型：模号；名字：U4脉冲；精度：0;单位：；
        uint32_t V4;//<类型：模号；名字：V4脉冲；精度：0;单位：；
        uint32_t W4;//<类型：模号；名字：W4脉冲；精度：0;单位：；


        uint32_t X5;//<类型：模号；名字：X5脉冲；精度：0;单位：；
        uint32_t Y5;//<类型：模号；名字：Y5脉冲；精度：0;单位：；
        uint32_t Z5;//<类型：模号；名字：Z5脉冲；精度：0;单位：；
        uint32_t U5;//<类型：模号；名字：U5脉冲；精度：0;单位：；
        uint32_t V5;//<类型：模号；名字：V5脉冲；精度：0;单位：；
        uint32_t W5;//<类型：模号；名字：W5脉冲；精度：0;单位：；
        uint32_t X6;//<类型：模号；名字：X6脉冲；精度：0;单位：；
        uint32_t Y6;//<类型：模号；名字：Y6脉冲；精度：0;单位：；
        uint32_t Z6;//<类型：模号；名字：Z6脉冲；精度：0;单位：；
        uint32_t U6;//<类型：模号；名字：U6脉冲；精度：0;单位：；
        uint32_t V6;//<类型：模号；名字：V6脉冲；精度：0;单位：；
        uint32_t W6;//<类型：模号；名字：W6脉冲；精度：0;单位：；
    }pos;
    uint32_t p[36];
}MOLD_P;

typedef struct{
    MOLD_PRO_USE use_p;
    MOLD_P tool;
}MOLD_PARAStruct;


typedef union {
    MOLD_PARAStruct para;
    uint32_t all[STRUCE_SIZE(ICAddr_Mold_Para0,ICAddr_Write_Section_End)];
}MOLD_PARA;


static const uint32_t read_addr[] = {
    ICAddr_Read_Status0,
    ICAddr_Read_Status40 //<类型：模号；名字：；结构：SYSTEM_PARA；地址：system_addr；
};
typedef struct{
    Axis_Data axis_data[8];
    uint32_t alarm;//<类型：状态；名字：当前报警；精度：0;单位：；
    STEP step;
    uint32_t origin:1;//<类型：状态；名字：原点信号；精度：0;单位：；
    uint32_t mode:4;//<类型：状态；名字：当前模式；精度：0;单位：；
    uint32_t io_id:3;//<类型：状态；名字：IO板ID；精度：0;单位：；
    uint32_t cnt_id:5;//<类型：状态；名字：计数器ID；精度：0;单位：；
    uint32_t cnt:19;//<类型：状态；名字：计数器当前计数；精度：0;单位：；
    uint32_t io_in;//<类型：状态；名字：IO板输入状态；精度：0;单位：；
    uint32_t io_out;//<类型：状态；名字：IO板输出状态；精度：0;单位：；
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
    Interpolation interpolation;//<类型：系统；名字：；精度：1;单位：
    ALPHA alpha;  //<类型：系统；名字：设定初始夹角；精度：3;单位：度；
    uint32_t p[ICAddr_Adapter_Para255-ICAddr_Adapter_Para201];
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
