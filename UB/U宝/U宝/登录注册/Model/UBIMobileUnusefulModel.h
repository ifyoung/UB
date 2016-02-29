//
//  UBIMobileUnusefulModel.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/9/17.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UBIMobileUnusefulModel : NSObject
+ (UBIMobileUnusefulModel *)shareInstance;

@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *cityNickName;
@property(nonatomic,copy)NSString *plateNo;
@property(nonatomic,copy)NSString *engineNo;
@property(nonatomic,copy)NSString *vin;


@end
