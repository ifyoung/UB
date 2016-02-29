//
//  PeccancyListCell.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/18.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "XTRootCustomCell.h"
#import "BindingCarListModel.h"

@interface PeccancyListCell : XTRootCustomCell

@property (weak, nonatomic) IBOutlet UIImageView *carImg;
@property (weak, nonatomic) IBOutlet UILabel *carplate;

@property (weak, nonatomic) IBOutlet UILabel *chaxun;

@property (nonatomic,strong)NSIndexPath *indexP;
@property (assign,nonatomic)BindingCarListModel *model;

@end
