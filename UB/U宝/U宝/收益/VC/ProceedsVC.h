//
//  ProceedsVC.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/17.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPBaseController.h"

@interface ProceedsVC : ZPBaseController

+ (ProceedsVC *)shareInstance;
@property (nonatomic,assign)BOOL isLoadDataCompete;
@property (nonatomic,assign)BOOL isLoadWeatherModel;
@property (nonatomic,assign)BOOL isLoadProNewsModel;

@property (nonatomic,assign)BOOL isAutoLogin;


- (void)loadAllData;

@end
