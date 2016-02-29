//
//  CurrentDeviceModel.m
//  车圣U宝
//
//  Created by 朱鹏的Mac on 15/10/16.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import "CurrentDeviceModel.h"

@implementation CurrentDeviceModel

+ (CurrentDeviceModel *)shareInstance{
    static CurrentDeviceModel *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

@end
