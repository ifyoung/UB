//
//  ProceedsTotalHeader.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/27.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import "ProceedsTotalHeader.h"
#import "ProceedsTotalVC.h"

@implementation ProceedsTotalHeader

- (void)awakeFromNib{
    [super awakeFromNib];

}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [self drawLine];
}

- (void)setModel:(ProceedsTotalModel *)model{
    _model = model;
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
 
    _money.text = [NSString stringWithFormat:@"%g元",self.model.totalIncome];
    [_money setTextColor:IWColor(74, 75, 75) range:NSMakeRange(_money.text.length - 1, 1)];
    [_money setFont:[UIFont systemFontOfSize:10.0f] range:NSMakeRange(_money.text.length - 1, 1)];
    
    _plate.text = [CurrentDeviceModel shareInstance].plateNo;
    
    
    _time.text = [NSString stringWithFormat:@"%@－%@",[NSDate dateWithOneMonthSinceToday],[NSDate getYesturdayDateString]];
    _time.adjustsFontSizeToFitWidth = YES;
    _time.textColor = IWColor(74, 75, 75);
}


/*
 *   line
 */
- (void)drawLine{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, kColor.CGColor);
    CGContextMoveToPoint(context, 55, 0);
    CGContextAddLineToPoint(context, 55,self.height);
    CGContextStrokePath(context);
    CGContextClosePath(context);
}


@end
