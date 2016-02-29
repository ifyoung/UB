//
//  HistoricalTrackVC.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/3.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "HistoricalTrackVC.h"

#import "HistoricalTopSpeedView.h"

#import <MAMapKit/MAMapKit.h>
#import "OMAMovingAnnotations.h"
#import "OMAMovingAnnotationView.h"


#import "CarAnnotationModel.h"
#import "CarHomeAnnotaton.h"
#import "HistoricalTrackAnnotationView.h"
#import "HistoricalCarLocationAnnatation.h"
#import "StretchMapView.h"

//弹出视图
#import "ASOButtonView.h"
#import "ASOTwoStateButton.h"
#import "ASOBounceButtonViewDelegate.h"


static  CGFloat  const  HistoricalTrackTimeInterval = 1.0f;


@interface HistoricalTrackVC ()<MAMapViewDelegate,StretchMapViewDelegate,ASOBounceButtonViewDelegate>{

    OMAMovingAnnotationView *omaannoView;
    HistoricalTopSpeedView *historicalTopSpeedView;
}

@property (nonatomic,strong)  MAMapView  *carMapView;
@property (nonatomic,strong)  MAPolyline *polyline;
@property (nonatomic,strong)  NSArray    *annotations;
@property (nonatomic,strong)  NSArray    *coordinateArray;
@property (strong, nonatomic) ASOTwoStateButton   *menuButton;
@property (strong, nonatomic) ASOButtonView *menuItemView;

@property (strong, nonatomic) NSArray *corrodnateArray;
@property (strong, nonatomic) NSArray *segmentArray;
@property (strong, nonatomic) OMAMovingAnnotationsAnimator *animator;
@property (strong ,nonatomic) OMAMovingAnnotation *omaMovingannotation;

@property (nonatomic,assign)long long starT;
@property (nonatomic,assign)long long emdT;

@property (nonatomic,assign)long locaitonIndex;
@property (nonatomic,strong)NSArray *gpsBaseInfoArray;

@end

@implementation HistoricalTrackVC
@synthesize carMapView,menuButton,menuItemView;

- (BOOL)hidesBottomBarWhenPushed{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史轨迹";
    
    [self createMapView];
    [self createASOTwoStateButton];
    [self createStretchMapView];
    
    [self sendCSWebSocketGetHistoryInfoCommand];
    [self handleLastGPS];
}

- (void)loadView{
    [super loadView];
    NSDate *start  = [NSDate getZeroDateFromDate:[NSDate date]];
    NSDate *end  =  [NSDate getNowSystemDate:[NSDate date]];
    
    _starT = [start timeIntervalSince1970GMT8];
    _emdT  = [end   timeIntervalSince1970GMT8];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
  
    [self removeALLOMAMovingAnnotationNotification];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"爱车历史轨迹"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"爱车历史轨迹"];
}





/*
 *   发起历史位置链接
 */
- (void)sendCSWebSocketGetHistoryInfoCommand{
    NSString *callL = [CurrentDeviceModel shareInstance].callLetter;
    if(callL == nil) return;
    CSWebSocketGetHistoryInfoCommand *command = [[CSWebSocketGetHistoryInfoCommand alloc]init];
    command.sn = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    command.historyType =  GBossMessageType_DeliverGPS;
    command.callLetters =  @[callL];
    command.startTime   =  _starT;
    command.endTime     =  _emdT;
    command.pageNumber  =   100;
    command.totalNumber =   5000;
    command.autonextpage = YES;
    command.reversed = NO;
    [[CSWebSocketService sharedManager] sendHistoryGpsCommand:command];
}

/*
 *  历史位置处理
 */
