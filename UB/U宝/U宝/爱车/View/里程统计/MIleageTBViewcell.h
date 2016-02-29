//
//  MIleageTBViewcell.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/10.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarmileageModel.h"

@interface MIleageTBViewcell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *date;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *mileage;

@property (weak, nonatomic) IBOutlet UILabel *timeline;

@property (weak, nonatomic) IBOutlet UILabel *totaltime;

@property (nonatomic,strong)CarmileageModel *model;

@property (nonatomic,strong)NSIndexPath *indexPath;

@end
