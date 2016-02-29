//
//  Interface.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/6/15.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "Interface.h"

@implementation Interface

+ (Interface *)shareInstance{
    static Interface *_instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

/*
 *   1.生成手机短信验证码  1、注册 2、修改密码（已登录）3、修改手机（已登录） 4、找回密码（无法登录）5、更换手机（无法登录）
 */
+ (void)vertifyCodeWithcallLetter:(NSString *)callLetter type:(int)type block:(CompletionHandle)block {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:callLetter forKey:@"callLetter"];
    [params setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [ZPAFDataService requestWithURL:VERTIFYCODE params:params httpMethod:@"POST" block:block];
}
/*
 *   2.用户注册接口
 */
+ (void)registerWithCallLetter:(NSString *)callLetter password:(NSString *)password sms:(NSString *)sms block:(CompletionHandle)block failblock:(FailHandle)failblock{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:callLetter forKey:@"callLetter"];
    [params setObject:[NSString md5:password] forKey:@"password"];
    [params setObject:sms forKey:@"sms"];
    [ZPAFDataService request:REGISTER_URL params:params httpMethod:@"POST" block:block failblock:failblock];
}
/*
 *   3.用户登录
 */
+ (void)loginWithName:(NSString *)callLetter password:(NSString *)password
                block:(CompletionHandle)block failblock:(FailHandle)failblock{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:callLetter forKey:@"callLetter"];
    [params setObject:[NSString md5:password] forKey:@"password"];
    [ZPAFDataService request:LOGIN_URL params:params httpMethod:@"POST" block:block failblock:failblock];
}
/*
 *   4.找回密码(手机号能用)
 */
+ (void)lookBackPassword:(NSString *)callLetter password:(NSString *)password sms:(NSString *)sms block:(CompletionHandle)block failblock:(FailHandle)failblock{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:callLetter forKey:@"callLetter"];
    [params setObject:[NSString md5:password] forKey:@"password"];
    [params setObject:sms forKey:@"sms"];
    [ZPAFDataService request:LOOKBACKCODE_URL params:params httpMethod:@"POST" block:block failblock:failblock];
}
/*
 *   5.丢失手机 验证身份
 */
+ (void)vertifyUserIdentity:(NSString *)callLetter  plateNo:(NSString *)plateNo vin:(NSString *)vin engineNo:(NSString *)engineNo block:(CompletionHandle)block{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:callLetter forKey:@"callLetter"];  //18820028298
    [params setObject:plateNo forKey:@"plateNo"];        //粤BC07D6
    [params setObject:engineNo forKey:@"engineNo"];      //EJ20768
    [params setObject:vin forKey:@"vin"];                //LVSFCAME2EF797906
    [ZPAFDataService requestWithURL:VERTIFYIDENTITY_URL params:params httpMethod:@"POST" block:block];
}
/*
 *   6.找回密码(手机号不能用)
 */
+ (void)newMobileResetNumberAndPasswordcallLetter:(NSString *)callLetter  password:(NSString *)password sms:(NSString *)sms block:(CompletionHandle)block failblock:(FailHandle)failblock{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:[NSNumber numberWithLong:userId] forKey:@"userId"];
    [params setObject:callLetter forKey:@"callLetter"];
    [params setObject:[NSString md5:password] forKey:@"password"];
    [params setObject:sms forKey:@"sms"];
    [ZPAFDataService request:NewMobileResetNumberAndPassword params:params httpMethod:@"POST" block:block failblock:failblock];
}
/*
 *  7.修改密码  (唐练)
 */
+ (void)modifyPassword:(NSString *)password  sms:(NSString *)sms block:(CompletionHandle)block{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString md5:password] forKey:@"password"];
    [params setObject:sms forKey:@"sms"];
    [ZPAFDataService requestWithURL:MODIFYPASSWORD params:params httpMethod:@"POST" block:block];
}
/*
 *  8.修改手机 (唐练)
 */
+ (void)modifyMobile:(NSString *)callLetter sms:(NSString *)sms block:(CompletionHandle)block{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:callLetter forKey:@"callLetter"];
    [params setObject:sms forKey:@"sms"];
    
    [ZPAFDataService requestWithURL:MODIFYMOBILE params:params httpMethod:@"POST" block:block];
}
/*
 *  9.获取详细资料  (唐练)
 */
