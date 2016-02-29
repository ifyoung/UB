//
//  PersonalSettingsVC.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/17.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "ZPBaseController.h"

@interface PersonalSettingsVC : ZPBaseController

+ (PersonalSettingsVC *)shareInstance;
@property(nonatomic,strong)NSMutableArray *newsArr;

@end
