//
//  DriveStatisticHeaderView.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/14.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "DriveStatisticHeaderView.h"

@interface DriveStatisticHeaderView ()

@end
@implementation DriveStatisticHeaderView
@synthesize drivelftbgView,drivefrequency,platerNo,time;

- (void)setModel:(CarDriveStatisticsModel *)model{
    _model = model;
    
    [self setNeedsLayout];
}

- (void)setCount:(NSInteger)count{
    _count = count;
    
    [self setNeedsLayout];
}

- (void)subViewSettings{
    
    drivefrequency.text = [NSString stringWithFormat:@"%ld次",(long)_count];
    [drivefrequency setTextColor:kColor008ce8 range:NSMakeRange(0,drivefrequency.text.length - 1)];
    [drivefrequency setTextColor:kColor898989 range:NSMakeRange(drivefrequency.text.length - 1, 1)];
    [drivefrequency setFont:[UIFont systemFontOfSize:22.0f] range:NSMakeRange(0,drivefrequency.text.length - 1)];
    [drivefrequency setFont:[UIFont systemFontOfSize:8.0f] range:NSMakeRange(drivefrequency.text.length - 1, 1)];
    
    platerNo.text = [CurrentDeviceModel shareInstance].plateNo;
    platerNo.textColor = kColor008ce8;
    
    
    time.textColor = kColor898989;
    if(_timeSelect == 0){
        time.text = [NSString stringWithFormat:@"%@（%@）",[NSDate getTodayDateString],@"今天"];
    }
    else if(_timeSelect == 1){
        time.text = [NSString stringWithFormat:@"%@（%@）",[NSDate getYesturdayDateString],@"昨天"];
    }else if(_timeSelect == 2){
        time.text = [NSString stringWithFormat:@"%@（%@）",[NSDate getThedaybeforeYesturday],@"前天"];
    }else if(_timeSelect == 3){
       
            time.text = [NSString stringWithFormat:@"%@－%@（%@）",[[NSDate getnowWeekDateString] firstObject],[[NSDate getnowWeekDateString] lastObject],@"本周"];
        
    }else if(_timeSelect == 4){
        
       time.text = [NSString stringWithFormat:@"%@－%@（%@）",[[NSDate getLastWeekDateString] firstObject],[[NSDate getLastWeekDateString] lastObject],@"上周"];
    }else if(_timeSelect == 5){
     
        
        time.text = [NSString stringWithFormat:@"%@－%@（%@）",[[NSDate getnowMonthDateString] firstObject],[[NSDate getnowMonthDateString] lastObject],@"本月"];
        
    }else if(_timeSelect == 6){
        time.text = [NSString stringWithFormat:@"%@－%@（%@）",[[NSDate getLastMonthDateString] firstObject],[[NSDate getLastMonthDateString] lastObject],@"上月"];
    }
    time.adjustsFontSizeToFitWidth = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self subViewSettings];
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [self drawLine];
}


/*
 *   line
 */
- (void)drawLine{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, kColor.CGColor);
    CGContextMoveToPoint(context, 55, drivelftbgView.bottom);
    CGContextAddLineToPoint(context, 55,self.height);
    CGContextStrokePath(context);
    CGContextClosePath(context);
}
@end
