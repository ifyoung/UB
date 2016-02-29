//
//  PeccancyResultModel.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/6/17.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PeccancyResultModel : NSObject
/*
 data =     {
         count = 1;
         details =    ();
         totalFine = 150;
         totalPoint = 3;
         vehicleId = 76379;
 };
 errorCode = 0;
 errorMsg = "<null>";

 */

@property(nonatomic,strong)NSNumber *count;
@property(nonatomic,strong)NSNumber *totalFine;
@property(nonatomic,strong)NSNumber *totalPoint;
@property(nonatomic,strong)NSNumber *vehicleId;

@property(nonatomic,strong)NSArray *details;

@end
