//
//  UIViewController+EXtension.h
//  车圣U宝
//
//  Created by 朱鹏的Mac on 15/10/13.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (EXtension)

/*
 *  弹出UIAlertController
 */
- (void)showAlert:(NSString *)message;
- (void)showAlert:(NSString *)title message:(NSString *)message comfirmblock:(void (^)(void)) comfirmblock;

/*
 *  push
 */
- (void)pushToViewController:(NSString *)vcName;
- (void)pushToViewContr:(NSString *)vcName title:(NSString *)title;


/*!
 *   resignResponder
 *
 *  @param sender
 */
- (void)setUpForDismissKeyboard;

@end
