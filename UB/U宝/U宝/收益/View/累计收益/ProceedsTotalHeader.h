//
//  ProceedsTotalHeader.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/27.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProceedsTotalModel.h"

@interface ProceedsTotalHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *plate;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (nonatomic,strong)ProceedsTotalModel *model;

@end