+ (void)getUserDetailMessageWithblock:(CompletionHandle)block{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [ZPAFDataService requestWithURL:GETUSERDETAIL params:params httpMethod:@"POST" block:block];
}





///////////////////////////////////////收益接口///////////////////////////////////////////////////
///////////////////////////////////////收益接口///////////////////////////////////////////////////
///////////////////////////////////////收益接口///////////////////////////////////////////////////
/*
 *  10.收益首页头部天气信息 PEECAACYTOPWHEATHER
 */
+ (void)getTopWheatherInfoWithCity:(NSString *)city block:(CompletionHandle)block failblock:(FailHandle)failblock{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:city forKey:@"city"];   //默认为深圳
    [ZPAFDataService request:PEECAACYTOPWHEATHER params:params httpMethod:@"POST" block:block failblock:failblock];
}
/*
 *  11.收益首页头部广告图  0 消息中心  1 首页轮播图
 */
+ (void)getTopUrlInfotype:(int)type block:(CompletionHandle)block failblock:(FailHandle)failblock{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [ZPAFDataService request:PEECAACYTOPURL params:params httpMethod:@"POST" block:block failblock:failblock];
}

/*
 *  12.收益首页
 */
+ (void)getPeccacyHomeDataWithvehicleId:(long)vehicleId block:(CompletionHandle)block failblock:(FailHandle)failblock{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithLong:vehicleId] forKey:@"vehicleId"];
    [ZPAFDataService request:PEECAACYHOMEDATA params:params httpMethod:@"POST" block:block failblock:failblock];
}

/*
 *  13.昨日收益详情
 */
+ (void)yesturdayPeccacyDetail:(long)vehicleId block:(CompletionHandle)block failblock:(FailHandle)failblock{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithLong:vehicleId] forKey:@"vehicleId"];
    [ZPAFDataService request:YESTURDAYINCOMEDETAIL params:params httpMethod:@"POST" block:block failblock:failblock];
}

/*
 *  14.安全驾驶明细
 */
+ (void)securityDriveDetail:(long)vehicleId block:(CompletionHandle)block failblock:(FailHandle)failblock{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithLong:vehicleId] forKey:@"vehicleId"];
    [ZPAFDataService request:SECURITYDRIVEDETAIL params:params httpMethod:@"POST" block:block failblock:failblock];
}

/*
 *  15.累计收益  开始日期 "yyyy-MM-dd" 格式 结束日期 "yyyy-MM-dd" 格式
 */
+ (void)totalPeccacyDetail:(long)vehicleId startDate:(NSString *)startDate  endDate:(NSString *)endDate block:(CompletionHandle)block failblock:(FailHandle)failblock{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithLong:vehicleId] forKey:@"vehicleId"];
    [params setObject:startDate forKey:@"startDate"];
    [params setObject:endDate forKey:@"endDate"];
    [ZPAFDataService request:TOTALPEECCACYDETAIL params:params httpMethod:@"POST" block:block failblock:failblock];
}



///////////////////////////////////////爱车接口///////////////////////////////////////////////////
///////////////////////////////////////爱车接口///////////////////////////////////////////////////
///////////////////////////////////////爱车接口///////////////////////////////////////////////////
/*
 *   16.获取绑定车辆列表  -1全部默认  0非设备  1设备  (唐练 朱鹏)
 */
+ (void)getBindingVehicleWithType:(long)hasUnit block:(CompletionHandle)block failblock:(FailHandle)failblock{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithLong:hasUnit] forKey:@"hasUnit"];
    [ZPAFDataService request:BINDINGCARLIST params:params httpMethod:@"POST" block:block failblock:failblock];
}
/*
 *   17.扫码绑定车辆
 */
+ (void)swipeQRCodeBindCarWithimei:(NSString *)imei  plateNo:(NSString *)plateNo distanceLevel:(NSString *)distanceLevel block:(CompletionHandle)block {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:imei forKey:@"imei"];
    [params setObject:plateNo forKey:@"plateNo"];
    [params setObject:distanceLevel forKey:@"distanceLevel"];
    [ZPAFDataService requestWithURL:SWIPEQRCODEBINDING params:params httpMethod:@"POST" block:block ];
}
/*
 *   18.解除绑定设备车辆  (朱鹏、唐练)
 */
+ (void)unbindingDeviceCarvehicleId:(long)vehicleId block:(CompletionHandle)block{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithLong:vehicleId] forKey:@"vehicleId"];
    [ZPAFDataService requestWithURL:UNBINDINGDEVICECAR params:params httpMethod:@"POST" block:block];
}
/*
 *   19.修改默认车辆   (唐练)
 */
