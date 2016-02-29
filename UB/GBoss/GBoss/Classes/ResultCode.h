//
//  ResultCode.h
//  testpb
//
//  Created by SG on 14-6-12.
//  Copyright (c) 2014年 ChinaGPS. All rights reserved.
//

#ifndef ResultCode_h
#define ResultCode_h

typedef enum _GBossResultCode{
    GBossResultCode_OK = 0,                         //成功
    GBossResultCode_UserName_Error = 1,             //用户不存在
    GBossResultCode_Password_Error = 2,             //密码错误
    GBossResultCode_UserExist_Error = 3,            //用户已经存在
    GBossResultCode_LoginNameExist_Error = 4,       //登录名已经存在
    GBossResultCode_MobileExist_Error = 5,          //手机号已经存在
    GBossResultCode_EmailExist_Error = 6,           //Email已经存在
    GBossResultCode_UserNoExist_Error = 7,          //用户不存在
    GBossResultCode_LoginNameEdit_Error = 8,        //登录名不能修改
    GBossResultCode_VehicleNoExist_Error = 9,       //车辆不存在，车牌号错误
    GBossResultCode_UnitNoExist_Error = 10,         //车台不存在, 呼号错误
    GBossResultCode_UserNoVehicle_Error = 11,       //用户没有该车辆
    GBossResultCode_VehicleNoUnit_Error = 12,       //车辆没有该车台
    GBossResultCode_CallLetterExist_Error = 13,     //车载号码已经存在
    GBossResultCode_UnitNoAck_Error = 14,           //指令发送成功但车台无反应
    GBossResultCode_CommandID_Error = 15,           //命令ID错误
    GBossResultCode_Parameters_Error = 16,          //参数错误
    GBossResultCode_Send_Error = 17,                //发送失败
    GBossResultCode_Timeout_Error = 18,             //超时失败
    GBossResultCode_CompanyNoExist_Error = 20,      //商户不存在
    GBossResultCode_NoLogin_Error = 21,             //没有登录
    GBossResultCode_DataBase_Error = 22,            //数据库错误
    GBossResultCode_ConnectFail_Error = 23,         //连接不成功
    GBossResultCode_Encode_Error = 24,              //编码（打包）错误
    GBossResultCode_Decode_Error = 25,              //解码（解包）失败
    GBossResultCode_Format_Error = 26,              //格式错误
    GBossResultCode_Time_Error = 27,                //时间错误
    GBossResultCode_NoRequest_Error = 28,           //没有申请错误
    GBossResultCode_Shutdowm_Error = 29,            //终端已经关机错误
    
    GBossResultCode_SeatNoLogin_Error = 40,         //坐席没有登录错误
    GBossResultCode_AlarmNoExist_Error = 41,        //警单不存在错误
    GBossResultCode_AlarmHandled_Error = 42,        //警单已经处理
    GBossResultCode_SeatExist_Error = 43,        	//坐席已经存在
    GBossResultCode_SeatBusy_Error = 44,        	//坐席忙碌
    GBossResultCode_Seat_Error = 45,                //坐席错误
    
    GBossResultCode_Hbase_Error = 101,                  //Hbase存储错误
    GBossResultCode_LastPosition_Error = 102,           //没有最后位置
    GBossResultCode_HistoryPosition_Error = 103,        //没有历史位置
    GBossResultCode_HistoryPositionNoStart_Error = 104, //没有开始历史位置（取下一页时）
    
    GBossResultCode_LastTravel_Error = 105,             //没有最后行程
    GBossResultCode_HistoryTravel_Error = 106,          //没有历史行程
    GBossResultCode_HistoryTravelNotStart_Error = 107,  //没有开始历史行程（取下一页时）
    
    GBossResultCode_LastFault_Error = 108,             //没有最后故障
    GBossResultCode_HistoryFault_Error = 109,          //没有历史故障
    GBossResultCode_HistoryFaultNotStart_Error = 110,  //没有开始历史故障（取下一页时）
    
    GBossResultCode_LastAlarm_Error = 111,           	//没有最后警情
    GBossResultCode_HistoryAlarm_Error = 112,        	//没有历史警情
    GBossResultCode_HistoryAlarmNoStart_Error = 113, 	//没有开始历史警情（取下一页时）
    
    GBossResultCode_LastOperateData_Error = 114,           //没有最后运营数据
    GBossResultCode_HistoryOperateData_Error = 115,        //没有历史运营数据
    GBossResultCode_HistoryOperateDataNoStart_Error = 116, //没有开始历史运营数据（取下一页时）
    
    GBossResultCode_LastSm_Error = 117,           	//没有最后短信
    GBossResultCode_HistorySm_Error = 118,        	//没有历史短信
    GBossResultCode_HistorySmNoStart_Error = 119, 	//没有开始历史短信（取下一页时）
    
    GBossResultCode_RefuseAlarm_Error = 201, 		//拒绝处理警情
    GBossResultCode_AppendAlarm_Error = 211, 		//添加警情到警情队列失败
    
    GBossResultCode_Other_Error = -1               //其他错误
}GBossResultCode;

#endif
