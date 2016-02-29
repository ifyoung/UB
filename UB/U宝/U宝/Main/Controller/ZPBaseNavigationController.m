//
//  ZPBaseNavigationController.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/6/26.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "ZPBaseNavigationController.h"

@interface ZPBaseNavigationController ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIView *topWrongbgView;

@end
@implementation ZPBaseNavigationController


- (void)viewDidLoad{
    [super viewDidLoad];

    //导航条设置
    //清除返回键的title
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
    forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName:[UIFont boldSystemFontOfSize:5.0f],
                                                           NSForegroundColorAttributeName:[UIColor whiteColor]
                                                           } forState:UIControlStateNormal];
    
    //navigationbar弄成透明的而不是带模糊的效果
    //[self.navigationBar setBackgroundImage:[UIImage new]
    //forBarMetrics:UIBarMetricsDefault];
    //self.navigationBar.shadowImage = [UIImage new];
    //self.navigationBar.translucent = YES;
    
    //self.hidesBarsOnSwipe = YES;
    //self.hidesBarsWhenKeyboardAppears = YES;
    //self.hidesBarsOnTap = YES;
    //self.hidesBottomBarWhenPushed = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    self.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.translucent = NO;
    
    if (IOS7_OR_LATER) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:kColor rect:CGSizeMake(KSCREEWIDTH,64)] forBarMetrics:UIBarMetricsDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    else{
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:kColor rect:CGSizeMake(KSCREEWIDTH,64)] forBarMetrics:UIBarMetricsDefault];
    }
    
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{
       NSFontAttributeName:[UIFont boldSystemFontOfSize:22.0f],
       NSForegroundColorAttributeName:[UIColor whiteColor]
    }];

    
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
    id target = self.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *swipe = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    swipe.delegate = self;
    [self.view addGestureRecognizer:swipe];
    self.interactivePopGestureRecognizer.enabled = NO;
#pragma clang diagnostic pop
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
      if (self.childViewControllers.count == 1) {
           return NO;
       }
    
    return YES;
}

@end