- (void)handleLastGPS{
    __weak typeof(self) this = self;
    [CSWebSocketService sharedManager].historyblock = ^(id result) {
        
        //请求失败或没有历史信息
        if([result isKindOfClass:[NSString class]] || result == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
             if(historicalTopSpeedView) historicalTopSpeedView.hidden = YES;
                [MBProgressHUD showIndicator:@"没有历史信息"];
            });
        }else{
        
            if([(NSArray *)result count] > 0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [this addannotationsWithGPS:result];
                });
            }else{
            
            
            }
        }
    };
}





/*
 *   1.1添加标注
 */
- (void)addannotationsWithGPS:(NSArray *)gpsArray{
    
    __weak typeof(self) this = self;
    GpsBaseInfoMessage *gpsBaseInfoCrrunt;
    for(int i = 0;i < gpsArray.count;i++){
        
        GpsBaseInfoMessage *gpsBaseInfoMessage = [gpsArray objectAtIndex:i];
        if(gpsBaseInfoMessage.loc == YES){
            gpsBaseInfoCrrunt = gpsBaseInfoMessage;
            break;
        }
    }
    
    NSMutableArray *duplicatRemoveArray = [NSMutableArray array];
    for(int i = 0;i < gpsArray.count;i++){
        
        GpsBaseInfoMessage *gpsBaseInfoMessage = [gpsArray objectAtIndex:i];
        //NSLog(@"第%d个点 速度:%f %d %d %d\n",i,gpsBaseInfoMessage.speed / 10.0,gpsBaseInfoMessage.loc,gpsBaseInfoMessage.lat,gpsBaseInfoMessage.lng);
        if (gpsBaseInfoMessage.loc == NO){
            
            //NSLog(@"不是定位点");
        }
        
        else if(gpsBaseInfoMessage.gpsTime == gpsBaseInfoCrrunt.gpsTime){
        
            //NSLog(@"时间相同点");
        }
        else if(gpsBaseInfoMessage.lat == gpsBaseInfoCrrunt.lat &&
           gpsBaseInfoMessage.lng == gpsBaseInfoCrrunt.lng){
         
            //NSLog(@"地点相同点");
        }else if(gpsBaseInfoMessage.speed == gpsBaseInfoCrrunt.speed
                 &&  gpsBaseInfoMessage.speed == 0){
        
             NSLog(@"速度连续为0:%d,%d",gpsBaseInfoCrrunt.speed,gpsBaseInfoMessage.speed);
        }else{
    
            [duplicatRemoveArray addObject:gpsBaseInfoMessage];
            gpsBaseInfoCrrunt = gpsBaseInfoMessage;
              NSLog(@"第%lu个有用点 速度:%f %d %d %d\n",(unsigned long)duplicatRemoveArray.count,gpsBaseInfoMessage.speed / 10.0,gpsBaseInfoMessage.loc,gpsBaseInfoMessage.lat,gpsBaseInfoMessage.lng);
        }
        
    }
    if(duplicatRemoveArray.count == 0){
        if(gpsBaseInfoCrrunt){
            [duplicatRemoveArray addObject:gpsBaseInfoCrrunt];
        }else{
            [duplicatRemoveArray addObject:[gpsArray lastObject]];
        }
    }
    
    
//    GpsBaseInfoMessage *mes1 = [duplicatRemoveArray firstObject];
//    GpsBaseInfoMessage *mes2 = [duplicatRemoveArray objectAtIndex:1];
//    GpsBaseInfoMessage *mes3 = [duplicatRemoveArray objectAtIndex:2];
//    duplicatRemoveArray = [ @[mes1,mes2,mes3] mutableCopy];
    
    
    
    _gpsBaseInfoArray = duplicatRemoveArray;
    
    
    //移除所有标注和线路、通知
    [this.animator stopAnimating];
    [this.animator removeAllAnnotations];
    
    [self removeALLOMAMovingAnnotationNotification];
    [carMapView removeAnnotations:carMapView.annotations];
    [carMapView removeOverlays:carMapView.overlays];
    
    
    //1.有重复点的话，去重，剩下一个点，显示车位置
    if(duplicatRemoveArray.count < 2){
       
        GpsBaseInfoMessage *gpsBaseInfoMessage = [duplicatRemoveArray firstObject];
        CarAnnotationModel *tg2 = [[CarAnnotationModel alloc] init];
        NSDate *gps = [NSDate dateWithTimeIntervalSince1970:gpsBaseInfoMessage.gpsTime / 1000.0];
        NSString *gpsstring = [NSDate stringFromDate:gps formate:@"yy-MM-dd HH:mm"];
        
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
        //0.坐标转换
        CLLocationCoordinate2D WGS = CLLocationCoordinate2DMake(gpsBaseInfoMessage.lat / 1000000.0, gpsBaseInfoMessage.lng / 1000000.0);
        CLLocationCoordinate2D GCJ021 =  [ZPLocationConverter wgs84ToGcj02:WGS];
        tg2.coordinate = GCJ021;
        
         HistoricalCarLocationAnnatation *anno = [[HistoricalCarLocationAnnatation alloc]init];
        anno.carmodel =  tg2;
        [carMapView addAnnotation:anno];
        [carMapView setCenterCoordinate:tg2.coordinate animated:YES];
        
        if(historicalTopSpeedView == nil)
            historicalTopSpeedView = [HistoricalTopSpeedView historicalTopSpeedView];
         NSString *gpsstring2 = [NSDate stringFromDate:gps formate:@"MM-dd HH:mm:ss"];
        historicalTopSpeedView.speed = [NSString stringWithFormat:@"%g",gpsBaseInfoMessage.speed / 10.0];
        historicalTopSpeedView.date  = [NSString stringWithFormat:@"%@",gpsstring2];
        [self.view addSubview:historicalTopSpeedView];
    }else{
        
            //2.车当天开过，有多个不同的点
            GpsBaseInfoMessage *gpsBaseInfoMessage1 = [duplicatRemoveArray firstObject];
            CarAnnotationModel *tg1 = [[CarAnnotationModel alloc] init];
            tg1.icon = @"始－１";
            //1.坐标转换
             CLLocationCoordinate2D WGS =  CLLocationCoordinate2DMake(gpsBaseInfoMessage1.lat / 1000000.0, gpsBaseInfoMessage1.lng / 1000000.0);
             CLLocationCoordinate2D GCJ021 =  [ZPLocationConverter wgs84ToGcj02:WGS];
             tg1.coordinate = GCJ021;
        
        
            CarHomeAnnotaton *anno1 = [[CarHomeAnnotaton alloc] init];
            anno1.carmodel = tg1;
            
            GpsBaseInfoMessage *gpsBaseInfoMessage2 = [duplicatRemoveArray lastObject];
            CarAnnotationModel *tg2 = [[CarAnnotationModel alloc] init];
            tg2.icon = @"终－1";
        
            //2.坐标转换
           CLLocationCoordinate2D WGS1 =  CLLocationCoordinate2DMake(gpsBaseInfoMessage2.lat / 1000000.0, gpsBaseInfoMessage2.lng / 1000000.0);
           CLLocationCoordinate2D GCJ022 =  [ZPLocationConverter wgs84ToGcj02:WGS1];
           tg2.coordinate = GCJ022;
        
        
            CarHomeAnnotaton *anno2 = [[CarHomeAnnotaton alloc] init];
            anno2.carmodel = tg2;
            _annotations =  @[anno1,anno2];
            [carMapView addAnnotations:_annotations];
            
        
                NSMutableArray *ddArray = [NSMutableArray array];
                for(long i =0;i < duplicatRemoveArray.count;i++){
                    GpsBaseInfoMessage *gpsBaseInfoMessage = [duplicatRemoveArray objectAtIndex:i];
                    
                    //3.坐标转
                    CLLocationCoordinate2D WGS1 =  CLLocationCoordinate2DMake(gpsBaseInfoMessage.lat / 1000000.0, gpsBaseInfoMessage.lng / 1000000.0);
                    CLLocationCoordinate2D GCJ022 =  [ZPLocationConverter wgs84ToGcj02:WGS1];
                    CLLocationCoordinate2D OMAMapViewCenter = GCJ022;
 
                    //CLLocationCoordinate2D ---> NSValue
                    NSValue *value =  [NSValue valueWithMACoordinate:OMAMapViewCenter];
                    [ddArray addObject:value];
                }
                _corrodnateArray = [ddArray copy];
    
        
                this.animator = [[OMAMovingAnnotationsAnimator alloc] init];
                OMAMovePath *path = [[OMAMovePath alloc] init];
                NSMutableArray *segments = [NSMutableArray array];
                for(long i = 0;i < _corrodnateArray.count - 1;i++){
                   NSValue *PathSegment =  [NSValue valueWithOMAMovePathSegment:
                                            
                                            //NSValue ---> CLLocationCoordinate2D
                   OMAMovePathSegmentMake([_corrodnateArray[i] MACoordinateValue],
                                            [_corrodnateArray[i + 1] MACoordinateValue],
                                            HistoricalTrackTimeInterval)];
                   [segments addObject:PathSegment];
                }
                [path addSegments:segments];
            
                _omaMovingannotation = [[OMAMovingAnnotation alloc] init];
                _omaMovingannotation.coordinate = [[_corrodnateArray firstObject] MACoordinateValue];
                _omaMovingannotation.movePath = path;
                //[annotation addObserver:this forKeyPath:@"moving" options:NSKeyValueObservingOptionNew context:NULL];
                [carMapView addAnnotation:_omaMovingannotation];
                [this.animator addAnnotation:_omaMovingannotation];
            
            dispatch_time_t removeTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
            dispatch_after(removeTime, dispatch_get_main_queue(), ^(void){
                
                [this.animator startAnimating];
            });
            
            
            /***********画线************/
            [this drawpolylineWithGPS:duplicatRemoveArray];
        
            
            /***********速度************/
           [this createTopSpeedView];
    }
}

