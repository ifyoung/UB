//
//  CarViewController.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/6/30.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "CarViewController.h"
#import "APIKey.h"
#import <MAMapKit/MAMapKit.h>
#import "CargpsBaseInfoModel.h"

#import "CarAnnotationModel.h"
#import "CarHomeAnnotaton.h"
#import "CarHomeAnnotatonView.h"
#import "StretchMapView.h"
#import "CarMenuPopView.h"

@interface CarViewController ()<MAMapViewDelegate,StretchMapViewDelegate,CarMenuPopViewDelegate,UIGestureRecognizerDelegate>{
 
    BOOL isToright;
    LocationButton *pop;
    UIView *leftView;
    UILabel *leftTopLocationLabel;
    UIView *leftTopLocationView;
    
    StretchMapView *stretchMapView;
    MenuPopButton *popMenuButton;
    CarMenuPopView *carMenuPopView;
    UIImageView *imgArrow;
    UIImageView *imgArrow1;
}

@property (nonatomic, strong) CLGeocoder *geocoder;
@property(nonatomic,strong)MAMapView *carMapView;
@property(nonatomic,strong)GpsBaseInfoMessage *gpsBaseInfoMessageeee;



@end

@implementation CarViewController
@synthesize carMapView;
+ (CarViewController *)shareInstance{
    static CarViewController *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = [CurrentDeviceModel shareInstance].plateNo;
    
    [self rightButtonItem];

    
    [self configureAPIKey];
    [self createMapView];
    [self createStretchMapView];
    [self createMenuPopButton];
    
    [self addwillEnterForegroundNotification];
    [self handleLastGPS];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"爱车最后位置"];
    
    //动画
    if(carMapView && _gpsBaseInfoMessageeee){
        [self setCarHomeAnnotatons:_gpsBaseInfoMessageeee];
        [self bottomArrowAnimation];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"爱车最后位置"];
    
    if(carMenuPopView){
        [carMenuPopView remove];
    }
}

- (void)loadView{
    [super loadView];
    
    [self sendWBSocketLoginCommand];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
 *   willEnterForegroundNotification
 */
- (void)addwillEnterForegroundNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}
- (void)willEnterForegroundNotification{
    
    if(carMapView && _gpsBaseInfoMessageeee){
        
      [self setCarHomeAnnotatons:_gpsBaseInfoMessageeee];
      [self bottomArrowAnimation];
    }
    
    [self sendWBSocketLoginCommand];
}


/*
 *   设置APIKey
 */
- (void)configureAPIKey
{
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
}

/*
 *  设置是否请求完成、更坏车辆
 */
- (void)setIsLoadDataCompete:(BOOL)isLoadDataCompete{
    _isLoadDataCompete = isLoadDataCompete;
    
    //更换车辆之后
    if(!_isLoadDataCompete && [CurrentDeviceModel shareInstance].callLetter && carMapView){
        
        self.navigationItem.title = [CurrentDeviceModel shareInstance].plateNo;
        
        [self changeCarLocationMonitorCommand];
    }
}

/*
 *   WebSoket 登录链接
 */
- (void)sendWBSocketLoginCommand{
    
    __weak CSWebSocketService *service =  [CSWebSocketService sharedManager];
    
    if(!service.wsRequest || !service.state){
     
        [service initWebSocket];
    }
    
    service.loginblock = ^(id result) {
        
        [service sendAddMonitorCommand];
        [service sendLastGpsCommand];
    };
}
- (void)changeCarLocationMonitorCommand{
    [[CSWebSocketService sharedManager] sendRemoveMonitorCommand];
    [[CSWebSocketService sharedManager] sendAddMonitorCommand];
    [[CSWebSocketService sharedManager] sendLastGpsCommand];
}


/*
 *  最后位置接收处理
 */
