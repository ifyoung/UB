//
//  IndicatorViewController.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/30.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "IndicatorViewController.h"
#import "UBLoginViewController.h"


@interface IndicatorViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *indicator;
@property (nonatomic,strong)OLImageView *Aimv;

@end

@implementation IndicatorViewController

@synthesize Aimv,indicator;

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = IWColor(112, 184, 232);
    
    [self gifAnimation];
}


/**
 *  gif
 *
 */
- (void)gifAnimation{

    OLImage *olimage = (OLImage *)[OLImage imageNamed:@"启动动画2.gif"];
    Aimv  = [[OLImageView alloc] initWithImage:olimage];
    [Aimv setFrame:self.view.bounds];
    Aimv.center = CGPointMake(self.view.center.x, Aimv.center.y);
    [Aimv setUserInteractionEnabled:YES];
    [self.view addSubview:Aimv];
    
    __block ProceedsVC *proceed = [ProceedsVC shareInstance];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(olimage.totalDuration  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
    
            [Aimv removeFromSuperview];
            Aimv = nil;
        
            //1.更新后第一次启动
             NSString *appVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
             NSString *appVersonLongStr = [NSString stringWithFormat:@"%@%@",@"CFBundleShortVersionString_",appVersion];
             if(![[NSUserDefaults standardUserDefaults] objectForKey:appVersonLongStr]){
                 
                 [[NSUserDefaults standardUserDefaults] setObject:appVersion forKey:appVersonLongStr];
                 
                 [self scollViewIndicator];
                return ;
             }
        
        
            //2.第一次登录成功
            if(![[NSUserDefaults standardUserDefaults] objectForKey:KFirtsLogin]){
                [appdelegate loginRootViewController];
                return;
            }
        
        
            //3.自动登录
            if([[NSUserDefaults standardUserDefaults] objectForKey:appVersonLongStr] &&
              [[NSUserDefaults standardUserDefaults] objectForKey:KFirtsLogin]
            ){
               
               proceed.isAutoLogin = YES;
       
              [appdelegate MainrootViewController];
           }
        
        
            //4.第一次进入主界面
            if(![[NSUserDefaults standardUserDefaults] objectForKey:KFirtsLaunchMain]){
                
                [self scollViewIndicator];
                return ;
            }
        
    });
}



/**
 *  引导页
 *
 */
- (void)scollViewIndicator{
    indicator = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    indicator.showsHorizontalScrollIndicator = NO;
    indicator.contentSize = CGSizeMake(KSCREEWIDTH * 3, KSCREEHEGIHT);
    indicator.pagingEnabled = YES;
    indicator.bounces = YES;
    for(int i = 0;i < 3;i++){
        UIImage *imgae = [UIImage imageNamed:[NSString stringWithFormat:@"引导页线条框%d",i + 1]];
        UIImageView *img = [[UIImageView alloc]initWithImage:imgae];
        img.userInteractionEnabled = YES;
        img.frame = CGRectMake(KSCREEWIDTH *  i, 0, KSCREEWIDTH, KSCREEHEGIHT);
        [indicator addSubview:img];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(go2MainVC)];
        [img addGestureRecognizer:tap];
    }
    [self.view addSubview:indicator];
}


/**
 *  登录
 *
 */
- (void)go2MainVC{
    [appdelegate loginRootViewController];
}
@end
