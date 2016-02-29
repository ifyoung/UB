//
//  CarViewController.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/6/30.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "ZPBaseController.h"

@interface CarViewController : ZPBaseController

+ (CarViewController *)shareInstance;
@property (nonatomic,assign)BOOL isLoadDataCompete;

@end

@interface LocationButton :UIButton

@end
@interface MenuPopButton :UIButton

@end