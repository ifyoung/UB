//
//  SafeDrivingDetailVC.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/21.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "ZPBaseController.h"

typedef NS_ENUM(NSInteger, SafeDrivingDetailType) {
    SafeDrivingDetailTypeNormoal = 0,
    SafeDrivingDetailTypeGreen,
    SafeDrivingDetailTypeGreenNo,
    SafeDrivingDetailTypeNoTenKM
};

@interface SafeDrivingDetailVC : ZPBaseController

@property(nonatomic,assign)SafeDrivingDetailType safeDrivingType;

@end