+ (void)chagngeTheTerminalDeviceVehicleId:(long)vehicleId block:(CompletionHandle)block{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithLong:vehicleId] forKey:@"vehicleId"];
    [ZPAFDataService requestWithURL:CHANGETERMINALDEVICE params:params httpMethod:@"POST" block:block];
}
/*
 *   22.行程统计 UBITravelStatistics
 */
+ (void)UBICarTravelListWithvehicleId:(long)vehicleId  startDate:(NSString *)startDate endDate:(NSString *)endDate block:(CompletionHandle)block failblock:(FailHandle)failblock{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithLong:vehicleId] forKey:@"vehicleId"];
    [params setObject:startDate forKey:@"startDate"];
    [params setObject:endDate forKey:@"endDate"];
    [ZPAFDataService request:UBITravelStatistics params:params httpMethod:@"POST" block:block failblock:failblock];
}

/*
 *   23.里程统计 UBIMileageStatistics
 */
+ (void)UBIMileageListWithvehicleId:(long)vehicleId  startDate:(NSString *)startDate endDate:(NSString *)endDate block:(CompletionHandle)block failblock:(FailHandle)failblock{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithLong:vehicleId] forKey:@"vehicleId"];
    [params setObject:startDate forKey:@"startDate"];
    [params setObject:endDate forKey:@"endDate"];
    [ZPAFDataService request:UBIMileageStatistics params:params httpMethod:@"POST" block:block failblock:failblock];
}

///////////////////////////////////////违章接口///////////////////////////////////////////////////
///////////////////////////////////////违章接口///////////////////////////////////////////////////
///////////////////////////////////////违章接口///////////////////////////////////////////////////
/*
 *   24.违章查询
 */
+ (void)UBIIlegalQueryWithvehicleId:(long)vehicleId  plateNo:(NSString *)plateNo vin:(NSString *)vin engineNo:(NSString *)engineNo block:(CompletionHandle)block{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[appdelegate cityCodeArrayOfCityArray] forKey:@"cnty"];;
    [params setObject:[NSNumber numberWithLong:vehicleId] forKey:@"vehicleId"];
    [params setObject:plateNo forKey:@"plateNo"];
    [params setObject:vin forKey:@"vin"];
    [params setObject:engineNo forKey:@"engineNo"];
    [ZPAFDataService requestWithURL:UBIIlegalQuery params:params httpMethod:@"POST" block:block ];
}
/*
 *   25.推送违章查询
 */
+ (void)UBIIlegalQueryWithCity:(NSString *)city vehicleId:(long)vehicleId plateNo:(NSString *)plateNo vin:(NSString *)vin engineNo:(NSString *)engineNo block:(CompletionHandle)block failblock:(FailHandle)failblock{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:city forKey:@"cnty"];;
    [params setObject:[NSNumber numberWithLong:vehicleId] forKey:@"vehicleId"];
    [params setObject:plateNo forKey:@"plateNo"];
    [params setObject:vin forKey:@"vin"];
    [params setObject:engineNo forKey:@"engineNo"];
    [ZPAFDataService request:UBIIlegalQuery params:params httpMethod:@"POST" block:block failblock:failblock];
}
/*
 *   26.获取聚合城市代码 http://v.juhe.cn/wz/citys
 */
+ (void)getCityFromJUHEblock:(CompletionHandle)block{
    [ZPAFDataService requestWithURL:@"http://v.juhe.cn/wz/citys?key=8c9311af0d5c38189ae93b3627dcc983" block:block];
}

/*
 *   27.自动登录
 */
+ (void)autoLoginRequest{
    if([Interface shareInstance].isGetCarListFailure){
        [Interface getBindingVehicleList:[Interface shareInstance].loginResult];
        return;
    }
    if([Interface shareInstance].isAutoLoginSuccess){
        [Interface getBindingVehicleList:[Interface shareInstance].loginResult];
    }else{
        [Interface login];
    }
}

/*
 *   28.登录失效
 */
