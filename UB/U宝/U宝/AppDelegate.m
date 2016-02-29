//
//  AppDelegate.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/6/10.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "AppDelegate.h"
#import "ProceedsYesturdayVC.h"
#import "PeccancySeekResultVC.h"


/* 信鸽推送*/
#define _IPHONE80_ 80000

#import "XGPush.h"
#import "XGSetting.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize provinces,sideMenuViewController,mainViewController,personalSettingsVC;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[SDImageCache sharedImageCache] setMaxCacheAge:24 * 60 * 60 * 15]; //缓存周期半个月
    // 设置网络缓存 － 4M 的内存缓存 20M 的磁盘缓存，使用默认的缓存路径 Caches/bundleId
    //NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    // 设置全局缓存
    //[NSURLCache setSharedURLCache:cache];

    //获取聚合城市
    [self loadAllCitys];
    
    //高德地图定位
    [self getUserLocation];
    
    //友盟本身是异步执行
    [self umengTrack];
    
    //信鸽推送设置
    [self initXGPushSettinsWithLaunchOptions:launchOptions];
    
    //页面显示逻辑
    [self MainVisibleVC:application launchOptions:launchOptions];

    [self.window makeKeyAndVisible];
    
    return YES;
}


/***********************************UIApplication********************************/
/***********************************UIApplication*******************************/

/***********************************信鸽推送********************************/
/***********************************信鸽推送********************************/
- (void)initXGPushSettinsWithLaunchOptions:(NSDictionary *)launchOptions{

    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                
                [self registerPush];
            }
            else{
                [self registerPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self registerPush];
#endif
        }
    };
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    
    //NSLog(@"%u",UINT32_MAX);
    [XGPush startApp:2200149270 appKey:@"IGN892S9E5TL"];
    
    //注销设备后，重新注册
    [XGPush initForReregister:successCallback];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //清除所有通知(包含本地通知)
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    //UIUserNotificationType allowedTypes = [notificationSettings types];
    //NSLog(@"%lu",(unsigned long)allowedTypes);
}
//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler  {
    
    if([identifier isEqualToString:@"CSUB"]){
        NSLog(@"CSUB is clicked");
    }
    completionHandler();
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED > _IPHONE80_
- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void(^)())completionHandler {

    if([identifier isEqualToString:@"CSUB"]){
        NSLog(@"CSUB is clicked");
    }
    //NSString *STR = responseInfo[UIUserNotificationActionResponseTypedTextKey];
    completionHandler();
}
#endif  
#endif
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    void (^successBlock)(void) = ^(void){
        NSLog(@"[XGPush Demo]register successBlock");
    };
    void (^errorBlock)(void) = ^(void){
        NSLog(@"[XGPush Demo]register errorBlock");
    };
    
    //设置帐号（别名）  一定要在注册设备之前设置别名
    [XGPush setAccount:[SFHFKeychainUtils getPasswordForUsername:KCSUBUSERACCOUNT andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL]];
    
    //XGSetting *setting = (XGSetting *)[XGSetting getInstance];
    //[setting setChannel:@"appstore"];
    //[setting setGameServer:@"巨神峰"];

    //注册设备
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //打印获取的deviceToken的字符串
    NSLog(@"%@",deviceToken);
    NSLog(@"[XGPush Demo] deviceTokenStr is %@",deviceTokenStr);
}
//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    //NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    NSLog(@"[XGPush Demo]%@",str);
}
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //程序正在运行  点击推送进入指定界面
    //是否有远程推送的消息
    application.applicationIconBadgeNumber = 0;
    
    //点击推送进入应用，跳转到指定页面
    [self pushToIRemoteNotificationVCFromUserInfo:userInfo];

    //推送反馈(app运行时)
    //[XGPush handleReceiveNotification:userInfo];
    
    //回调版本示例
    
     void (^successBlock)(void) = ^(void){
     //成功之后的处理
     NSLog(@"[XGPush]handleReceiveNotification successBlock");
     };
     
     void (^errorBlock)(void) = ^(void){
     //失败之后的处理
     NSLog(@"[XGPush]handleReceiveNotification errorBlock");
     };
     
     void (^completion)(void) = ^(void){
     //失败之后的处理
     NSLog(@"[xg push completion]userInfo is %@",userInfo);
     };
     
     [XGPush handleReceiveNotification:userInfo successCallback:successBlock errorCallback:errorBlock completion:completion];
}
- (void)registerPushForIOS8{
    //如果我们选择的BaseSDK小于8.0，不会导致编译错误。
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types 设置通知行为：
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;

    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    acceptAction.identifier = @"CSUB";
    acceptAction.title = @"CSUBB";
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    
    //Categories 设置通知策略：
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    inviteCategory.identifier = @"CSUBBB";
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];

    //mySettings 　注册通知配置（iOS8以后的方式）：
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}
- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}
/***********************************信鸽推送********************************/
/***********************************信鸽推送********************************/
- (void)applicationWillResignActive:(nonnull UIApplication *)application{
 /*
    一、挂起
    当有电话进来或者锁屏，这时你的应用程会挂起，在这时，UIApplicationDelegate委托会收到通知，调用 applicationWillResignActive 方法，你可以重写这个方法，做挂起前的工作，比如关闭网络，保存数据。
  */
}
- (void)applicationDidEnterBackground:(nonnull UIApplication *)application{
   //进入后台
}
- (void)applicationWillEnterForeground:(nonnull UIApplication *)application{
  //将要进入前台
}
- (void)applicationDidBecomeActive:(nonnull UIApplication *)application{
    /*
    二、复原
    当程序复原时，另一个名为 applicationDidBecomeActive 委托方法会被调用，在此你可以通过之前挂起前保存的数据来恢复你的应用程序：
     
     注意：应用程序在启动时，在调用了 applicationDidFinishLaunching 方法之后也会调用 applicationDidBecomeActive 方法，所以你要确保你的代码能够分清复原与启动，避免出现逻辑上的bug。
    */
}
- (void)applicationWillTerminate:(nonnull UIApplication *)application{
   /*
    当用户按下按钮，或者关机，程序都会被终止。当一个程序将要正常终止时会调用 applicationWillTerminate方法。但是如果长主按钮强制退出，则不会调用该方法。这个方法该执行剩下的清理工作，比如所有的连接都能正常关闭，并在程序退出前执行任何其他的必要的工作：
    */
}
/***********************************UIApplication********************************/
/***********************************UIApplication*******************************/