/*
 *   1.2添加轨迹
 */
- (void)drawpolylineWithGPS:(NSArray *)gpsArray{
    
    [carMapView removeOverlays:carMapView.overlays];
    NSMutableArray *ddArray = [NSMutableArray array];
    for(long int i =0;i < gpsArray.count;i++){
        GpsBaseInfoMessage *gpsBaseInfoMessage = [gpsArray objectAtIndex:i];
        //坐标转化
        CLLocationCoordinate2D WGS1 =  CLLocationCoordinate2DMake(gpsBaseInfoMessage.lat / 1000000.0, gpsBaseInfoMessage.lng / 1000000.0);
        CLLocationCoordinate2D GCJ022 =  [ZPLocationConverter wgs84ToGcj02:WGS1];

        
        NSDictionary *dic = @{ @"latitude":  [NSString stringWithFormat:@"%f",GCJ022.latitude],
                               @"longitude": [NSString stringWithFormat:@"%f",GCJ022.longitude]
                             };
        [ddArray addObject:dic];
    }
    _coordinateArray = ddArray;
    
    //define minimum, maximum points
    MAMapPoint northEastPoint = MAMapPointMake(0.f, 0.f);
    MAMapPoint southWestPoint = MAMapPointMake(0.f, 0.f);
    
    //create a c array of points.
    MAMapPoint *pointArray = (MAMapPoint *)malloc(sizeof(MAMapPoint) * _coordinateArray.count);
    for(int idx = 0; idx < _coordinateArray.count; idx++){
        
        NSDictionary *dic = [_coordinateArray objectAtIndex:idx];
        
        //CLLocation *location =  [[CLLocation alloc]initWithLatitude:[dic[@"latitude"]  doubleValue] longitude:[dic[@"longitude"] doubleValue]];
        
        CLLocationDegrees latitude  =  [dic[@"latitude"]  doubleValue];  //location.coordinate.latitude;
        CLLocationDegrees longitude =  [dic[@"longitude"] doubleValue];  //location.coordinate.longitude;
        
        // create our coordinate and add it to the correct spot in the array
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        MAMapPoint point = MAMapPointForCoordinate(coordinate);
        
        // if it is the first point, just use them, since we have nothing to compare to yet.
        if (idx == 0) {
            northEastPoint = point;
            southWestPoint = point;
        } else {
            if (point.x > northEastPoint.x)
                northEastPoint.x = point.x;
            if (point.y > northEastPoint.y)
                northEastPoint.y = point.y;
            if (point.x < southWestPoint.x)
                southWestPoint.x = point.x;
            if (point.y < southWestPoint.y)
                southWestPoint.y = point.y;
        }
        
        pointArray[idx] = point;
    }
 
    MAPolyline *polylinee = [MAPolyline polylineWithPoints:pointArray count:_coordinateArray.count];
    [carMapView addOverlay:polylinee];
    double width = northEastPoint.x - southWestPoint.x;
    double height = northEastPoint.y - southWestPoint.y;
    MAMapRect routeRect = MAMapRectMake(southWestPoint.x, southWestPoint.y, width, height);
    [carMapView setVisibleMapRect:routeRect edgePadding:UIEdgeInsetsMake(30, 30, 30, 30) animated:YES];
    
    free(pointArray);
    pointArray = NULL;
}


 /*
  *    1.头部速度时间显示
  */
