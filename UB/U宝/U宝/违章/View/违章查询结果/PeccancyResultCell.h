//
//  PeccancyResultCell.h
//  赛格车圣
//
//  Created by 朱鹏 on 15/6/11.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeccancyResultCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *kou;

@property (weak, nonatomic) IBOutlet UILabel *fa;

@property (weak, nonatomic) IBOutlet UILabel *koufen;

@property (weak, nonatomic) IBOutlet UILabel *faqian;

@property (weak, nonatomic) IBOutlet UILabel *isHandle;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *location;

@property (weak, nonatomic) IBOutlet UILabel *reason;

@property (weak, nonatomic) IBOutlet UIImageView *timeImg;

@property (weak, nonatomic) IBOutlet UIImageView *locationImg;

@property (weak, nonatomic) IBOutlet UIImageView *resonImg;

@property (weak, nonatomic) IBOutlet UIImageView *isStamp;

@property (nonatomic,strong)PeccancyRecordModel *model;


@property (nonatomic,assign)float locaitonHeight;
@property (nonatomic,assign)float resonHeight;
@property (nonatomic,strong)NSIndexPath *indexPath;



@end
