//
//  CarMileageViewController.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/3.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "CarMileageViewController.h"
#import "MileageTBHeaderView.h"
#import "MIleageTBViewcell.h"
#import "CarmileageModel.h"
#import "CarmileageOutModel.h"

//弹出视图
#import "ASOButtonView.h"
#import "ASOTwoStateButton.h"
#import "ASOBounceButtonViewDelegate.h"

@interface CarMileageViewController ()<ASOBounceButtonViewDelegate>{

    NSMutableArray *dataArray;
    CarmileageOutModel *outlevelModel;
    
    ASOTwoStateButton   *menuButton;
    ASOButtonView *menuItemView;
    
    OLImageView *Aimv;
    UILabel *noDataGifView;
}

@property (nonatomic,strong)SRRefreshView *slimeView;

@property(nonatomic,strong)UITableView *mileTBView;
@property(nonatomic,strong)MileageTBHeaderView *header;

@property (nonatomic,assign)BOOL isReload;
@property (nonatomic,assign)NSInteger timeSelect;

@end

@implementation CarMileageViewController
@synthesize mileTBView;

- (BOOL)hidesBottomBarWhenPushed{
    return YES;
}

- (void)loadView{
    [super loadView];
    
        _timeSelect = 1;
        _startDate = [NSDate getYesturdayDateString];
        _endDate   = [NSDate getYesturdayDateString];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"里程统计";

    if(self.isYesturday && self.proceedsModel.greenMoney == 1){
     
        [self createNoDataGifView];
    }else{
    
      [self UBIMileageListData];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"爱车里程统计"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"爱车里程统计"];
}


/*
 *   UBIMileageList
 */
- (void)UBIMileageListData{
    if(!_isReload)
       [MBProgressHUD showMessage:KIndicatorStr];
    __weak typeof(self) this = self;
    [Interface UBIMileageListWithvehicleId:[CurrentDeviceModel shareInstance].vehicleId
                                 startDate:_startDate
                                   endDate:_endDate
                                     block:^(id result){
        NSLog(@"%@",result);
        if([(NSArray *)[[result objectForKey:@"data"] objectForKey:@"details"] count] == 0){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
             
                [this TBViewRemoveFromSuperView];
                
                [this createNoDataGifView];
                
                [this createASOTwoStateButton];
            });
        }else{
             outlevelModel = [CarmileageOutModel objectWithKeyValues:[result objectForKey:KServerdataStr]];
             outlevelModel.details =  [[result objectForKey:KServerdataStr] objectForKey:@"details"];
             dataArray = [NSMutableArray array];
             for(NSDictionary *dic in outlevelModel.details){
                  CarmileageModel  *model = [CarmileageModel objectWithKeyValues:dic];
                  [dataArray addObject:model];
             }
            
             dataArray = [[[dataArray reverseObjectEnumerator] allObjects] copy];
            
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUD];
                 
                 [noDataGifView removeFromSuperview];
                 [Aimv removeFromSuperview];
                 noDataGifView = nil;
                 Aimv = nil;
                 
                 [this createTBView];
                 
                 [this createASOTwoStateButton];
             });
        }
    }failblock:^(id result) {
        NSString *indicatorstr;
        if(result == nil ||
           [result isKindOfClass:[NSNull class]] ||
           [result objectForKey:KServererrorMsgStr] == nil ||
           [[result objectForKey:KServererrorMsgStr] isKindOfClass:[NSNull class]]){
            indicatorstr = @"查询失败";
        }else{
            indicatorstr = [result objectForKey:KServererrorMsgStr];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showError:indicatorstr delay:1.0];
        });
    }];
}


/*
 *    1.UITableView
 */
- (void)createTBView{
    CGRect tbframe = CGRectMake(0, 0, KSCREEWIDTH, KSCREEHEGIHT - 64);
    if(mileTBView == nil)
    mileTBView = [[UITableView alloc]initWithFrame:tbframe style:UITableViewStylePlain];
    mileTBView.delegate = self;
    mileTBView.dataSource = self;
    mileTBView.rowHeight = 60;
    mileTBView.backgroundColor = IWColor(235, 235, 235);
    mileTBView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [mileTBView addSubview:self.slimeView];
    
    if(_header == nil)
    _header =  kLOADNIBWITHNAME(@"MileageTBHeaderView", self);
    _header.timeSelect = self.isYesturday? 1 : _timeSelect;
    _header.model = outlevelModel;
    mileTBView.tableHeaderView = _header;
    
    [self.view addSubview:mileTBView];
    [mileTBView reloadData];
}
- (void)TBViewRemoveFromSuperView{
    [mileTBView removeFromSuperview];
    mileTBView = nil;
    [_header removeFromSuperview];
    _header = nil;
}


/*
 *   没有开车，没数据
 */
