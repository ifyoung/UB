//
//  PeccancyResultFrame.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/6/23.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PeccancyRecordModel.h"


@interface PeccancyResultFrame : NSObject

@property(nonatomic,assign)float locationHeight;

@property(nonatomic,assign)float resonHeight;

@property(nonatomic,assign)float height;


@property(nonatomic,strong)PeccancyRecordModel *model;


@end
