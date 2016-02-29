//
//  ProceedsVC.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/17.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "ProceedsVC.h"
#import "ProceedsYesturdayVC.h"
#import "PeccancySeekResultVC.h"
#import "WebViewController.h"

#import "ProhoriTBView.h"
#import "ProceedsCirclePathView.h"
#import "NSTimer+Addition.h"
#import "ProhoriFirstWeather.h"

#import "ProNewsModel.h"
#import "WeatherModel.h"
#import "ProceedsModel.h"


#define topImgCount   (topItemsCount + 1)
#define topImgTotal   (topImgCount == 1? 1 : (topImgCount * 10000))


@interface ProceedsVC () <UIScrollViewDelegate,UITableViewDataSource, UITableViewDelegate,SRRefreshDelegate>{

    ProhoriTBView          *protbview;
    ProceedsCirclePathView *circleView;
    UIPageControl          *pageControl;
    NSTimer                *timer;
    
    //头部数据
    NSInteger       topItemsCount;
    NSMutableArray  *imgurls;
    WeatherModel    *weathmodel;
    ProceedsModel   *proceedModel;
    
    UIScrollView *KscrollView;
}

@property (nonatomic,strong)SRRefreshView *slimeView;

@end

@implementation ProceedsVC


+ (ProceedsVC *)shareInstance{
    static ProceedsVC *_instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)loadView{
    [super loadView];
    
    KscrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KSCREEWIDTH, KSCREEHEGIHT - 64 - 49)];
    KscrollView.delegate = self;
    KscrollView.contentSize = CGSizeMake(KSCREEWIDTH,KSCREEHEGIHT - 64 - 49 + 1);
    KscrollView.showsVerticalScrollIndicator = NO;
    [KscrollView addSubview:self.slimeView];
    
    self.view = KscrollView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = [CurrentDeviceModel shareInstance].plateNo;
    self.view.backgroundColor = IWColor(227, 243, 254);
    
    [self rightButtonItem];
    [self createTopTBView];
    [self createCirclePathView];

    
    [self networkreachableHander];
    
    //
    [self location];

    
    if(!self.isAutoLogin){
        [self loadAllData];
    }else{
        [Interface autoLoginRequest];
    }
    

    //app推送
    [self appPushFromTypeRemoteNotification];

    //检查更新
    [appdelegate  checkAppVersonUpdate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"收益首页"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"收益首页"];
    
    if([CurrentDeviceModel shareInstance].plateNo)
        self.navigationItem.title = [CurrentDeviceModel shareInstance].plateNo;
}



/*
 *   4.头部滑动
 */
