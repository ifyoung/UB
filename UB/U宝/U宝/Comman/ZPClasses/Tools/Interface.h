//
//  Interface.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/6/15.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPAFDataService.h"

@interface Interface : NSObject

@property (nonatomic,assign)BOOL isAutoLoginSuccess;
@property (nonatomic,assign)BOOL isGetCarListFailure;
@property (nonatomic,strong)NSDictionary *loginResult;

/*
 *   1.验证码
 */
+ (void)vertifyCodeWithcallLetter:(NSString *)callLetter type:(int)type block:(CompletionHandle)block;

/*
 *   2.用户注册接口
 */
+ (void)registerWithCallLetter:(NSString *)callLetter password:(NSString *)password sms:(NSString *)sms block:(CompletionHandle)block failblock:(FailHandle)failblock;
/*
 *   3.用户登录
 */
+ (void)loginWithName:(NSString *)callLetter password:(NSString *)password
                block:(CompletionHandle)block failblock:(FailHandle)failblock;
/*
 *   4.找回密码
 */
+ (void)lookBackPassword:(NSString *)callLetter password:(NSString *)password sms:(NSString *)sms block:(CompletionHandle)block failblock:(FailHandle)failblock;
/*
 *   5.丢失手机 验证身份 -2认证失败
 */
+ (void)vertifyUserIdentity:(NSString *)callLetter  plateNo:(NSString *)plateNo vin:(NSString *)vin engineNo:(NSString *)engineNo block:(CompletionHandle)block;
/*
 *   6.丢失手机 — 重设手机号与密码
 */
+ (void)newMobileResetNumberAndPasswordcallLetter:(NSString *)callLetter  password:(NSString *)password sms:(NSString *)sms block:(CompletionHandle)block failblock:(FailHandle)failblock;
/*
 *   7.修改密码
 */
+ (void)modifyPassword:(NSString *)password  sms:(NSString *)sms block:(CompletionHandle)block;
/*
 *  8.修改手机  (唐练)
 */
+ (void)modifyMobile:(NSString *)callLetter sms:(NSString *)sms block:(CompletionHandle)block;
/*
 *  9.获取详细资料  (唐练)
 */
+ (void)getUserDetailMessageWithblock:(CompletionHandle)block;

///////////////////////////////////////收益接口///////////////////////////////////////////////////
///////////////////////////////////////收益接口///////////////////////////////////////////////////
///////////////////////////////////////收益接口///////////////////////////////////////////////////
/*
 *  10.收益首页头部天气信息
 */
+ (void)getTopWheatherInfoWithCity:(NSString *)city block:(CompletionHandle)block failblock:(FailHandle)failblock;
/*
 *  11.收益首页头部天气信息
 */
+ (void)getTopUrlInfotype:(int)type block:(CompletionHandle)block failblock:(FailHandle)failblock;
/*
 *  12.收益首页
 */
+ (void)getPeccacyHomeDataWithvehicleId:(long)vehicleId block:(CompletionHandle)block failblock:(FailHandle)failblock;
/*
 *  13.昨日收益详情
 */
+ (void)yesturdayPeccacyDetail:(long)vehicleId block:(CompletionHandle)block failblock:(FailHandle)failblock;
/*
 *  14.安全驾驶明细
 */
+ (void)securityDriveDetail:(long)vehicleId block:(CompletionHandle)block failblock:(FailHandle)failblock;
/*
 *  15.累计收益  开始日期 "yyyy-MM-dd" 格式 结束日期 "yyyy-MM-dd" 格式
 */
+ (void)totalPeccacyDetail:(long)vehicleId startDate:(NSString *)startDate  endDate:(NSString *)endDate block:(CompletionHandle)block failblock:(FailHandle)failblock;




///////////////////////////////////////爱车接口///////////////////////////////////////////////////
///////////////////////////////////////爱车接口///////////////////////////////////////////////////
///////////////////////////////////////爱车接口///////////////////////////////////////////////////
/*
 *   16.获取绑定车辆列表 -1全部默认  0非设备  1设备  (朱鹏 唐练)
 */
+ (void)getBindingVehicleWithType:(long)hasUnit block:(CompletionHandle)block failblock:(FailHandle)failblock;

/*
 *   17.扫码绑定车辆
 */
+ (void)swipeQRCodeBindCarWithimei:(NSString *)imei  plateNo:(NSString *)plateNo distanceLevel:(NSString *)distanceLevel block:(CompletionHandle)block;

/*
 *   18.解除绑定设备车辆   (唐练)
 */
+ (void)unbindingDeviceCarvehicleId:(long)vehicleId block:(CompletionHandle)block;

/*
 *   19.修改默认车辆   (唐练)
 */
+ (void)chagngeTheTerminalDeviceVehicleId:(long)vehicleId block:(CompletionHandle)block;

/*
 *   22.行程统计 UBITravelStatistics
 */
+ (void)UBICarTravelListWithvehicleId:(long)vehicleId  startDate:(NSString *)startDate endDate:(NSString *)endDate block:(CompletionHandle)block failblock:(FailHandle)failblock;

/*
 *   23.里程统计 UBIMileageStatistics
 */
+ (void)UBIMileageListWithvehicleId:(long)vehicleId  startDate:(NSString *)startDate endDate:(NSString *)endDate block:(CompletionHandle)block failblock:(FailHandle)failblock;

///////////////////////////////////////违章接口///////////////////////////////////////////////////
///////////////////////////////////////违章接口///////////////////////////////////////////////////
///////////////////////////////////////违章接口///////////////////////////////////////////////////

/*
 *   24.违章查询
 */
+ (void)UBIIlegalQueryWithvehicleId:(long)vehicleId  plateNo:(NSString *)plateNo vin:(NSString *)vin engineNo:(NSString *)engineNo block:(CompletionHandle)block ;
/*
 *   25.推送违章查询
 */
+ (void)UBIIlegalQueryWithCity:(NSString *)city vehicleId:(long)vehicleId plateNo:(NSString *)plateNo vin:(NSString *)vin engineNo:(NSString *)engineNo block:(CompletionHandle)block failblock:(FailHandle)failblock;
/*
 *   26.获取聚合城市代码 http://v.juhe.cn/wz/citys
 */
+ (void)getCityFromJUHEblock:(CompletionHandle)block;
/*
 *   27.自动登录
 */
+ (void)autoLoginRequest;

/*
 *   28.登录失效
 */
+ (void)loginUnUsefulComfirmblock:(void (^)(void)) comfirmblock;

/**
 *  29.反馈建议
 */
+ (void)suggestWithContent:(NSString *)content block:(CompletionHandle)block;

@end