//是否有远程推送的消息
/***********************************界面跳转********************************/
/***********************************界面跳转********************************/
//MainVisibleViewController  页面显示
- (void)MainVisibleVC:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions{
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo){
        
        //是否有远程推送的消息
        application.applicationIconBadgeNumber = 0;
        
        //点击推送进入应用，跳转到指定页面
        [self pushToRemoteNotificationVCFromlaunchOptions:userInfo];
        
    }else{
        
        [self indicatorRootViewController];
        //[self loginRootViewController];
    }
}
//IRemoteNotification 跳转 app没打开
- (void)pushToRemoteNotificationVCFromlaunchOptions:(NSDictionary *)launchuserInfo{
    
    self.remotePushLaunchOptions = launchuserInfo;
    
    if([[launchuserInfo objectForKey:@"activity"] isEqualToString:@"income"]){
        
        self.appPushFromType = AppPushFromTypeRemoteNotificaitonProceedIncome;
        
    }else if([[launchuserInfo objectForKey:@"activity"] isEqualToString:@"illegal"]){
        
        self.appPushFromType = AppPushFromTypeRemoteNotificationPeccancyResult;
    }
    
    [self indicatorRootViewController];
}
//IRemoteNotification 跳转 app已经打开
- (void)pushToIRemoteNotificationVCFromUserInfo:(NSDictionary *)userInfo
{
    __weak typeof(self) this = self;
    if([[userInfo objectForKey:@"activity"] isEqualToString:@"income"]){
        
        self.appPushFromType = AppPushFromTypeRemoteNotificaitonProceedIncome;
        
        //获取当前导航控制器跳转
        if([self.window.rootViewController isKindOfClass:[RESideMenu class]]){
            
            RESideMenu *menuVC = (RESideMenu *)self.window.rootViewController;
            [self.sideMenuViewController setContentViewController:self.mainViewController
                                                         animated:YES];
            UITabBarController *tabVC = (UITabBarController *)menuVC.contentViewController;
            tabVC.selectedIndex =  0;
        }else{
            
            ProceedsVC *proceed = [ProceedsVC shareInstance];
            proceed.isAutoLogin = YES;
            [self MainrootViewController];
        }
        
    }else if([[userInfo objectForKey:@"activity"] isEqualToString:@"illegal"]){
        
        self.appPushFromType = AppPushFromTypeRemoteNotificationPeccancyResult;
        
        PeccancySeekResultVC *resultVC = [[PeccancySeekResultVC alloc]init];
        resultVC.appPushFromType = AppPushFromTypeRemoteNotificationPeccancyResult;
        resultVC.vehicleId  =  [[userInfo objectForKey:@"vehicleId"] longValue];
        resultVC.city       =  [userInfo objectForKey:@"cnty"];
        resultVC.plateNo    =  [userInfo objectForKey:@"plateNo"];
        resultVC.vin        =  [userInfo objectForKey:@"vin"];
        resultVC.engineNo   =  [userInfo objectForKey:@"engineNo"];
        
        //获取当前导航控制器跳转
        if([self.window.rootViewController isKindOfClass:[RESideMenu class]]){
            
            RESideMenu *menuVC = (RESideMenu *)self.window.rootViewController;
            [self.sideMenuViewController setContentViewController:self.mainViewController
                                                         animated:YES];
            UITabBarController *tabVC = (UITabBarController *)menuVC.contentViewController;
            tabVC.selectedIndex =   2;
            ZPBaseNavigationController *resultVCNA = (ZPBaseNavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
            [resultVCNA pushViewController:resultVC animated:YES];
            
        }else{
            
            ProceedsVC *proceed = [ProceedsVC shareInstance];
            proceed.isAutoLogin = YES;
            [self MainrootViewController];
        }
    }
    
    //未知类型
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [this loginRootViewController];
        });
    }
}
- (void)bindingViewController{
    ZPBaseNavigationController *navi = [[ZPBaseNavigationController alloc]initWithRootViewController:[[BindOBDTerminalVC alloc]init]];
    self.window.rootViewController  = navi;
}
- (void)indicatorRootViewController{
    IndicatorViewController *indicator = [[IndicatorViewController alloc]init];
    self.window.rootViewController  = indicator;
}
- (void)loginRootViewController{
    ZPBaseNavigationController *navi = [[ZPBaseNavigationController alloc]initWithRootViewController:[[UBLoginViewController alloc]init]];
    self.window.rootViewController  = navi;
}
- (void)MainrootViewController{
    
    if(mainViewController == nil){
        mainViewController = [[UITabBarController alloc] init];
        mainViewController.viewControllers = [self tabBarViewControllers];
    }
    if(personalSettingsVC == nil){
        personalSettingsVC = [[PersonalSettingsVC alloc] init];
    }
    
    sideMenuViewController = [[RESideMenu alloc]
                              initWithContentViewController:mainViewController
                              leftMenuViewController:nil
                              rightMenuViewController:personalSettingsVC];
    //sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    sideMenuViewController.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    sideMenuViewController.delegate = self;
    sideMenuViewController.panGestureEnabled = YES;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    
    self.window.rootViewController = sideMenuViewController;
}
- (NSArray *)tabBarViewControllers{
    NSArray *controllers = [NSArray arrayWithObjects:
                            
                            [self viewControllerWithVCName:@"ProceedsVC" TabTitle:@"收益" image:[UIImage imageNamed:@"收益未选中"] selct:[UIImage imageNamed:@"收益选中"]],
                            
                            [self viewControllerWithVCName:@"CarViewController" TabTitle:@"爱车" image:[UIImage imageNamed:@"爱车未选中"] selct:[UIImage imageNamed:@"爱车选中"]],
                            
                            [self viewControllerWithVCName:@"PeccancyListVC" TabTitle:@"违章查询" image:[UIImage imageNamed:@"违章未选中"] selct:[UIImage imageNamed:@"违章选中"]],
                            nil];
    return controllers;
}
-(ZPBaseNavigationController *) viewControllerWithVCName:(NSString *)vcname  TabTitle:(NSString *) title image:(UIImage *)image selct:(UIImage *)selctImg{
    
    image    = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selctImg = [selctImg  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    ZPBaseNavigationController *na;
    if([vcname isEqualToString:@"PeccancyListVC"]){
        PeccancyListVC *viewController = [PeccancyListVC shareInstance];
        viewController.title = @"违章查询";
        viewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:image selectedImage:selctImg];
        
        na = [[ZPBaseNavigationController alloc]initWithRootViewController:viewController];
        
    }else if([vcname isEqualToString:@"CarViewController"]){
        CarViewController *viewController = [CarViewController shareInstance];
        viewController.title = @"爱车";
        viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image: image selectedImage:selctImg];
        na = [[ZPBaseNavigationController alloc]initWithRootViewController:viewController];
    }else {
        ProceedsVC *viewController = [ProceedsVC shareInstance];
        viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image  selectedImage:selctImg];
        na = [[ZPBaseNavigationController alloc]initWithRootViewController:viewController];
    }
    /*
     着色（Tint Color）是iOS7界面中的一个.设置UIImage的渲染模式：UIImage.renderingMode重大改变，你可以设置一个UIImage在渲染时是否使用当前视图的Tint Color。UIImage新增了一个只读属性：renderingMode，对应的还有一个新增方法：imageWithRenderingMode:，它使用UIImageRenderingMode枚举值来设置图片的renderingMode属性。该枚举中包含下列值：
     
     UIImageRenderingModeAutomatic  // 根据图片的使用环境和所处的绘图上下文自动调整渲染模式。
     UIImageRenderingModeAlwaysOriginal   // 始终绘制图片原始状态，不使用Tint Color。
     UIImageRenderingModeAlwaysTemplate   // 始终根据Tint Color绘制图片，忽略图片的颜色信息。
     
     renderingMode属性的默认值是UIImageRenderingModeAutomatic，即UIImage是否使用Tint Color取决于它显示的位置。其他情况可以看下面的图例
     */
    return na;
}
#pragma mark -
#pragma mark RESideMenu Delegate
- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}
- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}
- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}
- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}
/***********************************界面跳转********************************/
/***********************************界面跳转********************************/



