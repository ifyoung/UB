//
//  Comman.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/6/10.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#ifndef _____Comman_h
#define _____Comman_h


//APP store APPID
#define APP_ID @"1063628434"


//主界面
#import "AppDelegate.h"
#import "RESideMenu.h"
#import "UIViewController+RESideMenu.h"
#import "ZPBaseNavigationController.h"
#import "ProceedsVC.h"
#import "PeccancyListVC.h"
#import "CarViewController.h"


/* 友盟统计 */
#import "MobClick.h"
#define AppScheme   @"cheshengUbao"
#define UMENG_APPKEY @"564159a867e58e80f700477a"  //友盟统计


//tools
#import "OLImage.h"
#import "OLImageView.h"
#import "Reachability.h"
#import "SRRefreshView.h"
#import "ZPUiutsHelper.h"
#import "MBProgressHUD.h"
#import "SFHFKeychainUtils.h"
#import "ZPLocationConverter.h"
#import "ALAssetsLibraryUitis.h"
#import "ELCImagePickerController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "TPKeyboardAvoidingScrollView.h"

//Extensions
#import "UIViewExt.h"
#import "UIImage+Addtions.h"
#import "NSString+Utils.h"
#import "UIView+Addition.h"
#import "MBProgressHUD+MJ.h"
#import "NSDate+Additions.h"
#import "UILabel+FormattedText.h"
#import "UIViewController+EXtension.h"
#import "UIDevice+IdentifierAddition.h"
#import "NSNull+InternalNullExtention.h"

//接口
#import "Interface.h"
#import "ZPAFDataService.h"

//MJ sqlite
#import "MJExtension.h"

//Model
#import "SeekparamModel.h"
#import "CurrentDeviceModel.h"
#import "PeccancyResultFrame.h"
#import "PeccancyResultModel.h"
#import "PeccancyRecordModel.h"

//webSocket
#import "CSWebSocketService.h"

//SDWebImage
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"



//appdelegate
#define  appdelegate  (AppDelegate *)[UIApplication sharedApplication].delegate
//屏幕大小
#define KSCREEHEGIHT [UIScreen mainScreen].bounds.size.height
#define KSCREEWIDTH  [UIScreen mainScreen].bounds.size.width
#define kBarContentHeight (1136 - 49 - 64)
#define kContentHeight    (1136 - 64)
#define nBarContentHeight (KSCREEHEGIHT - 49 - 64)
#define nContentHeight    (KSCREEHEGIHT - 64)
//收益设置
#define pcernt        170 / (1136 / 2.0 - 64 - 49.0)
#define TopPercent    ((KSCREEHEGIHT - 64 - 49) * pcernt)
#define ImageHight 164.0f


//判断是否为iOS8之前
#define iOS8Earlier ([[UIDevice currentDevice].systemVersion doubleValue] < 8.0)
//判断是否为iOS7之后
#define iOS7later ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

//获得RGB颜色
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define IWColorAlpha(r, g, b,c) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:c]
#define rgb(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//项目主题颜色
#define kColor        [ZPUiutsHelper colorWithHexString:@"#008dea"]
#define kColor008ce8  [ZPUiutsHelper colorWithHexString:@"#008ce8"]
#define kColor898989  [ZPUiutsHelper colorWithHexString:@"#898989"]
#define kColor7d7d7d  [ZPUiutsHelper colorWithHexString:@"#7d7d7d"]
#define kColor00a0e9  [ZPUiutsHelper colorWithHexString:@"#00a0e9"]
#define SettingColor IWColor(237, 238, 239)  //sideVC的颜色
#define bggrayColor  IWColor(238,238,238)

#define kLOADNIBWITHNAME(CLASS, OWNER) [[[NSBundle mainBundle] loadNibNamed:CLASS owner:OWNER options:nil] lastObject]



//log
/**
 *  输出时打印输出的位置
 *
 *  @param format
 *  @param ...
 *
 *  @return
 */