- (void)createTopTBView{
    
    CGRect rect = CGRectMake(0, 0, KSCREEWIDTH, TopPercent);
    
    if(protbview == nil)
        protbview = [[ProhoriTBView alloc]initWithFrame:rect style:UITableViewStylePlain];
        protbview.delegate   = self;
        protbview.dataSource = self;
        protbview.pagingEnabled = YES;
        protbview.bounces = YES;
        protbview.showsVerticalScrollIndicator = NO;
        [self.view addSubview:protbview];

    
    if(imgurls && pageControl == nil && imgurls.count > 1)
        pageControl = [[UIPageControl alloc]init];
        pageControl.enabled  = NO;
        pageControl.frame = CGRectMake(0, TopPercent - 20, KSCREEWIDTH, 20);
        pageControl.numberOfPages = topImgCount;
        [pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
        [pageControl setPageIndicatorTintColor:[UIColor colorWithWhite:.7 alpha:.5]];
        pageControl.currentPage = 0;
        [self.view addSubview:pageControl];
    
    [protbview reloadData];

    if(imgurls && imgurls.count > 1 && timer == nil){
       timer =  [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(TimePageAction) userInfo:nil repeats:YES];
         [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    
    //[[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    //[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    //[[NSRunLoop currentRunLoop] run];
}
- (void)TimePageAction{
    //这个动画需要时间！！！！
    //TICK;
    NSInteger page =  (protbview.contentOffset.y + KSCREEWIDTH) / KSCREEWIDTH;
    [protbview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    //TOCK;
}
- (void)setpage{
    int y = protbview.contentOffset.y / KSCREEWIDTH;
    pageControl.currentPage = y % topImgCount;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if([scrollView isEqual:protbview]){
        
    }else{
    
        [_slimeView scrollViewDidScroll];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if([scrollView isEqual:protbview]) {
    
      int y = protbview.contentOffset.y / KSCREEWIDTH;
      pageControl.currentPage = y % topImgCount;
    }else{
    
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if([scrollView isEqual:protbview]){
    
       [timer pauseTimer];
    }else{
    
    
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if([scrollView isEqual:protbview]){
        
        [timer resumeTimerAfterTimeInterval:1];
    }else{
        
        [_slimeView scrollViewDidEndDraging];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(nonnull UIScrollView *)scrollView{
    
    if([scrollView isEqual:protbview]){
    
       [self setpage];
    }
}


#pragma mark - slimeRefresh
- (SRRefreshView *)slimeView{
    __weak __typeof__ (self) wself = self;
    if (!_slimeView) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
        _slimeView.backgroundColor = [UIColor whiteColor];
        _slimeView.block = ^(SRRefreshView *refreshView){
            [wself loadAllData];
            [refreshView endRefresh];
        };
    }
    return _slimeView;
}


/*
 *   5.圆环路径
 */
- (void)createCirclePathView{
    if(circleView == nil)
        circleView = [[ProceedsCirclePathView alloc]initWithFrame:CGRectMake(0.0f,TopPercent, KSCREEWIDTH , KSCREEHEGIHT - 64 - 49 - TopPercent)];
    circleView.model = proceedModel;
    [circleView setYesProceeds:proceedModel.income ];
    [circleView setTotalProceeds:proceedModel.totalIncome];
    [circleView setYesscores:proceedModel.score];
    [self.view addSubview:circleView];
}




#define mark UITableView delegate and  dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(imgurls && imgurls.count >1 ){
        return  (imgurls.count + 1) * 10000;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ProhoriTBViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KSCREEWIDTH, TopPercent)];
        //imageview.backgroundColor = [UIColor greenColor];
        imageview.tag = 300;
        [cell.contentView addSubview:imageview];
        
        ProhoriFirstWeather *weather = [[ProhoriFirstWeather alloc]initWithFrame:CGRectMake(0, 0, KSCREEWIDTH, TopPercent)];
        //weather.backgroundColor = [UIColor redColor];
        weather.tag = 400;
        [cell.contentView addSubview:weather];
    }
    ProhoriFirstWeather *weather = (ProhoriFirstWeather *)[cell.contentView viewWithTag:400];
    weather.model = weathmodel;
    //天气类型 一共7种，晴、阴、雨、雪、霾、沙尘、雷
    //weathmodel.weather

    NSString *weatherStr = @"";
    if([weathmodel.weather iscontainSubString:@"多云"] || [weathmodel.weather iscontainSubString:@"阴"]){
        weatherStr = @"阴";
    }else if([weathmodel.weather  iscontainSubString:@"晴"]){
        weatherStr = @"晴";
    }else if ([weathmodel.weather iscontainSubString:@"雨"]){
        weatherStr = @"雨";
    }else if([weathmodel.weather  iscontainSubString:@"雪"]){
        weatherStr = @"雪";
    }else if ([weathmodel.weather iscontainSubString:@"雾"] || [weathmodel.weather iscontainSubString:@"霾"]){
        weatherStr = @"雾";
    }else if ([weathmodel.weather iscontainSubString:@"尘"]){
        weatherStr = @"沙尘";
    }else if ([weathmodel.weather iscontainSubString:@"冰"]){
        weatherStr = @"雷";
    }
    
    
    UIImageView *imageview = (UIImageView *)[cell.contentView viewWithTag:300];
    
    if(indexPath.row % topImgCount == 0){
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",weatherStr]];
        imageview.image = image;
    }else{
        NSInteger index = indexPath.row % topImgCount;
        ProNewsModel *model = [imgurls objectAtIndex:index - 1];
        [imageview setShowActivityIndicatorView:YES];
        [imageview setIndicatorStyle:UIActivityIndicatorViewStyleGray];
        imageview.contentMode = UIViewContentModeScaleToFill;
        [imageview sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]
                          placeholderImage:[UIImage imageNamed:weatherStr] options:SDWebImageRetryFailed | SDWebImageProgressiveDownload | SDWebImageLowPriority];
    }
    
    if(indexPath.row % topImgCount == 0){
        weather.hidden = NO;
        imageview.hidden = NO;
    }else{
        weather.hidden = YES;
        imageview.hidden = NO;
    }
    return cell;
}
- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    //跳到网页
    NSInteger index = indexPath.row % topImgCount;
    if(index == 0) return;
    ProNewsModel *model = [imgurls objectAtIndex:index - 1];
    WebViewController *webvc = [[WebViewController alloc]init];
    webvc.url = model.url;
    [self.navigationController pushViewController:webvc animated:YES];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
}



//app未打开违章推送
- (void)appPushFromTypeRemoteNotification{
    AppDelegate *deleagte = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(deleagte.appPushFromType == AppPushFromTypeRemoteNotificationPeccancyResult){
        
        NSDictionary *launchuserInfo = deleagte.remotePushLaunchOptions;
        
        PeccancySeekResultVC *resultVC = [[PeccancySeekResultVC alloc]init];
        resultVC.appPushFromType = AppPushFromTypeRemoteNotificationPeccancyResult;
        resultVC.vehicleId  =  [[launchuserInfo objectForKey:@"vehicleId"] longValue];
        resultVC.city       =  [launchuserInfo objectForKey:@"cnty"];
        resultVC.plateNo    =  [launchuserInfo objectForKey:@"plateNo"];
        resultVC.vin        =  [launchuserInfo objectForKey:@"vin"];
        resultVC.engineNo   =  [launchuserInfo objectForKey:@"engineNo"];
        [self.navigationController pushViewController:resultVC animated:YES];
        
        deleagte.appPushFromType = AppPushFromTypeNormal;
        
    }else if(deleagte.appPushFromType == AppPushFromTypeRemoteNotificaitonProceedIncome){
        
        deleagte.appPushFromType = AppPushFromTypeNormal;
    }
}


/**
 *   定位
 *
 *  @return
 */
- (void)location{
    __weak typeof(self) this = self;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(delegate.userlocation) return;
    [delegate getUserLocation];
    delegate.block = ^{
        [SeekparamModel shareInstance].city = [SFHFKeychainUtils getPasswordForUsername:@"UserLocationCity" andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL];
        [SeekparamModel shareInstance].cityNickName = [SFHFKeychainUtils getPasswordForUsername:@"UserProvinceNickName1" andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL];
        [this  getTopWheatherInfoWithCity];
    };
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"JUHEprovincesAndCitys"]){
        [delegate loadAllCitys];
    }
}