/***********************************友盟统计********************************/
/***********************************友盟统计********************************/
- (void)umengTrack{
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}
- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}
/***********************************友盟统计********************************/
/***********************************友盟统计********************************/



/***********************************位置开始********************************/
/***********************************位置开始********************************/
/*
 *   citys
 */
- (void)loadAllCitys{
    [Interface getCityFromJUHEblock:^(id result) {
        
        if([result isEqualToDictionary:@{}]){
            
            provinces =  [[NSUserDefaults standardUserDefaults] objectForKey:@"JUHEprovincesAndCitys"];
        }else {
            NSDictionary *dic  = (NSDictionary *)result;
            NSDictionary *proDic = [dic objectForKey:@"result"];
            provinces = [NSMutableArray array];
            for(NSString *prokey in [proDic allKeys]){
                NSArray *citys = [[proDic objectForKey:prokey] objectForKey:@"citys"];
                if(citys.count < 2){
                    [provinces insertObject:[proDic objectForKey:prokey] atIndex:0];
                }else{
                    [provinces addObject:[proDic objectForKey:prokey]];
                }
            }
            [[NSUserDefaults standardUserDefaults] setObject:provinces forKey:@"JUHEprovincesAndCitys"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
}
- (NSString *)cityCodeOfCity:(NSString *)cityName{
    for(NSDictionary *dic in provinces){
        for(NSDictionary *subDic in [dic objectForKey:@"citys"]){
            if([[subDic objectForKey:@"city_name"] isEqualToString:cityName]){
                return [subDic objectForKey:@"city_code"];}}}
    return @"";
}
- (NSString *)cityCodeArrayOfCityArray{
    return  [self cityCodeOfCity:[SeekparamModel shareInstance].city];
}

/*
 *   location
 */
- (CLGeocoder *)geocoder{
    if (!_geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
- (void)getUserLocation{
    if(![CLLocationManager locationServicesEnabled]) {
        
        [ZPUiutsHelper showAlertView:@"定位不可用" Message:@"请到设置更改" delegate:self];
    }
    
    //创建一个定位服务对
    _locationManager = [[CLLocationManager alloc]init];
    
    //设置精度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //设置代理对象
    _locationManager.delegate = self;
    
    
#ifdef __IPHONE_8_0  //某个宏被定义
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        //__OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_8_0)
        [_locationManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
    }
#endif
    
    //开始定位
    [_locationManager startUpdatingLocation];
}
/**
 *  只要定位到用户的位置，就会调用（调用频率特别高）
 *  @param locations : 装着CLLocation对象
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    // 1.包装位置
    CLLocationDegrees latitude =  [[locations firstObject] coordinate].latitude;
    CLLocationDegrees longitude = [[locations firstObject] coordinate].longitude;
    _userlocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    _cLLocationCoordinate2D = _userlocation.coordinate;
    
    // 保存 Device 的现语言 (英语 法语 ，，，)
    NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]
                                            objectForKey:@"AppleLanguages"];
    // 强制 成 简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil] forKey:@"AppleLanguages"];
    
    // 2.反地理编码
    [self.geocoder reverseGeocodeLocation:_userlocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        //取出最前面的地址
        CLPlacemark *pm = [placemarks firstObject];
        
        // pm.administrativeArea
        NSString *path = [[NSBundle mainBundle] pathForResource:@"province_nick"
                                                         ofType:@"plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
        
        if(placemarks.count > 0){
            NSString *pmStr = @"";
            if(pm.administrativeArea.length > 2){
                
                pmStr = [pm.administrativeArea substringToIndex:2];
            }else{
                pmStr = pm.administrativeArea;
            }
            NSString *string = [NSString stringWithFormat:@"self CONTAINS '%@'",pmStr];
            NSPredicate *predicte = [NSPredicate predicateWithFormat:string];
            NSArray *fliterArray = [[dic allKeys] filteredArrayUsingPredicate:predicte];
            
            if(fliterArray && fliterArray.count > 0){
                
                [SFHFKeychainUtils storeUsername:@"UserProvinceNickName1" andPassword:[dic objectForKey:[fliterArray firstObject]] forServiceName:[[NSBundle mainBundle] bundleIdentifier] updateExisting:YES error:NULL];
                
                NSString *city = @"";
                if(pm.locality.length > 2){
                    
                    city = [pm.locality substringToIndex:pm.locality.length - 1];
                }else{
                    city = pm.locality;
                }
                [SFHFKeychainUtils storeUsername:@"UserLocationCity" andPassword: city forServiceName:[[NSBundle mainBundle] bundleIdentifier] updateExisting:YES error:NULL];
            }else{
                
                [SFHFKeychainUtils storeUsername:@"UserProvinceNickName1" andPassword:KCityNikeName forServiceName:[[NSBundle mainBundle] bundleIdentifier] updateExisting:YES error:NULL];
                
                [SFHFKeychainUtils storeUsername:@"UserLocationCity" andPassword:KLocationCity forServiceName:[[NSBundle mainBundle] bundleIdentifier] updateExisting:YES error:NULL];
            }
            
        }else{
            
            [SFHFKeychainUtils storeUsername:@"UserProvinceNickName1" andPassword:KCityNikeName  forServiceName:[[NSBundle mainBundle] bundleIdentifier] updateExisting:YES error:NULL];
            
            [SFHFKeychainUtils storeUsername:@"UserLocationCity" andPassword:KLocationCity forServiceName:[[NSBundle mainBundle] bundleIdentifier] updateExisting:YES error:NULL];
        }
        
        // 还原Device 的语言
        [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
        
        if(_block){
            
            _block();
        }
    }];
    [manager stopUpdatingLocation];
}
/***********************************位置结束********************************/
/***********************************位置结束********************************/
/***********************************检查更新********************************/
/***********************************检查更新********************************/
- (void)checkAppVersonUpdate {
    
    NSString *updateUrlString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@&country=%@",APP_ID,@"cn"];
    NSURL *updateUrl = [NSURL URLWithString:updateUrlString];
    NSMutableURLRequest *versionRequest = [NSMutableURLRequest requestWithURL:updateUrl];
    [versionRequest setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:versionRequest queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(data != nil && ![data isKindOfClass:[NSNull class]]){
            _appVersonInfo = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:nil];
            //通过比较版本号进行提示：
            NSString *latestVersion = [[[_appVersonInfo objectForKey:@"results"] firstObject] objectForKey:@"version"];
            //NSString *laa =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]; //2  build
            
            //NSString *aaa = XcodeAppVersion; ///1.0
            
            if (latestVersion && ![XcodeAppVersion isEqualToString:latestVersion]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有版本更新，是否去更新？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去更新",nil];
                    alert.delegate = self;
                    [alert show];
                    
                });
            } else {
                
            }
        }else{
            
            
        }
    }];
}
- (void)alertView:(nonnull UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        NSString *trackViewUrl = [[[_appVersonInfo objectForKey:@"results"] firstObject] objectForKey:@"trackViewUrl"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
    }
}
/***********************************检查更新********************************/
/***********************************检查更新*******************************/

@end

/*
 activity = income;
 aps =     {
 alert = "\U60a8\U6628\U65e5\U6536\U76ca\U4e3a 0.09 \U5143";
 };
 xg =     {
 bid = 0;
 ts = 1447915559;
 };
 
 activity = illegal;
 aps =     {
 alert = "\U60a8\U7684\U7231\U8f66\Uff08\U7ca4BC07D6\Uff09\U6709 1 \U8d77\U8fdd\U7ae0\U672a\U5904\U7406\U3002";
 };
 cnty = "GD_SZ";
 engineNo = EJ20768;
 plateNo = "\U7ca4BC07D6";
 vehicleId = 54;
 vin = LVSFCAME2EF797906;
 xg =     {
 bid = 0;
 ts = 1447917965;
 };
 */