- (void)createTopSpeedView{
    
   if(![_gpsBaseInfoArray firstObject]) return;
   if(historicalTopSpeedView == nil)
      historicalTopSpeedView = [HistoricalTopSpeedView historicalTopSpeedView];
    
    GpsBaseInfoMessage *info  = [_gpsBaseInfoArray firstObject];
    _locaitonIndex = 1;
    
    NSDate *gps = [NSDate dateWithTimeIntervalSince1970:info.gpsTime / 1000.0];
    NSString *gpsstring = [NSDate stringFromDate:gps formate:@"MM-dd HH:mm:ss"];
    
    historicalTopSpeedView.speed = [NSString stringWithFormat:@"%g",info.speed / 10.0];
    historicalTopSpeedView.date  = [NSString stringWithFormat:@"%@",gpsstring];
    
    [self.view addSubview:historicalTopSpeedView];
    
    [self removeOMAMovingAnnotationAngleChangedNocaiton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(angleChangeAction:) name:@"OMAMovingAnnotationAngleChangedNocaiton" object:nil];
}
- (void)removeOMAMovingAnnotationAngleChangedNocaiton{
 [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OMAMovingAnnotationAngleChangedNocaiton" object:nil];
}
- (void)removeALLOMAMovingAnnotationNotification{
    [self        removeOMAMovingAnnotationAngleChangedNocaiton];
    [omaannoView removeOMAMovingAnnotationAngleChangedNocaiton];
    //[_omaMovingannotation removeObserver:self forKeyPath:@"moving"];
}
//每一小段距离结束之后(每个点)更改速度时间显示，车辆状态颜色
- (void)angleChangeAction:(NSNotification *)notificaiton{
    
     GpsBaseInfoMessage *info  = [_gpsBaseInfoArray objectAtIndex:_locaitonIndex];
    
     NSDate *gps = [NSDate dateWithTimeIntervalSince1970:info.gpsTime / 1000.0];
     NSString *gpsstring = [NSDate stringFromDate:gps formate:@"MM-dd HH:mm:ss"];
     
     historicalTopSpeedView.speed = [NSString stringWithFormat:@"%g",info.speed / 10.0];
     historicalTopSpeedView.date  = [NSString stringWithFormat:@"%@",gpsstring];
    
    
     if(_locaitonIndex == _gpsBaseInfoArray.count - 1) _locaitonIndex = 0;
     _locaitonIndex ++;
}





/*
 *    2.地图
 */
 - (void)createMapView{
     if(carMapView == nil)
     carMapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, KSCREEWIDTH,KSCREEHEGIHT)];
     
     carMapView.language = MAMapLanguageZhCN;
     carMapView.userTrackingMode = MAUserTrackingModeFollow;
     carMapView.distanceFilter =  kCLDistanceFilterNone;
     carMapView.desiredAccuracy =  kCLLocationAccuracyBest;
     carMapView.headingFilter = kCLHeadingFilterNone;
     carMapView.showsUserLocation = NO;
     //carMapView.showsBuildings = YES;
     carMapView.mapType = MAMapTypeStandard;
     carMapView.delegate = self;
     carMapView.showsCompass = NO;
     carMapView.showsScale = NO;
     
     AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
     [carMapView setCenterCoordinate:delegate.cLLocationCoordinate2D animated:YES];
     [self.view addSubview:carMapView];
 }


