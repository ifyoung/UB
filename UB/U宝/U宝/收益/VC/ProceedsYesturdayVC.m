//
//  ProceedsYesturdayVC.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/21.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "ProceedsYesturdayVC.h"
#import "ProceedsItemView.h"
#import "YesterdayProceedsModel.h"

@interface ProceedsYesturdayVC (){

    YesterdayProceedsModel *model;
}
@end

@implementation ProceedsYesturdayVC
- (BOOL)hidesBottomBarWhenPushed{
    return YES;
}
- (void)loadView{
    [super loadView];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    scrollView.contentSize = CGSizeMake(KSCREEWIDTH,KSCREEHEGIHT - 64 + 1);
    scrollView.showsVerticalScrollIndicator = NO;
    self.view = scrollView;
 }
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"昨日收益";
    [self yesturdayPeccacyDetail];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"昨日收益"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"昨日收益"];
}


/*
 *  1.昨日收益详情
 data =     {
 date = "<null>";
 distanceIncome = 0;
 greenIncome = 1;
 income = 1;
 safeIncome = 0;
 };
 errorCode = 0;
 errorMsg = "<null>";
 */
- (void)yesturdayPeccacyDetail{

    [MBProgressHUD showMessage:KIndicatorStr];
    [Interface yesturdayPeccacyDetail:[CurrentDeviceModel shareInstance].vehicleId block:^(id result) {
        
        NSLog(@"%@",result);
            model = [YesterdayProceedsModel objectWithKeyValues:[result objectForKey:KServerdataStr]];
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showError:KIndicatorError];
            });
        }
    }];
}


/*
 *   createSubViews
 */
- (void)createSubViews{
    
    NSString *income         = [NSString stringWithFormat:@"%g元",model.income];
    NSString *distanceIncome = [NSString stringWithFormat:@"%g元",model.distanceIncome];
    NSString *greenIncome    = [NSString stringWithFormat:@"%g元",model.greenIncome];
    NSString *safeIncome     = [NSString stringWithFormat:@"%g元",model.safeIncome];

    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 20, 20)];
    time.text = [NSString stringWithFormat:@"%@（昨天）",[NSDate getYesturdayDateString]];
    time.textColor = IWColor(89,90,91);
    [time sizeToFit];
    [self.view addSubview:time];

    
    UIImageView *topImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"昨日收益"]];
    topImg.frame = CGRectMake(0, time.bottom + 20, 170 / 2.0, 190 / 2.0);
    topImg.center = CGPointMake(KSCREEWIDTH / 2.0, topImg.center.y);
    [self.view addSubview:topImg];
    
    UILabel *topImgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, topImg.width, 40)];
    topImgLabel.bottom = topImg.height - 10;
    topImgLabel.text =   income;
    topImgLabel.textAlignment = NSTextAlignmentCenter;
    [topImg addSubview:topImgLabel];

    NSArray *items = @[
                       @{@"name":@"里程奖励",   @"money":distanceIncome},
                       @{@"name":@"绿色奖励",   @"money":greenIncome},
                       @{@"name":@"安全驾驶奖励",@"money":safeIncome}
                      ];
    for(int i=0;i < 3;i++){
        CGFloat itemw = 50;
        CGFloat margin = (KSCREEHEGIHT - 64 - topImg.bottom - itemw  * 3) / 4.0;
        ProceedsItemView *itemView = [[ProceedsItemView alloc]initWithFrame:CGRectMake(0, topImg.bottom + (margin + itemw + 1) * i , KSCREEWIDTH, margin + itemw)];
        itemView.proceedsModel = self.proceedsModel;
        itemView.backgroundColor = [UIColor clearColor];
        itemView.leftTitle  = [items[i] objectForKey:@"name"];
        itemView.middleImgName  = [items[i] objectForKey:@"name"];
        itemView.rightTitle = [items[i] objectForKey:@"money"];
        [self.view addSubview:itemView];
    }
}
@end
