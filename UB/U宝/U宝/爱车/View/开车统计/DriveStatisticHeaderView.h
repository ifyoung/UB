//
//  DriveStatisticHeaderView.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/14.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InnerShadowView.h"
#import "CarDriveStatisticsModel.h"

@interface DriveStatisticHeaderView : UIView

@property (weak, nonatomic) IBOutlet InnerShadowView *drivelftbgView;

@property (weak, nonatomic) IBOutlet UILabel *drivefrequency;

@property (weak, nonatomic) IBOutlet UILabel *platerNo;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (nonatomic,strong)CarDriveStatisticsModel *model;

@property (nonatomic,assign)NSInteger count;

@property (nonatomic,assign)NSInteger timeSelect;
@end
