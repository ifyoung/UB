//
//  SafeDrivingDetailVC.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/21.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "SafeDrivingDetailVC.h"
#import "SafeDviveHeader.h"
#import "SafeDriveItem.h"
#import "SafeBottomWave.h"
#import "SafeDriveDetailModel.h"


@interface SafeDrivingDetailVC (){
 
    UIScrollView *scrollView;
    UILabel *conmentLabel;

    SafeDriveDetailModel *model;
}
@property (nonatomic, getter=isRunning) BOOL running;

@end

@implementation SafeDrivingDetailVC
- (BOOL)hidesBottomBarWhenPushed{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  IWColor(238, 238, 238);
    
    if(self.safeDrivingType != SafeDrivingDetailTypeNormoal){
       [self createNoDataGifView];
    }else{
       [self securityDriveDetailData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"安全驾驶明细"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"安全驾驶明细"];
}

/*
 *   createSubViews
 */
- (void)createSubViews{
    [self createbgscrollview];
    [self createHearderView];
    [self createDriveDetail];
    [self createSummary];
    [self createBottomWave];
}
- (void)createbgscrollview{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KSCREEWIDTH, KSCREEHEGIHT - 64)];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
}


/*
 *    securityDriveDetail
 */
- (void)securityDriveDetailData{

    __weak typeof(self) this = self;
   [MBProgressHUD showMessage:KIndicatorStr];
   [Interface securityDriveDetail:[CurrentDeviceModel shareInstance].vehicleId block:^(id result) {
    
       NSLog(@"%@",result);
       if([result objectForKey:KServerdataStr] == nil || [[result objectForKey:KServerdataStr] isKindOfClass:[NSNull class]]){
           //model = [[SafeDriveDetailModel alloc]init];
           //for(NSString *key in [[model properties] allKeys]){
               //[model setValue:@0 forKey:key];
           //}
       }else{
           model = [SafeDriveDetailModel objectWithKeyValues:[result objectForKey:KServerdataStr]];
       }
           dispatch_async(dispatch_get_main_queue(), ^{
               [MBProgressHUD hideHUD];
               [this createSubViews];
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
 *   头部驾驶得分
 */
- (void)createHearderView{
    [scrollView addSubview:({
        SafeDviveHeader *header =  [[SafeDviveHeader alloc]init];
        header.backgroundColor =   IWColor(227, 243, 254);
        header.model = model;
        header;
    })];
}


/*
 *   驾驶明细
 */
- (void)createDriveDetail{
    NSArray *titles = @[@"急加速",@"急刹车",@"疲劳驾驶",@"怠速时长",@"平均速度",@"夜间行驶"];
    NSArray *units  = @[@"次",@"次",@"h",@"%",@"km/h",@"h"];
    NSArray *nubers = @[model.speedUp,model.speedDown,model.fatigueTime,model.speedLowTime,model.speedSVG,model.nightTime];
    NSArray *svgs    = @[model.speedUpSVG,model.speedDownSVG];
    for(int i=0;i < 6;i++){
        float imgWidth = (KSCREEWIDTH - 2)  / 3.0;
        float imgX = (imgWidth + 1 ) * (i % 3);
        float imgY = (imgWidth + 1) * (i / 3);
        CGRect rect = CGRectMake(imgX,120 + imgY, imgWidth, imgWidth);
        SafeDriveItem *item = [[SafeDriveItem alloc]initWithFrame:rect];
        if(i > 1){
            item.hidemiddle = YES;
        }else{
            item.speedUpOrDownSVG = [NSString stringWithFormat:@"%@",[svgs objectAtIndex:i]];
        }
        item.number =  [NSString stringWithFormat:@"%@",[nubers objectAtIndex:i]];
        item.unit   =  [NSString stringWithFormat:@"%@",[units objectAtIndex:i]];
        item.title  =  [NSString stringWithFormat:@"%@",[titles objectAtIndex:i]];
        item.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:item];
    }
}

/*
 *   绿色出行提示
 */
- (void)createNoDataGifView{

    NSString *title;
    NSString *imgName;
    if(_safeDrivingType == SafeDrivingDetailTypeGreen){
        title = @"昨日未开车，\n感谢您为环保做出了一份贡献～";
        imgName = @"绿色出行未开车";
    }else if (_safeDrivingType == SafeDrivingDetailTypeGreenNo){
        title = @"昨日开车了，\n所以没有绿色奖励～";
        imgName = @"绿色出行开车了";
    }else if(_safeDrivingType == SafeDrivingDetailTypeNoTenKM){
        title = @"单次行程超过10公里及10分钟\n才能参与驾驶评分～";
        imgName = @"十公里上评分";
    }
    if(_safeDrivingType == SafeDrivingDetailTypeNormoal)
        return;
    UILabel *top = [[UILabel alloc]initWithFrame:CGRectZero];
    top.frame = CGRectMake(0, 20,KSCREEWIDTH, 80);
    top.textAlignment = NSTextAlignmentCenter;
    top.textColor = IWColor(93, 93, 93);
    top.text = title;
    top.numberOfLines = 2;
    [self.view addSubview:top];
    
    
    OLImageView *Aimv  = [[OLImageView alloc] initWithImage:[OLImage imageNamed:imgName]];
    [Aimv setFrame:CGRectMake(0, top.bottom + 20, 150, 150)];
    Aimv.center = CGPointMake(self.view.center.x, Aimv.center.y);
    [Aimv setUserInteractionEnabled:YES];
    [self.view addSubview:Aimv];
}



//- (void)handleTap:(UITapGestureRecognizer *)gestRecon
//{
//    OLImageView *imageView = (OLImageView *)gestRecon.view;
//    if (self.isRunning) {
//        self.running = NO;
//        NSLog(@"STOP");
//        [imageView stopAnimating];
//    } else {
//        self.running = YES;
//        NSLog(@"START");
//        [imageView startAnimating];
//    }
//}



/*
 *   综合测评
 */
- (void)createSummary{
    CGFloat bottY = 120 + (KSCREEWIDTH / 3.0) * 2 ;
    for(int i =0;i < 2;i++){
       CGRect rect =  CGRectMake(20,bottY + 10 + (20 + 5) * i, KSCREEWIDTH - 40, 20);
       UILabel *label = [[UILabel alloc]initWithFrame:rect];
       label.textColor = kColor;
        label.font = [UIFont systemFontOfSize:15.0f];
       label.text = @"综合测评";
       if(i == 1)
       conmentLabel  = label;
       [scrollView addSubview:label];
    }
    conmentLabel.numberOfLines = 0;
    conmentLabel.textColor = IWColor(74, 75, 75);
    conmentLabel.font = [UIFont systemFontOfSize:15.0f];
    if([model.score floatValue] > 90){
         conmentLabel.text = @"您今日的驾驶行为评分优秀，请继续保持，记得要平稳驾驶哦~";
    }else if([model.score floatValue] >= 80){
         conmentLabel.text = @"您今日的驾驶行为评分良好，再接再厉，争取成为一名更加优秀的驾驶员吧。";
    }else if ([model.score floatValue] >= 60){
         conmentLabel.text = @"您今日的驾驶行为评分欠佳，为了您和家人的安全，请避免有安全隐患的驾驶行为。";
    }else if ([model.score floatValue] > 0){ 
         conmentLabel.text = @"您好，我们初步判定您为“路怒症”患者，世界如此美妙，您却如此烦躁，不好不好，建议您休息一下，平复心情，继续您的开心驾驶之旅吧~";
    }else{
         conmentLabel.text = @"您好，您昨天没有开车~";
    }
    conmentLabel.text = [NSString stringWithFormat:@"%@\n%@",conmentLabel.text,@"车圣U宝始终为您提供专业、准确的数据，为您保驾护航!"];
    CGSize size =  [conmentLabel.text sizeWithFont:[UIFont systemFontOfSize:15.0f] maxSize:CGSizeMake(KSCREEWIDTH - 40, KSCREEHEGIHT)];
    conmentLabel.height = size.height;
    //conmentLabel.backgroundColor = [UIColor redColor];
}


/*
 *   底部波浪
 */
- (void)createBottomWave{
    SafeBottomWave * wave = [[SafeBottomWave alloc]init];
    wave.frame = CGRectMake(0, KSCREEHEGIHT - 64 - 30, KSCREEWIDTH, 30);
    wave.backgroundColor = [UIColor clearColor];
    [self.view addSubview:wave];
    if((KSCREEHEGIHT - 64 - 30) < (conmentLabel.bottom)){
        scrollView.contentSize = CGSizeMake(KSCREEWIDTH, conmentLabel.bottom + 30);
    }else{
        scrollView.contentSize = CGSizeMake(KSCREEWIDTH, KSCREEHEGIHT - 64 - 40 + 1);
    }
}
@end
