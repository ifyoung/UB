//
//  UserInfoModel.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/1.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
data =     {
    days = 0;
    imgUrl = "<null>";
    lastLogin = 1443492587000;
    nickname = "<null>";
};
errorCode = 0;
errorMsg = "<null>";
*/

@interface UserInfoModel : NSObject

@property (nonatomic,strong)NSNumber  *days;
@property (nonatomic,copy)  NSString  *imgUrl;
@property (nonatomic,strong)NSNumber  *lastLogin;
@property (nonatomic,copy)  NSString  *nickname;

@end
