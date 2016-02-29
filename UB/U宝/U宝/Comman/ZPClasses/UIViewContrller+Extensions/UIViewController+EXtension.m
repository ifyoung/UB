//
//  UIViewController+EXtension.m
//  车圣U宝
//
//  Created by 朱鹏的Mac on 15/10/13.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import "UIViewController+EXtension.h"

@implementation UIViewController (EXtension)

/*
 *  弹出UIAlertController
 */
#ifdef __IPHONE_8_0
- (void)showAlert:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:NULL];
}
- (void)showAlert:(NSString *)title message:(NSString *)message comfirmblock:(void (^)(void)) comfirmblock{
   
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if(comfirmblock)
            comfirmblock();
    }];
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:NULL];
}
#endif

/*
 *  push
 */
- (void)pushToViewController:(NSString *)vcName{
    id myObj = [[NSClassFromString(vcName) alloc] init];
    [self.navigationController pushViewController:myObj animated:YES];
}
- (void)pushToViewContr:(NSString *)vcName title:(NSString *)title{
    UIViewController *myObj = [[NSClassFromString(vcName) alloc] init];
    myObj.title = title;
    [self.navigationController pushViewController:myObj animated:YES];
}


/*!
 *   resignResponder
 *
 *  @param sender
 */
- (void)setUpForDismissKeyboard {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard)];
    
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    
    [notificationCenter addObserverForName:UIKeyboardWillShowNotification
                                    object:nil
                                     queue:mainQuene
                                usingBlock:^(NSNotification *note){
                                    
                                    [self.view addGestureRecognizer:singleTapGR];
                                }];
    
    [notificationCenter addObserverForName:UIKeyboardWillHideNotification
                                    object:nil
                                     queue:mainQuene
                                usingBlock:^(NSNotification *note){
                                    
                                    [self.view removeGestureRecognizer:singleTapGR];
                                }];
}
- (void)tapAnywhereToDismissKeyboard {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}
@end
