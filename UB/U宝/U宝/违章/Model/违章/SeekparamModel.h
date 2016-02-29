//
//  SeekparamModel.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/6/17.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeekparamModel : NSObject

+ (SeekparamModel *)shareInstance;

@property (nonatomic,assign)long  vehicleId;

@property(nonatomic,strong)NSString *city;
@property(nonatomic,copy)NSString *cityNickName;

@property(nonatomic,copy)NSString *plateNo;
@property(nonatomic,copy)NSString *engineNo;
@property(nonatomic,copy)NSString *vin;

@end
