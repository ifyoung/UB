//
//  MileageTBHeaderView.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/10.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InnerShadowView.h"
#import "CarmileageOutModel.h"

@interface MileageTBHeaderView : UIView

@property (weak, nonatomic) IBOutlet InnerShadowView *mileageView;

@property (weak, nonatomic) IBOutlet UILabel *mileageLabel;

@property (weak, nonatomic) IBOutlet UILabel *mileageTotalTime;

@property (weak, nonatomic) IBOutlet UILabel *plateNo;

@property (weak, nonatomic) IBOutlet UILabel *timeduration;

@property (weak, nonatomic) IBOutlet UILabel *oilSum;

@property (nonatomic,strong)CarmileageOutModel *model;

@property (nonatomic,assign)NSInteger timeSelect;

@end