- (void)handleLastGPS{
    __weak typeof(self) this = self;
    [CSWebSocketService sharedManager].lastblock = ^(id result) {
        if([result isKindOfClass:[NSString class]] || result == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showIndicator:@"没有定位信息" delay:1];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [this setCarHomeAnnotatons:[result firstObject]];
                [this showLoveCarDestination:[result lastObject]];
            });
        }
    };
}


/*
 *   爱车定位
     0.
     1.绿色  启动且速度>=10
     2.蓝色  启动且速度<10
     3.红色  出现警情
     4.紫色  未知：最后上传时间(gpsTime)早于当前时间2分钟就直接设置为未知了
     5.灰色  熄火    23:车辆熄火
 */
- (void)setCarHomeAnnotatons:(GpsBaseInfoMessage *)gpsBaseInfoMessage{
    
    if(gpsBaseInfoMessage.lat == NO){
        _isLoadDataCompete = NO;
        
        //获取上次缓存的有效点
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"cargpsBaseInfoModel"];
        CargpsBaseInfoModel *cargpsBaseInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if(cargpsBaseInfoModel){
            _gpsBaseInfoMessageeee         = [[GpsBaseInfoMessage alloc]init];
            _gpsBaseInfoMessageeee.loc     = cargpsBaseInfoModel.loc;
            _gpsBaseInfoMessageeee.gpsTime = cargpsBaseInfoModel.gpsTime;
            _gpsBaseInfoMessageeee.lat     = cargpsBaseInfoModel.lat;
            _gpsBaseInfoMessageeee.lng     = cargpsBaseInfoModel.lng;
            _gpsBaseInfoMessageeee.speed   = cargpsBaseInfoModel.speed;
            _gpsBaseInfoMessageeee.course  = cargpsBaseInfoModel.course;
            _gpsBaseInfoMessageeee.status  = cargpsBaseInfoModel.status;
        }else{


            return;
        }
    }else{
         //缓存有效点
        CargpsBaseInfoModel *cargpsBaseInfoModel = [[CargpsBaseInfoModel alloc]init];
        cargpsBaseInfoModel.loc        = gpsBaseInfoMessage.loc;
        cargpsBaseInfoModel.gpsTime    = gpsBaseInfoMessage.gpsTime;
        cargpsBaseInfoModel.lat        = gpsBaseInfoMessage.lat;
        cargpsBaseInfoModel.lng        = gpsBaseInfoMessage.lng;
        cargpsBaseInfoModel.speed      = gpsBaseInfoMessage.speed;
        cargpsBaseInfoModel.course     = gpsBaseInfoMessage.course;
        cargpsBaseInfoModel.status     = gpsBaseInfoMessage.status;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cargpsBaseInfoModel];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"cargpsBaseInfoModel"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        
        _gpsBaseInfoMessageeee = gpsBaseInfoMessage;
        _isLoadDataCompete = YES;
    }
    

    NSDate *gps = [NSDate dateWithTimeIntervalSince1970:gpsBaseInfoMessage.gpsTime / 1000.0];
    NSString *gpsstring = [NSDate stringFromDate:gps formate:@"yy-MM-dd HH:mm"];
    CarAnnotationModel *tg2 = [[CarAnnotationModel alloc] init];
    if(gpsBaseInfoMessage.speed >= 10){
        tg2.icon = @"green-car";
    }else if ((gpsBaseInfoMessage.speed / 10.0) < 10 && (gpsBaseInfoMessage.speed / 10.0) > 0){
        tg2.icon = @"blue-car";
    }else if ([gpsBaseInfoMessage.status containsObject:@23]){
        tg2.icon = @"gray-car";
    }else if (([[NSDate date] timeIntervalSince1970] - gpsBaseInfoMessage.gpsTime / 1000.0) > 120){
        tg2.icon = @"purple-car";
    }else{
        tg2.icon = @"red-car";
    }
    tg2.gpstime   = gpsstring;
    tg2.direction = gpsBaseInfoMessage.course;
    tg2.carStatus = gpsBaseInfoMessage.status;
    tg2.plateNo = [CurrentDeviceModel shareInstance].plateNo;
    tg2.speed = [NSString stringWithFormat:@"%gkm/h",gpsBaseInfoMessage.speed / 10.0];
    
    
    CLLocationCoordinate2D WGS = CLLocationCoordinate2DMake(gpsBaseInfoMessage.lat / 1000000.0, gpsBaseInfoMessage.lng / 1000000.0);
    CLLocationCoordinate2D GCJ021 =  [ZPLocationConverter wgs84ToGcj02:WGS];
    
    tg2.coordinate = GCJ021;
    
    
    CarHomeAnnotaton *anno = [[CarHomeAnnotaton alloc] init];
    anno.carmodel = tg2;
    [carMapView removeAnnotations:carMapView.annotations];
    [carMapView addAnnotation:anno];
    [carMapView setCenterCoordinate:tg2.coordinate animated:YES];
}

