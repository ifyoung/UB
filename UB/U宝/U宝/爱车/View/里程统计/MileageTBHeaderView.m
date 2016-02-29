//
//  MileageTBHeaderView.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/10.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "MileageTBHeaderView.h"
#import "CarMileageViewController.h"

@implementation MileageTBHeaderView
@synthesize mileageView,mileageLabel,mileageTotalTime,oilSum,plateNo,timeduration;

- (void)awakeFromNib{
    [super awakeFromNib];

}
- (void)setModel:(CarmileageOutModel *)model{
    _model = model;
    
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self subViewSettings];
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [self drawLine];
}




- (void)subViewSettings{
    mileageLabel.text = [NSString stringWithFormat:@"%gkm",_model.totalDistance];
    mileageTotalTime.text = [NSString stringWithFormat:@"%@",_model.totalDriverTime];
    oilSum.text = [NSString stringWithFormat:@"%gL",_model.totalOil];
    [mileageLabel setTextColor:kColor range:NSMakeRange(0,mileageLabel.text.length - 2)];
    [mileageLabel setTextColor:[UIColor grayColor] range:NSMakeRange(mileageLabel.text.length - 2, 2)];
    [mileageLabel setFont:[UIFont systemFontOfSize:11.0f] range:NSMakeRange(0,mileageLabel.text.length - 2)];
    [mileageLabel setFont:[UIFont systemFontOfSize:9.0f] range:NSMakeRange(mileageLabel.text.length - 2, 2)];
    mileageLabel.adjustsFontSizeToFitWidth = YES;
    oilSum.textColor = IWColor(38, 188, 29);
    oilSum.adjustsFontSizeToFitWidth = YES;
    mileageTotalTime.textColor = IWColor(229, 152, 0);
    mileageTotalTime.adjustsFontSizeToFitWidth = YES;
    
    
    
    plateNo.text = [CurrentDeviceModel shareInstance].plateNo;
    plateNo.textColor = kColor;
    timeduration.adjustsFontSizeToFitWidth = YES;
    
    if(_timeSelect == 0){
       timeduration.text = [NSString stringWithFormat:@"%@（%@）",[NSDate getTodayDateString],@"今天"];
    }
    else if(_timeSelect == 1){
        timeduration.text = [NSString stringWithFormat:@"%@（%@）",[NSDate getYesturdayDateString],@"昨天"];
    }else if(_timeSelect == 2){
        timeduration.text = [NSString stringWithFormat:@"%@（%@）",[NSDate getThedaybeforeYesturday],@"前天"];
    }else if(_timeSelect == 3){
        
            timeduration.text = [NSString stringWithFormat:@"%@－%@（%@）",[[NSDate getnowWeekDateString] firstObject],[[NSDate getnowWeekDateString] lastObject],@"本周"];
        
    }else if(_timeSelect == 4){
        timeduration.text = [NSString stringWithFormat:@"%@－%@（%@）",[[NSDate getLastWeekDateString] firstObject],[[NSDate getLastWeekDateString] lastObject],@"上周"];
    }else if(_timeSelect == 5){
    
        timeduration.text = [NSString stringWithFormat:@"%@－%@（%@）",[[NSDate getnowMonthDateString] firstObject],[[NSDate getnowMonthDateString] lastObject],@"本月"];
        
    }else if(_timeSelect == 6){
        timeduration.text = [NSString stringWithFormat:@"%@－%@（%@）",[[NSDate getLastMonthDateString] firstObject],[[NSDate getLastMonthDateString] lastObject],@"上月"];
    }
}
/*
 *   line
 */
- (void)drawLine{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, kColor.CGColor);
    CGContextMoveToPoint(context, 55, mileageView.bottom);
    CGContextAddLineToPoint(context, 55,self.height);
    CGContextStrokePath(context);
    CGContextClosePath(context);
}
@end
