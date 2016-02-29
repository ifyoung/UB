//
//  PeccancyResultIllegalModel.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/6/19.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 address = "\U3010\U5e7f\U4e1c\U6c55\U5c3e\U3011\U6c88\U6d77\U9ad8\U901f2729\U516c\U91cc";
 createTime = "<null>";
 dataSource = JH;
 modifyTime = "<null>";
 reason = "\U9a7e\U9a76\U4e2d\U578b\U4ee5\U4e0a\U8f7d\U5ba2\U8f7d\U8d27\U6c7d\U8f66\U3001\U5371\U9669\U7269\U54c1\U8fd0\U8f93\U8f66\U8f86\U4ee5\U5916\U7684\U5176\U4ed6\U673a\U52a8\U8f66\U884c\U9a76\U8d85\U8fc7\U89c4\U5b9a\U65f6\U901f10%\U672a\U8fbe20%\U7684";
 time = "2015-08-06 15:08:00";
 
 
 illegalId = 76;
 fine = 150;
 code = 1352A;
 status = 0;
 point = 3;
 vehicleId = 76379;
*/

@interface PeccancyRecordModel : NSObject

@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *dataSource;
@property(nonatomic,copy)NSString *modifyTime;
@property(nonatomic,copy)NSString *reason;
@property(nonatomic,copy)NSString *time;

@property(nonatomic,strong)NSNumber *illegalId;
@property(nonatomic,strong)NSNumber *fine;
@property(nonatomic,strong)NSNumber *code;
@property(nonatomic,strong)NSNumber *status;
@property(nonatomic,strong)NSNumber *point;
@property(nonatomic,strong)NSNumber *vehicleId;

@end