#if DEBUG
#define NSLog(format, ...)    do {  \
         fprintf(stderr, "<%s : %d> %s\n",    \
         [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
         __LINE__, \
          __func__); \
        (NSLog)((format), ##__VA_ARGS__);   \
         fprintf(stderr, "-------\n");      \
} while (0)
#else
#define NSLog(...)
#endif


//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define DLog(fmt, ...) \
         NSLog((@"%s [Line %d] " fmt), \
           __PRETTY_FUNCTION__,\
          __LINE__,\
          ##__VA_ARGS__);
#else
#   define DLog(...)
#endif


//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define ZPLog(FORMAT, ...) \
        fprintf(stderr,"\nfunction:%s line:%d content:%s\n", \
            __FUNCTION__,\
            __LINE__,\
            [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define ZPLog(FORMAT, ...) nil
#endif


//法一：单例化一个类
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
static classname *shared##classname = nil; \
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
return shared##classname; \
} \
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
return nil; \
} \
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
}


//法二：单例化一个类
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;
#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}


//去除"-(id)performSelector:(SEL)aSelector withObject:(id)object;"的警告
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
     Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)


//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian * 180.0)/(M_PI)

//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

//释放一个对象
#define SAFE_DELETE(P) if(P) { [P release], P = nil;}
#define SAFE_RELEASE(x) [x release];x=nil

//__weak __typeof(self) wself = self;
//__weak __typeof__ (self) wself = self;
//__weak typeof(self) weakSelf = self;
//__strong __typeof(weakSelf) strongSelf = weakSelf;

#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])




/*********************项目文本*******************/
/*********************项目文本*******************/

//hmqc66  123456h
//海马测试账号
//测试默认值
#define KCSUBUSERACCOUNT     @"csubaccount"
#define KCSUBPASSWORD        @"csubpassword"

#define KFirtsLaunchMain     @"KFirtsLaunchMain"
#define KFirtsLogin          @"firtsLogin"
#define KUserLoginDays       @"UserLoginDays"

#define KServerdataStr       @"data"
#define KServererrorMsgStr   @"errorMsg"
#define KServererrorCodeStr  @"errorCode"
#define KCityNikeName        @"粤"
#define KLocationCity        @"深圳"
#define KPlateNO             @"粤B 12345"
#define KIndicatorStr        @"请稍后..."
#define KIndicatorError      @"查询失败"
#define KLoginError          @"登录失败"
#define KRegisterError       @"注册失败"
#define KVertifyError        @"认证失败"
#define KLookCodeError       @"找回失败"
#define KBindingError        @"绑定失败"
#define KNetworkError        @"您的网络好像出了点问题"
#define KPeecanError         @"您的查询信息有误，请核对后继续查询"


#define  BASE_URL              @"http://ubiapp.952100.cc/st-app/"
//1.验证码
#define  VERTIFYCODE           @"base/sms"
//2.新用户注册
#define  REGISTER_URL          @"user/register"
//3.用户登录接口
#define  LOGIN_URL             @"user/login"
//4.找回密码
#define  LOOKBACKCODE_URL      @"user/resetPwd"
//5.验证身份
#define  VERTIFYIDENTITY_URL   @"user/resetCallLetterVerify"
//6.丢失手机 — 重设手机号与密码
#define  NewMobileResetNumberAndPassword  @"user/resetCallLetter"
//7.修改密码
#define  MODIFYPASSWORD        @"user/modifyPwd"
//8.修改手机号
#define  MODIFYMOBILE          @"user/modifyCallLetter"
//9.获取详细资料
#define  GETUSERDETAIL         @"user/detail"
//10天气信息
#define  PEECAACYTOPWHEATHER   @"base/getBoardMainInfo"
//11.头部网址
#define  PEECAACYTOPURL        @"base/getBoardUrls"
//12.收益首页
#define  PEECAACYHOMEDATA      @"income/main"
//13.昨日收益详情
#define  YESTURDAYINCOMEDETAIL @"income/incomeDetail"
//14.安全驾驶明细
#define  SECURITYDRIVEDETAIL   @"income/safeDetail"
//15.累计收益
#define  TOTALPEECCACYDETAIL   @"income/historyDetail"
//16.获取绑定车辆
#define  BINDINGCARLIST        @"car/list"
//17.扫码绑定设备车辆
#define  SWIPEQRCODEBINDING    @"car/bind"
//18.解除绑定车辆
#define  UNBINDINGDEVICECAR    @"car/unBind"
//19.修改默认车辆
#define  CHANGETERMINALDEVICE  @"car/setDefaultVehicleId"
//22.行程统计
#define  UBITravelStatistics   @"car/travel"
//23.里程统计
#define  UBIMileageStatistics  @"car/mileage"
//24.违章查询
#define  UBIIlegalQuery        @"illegal/query"
//25.反馈建议
#define SUGGEST                @"base/suggest"

#endif