/*
 *    1.地图
 */
- (void)createMapView{
    
    if(carMapView == nil)
    carMapView = [[MAMapView alloc]initWithFrame:CGRectMake(0,0, KSCREEWIDTH,KSCREEHEGIHT- 49)];
    
    carMapView.language = MAMapLanguageZhCN;
    carMapView.userTrackingMode = MAUserTrackingModeFollow;
    carMapView.distanceFilter =  kCLDistanceFilterNone;
    carMapView.desiredAccuracy =  kCLLocationAccuracyBest;
    carMapView.headingFilter = kCLHeadingFilterNone;
    carMapView.showsUserLocation = NO;
    carMapView.mapType = MAMapTypeStandard;
    carMapView.delegate = self;
    carMapView.showsCompass = NO;
    carMapView.showsScale = NO;
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [carMapView setCenterCoordinate:delegate.cLLocationCoordinate2D animated:YES];
    [self.view addSubview:carMapView];
}



/*
 *  2.显示当前爱车位置
 */
- (void)showLoveCarDestination:(GpsReferPositionMessage *)gpsRefer{

    NSString *location = [NSString stringWithFormat:@"%@%@%@%@%@",
                          gpsRefer.province == nil? @"":gpsRefer.province,
                          gpsRefer.city     == nil? @"":gpsRefer.city,
                          gpsRefer.county   == nil? @"":gpsRefer.county,
                          gpsRefer.roads    == nil? @"":[gpsRefer.roads firstObject],
                          gpsRefer.points   == nil? @"": [gpsRefer.points firstObject]
                          ];
    
    if(pop == nil)
    pop = [LocationButton buttonWithType:UIButtonTypeCustom];
    pop.frame = CGRectMake(0, 0, 60, 60);
    pop.backgroundColor  = [UIColor clearColor];
     [pop setImage:[UIImage imageNamed:@"爱车定位"] forState:UIControlStateNormal];
    [pop addTarget:self action:@selector(popCarLocationLabelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pop];
    
    if(leftTopLocationView == nil)
    leftTopLocationView = [[UIView alloc]initWithFrame:CGRectMake(40,0,0,40)];
    if(leftTopLocationLabel == nil)
    leftTopLocationLabel  = [[UILabel alloc]initWithFrame:leftTopLocationView.bounds];
    leftTopLocationLabel.font = [UIFont systemFontOfSize:12.0f];
    leftTopLocationLabel.text = location;
    if(location.length == 0) leftTopLocationLabel.text = @"加载中...";
    leftTopLocationLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    if(leftView == nil)
    leftView = [[UIView alloc]init];
    leftView.frame = CGRectMake(0, 0, 40, 40);
    leftView.backgroundColor = [UIColor colorWithWhite:1 alpha:.8];
    [self.view insertSubview:leftView belowSubview:pop];
    
    [leftTopLocationView addSubview:leftTopLocationLabel];
    leftTopLocationView.backgroundColor = [UIColor colorWithWhite:1 alpha:.8];
    [self.view insertSubview:leftTopLocationView belowSubview:pop];
    
    [self reverseGeocode];
}
- (void)popCarLocationLabelAction{
    if(!isToright){
        isToright = YES;
        [UIView animateWithDuration:2 animations:^{
            leftTopLocationView.width =  KSCREEWIDTH - 40;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:2 delay:2 options:UIViewAnimationOptionCurveEaseOut animations:^{
                leftTopLocationView.width = 0;
            } completion:^(BOOL finished) {
                
                isToright = NO;
            }];
            
        }];
    }
}
/**
 *  反地理编码
 */
- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
- (void)reverseGeocode {
    
    // 1.包装位置  张工GPS点
    CLLocationDegrees latitude = _gpsBaseInfoMessageeee.lat / 1000000.0;
    CLLocationDegrees longitude = _gpsBaseInfoMessageeee.lng / 1000000.0;
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    // 2.反地理编码
    [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) { // 有错误（地址乱输入）
            
            leftTopLocationLabel.text = @"加载中...";
        } else { // 编码成功
            // 取出最前面的地址
            CLPlacemark *pm = [placemarks firstObject];
            NSString *name = pm.name;
            
            if(name.length > 2 && [[name substringToIndex:2] iscontainSubString:@"中国"]){
                name = [name substringFromIndex:2];
            }
            if(name.length > 2 && [[name substringToIndex:3] iscontainSubString:@"省"]){
               
                name = [name substringFromIndex:3];
            }
            
            // 设置具体地址
            if(![name iscontainSubString:@"市"] && ![name iscontainSubString:@"区"]){
            
                NSString *City =        [[pm.addressDictionary objectForKey:@"City"] isNullOrNil];
                NSString *SubLocality = [[pm.addressDictionary objectForKey:@"SubLocality"] isNullOrNil];
                NSString *Street = [[pm.addressDictionary objectForKey:@"Street"] isNullOrNil];
                NSString *Name = [[pm.addressDictionary objectForKey:@"Name"] isNullOrNil];
                //NSString *FormattedAddressLines = [pm.addressDictionary objectForKey:@"FormattedAddressLines"];
                //NSString *formattedName =
                NSString *locationDetail = [NSString stringWithFormat:@"%@%@%@%@",City,SubLocality,Street,Name];
                 leftTopLocationLabel.text = locationDetail;
            }else{
            
                leftTopLocationLabel.text = name;
            }
        
    
            /*
             pm.addressDictionary
             
             SubLocality 龙岗区
             CountryCode CN
             Street 翠宝路28号
             State 广东省
             Name 赛格导航科技园
             Thoroughfare 翠宝路
             FormattedAddressLines (
             "\U4e2d\U56fd\U5e7f\U4e1c\U7701\U6df1\U5733\U5e02\U9f99\U5c97\U533a\U9f99\U5c97\U8857\U9053\U7fe0\U5b9d\U8def28\U53f7"
             )
             SubThoroughfare 28号
             Country 中国
             City 深圳市
             
             */
        }
    }];
}

/*
 *    3.StretchMapView
 */
- (void)createStretchMapView{
    if(stretchMapView == nil)
    stretchMapView = [[StretchMapView alloc]initWithDelegate:self type:StretchMapViewLastLocation];
    [self.view addSubview:stretchMapView];
}


/*
 *    3.MenuPopButton
 */
