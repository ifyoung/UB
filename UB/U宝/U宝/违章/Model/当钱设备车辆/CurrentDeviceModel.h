//
//  CurrentDeviceModel.h
//  车圣U宝
//
//  Created by 朱鹏的Mac on 15/10/16.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentDeviceModel : NSObject

+ (CurrentDeviceModel *)shareInstance;
@property (nonatomic,assign)long  vehicleId;
@property (nonatomic,copy)  NSString *brand;        //车辆品牌
@property (nonatomic,copy)  NSString *model;        //车型
@property (nonatomic,copy) NSString *callLetter;   //设备卡 判断是否是设备车辆
@property (nonatomic,copy) NSString *engineNo;
@property (nonatomic,copy) NSString *plateNo;
@property (nonatomic,copy) NSString *vin;
@property (nonatomic,copy) NSString *imei;
@property (nonatomic,copy) NSString *hasUnit;

@end
