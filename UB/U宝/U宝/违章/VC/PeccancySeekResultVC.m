//
//  PeccancySeekResultVC.m
//  赛格车圣
//
//  Created by 朱鹏 on 15/6/11.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "PeccancySeekResultVC.h"
#import "PeccancyResultCell.h"
#import "UBRegisterViewController.h"

@interface PeccancySeekResultVC (){
    UIView *tableHeaderView;
    UITableView *table;
    UILabel *tellLabel;
}

@end

@implementation PeccancySeekResultVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.hidesBottomBarWhenPushed  = YES;
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"查询结果";
    self.view.backgroundColor = IWColor(233, 233, 233);
    
    AppDelegate *deleagte = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(self.appPushFromType == AppPushFromTypeRemoteNotificationPeccancyResult){
    
        [self loadRecodListFromInputParams];

         deleagte.appPushFromType = AppPushFromTypeNormal;
    }else{
        [self createTBView];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"违章查询_违章结果列表"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"违章查询_违章结果列表"];
}

/**
 *   查询数据
 *
 *  @return
 */
- (void)loadRecodListFromInputParams{
    [MBProgressHUD showMessage:KIndicatorStr];
    __weak PeccancySeekResultVC *this = self;
    [Interface UBIIlegalQueryWithCity:self.city vehicleId:self.vehicleId plateNo:self.plateNo vin:self.vin engineNo:self.engineNo block:^(id result) {
        
          NSLog(@"%@",result);
          NSDictionary *resdic = (NSDictionary *)result;
          if(resdic &&  ![resdic isKindOfClass:[NSNull class]]  && ![[resdic objectForKey:KServerdataStr] isKindOfClass:[NSNull class]]){
              //如果有记录信息
              NSDictionary *datas = [resdic objectForKey:KServerdataStr];
              NSMutableArray *dataArray = [NSMutableArray array];
              PeccancyResultModel *resmodel = [PeccancyResultModel objectWithKeyValues:datas];
              NSMutableArray *recModelArray = [NSMutableArray array];
              for(NSDictionary *dic  in resmodel.details){
                  PeccancyResultFrame *frame = [[PeccancyResultFrame alloc]init];
                  PeccancyRecordModel *recModel = [PeccancyRecordModel objectWithKeyValues:dic];
                  CGFloat locaitonHeight = [recModel.address   sizeWithFont:[UIFont systemFontOfSize:14.0f] maxSize:CGSizeMake(KSCREEWIDTH - 20 - 45 - 10 , MAXFLOAT)].height  + 1;
                  CGFloat reseaonsHeight = [recModel.reason   sizeWithFont:[UIFont systemFontOfSize:14.0f] maxSize:CGSizeMake(KSCREEWIDTH - 20 - 45 - 10 , MAXFLOAT)].height + 1;
                  frame.locationHeight = locaitonHeight;
                  frame.resonHeight    = reseaonsHeight;
                  frame.height = locaitonHeight + reseaonsHeight + 100 - 6;
                  frame.model = recModel;
                  [dataArray addObject:frame];
                  [recModelArray addObject:recModel];
              }
              this.frameArray = dataArray;
              resmodel.details = [recModelArray copy];
              this.resultModel =  resmodel;
              dispatch_async(dispatch_get_main_queue(), ^{
                  [MBProgressHUD hideHUD];
                  [self createTBView];
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
 *   UITableView
 */
- (void)createTBView{
    if(_frameArray.count == 0){
        NSArray *imgs = @[@"没有违章",@"交警形象"];
        for(int i =0;i  < 2;i++){
            UIImage *img = [UIImage imageNamed:[imgs objectAtIndex:i]];
            CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
            UIImageView *image = [[UIImageView alloc]initWithFrame:rect];
            image.center = CGPointMake(0, (KSCREEHEGIHT - 64) / 2.0);
            if(i == 0)
                image.right = KSCREEWIDTH / 2.0;
            if(i == 1)
                image.left = KSCREEWIDTH / 2.0 + 20;
            image.image = img;
            [self.view addSubview:image];
        }
    }else{
        if(_resultModel.details.count == 0) return;
        if(!table)
        table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSCREEWIDTH, KSCREEHEGIHT - 64) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:table];
        table.tableHeaderView = [self headerViewForTableView];
        table.tableFooterView = [self footerViewForTableView];
    }
}

/*
 *   UITableViewHeaderView
 */
- (UIView *)headerViewForTableView{
    UIView  *tableHeaderView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEWIDTH, 80)];
    UILabel *topLabel =  [[UILabel alloc]initWithFrame:CGRectMake(0, 10, KSCREEWIDTH, 40)];
  
    NSString *plateNo =  [NSString stringWithFormat:@"%@%@",[SeekparamModel shareInstance].cityNickName,[SeekparamModel shareInstance].plateNo];
    
    topLabel.text = [NSString stringWithFormat:@"%@ %@",[plateNo substringToIndex:2],[plateNo substringFromIndex:2]];
   
    topLabel.textColor = kColor;
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [tableHeaderView1 addSubview:topLabel];
    
    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, topLabel.bottom , KSCREEWIDTH, 20)];
    bottomLabel.font = [UIFont systemFontOfSize:11.0f];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.textColor = [UIColor grayColor];
    bottomLabel.text = [NSString stringWithFormat:@"(您还有%@次违章未处理，罚%@元，扣%@分)",_resultModel.count,_resultModel.totalFine,_resultModel.totalPoint];
    
    NSString *weiCount = [NSString stringWithFormat:@"%@",_resultModel.count];
    [bottomLabel setFont:[UIFont systemFontOfSize:17.0f] afterOccurenceOfString:@"您还有" count:weiCount.length];
    [bottomLabel setTextColor:IWColor(237, 75, 77) afterOccurenceOfString:@"您还有" count:weiCount.length];
    
    NSString *totalfines = [NSString stringWithFormat:@"%@",_resultModel.totalFine];
    [bottomLabel setFont:[UIFont systemFontOfSize:17.0f] afterOccurenceOfString:@"为处理，罚" count:totalfines.length];
    [bottomLabel setTextColor:IWColor(237, 75, 77) afterOccurenceOfString:@"为处理，罚" count:totalfines.length];
    
    NSString *totalpoints = [NSString stringWithFormat:@"%@",_resultModel.totalPoint];
    [bottomLabel setFont:[UIFont systemFontOfSize:17.0f] afterOccurenceOfString:@"，扣" count:totalpoints.length];
    [bottomLabel setTextColor:IWColor(237, 75, 77) afterOccurenceOfString:@"，扣" count:totalpoints.length];
    
    [tableHeaderView1 addSubview:bottomLabel];
    return tableHeaderView1;
}