- (void)createMenuPopButton{
    CGRect frame = CGRectMake((KSCREEWIDTH - 100) /2.0, KSCREEHEGIHT  - 64 - 49 - 50, 100,50);
    if(popMenuButton == nil)
    popMenuButton = [MenuPopButton buttonWithType:UIButtonTypeCustom];
    popMenuButton.frame = frame;
    [popMenuButton setImage:[UIImage imageNamed:@"爱车弹出更多按钮"] forState:UIControlStateNormal];
    [popMenuButton addTarget:self action:@selector(popCarMenuAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popMenuButton];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(popCarMenuAction)];
    swipe.delegate = self;
    [popMenuButton addGestureRecognizer:swipe];
    //popMenuButton.backgroundColor = [UIColor redColor];

    if(imgArrow == nil)
    imgArrow = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 13, 6)];
    imgArrow.center =  CGPointMake(popMenuButton.center.x, popMenuButton.center.y + 15);
    imgArrow.image = [UIImage imageNamed:@"更多渐变色1"];
    [self.view addSubview:imgArrow];
    if(imgArrow1 == nil)
     imgArrow1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 13, 6)];
    imgArrow1.center = CGPointMake(popMenuButton.center.x, popMenuButton.center.y + 15);
    imgArrow1.top = imgArrow.bottom;
    imgArrow1.image = [UIImage imageNamed:@"更多渐变色1"];
    [self.view addSubview:imgArrow1];
    
    [self bottomArrowAnimation];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if([touch.view isKindOfClass:[UIButton class]]){
      
        return YES;
    }
    
    return NO;
}
- (void)bottomArrowAnimation{
    imgArrow.center = CGPointMake(popMenuButton.center.x, popMenuButton.center.y + 15);;
    imgArrow1.center = CGPointMake(popMenuButton.center.x, popMenuButton.center.y + 15);;
    imgArrow1.top = imgArrow.bottom;
    imgArrow.alpha = 1;
    imgArrow1.alpha = 1;
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionRepeat  animations:^{
        imgArrow.top = popMenuButton.frame.origin.y + 30;
        imgArrow.alpha = 0;
        imgArrow1.top = popMenuButton.frame.origin.y + 30;
        imgArrow1.alpha = 0;
    } completion:NULL];
}

/*
 *  CarMenuPopView
 */
- (void)popCarMenuAction{
     carMenuPopView = [[CarMenuPopView alloc]initWithDelegate:self];
    [carMenuPopView show];
}
- (void)didSelectedCarMenuPopView:(CarMenuPopView *)carMenuPopView index:(NSInteger)index{
    switch (index) {
        case 0:
            [self pushToViewController:@"HistoricalTrackVC"];
            break;
        case 1:
            [self pushToViewController:@"CarMileageViewController"];
            break;
        case 2:
            [self pushToViewController:@"DriveStatisticsVC"];
            break;
        default:
            break;
    }
}



#pragma mark - MKMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation{
    
    if(_gpsBaseInfoMessageeee == nil){
        //userLocation.title = @"赛格车圣";
        //userLocation.subtitle = @"是个非常牛逼的地方!";
        CLLocationCoordinate2D center = userLocation.location.coordinate;
        [mapView setCenterCoordinate:center animated:YES];
    }
}
- (CarHomeAnnotatonView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isMemberOfClass:[MAUserLocation class]]) {
        return nil;
    }
    //创建大头针view
    CarHomeAnnotatonView *annoView = [CarHomeAnnotatonView annotationViewWithMapView:mapView];
    annoView.annotation = annotation;
    return annoView;
}
//- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
//}
//- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
//{
//    NSLog(@"%f %f", mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta);
//}
#pragma mark - StretchMapViewDelegate
- (void)didSelectStretchMapViewIndex:(NSInteger)index{
    NSUInteger level =  [carMapView zoomLevel];
    level = index==0? ++level:--level;
    if(level < 3 || level > 19) return;
    [carMapView setZoomLevel:level animated:YES];
}
@end

@implementation LocationButton
// 内部图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 31/ 2.0;
    CGFloat imageH = 38 / 2.0;
    CGFloat margin = (40 - imageW) / 2.0;
    return CGRectMake(margin, margin, imageW, imageH);
}
@end
@implementation MenuPopButton
// 内部图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 70;
    CGFloat imageH = 20;
    return CGRectMake((contentRect.size.width - 70) / 2.0, contentRect.size.height - 20, imageW, imageH);
}
@end
