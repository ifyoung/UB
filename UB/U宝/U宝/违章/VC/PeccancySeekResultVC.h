//
//  PeccancySeekResultVC.h
//  赛格车圣
//
//  Created by 朱鹏 on 15/6/11.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "ZPBaseController.h"

@interface PeccancySeekResultVC : ZPBaseController

@property(nonatomic,strong)NSArray *frameArray;
@property(nonatomic,strong)PeccancyResultModel *resultModel;

@property (nonatomic,assign)long   vehicleId;
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *vin;
@property (nonatomic,copy)NSString *plateNo;
@property (nonatomic,copy)NSString *engineNo;


@property (nonatomic,assign)AppPushFromType appPushFromType;

@end
