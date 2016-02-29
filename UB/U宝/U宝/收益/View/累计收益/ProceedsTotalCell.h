//
//  ProceedsTotalCell.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/27.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrpceedsTotailDetailModel.h"

@interface ProceedsTotalCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *time;


@property (weak, nonatomic) IBOutlet UILabel *totalMoney;


@property (weak, nonatomic) IBOutlet UILabel *mileL;
@property (weak, nonatomic) IBOutlet UILabel *mileM;


@property (weak, nonatomic) IBOutlet UILabel *greenL;
@property (weak, nonatomic) IBOutlet UILabel *greenM;


@property (weak, nonatomic) IBOutlet UILabel *safeL;
@property (weak, nonatomic) IBOutlet UILabel *safeM;

@property (nonatomic,strong)PrpceedsTotailDetailModel *model;

@end
