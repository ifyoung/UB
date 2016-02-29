//
//  AppDelegate.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/6/10.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "BindOBDTerminalVC.h"
#import "IndicatorViewController.h"
#import "UBLoginViewController.h"

#import "RESideMenu.h"
#import "PersonalSettingsVC.h"

#import "MBProgressHUD.h"

typedef void(^LocationCompletionHandle)();
//app推送跳转类型
typedef NS_ENUM(NSInteger, AppPushFromType) {
    AppPushFromTypeNormal = 0,
    AppPushFromTypeRemoteNotificaitonProceedIncome,
    AppPushFromTypeRemoteNotificationPeccancyResult
};


@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,RESideMenuDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RESideMenu *sideMenuViewController;
@property (strong, nonatomic) UITabBarController *mainViewController;
@property (strong, nonatomic) PersonalSettingsVC *personalSettingsVC;
@property (strong, nonatomic) MBProgressHUD *hud;

//app推送跳转类型
@property (nonatomic,assign)AppPushFromType appPushFromType;
@property (nonatomic,strong)NSDictionary *remotePushLaunchOptions;



//位置  Apple定位是谷歌坐标系统
@property (nonatomic,strong) CLLocation *userlocation;
@property (nonatomic,assign) CLLocationCoordinate2D cLLocationCoordinate2D;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLGeocoder *geocoder;
@property (nonatomic,copy)LocationCompletionHandle block;

//城市
@property (nonatomic,strong)NSMutableArray *provinces;

//检查更新
@property (nonatomic,strong)NSDictionary *appVersonInfo;
- (void)checkAppVersonUpdate;


/*
 *   IndicatorrootViewController
 */
- (void)bindingViewController;
/*
 *   loginRootViewController
 */
- (void)loginRootViewController;
/*
 *   mainrootViewController
 */
- (void)MainrootViewController;


/*
 *   定位当前位置
 */
- (void)getUserLocation;

/*
 *   获取城市对应的代码
 */
/*
 *   citys
 */
- (void)loadAllCitys;
- (NSString *)cityCodeArrayOfCityArray;


@end