/*
 *  1.收益首页头部广告图
 */
- (void)getTopUrlInfo{
    if(![UIDevice checkNowNetworkStatus]) return;
    __weak typeof(self) this = self;
    [Interface getTopUrlInfotype:1 block:^(id result) {
        
        imgurls = [NSMutableArray array];
        
        for(NSDictionary *dic in [result objectForKey:KServerdataStr]){
            
            ProNewsModel *newsModel = [ProNewsModel objectWithKeyValues:dic];
            
            [imgurls addObject:newsModel];
        }
        
        topItemsCount = imgurls.count;
        
        this.isLoadProNewsModel = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [this createTopTBView];
            
            if(imgurls && imgurls.count > 1){
                
                [protbview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:topImgTotal / 2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        });
        
    }failblock:^(id result) {
        
        this.isLoadProNewsModel = NO;
    }];
}


/*
 *  2.收益首页头部天气
 */
- (void)getTopWheatherInfoWithCity{
    
    if(![UIDevice checkNowNetworkStatus]) return;
    
    __weak typeof(self) weakSelf = self;
    
    NSString *locationCity = [SFHFKeychainUtils getPasswordForUsername:@"UserLocationCity" andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL];
    if(locationCity == nil || locationCity.length == 0) locationCity = @"深圳";
    
    [Interface getTopWheatherInfoWithCity:locationCity block:^(id result)  {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        weathmodel =  [WeatherModel objectWithKeyValues:[result objectForKey:KServerdataStr]];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weathmodel];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"ProceedsWeatherModel"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            strongSelf.isLoadWeatherModel = YES;
            
            [strongSelf createTopTBView];
            
        });
        
        
        [strongSelf getTopUrlInfo];
        
    }failblock:^(id result) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.isLoadWeatherModel = NO;
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProceedsWeatherModel"];
        weathmodel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if(!weathmodel)
            weathmodel = [WeatherModel objectWithKeyValues:@{@"washIndex":@"适宜",@"temperature":@"20° / 26°",@"weather":@"晴",@"pm25":@0}];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [strongSelf createTopTBView];
        });
    }];
}


/*
 *  3.收益首页收益数据
 */
- (void)getPeccacyHomeData{
    if(![UIDevice checkNowNetworkStatus]) return;
    __weak typeof(self) this = self;
    [Interface getPeccacyHomeDataWithvehicleId:[CurrentDeviceModel shareInstance].vehicleId block:^(id result){
        NSLog(@"%@",result);
        proceedModel = [ProceedsModel objectWithKeyValues:[result objectForKey:KServerdataStr]];
//        proceedModel.income = 7.0;
//        proceedModel.totalIncome = 600;
//        proceedModel.score = 120;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            this.isLoadDataCompete = YES;
            [this createCirclePathView];
            
        });
    }failblock:^(id result) {
        
        this.isLoadDataCompete = NO;
        
        proceedModel = [ProceedsModel objectWithKeyValues:@{@"income":@"0",@"totalIncome":@"0",@"score":@0}];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [this createCirclePathView];
            [MBProgressHUD showIndicator:@"客官莫急，系统正在计算昨日收益中。"];
        });
    }];
}



#pragma mark setters
- (void)loadAllData{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationItem.title = [CurrentDeviceModel shareInstance].plateNo;
    });
    
    [self getPeccacyHomeData];
  
    [self getTopWheatherInfoWithCity];
}


//网络连接成功
- (void)networkreachableHander{
    __weak typeof(self) this = self;
    this.networkreachableBlock = ^{
        
        [Interface loginUnUsefulComfirmblock:^{
            
            if(!this.isLoadDataCompete){
                
                [this getPeccacyHomeData];
            }
            
            if(!this.isLoadProNewsModel){
                
                [this getTopUrlInfo];
            }
            
            if (!this.isLoadWeatherModel){
                
                [this getTopWheatherInfoWithCity];
            }
        }];
    };
}
@end
