//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+MJ.h"

@implementation MBProgressHUD (MJ)

#pragma mark 显示一些信息 不带图片
+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    
     AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
     if (view == nil)
         view = delegate.window;
    
     [delegate.hud removeFromSuperview];
    
     delegate.hud = nil;
    
     delegate.hud = [MBProgressHUD showHUDAddedTo:view animated:YES];

     delegate.hud.removeFromSuperViewOnHide = YES;
    
     delegate.hud.dimBackground = YES;

     delegate.hud.labelText = message;
    
     return  delegate.hud;
}
+ (void)showError:(NSString *)error
{
     [self show:error delay:1.0];
}
+ (void)showError:(NSString *)error delay:(NSTimeInterval)delay{
    [self show:error delay:delay];
}
+ (void)show:(NSString *)text delay:(NSTimeInterval)delay
{
     AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
     delegate.hud.labelText = text;
    
     delegate.hud.mode = MBProgressHUDModeCustomView;
    
     [delegate.hud hide:YES afterDelay:delay];
}
#pragma mark 隐藏
+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}
+ (void)hideHUD
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.hud hide:YES afterDelay:1.0];
}
+ (void)hideHUD:(NSTimeInterval)delay{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.hud hide:YES afterDelay:delay];
}









#pragma mark 显示提示信息
+ (void)showIndicator:(NSString *)message
{
    //UIView  *view = [[UIApplication sharedApplication].windows lastObject];

    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [delegate.hud removeFromSuperview];
    
    delegate.hud = nil;
    
    delegate.hud = [MBProgressHUD showHUDAddedTo:delegate.window animated:YES];
    
    delegate.hud.labelText = message;
    
    delegate.hud.removeFromSuperViewOnHide = YES;

    delegate.hud.mode = MBProgressHUDModeCustomView;
    
    [delegate.hud hide:YES afterDelay:0.7];
}
+ (void)showIndicator:(NSString *)message delay:(NSTimeInterval)delay
{
    //UIView  *view = [[UIApplication sharedApplication].windows lastObject];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [delegate.hud removeFromSuperview];
    
    delegate.hud = nil;
    
    delegate.hud = [MBProgressHUD showHUDAddedTo:delegate.window animated:YES];
    
    delegate.hud.labelText = message;
    
    delegate.hud.removeFromSuperViewOnHide = YES;
    
    delegate.hud.mode = MBProgressHUDModeCustomView;
    
    [delegate.hud hide:YES afterDelay:delay];
}
@end
