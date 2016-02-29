//
//  CarInfoModel.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/3.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarAnnotationModel : NSObject

/**
 *  车牌
 */
@property (nonatomic, copy) NSString *plateNo;
/**
 *  汽车图片
 */
@property (nonatomic, copy) NSString *icon;
/**
 *  汽车方向
 */
@property (nonatomic,assign)int direction;
/**
 *  汽车速度
 */
@property (nonatomic,copy) NSString *speed;
/**
 *  时间
 */
@property (nonatomic,copy)NSString *gpstime;
/**
 *  汽车状态
 */
@property (nonatomic,strong) NSArray *carStatus;
/**
 *  位置
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


@end
