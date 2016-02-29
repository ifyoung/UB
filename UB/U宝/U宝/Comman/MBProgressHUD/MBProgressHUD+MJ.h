//
//  MBProgressHUD+MJ.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (MJ)
//1.请求进度
+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (void)showError:(NSString *)error delay:(NSTimeInterval)delay;
+ (void)showError:(NSString *)error;
+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;
+ (void)hideHUD:(NSTimeInterval)delay;

//2.提示信息
+ (void)showIndicator:(NSString *)message;
+ (void)showIndicator:(NSString *)message delay:(NSTimeInterval)delay;

@end
