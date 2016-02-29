//
//  DriveStatisticsCell.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/14.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarDriveStatisticsModel.h"

@interface DriveStatisticsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *frequcy;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *origin;

@property (weak, nonatomic) IBOutlet UILabel *destination;

@property (weak, nonatomic) IBOutlet UILabel *duration;

@property (weak, nonatomic) IBOutlet UIImageView *originImg;

@property (weak, nonatomic) IBOutlet UIImageView *destinationImg;

@property (weak, nonatomic) IBOutlet UIImageView *durationImg;

@property (nonatomic,strong)CarDriveStatisticsModel *model;

@property (nonatomic,strong)NSIndexPath *indexPath;

@end