/*
 *    3.StretchMapView
 */
- (void)createStretchMapView{
    StretchMapView *stretchMapView = [[StretchMapView alloc]initWithDelegate:self type:StretchMapViewHistoryLocation];
    [self.view addSubview:stretchMapView];
}


/*
 *    4.ASOTwoStateButton
 */
- (void)createASOTwoStateButton{
    
    CGRect rect = CGRectMake(KSCREEWIDTH - 60, KSCREEHEGIHT  - 60 - 64 , 100 / 2.0 , 100 /2.0);
    if(menuButton == nil){
        menuButton = [[ASOTwoStateButton alloc]initWithFrame:rect];
        [menuButton setBackgroundImage:[UIImage imageNamed:@"clickPopTime"] forState:UIControlStateNormal];
        [menuButton setBackgroundImage:[UIImage imageNamed:@"iconfont-guanbi"] forState:UIControlStateSelected];
        [menuButton addTarget:self action:@selector(ASOTwoStateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [menuButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [menuButton setTitle:@"时间" forState:UIControlStateNormal];
        [menuButton setTitle:@"" forState:UIControlStateSelected];
        [menuButton addTarget:self action:@selector(ASOTwoStateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        //[menuButton initAnimationWithFadeEffectEnabled:YES];
    }
    [self.view addSubview:menuButton];
    
    if(menuItemView == nil){
    CGRect menuItemViewrect = CGRectMake(0, 0, KSCREEWIDTH, KSCREEHEGIHT - 64);
    menuItemView = [[ASOButtonView alloc]initWithFrame:menuItemViewrect];
    menuItemView.type = ASOButtonViewHistoricalTrack1;
    menuItemView.boundFrame = menuButton.frame;
    [menuItemView setDelegate:self];
    }
}

/*
 *    4.1 ASOTwoStateButton action
 */
- (void)ASOTwoStateButtonAction:(ASOTwoStateButton *)sender{
    if (!sender.selected) {
        
        [menuButton addCustomView:menuItemView];
        [menuItemView expandWithAnimationStyle:ASOAnimationStyleRiseProgressively];
    }
    else {
        [menuItemView collapseWithAnimationStyle:ASOAnimationStyleRiseProgressively];
        [menuButton removeCustomView:menuItemView interval:[menuItemView.collapsedViewDuration doubleValue]];
    }
    
    sender.selected = !sender.selected;
}
#pragma mark - Menu item view delegate method
- (void)didSelectBounceButtonAtIndex:(NSInteger)index{
    
    menuButton.selected = !menuButton.selected;
    [menuItemView collapseWithAnimationStyle:ASOAnimationStyleRiseConcurrently];
    [menuButton removeCustomView:menuItemView interval:[menuItemView.collapsedViewDuration doubleValue]];
    //移除所有标注和线路、通知
    [self removeALLOMAMovingAnnotationNotification];
    [carMapView removeAnnotations:carMapView.annotations];
    [carMapView removeOverlays:carMapView.overlays];
    
    
    //更换前天  昨天 今天的轨迹
    menuItemView.selectIndex = index;
    if(index == 0){
        NSDate *start  =  [NSDate getZeroDateFromDate:[NSDate date]];
        NSDate *end    =  [NSDate getNowSystemDate:[NSDate date]];
        _starT         =  [start timeIntervalSince1970GMT8];
        _emdT          =  [end timeIntervalSince1970GMT8];
    }else if (index == 1){
        NSDate *yesdate = [NSDate dateWithTimeIntervalSinceNow:-24*60*60];
        NSDate *start  =  [NSDate getZeroDateFromDate:yesdate];
        NSDate *end  =    [NSDate getZeroDateFromDate:[NSDate date]];
        _starT = [start timeIntervalSince1970GMT8];
        _emdT  = [end timeIntervalSince1970GMT8];
        
    }else{
        NSDate *yesdate =  [NSDate dateWithTimeIntervalSinceNow:-24*60*60];
        NSDate *byesdate = [NSDate dateWithTimeIntervalSinceNow:-24*60*60*2];
        NSDate *start  =   [NSDate getZeroDateFromDate:byesdate];
        NSDate *end  =     [NSDate getZeroDateFromDate:yesdate];
        _starT = [start timeIntervalSince1970GMT8];
        _emdT  = [end timeIntervalSince1970GMT8];
    }
    
    [self sendCSWebSocketGetHistoryInfoCommand];
}






#pragma mark - MKMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation{
    if(!_isLoadDataCompete){
        //userLocation.title = @"赛格车圣";
        //userLocation.subtitle = @"是个非常牛逼的地方!";
        CLLocationCoordinate2D center = userLocation.location.coordinate;
        [mapView setCenterCoordinate:center animated:YES];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    if ([annotation isMemberOfClass:[MAUserLocation class]]) {
        return nil;
    }
    
    //有轨迹，显示起点终点
    else if ([annotation isMemberOfClass:[CarHomeAnnotaton class]]){
      HistoricalTrackAnnotationView *annoView = [HistoricalTrackAnnotationView annotationViewWithMapView:mapView];
      annoView.annotation = annotation;
      return annoView;
    }
    //有轨迹 显示运动点
    else if ([annotation isMemberOfClass:[OMAMovingAnnotation class]]){
        omaannoView = [OMAMovingAnnotationView annotationViewWithMapView:mapView];
        omaannoView.annotation = annotation;
        return omaannoView;
    }
    
    //没有轨迹 显示最后位置
    else if ([annotation isMemberOfClass:[HistoricalCarLocationAnnatation class]]){
        
        OMAMovingAnnotationView *omaannoView11 = [OMAMovingAnnotationView annotationViewWithMapView:mapView];
        omaannoView11.annotation = annotation;
        return omaannoView11;
    }
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    
    if([overlay isKindOfClass:[MACircle class]]){
       MACircleRenderer *circleRenderer = [[MACircleRenderer alloc]initWithOverlay:overlay];
        circleRenderer.lineWidth   = 4.f;
        circleRenderer.strokeColor = kColor;
        circleRenderer.fillColor   = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
        return circleRenderer;
    }
    
    MAPolylineRenderer *renderer = [[MAPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [ZPUiutsHelper colorWithHexString:@"#00efef"];
    renderer.lineWidth = 3;
    renderer.lineCap = kCGLineCapRound;
    renderer.lineJoin = kCGLineJoinRound;
    return renderer;
}
 
#pragma mark - StretchMapViewDelegate
- (void)didSelectStretchMapViewIndex:(NSInteger)index{
    //高德默认3- 19
    NSUInteger level =  [carMapView zoomLevel];
    level = index==0? ++level:--level;
    if(level < 3 || level > 19) return;
    [carMapView setZoomLevel:level animated:YES];
}
@end
