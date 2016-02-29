//
//  CarmileageModel.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/9/29.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 date = "2015-10-10";
 distance = "46.28";
 driverTime = "02:20:46";
 oil = "4.8";
 */
@interface CarmileageModel : NSObject

@property(nonatomic,copy)NSString *date;
@property(nonatomic,assign)double distance;
@property(nonatomic,copy)NSString *driverTime;
@property(nonatomic,assign)double oil;

@end
