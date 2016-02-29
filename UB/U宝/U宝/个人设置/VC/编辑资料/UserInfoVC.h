//
//  UserInfoVC.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/18.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "ZPBaseController.h"

@class UserInfoVC;
@protocol UserInfoVCDelegate <NSObject>

@optional
/**头像代理方法*/
-(void)userInfoVC:(UserInfoVC *)info changeImage:(UIImage *)image;
/**昵称代理方法*/
-(void)userInfoVC:(UserInfoVC *)info changeName:(NSString *)name;

@end

@interface UserInfoVC : ZPBaseController

@property(nonatomic,weak)id<UserInfoVCDelegate>delegate;

@end