- (void)createNoDataGifView{
    
    NSArray *dateArray = @[@"今天",@"昨天",@"前天",@"本周",@"上周",@"本月",@"上月"];
    NSString *dateStr = @"";
    dateStr = [dateArray objectAtIndex:_timeSelect];
    
    if(noDataGifView == nil){
        noDataGifView = [[UILabel alloc]initWithFrame:CGRectZero];
    }
    noDataGifView.frame = CGRectMake(0, 20,KSCREEWIDTH, 80);
    noDataGifView.textAlignment = NSTextAlignmentCenter;
    noDataGifView.textColor = IWColor(93, 93, 93);
    noDataGifView.text = [NSString stringWithFormat:@"%@未开车，\n感谢您为环保做出了一份贡献～",dateStr];
    noDataGifView.numberOfLines = 2;
    [self.view addSubview:noDataGifView]; 
    
    if(Aimv == nil)
    Aimv  = [[OLImageView alloc] initWithImage:[OLImage imageNamed:@"绿色出行未开车.gif"]];
    [Aimv setFrame:CGRectMake(0, noDataGifView.bottom + 20, 150, 150)];
    Aimv.center = CGPointMake(self.view.center.x, Aimv.center.y);
    [Aimv setUserInteractionEnabled:YES];
    [self.view addSubview:Aimv];
}



/*
 *    2.ASOTwoStateButton
 */
- (void)createASOTwoStateButton{
    if(_isYesturday) return;
    
    CGFloat height =  (KSCREEHEGIHT - 64 - 20 - 80) / 8.0;
    if(height > 50.0) height = 50.0;
    CGRect rect = CGRectMake(KSCREEWIDTH - (height + 10), KSCREEHEGIHT  - (height + 10) - 64 , height , height);
    if(menuButton == nil){
        menuButton = [[ASOTwoStateButton alloc]initWithFrame:rect];
        [menuButton setBackgroundImage:[UIImage imageNamed:@"clickPopTime"] forState:UIControlStateNormal];
        [menuButton setBackgroundImage:[UIImage imageNamed:@"iconfont-guanbi"] forState:UIControlStateSelected];
        [menuButton addTarget:self action:@selector(ASOTwoStateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [menuButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [menuButton setTitle:@"时间" forState:UIControlStateNormal];
        [menuButton setTitle:@"" forState:UIControlStateSelected];
        //[menuButton initAnimationWithFadeEffectEnabled:YES];
    }
    [self.view addSubview:menuButton];
    
    
    if(menuItemView == nil){
     CGRect menuItemViewrect = CGRectMake(0, 0, KSCREEWIDTH, KSCREEHEGIHT - 64);
     menuItemView = [[ASOButtonView alloc]initWithFrame:menuItemViewrect];
     menuItemView.type = ASOButtonViewHistoricalTrack;
     menuItemView.boundFrame = menuButton.frame;
    }
    [menuItemView setDelegate:self];
    
}
- (void)ASOTwoStateButtonAction:(ASOTwoStateButton *)sender{
    
    if (!sender.selected) {
        
        [menuButton addCustomView:menuItemView];
        [menuItemView expandWithAnimationStyle:ASOAnimationStyleRiseConcurrently];
    }
    else {
        
        [menuItemView collapseWithAnimationStyle:ASOAnimationStyleRiseConcurrently];
        [menuButton removeCustomView:menuItemView interval:[menuItemView.collapsedViewDuration doubleValue]];
    }
    
    sender.selected = !sender.selected;
}


#pragma mark - Menu item view delegate method
- (void)didSelectBounceButtonAtIndex:(NSInteger)index
{
    menuButton.selected = !menuButton.selected;
    [menuItemView collapseWithAnimationStyle:ASOAnimationStyleRiseConcurrently];
    [menuButton removeCustomView:menuItemView interval:[menuItemView.collapsedViewDuration doubleValue]];

    //更换前天  昨天 今天的轨迹 index从0开始
    menuItemView.selectIndex = index;
    _isReload = YES;
    _timeSelect = index;
    
    switch (index) {
        case 0:{
        
            _startDate =  [NSDate getTodayDateString];
            _endDate   =  [NSDate getTodayDateString];

        }
            break;
        case 1: //昨天
        {
            _startDate =  [NSDate getYesturdayDateString];
            _endDate   =  [NSDate getYesturdayDateString];
        }
            break;
        case 2://前天
        {
            _startDate =  [NSDate getThedaybeforeYesturday];
            _endDate   =  [NSDate getThedaybeforeYesturday];
        }
            break;
        case 3://本周
        {
            _startDate =  [[NSDate getnowWeekDateString] firstObject];
            _endDate   =  [[NSDate getnowWeekDateString] lastObject];
        }
            break;
        case 4://上周
        {
            _startDate =  [[NSDate getLastWeekDateString] firstObject];
            _endDate   =  [[NSDate getLastWeekDateString] lastObject];
        }
            break;
        case 5://本月
        {
            _startDate =  [[NSDate getnowMonthDateString] firstObject];
            _endDate   =  [[NSDate getnowMonthDateString] lastObject];
        }
            break;
        case 6://上月
        {
            _startDate =  [[NSDate getLastMonthDateString] firstObject];
            _endDate   =  [[NSDate getLastMonthDateString] lastObject];
        }
            break;
        default:
            break;
    }
  
    [self UBIMileageListData];
}

#pragma mark - UITableView delegate and dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return   dataArray.count;
}
- (MIleageTBViewcell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IDENTIFIER = @"CarMileageTBViewCell";
    MIleageTBViewcell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if(!cell){
        cell = kLOADNIBWITHNAME(@"MIleageTBViewcell", self);
    }
    cell.indexPath = indexPath;
    cell.model = dataArray[indexPath.row];
    return cell;
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
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
            [wself UBIMileageListData];
            [refreshView endRefresh];
        };
    }
    return _slimeView;
}
@end
