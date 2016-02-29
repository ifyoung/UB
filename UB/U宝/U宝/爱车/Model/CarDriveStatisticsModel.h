//
//  CarDriveStatisticsModel.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/9/29.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 date = "2015-10-12";
 distance = "17.36";
 driveEnd = "2015-10-12 08:25:23";
 driveStart = "2015-10-12 07:08:41";
 driverTime = "01:16:42";
 oil = "2.7";
*/
@interface CarDriveStatisticsModel : NSObject

@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *distance;
@property(nonatomic,copy)NSString *driveEnd;
@property(nonatomic,copy)NSString *driveStart;
@property(nonatomic,copy)NSString *driverTime;
@property(nonatomic,copy)NSString *oil;


@end
