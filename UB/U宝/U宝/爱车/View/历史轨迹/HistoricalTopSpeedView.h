//
//  HistoricalTopSpeedView.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/9/14.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoricalTopSpeedView : UIView

@property(nonatomic,copy)NSString *speed;
@property(nonatomic,copy)NSString *date;

+ (HistoricalTopSpeedView *)historicalTopSpeedView;

@end
