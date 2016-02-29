//
//  CargpsBaseInfoModel.h
//  车圣U宝
//
//  Created by 朱鹏的Mac on 15/11/5.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CargpsBaseInfoModel : NSObject


@property (nonatomic, assign) BOOL loc;
@property (nonatomic, assign) long long gpsTime;
@property (nonatomic, assign) int lat;
@property (nonatomic, assign) int lng;
@property (nonatomic, assign) int speed;
@property (nonatomic, assign) int course;
@property (nonatomic, strong) NSMutableArray *status;


@end