+ (void)loginUnUsefulComfirmblock:(void (^)(void)) comfirmblock{

    NSString *account =  [SFHFKeychainUtils getPasswordForUsername:KCSUBUSERACCOUNT andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL];
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:KCSUBPASSWORD andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL];
    
    [Interface loginWithName:account password:password block:^(id result) {
        
        //缓存登录信息
        [ZPUiutsHelper storeNowMobileLoginResult:result];
        
        [Interface getBindingVehicleWithType:1 block:^(id result) {
            
            //列表信息
            NSDictionary *dic = [[result objectForKey:KServerdataStr] firstObject];
            [[CurrentDeviceModel shareInstance] setKeyValues:dic];
            
            if(comfirmblock)
                comfirmblock();
            
        }failblock:^(id result) {
            
            
        }];
         

    }failblock:^(id result) {
        
        
    }];
}

+ (void)login{
    
    NSString *account =  [SFHFKeychainUtils getPasswordForUsername:KCSUBUSERACCOUNT andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL];
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:KCSUBPASSWORD andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL];
    
    __block AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [Interface loginWithName:account password:password block:^(id result) {
        
        
        [Interface shareInstance].isAutoLoginSuccess = YES;
        [Interface shareInstance].loginResult = result;
        [Interface getBindingVehicleList:result];
        
    }failblock:^(id result) {
        
        //－2登录名或密码错误
        if(result && [[result objectForKey:KServererrorCodeStr]  isEqual: @-2]){
         
            NSString *indicatorstr;
            if([result objectForKey:KServererrorMsgStr] == nil ||
               [[result objectForKey:KServererrorMsgStr] isKindOfClass:[NSNull class]]){
                indicatorstr = KLoginError;
            }else{
                indicatorstr = [result objectForKey:KServererrorMsgStr];
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showIndicator:indicatorstr];
                

                UBLoginViewController *loagin =  [[UBLoginViewController alloc]init];
                loagin.logAgain = YES;
                ZPBaseNavigationController *navi = [[ZPBaseNavigationController alloc]initWithRootViewController:loagin];
                delegate.window.rootViewController  = navi;
            
            });
        }else{
        
          [Interface shareInstance].isAutoLoginSuccess = NO;
        }
    }];
}

+ (void)getBindingVehicleList:(NSDictionary *)logresult{
    
    __block AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [Interface getBindingVehicleWithType:1 block:^(id result) {
        
        NSLog(@"%@",result);
        NSArray *data = [result objectForKey:KServerdataStr];
        if (data.count == 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate bindingViewController];
            });
        }else{
            
            [Interface shareInstance].isGetCarListFailure = NO;
      
            //缓存登录信息
            [ZPUiutsHelper storeNowMobileLoginResult:logresult];
            
            //列表信息
            NSDictionary *dic = [[result objectForKey:KServerdataStr] firstObject];
            [[CurrentDeviceModel shareInstance] setKeyValues:dic];
            
            
            [[ProceedsVC shareInstance] loadAllData];
            
        }
    }failblock:^(id result){
        
        [Interface shareInstance].isGetCarListFailure = YES;
    }];
}



- (void)setIsAutoLoginSuccess:(BOOL)isAutoLoginSuccess{
    _isAutoLoginSuccess = isAutoLoginSuccess;
    if(!isAutoLoginSuccess){
         if([UIDevice checkNowNetworkStatus])
        [Interface autoLoginRequest];
    }
}
//请求列表失败
- (void)setIsGetCarListFailure:(BOOL)isGetCarListFailure{
    _isGetCarListFailure = isGetCarListFailure;
    if(isGetCarListFailure){
        if([UIDevice checkNowNetworkStatus])
        [Interface  autoLoginRequest];
    }
}


/**
 *   Reachability
 *
 *  @param animated
 */
- (void)ReachabilitySettings{
   Reachability *reach = [Reachability reachabilityForInternetConnection];
    reach.reachableBlock = ^(Reachability * reachability)
    {
        if(reachability.isReachableViaWiFi){
            
            NSLog(@"Wi-Fi");
            
        }else if (reachability.isReachableViaWWAN){
            
            NSLog(@"运营商网络");
        }
        if([Interface shareInstance].isGetCarListFailure || ![Interface shareInstance].isAutoLoginSuccess){
        
            [Interface  autoLoginRequest];
        }
    };
    [reach startNotifier];
}

/**
 *  29.反馈建议
 */
+ (void)suggestWithContent:(NSString *)content block:(CompletionHandle)block{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:content forKey:@"content"];
    [ZPAFDataService requestWithURL:SUGGEST params:params httpMethod:@"POST" block:block];
}
@end
