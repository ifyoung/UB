//
//  MessageType.h
//  testpb
//
//  Created by SG on 14-6-12.
//  Copyright (c) 2014年 ChinaGPS. All rights reserved.
//

#ifndef MessageType_h
#define MessageType_h

typedef enum _GBossRemoteControlType {
    GBossRemoteControlViewCarType = 0x0001,
    GBossRemoteControlLockType = 0x0004,
    GBossRemoteControlUnlockType = 0x0005,
    GBossRemoteControlAbortType = 0x0006,
    GBossRemoteControlResumeType = 0x0007,
    GBossRemoteControlOpenWindowsType = 0x000D,
    GBossRemoteControlCloseWindowsType = 0x000E,
    GBossRemoteControlFindCarType = 0x0013,
    GBossRemoteControlLightOnType = 0x0061,
    GBossRemoteControlLightOffType = 0x0062,
    GBossRemoteControlOpenTrunkType = 0x0063,
    GBossRemoteControlNavigationType = 0x0292,
    GBossRemoteControlFireType= 0x0069,
    GBossRemoteControlFlameType = 0x006A,
    GBossRemoteControlSetAirType = 0x0065,
    GBossRemoteControlResetAirType = 0x0066,
    GBossRemoteControlExamType = 0x00A3
}GBossRemoteControlType;

typedef enum _GBossMessageType {
    GBossMessageType_Login = 1001,               //登录
    GBossMessageType_Login_ACK = 8001,           //登录应答
    GBossMessageType_Logout = 1002,              //退录
    GBossMessageType_Logout_ACK = 8002,          //退录应答
    GBossMessageType_ActiveLink = 1003,          //链路检测（心跳）
    GBossMessageType_ActiveLink_ACK = 8003,      //链路检测（心跳）应答
    
    GBossMessageType_AddMonitor = 1011,          //添加监控列表
    GBossMessageType_AddMonitor_ACK = 8011,      //添加监控列表应答
    GBossMessageType_RemoveMonitor = 1012,       //删除监控列表
    GBossMessageType_RemoveMonitor_ACK = 8012,   //删除监控列表应答
    
    GBossMessageType_GetLastInfo = 1013,                //取最后位置、取最后行程、取最后故障
    GBossMessageType_GetLastInfo_ACK = 8013,            //取最后位置、取最后行程、取最后故障的应答
    GBossMessageType_GetHistoryInfo = 1014,             //取历史位置、历史行程、历史故障（如果换了一辆车，前一辆车的历史查询自动结束）
    GBossMessageType_GetHistoryInfoNextPage = 1015,     //取下一页历史位置、历史行程、历史故障
    GBossMessageType_GetHistoryInfo_ACK = 8014,         //取历史位置、历史行程、历史故障应答（1014, 1015共用一个应答）
    GBossMessageType_StopHistoryInfo = 1016,            //结束读历史位置、历史行程、历史故障（如果分页全部取完了，自动结束）
    GBossMessageType_StopHistoryInfo_ACK = 8016,        //结束读历史位置、历史行程、历史故障应答
    
    GBossMessageType_GetHistorySimpleGpsInfo_ACK = 8017,       //取历史位置主要信息应答
    
    GBossMessageType_SendCommand = 1051,            //下发指令
    GBossMessageType_SendCommand_ACK = 8051,        //下发指令结果
    GBossMessageType_SendCommandSend_ACK = 8052,    //网关发送指令成功回应
    
    GBossMessageType_TestDeliver = 2000,            //测试用，客户端请求模拟终端上传信息
    GBossMessageType_DeliverGPS = 2001,             //上传GPS（包括OBD数据）
    GBossMessageType_DeliverOperateData = 2002,     //上传运营数据
    GBossMessageType_DeliverSMS = 2003,             //上传短消息
    GBossMessageType_DeliverUnitLoginOut = 2004,    //上传终端登退录消息
    GBossMessageType_DeliverTravel = 2005,          //上传终端行程消息
    GBossMessageType_DeliverFault = 2006,           //上传终端故障消息
    GBossMessageType_DeliverAlarm = 2007,           //上传终端报警消息
    GBossMessageType_DeliverSimpleGPS = 2008,       //GPS主要信息(历史查询时用，减少传输字节)
    GBossMessageType_DeliverOBD = 2009,             //上传终端OBD数据
    GBossMessageType_DeliverAppNotice = 2010,       //APP通知类消息
    GBossMessageType_DeliverUnitVersion = 2011,     //终端升级成功上报版本号
    GBossMessageType_DeliverFaultLight = 2012,      //上传故障灯状态(放在GPS内，没有单独)
    GBossMessageType_DeliverECUConfig = 2013,       //上传ECU配置
    
    //下面是坐席和通信中心之间，预处理警情的报文类型**************************************************************************************
    GBossMessageType_SetAlarmBusy = 3001,           //坐席设置处理警情忙闲状态
    GBossMessageType_SetAlarmBusy_ACK = 10001,      //坐席设置处理警情忙闲状态, 服务器返回结果
    GBossMessageType_AllotAlarm = 3002,             //服务器分配警情给某坐席（包括追加警情）
    GBossMessageType_AllotAlarm_ACK = 10002,        //服务器分配警情给某坐席, 坐席应答结果
    GBossMessageType_PauseAlarm = 3003,             //坐席请求挂警（暂时不处理这个警情），可以接收其他警情
    GBossMessageType_PauseAlarm_ACK = 10003,        //服务器返回请求挂警结果
    GBossMessageType_CancelPauseAlarm = 3013,       //坐席请求取消挂警（继续处理这个警情）
    GBossMessageType_CancelPauseAlarm_ACK = 10013,  //服务器返回请求取消挂警结果
    GBossMessageType_HandleAlarm = 3004,            //坐席向服务器报告处理警情结果（已经追加的警情也作相同的处理）
    GBossMessageType_HandleAlarm_ACK = 10004,       //服务器返回处理警情结果
    
    GBossMessageType_AskSeatList = 3005,            //坐席向服务器请求坐席列表
    GBossMessageType_AskSeatList_ACK = 10005,       //服务器返回坐席列表
    GBossMessageType_TransferAlarm = 3006,          //坐席向服务器请求转警
    GBossMessageType_TransferAlarm_ACK = 10006,     //服务器返回转警请求结果, 只有等到已经转到目的坐席才返回
    GBossMessageType_AllotTransferAlarm = 3007,     //服务器向转警目的坐席分配转警
    GBossMessageType_AllotTransferAlarm_ACK = 10007,//目的坐席回复是否收到转警
    
    GBossMessageType_AskAlarmList = 3008,           //坐席向服务器请求警情列表（未处理和正在处理的）
    GBossMessageType_AskAlarmList_ACK = 10008,      //服务器返回警情列表
    
    //下面是通信中心之间协调，UDP组播报文类型*********************************************************************************************
    GBossMessageType_SeatStatus = 4001,             //坐席状态(登录、退录、忙碌、空闲、挂警、处警结果、申请转警、接收转警(Slaver通知Master)
    GBossMessageType_SeatStatus_ACK = 12001,        //Master应答
    GBossMessageType_NewAlarm = 4002,               //有新的警情生成(Slaver通知Master)
    GBossMessageType_NewAlarm_ACK = 12002          //Master应答
}GBossMessageType;

#endif