/*
 *   UITableViewHeaderView
 */
- (UIView *)footerViewForTableView{
    NSArray *titles = @[@"温馨提示：",@"如需要处理请拨打我们的客服热线"];
    UIView *bgView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEWIDTH, 70)];
    for(int i = 0;i < 2;i++){
        CGRect rect =  CGRectMake(10, 10 + 25 * i, KSCREEWIDTH - 20, 20);
        UILabel *label = [[UILabel alloc]initWithFrame:rect];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.text = [titles objectAtIndex:i];
        [label sizeToFit];
        if(i == 1) tellLabel = label;
        [bgView addSubview:label];
    }
    UIImageView *kefu = [[UIImageView alloc]initWithFrame:CGRectMake(tellLabel.right+ 3, tellLabel.top, 50 / 2.0, 42 / 2.0)];
    kefu.tintColor = kColor;
    kefu.center = CGPointMake(kefu.center.x, tellLabel.center.y);
    kefu.image = [UIImage imageNamed:@"客服logo"];
    [bgView addSubview:kefu];
    
    bottomlineButton *bottomline = [bottomlineButton buttonWithType:UIButtonTypeCustom];
    bottomline.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    bottomline.showsTouchWhenHighlighted = YES;
    bottomline.frame = CGRectMake(kefu.right, tellLabel.top, 50, tellLabel.height);
    [bottomline setTitleColor:kColor  forState:UIControlStateNormal];
    [bottomline addTarget:self action:@selector(tellAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomline setTitle:@"952100" forState:UIControlStateNormal];
    [bgView addSubview:bottomline];
    return bgView;
}

/*
 *   打客服电话办理违章
 */
- (void)tellAction{
    [self showAlert:@"温馨提示" message:@"拨打客服电话:952100" comfirmblock:^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", @"952100"]];
        [[UIApplication sharedApplication] openURL:url];
    }];
}

#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return   _resultModel.details.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
 }
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(nonnull UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (PeccancyResultCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"PeccancyResultCell";
    PeccancyResultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
       cell = kLOADNIBWITHNAME(@"PeccancyResultCell", self);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    PeccancyResultFrame *frame = _frameArray[indexPath.section];
    cell.locaitonHeight = frame.locationHeight;
    cell.resonHeight = frame.resonHeight;
    cell.indexPath = indexPath;
    cell.model = _resultModel.details[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PeccancyResultFrame *frame = _frameArray[indexPath.section];
    return frame.height;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
#ifdef __IPHONE_8_0
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
#endif
}
@end
