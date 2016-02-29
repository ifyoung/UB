//
//  ProceedsTotalVC.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/21.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "ProceedsTotalVC.h"
#import "ProceedsTotalCell.h"
#import "ProceedsTotalHeader.h"
#import "ProceedsTotalModel.h"
#import "PrpceedsTotailDetailModel.h"

@interface ProceedsTotalVC (){
 
    ProceedsTotalModel *totailModel;
    UITableView *totalTBView;
    NSMutableArray *dataArray;
    BOOL isreload;
}
@property (nonatomic,strong)SRRefreshView *slimeView;

@end

@implementation ProceedsTotalVC

- (BOOL)hidesBottomBarWhenPushed{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"累计收益";
    
    [self totalPeccacyDetail];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"累计收益"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"累计收益"];
}

/*
 *   累计收益数据
 */
- (void)totalPeccacyDetail{
    NSString *startDate = [NSDate dateWithOneMonthSinceToday];
    NSString *endDate   = [NSDate getTodayDateString];
    
    if(!isreload)
    [MBProgressHUD showMessage:KIndicatorStr];
    [Interface totalPeccacyDetail:[CurrentDeviceModel shareInstance].vehicleId startDate:startDate endDate:endDate block:^(id result) {
        
        NSLog(@"%@",result);
        dataArray = [NSMutableArray array];
        totailModel = [ProceedsTotalModel objectWithKeyValues:[result objectForKey:KServerdataStr]];
        for(NSDictionary *dic in totailModel.details){
            PrpceedsTotailDetailModel *model = [PrpceedsTotailDetailModel objectWithKeyValues:dic];
            [dataArray addObject:model];
        
        }
        
        dataArray = [[[dataArray reverseObjectEnumerator] allObjects] copy];
        
        [totailModel setDetails:dataArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [self createSubViews];
        });
    }failblock:^(id result) {
        if(![UIDevice checkNowNetworkStatus]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showIndicator:KNetworkError];
            });
            return;
        }else{
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
        }
    }];
}


/*
 *   createSubViews
 */
- (void)createSubViews{
    if(!totalTBView)
    totalTBView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSCREEWIDTH, KSCREEHEGIHT - 64) style:UITableViewStylePlain];
    totalTBView.separatorStyle = UITableViewCellSeparatorStyleNone;
    totalTBView.backgroundColor = IWColor(234, 235, 236);
    totalTBView.delegate = self;
    totalTBView.dataSource = self;
    totalTBView.rowHeight = 100;
    
    [totalTBView addSubview:self.slimeView];
    
    ProceedsTotalHeader *header = kLOADNIBWITHNAME(@"ProceedsTotalHeader", self);
    header.model = totailModel;
    
    totalTBView.tableHeaderView = header;
    [self.view addSubview:totalTBView];
}


#pragma mark - UITableView delegate and dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IDENTIFIER = @"DriveStatisticsCell";
    ProceedsTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if(!cell){
        cell = kLOADNIBWITHNAME(@"ProceedsTotalCell", self);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
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

#pragma mark - slimeRefresh delegate
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
             isreload = YES;
            [wself totalPeccacyDetail];
            [refreshView endRefresh];
        };
    }
    return _slimeView;
}
@end
