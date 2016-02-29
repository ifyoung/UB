//
//  CarMileageViewController.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/3.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "ZPBaseController.h"
#import "ProceedsModel.h"

@interface CarMileageViewController : ZPBaseController

@property (nonatomic,copy)NSString *startDate;
@property (nonatomic,copy)NSString *endDate;
@property (nonatomic,assign)BOOL isYesturday;


@property (nonatomic,strong)ProceedsModel *proceedsModel;

@end
