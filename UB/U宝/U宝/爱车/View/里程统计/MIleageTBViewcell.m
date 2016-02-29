//
//  MIleageTBViewcell.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/10.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "MIleageTBViewcell.h"
#import "CarMileageViewController.h"

@implementation MIleageTBViewcell
@synthesize date,bgView,mileage,timeline,totaltime;

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)setModel:(CarmileageModel *)model{
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
    
    [self drawImage];
    
    [self drawTriangleView];
}



- (void)subViewSettings{
    
    date.text = _model.date;
    date.text = [NSString stringWithFormat:@"%@\n%@",[date.text substringToIndex:4],[date.text substringFromIndex:5]];
    date.textAlignment = NSTextAlignmentRight;
    date.numberOfLines = 2;
    
    
    mileage.text = [NSString stringWithFormat:@"里程 %gkm",_model.distance];
    totaltime.text = [NSString stringWithFormat:@"时长 %@",_model.driverTime];
    timeline.text = [NSString stringWithFormat:@"油耗 %gL",_model.oil];
    
    
    [date setTextColor:[UIColor grayColor] range:NSMakeRange(0,4)];
    [date setTextColor:kColor range:NSMakeRange(date.text.length - 5, 5)];
    
    //里程
    mileage.translatesAutoresizingMaskIntoConstraints = YES;
    mileage.adjustsFontSizeToFitWidth = YES;
    
    //油耗
    //timeline.translatesAutoresizingMaskIntoConstraints = YES;
    timeline.adjustsFontSizeToFitWidth = YES;
    
    //时长
    totaltime.translatesAutoresizingMaskIntoConstraints = YES;
    totaltime.adjustsFontSizeToFitWidth = YES;
}

//绘制一张图片
- (void)drawImage{
    UIImage *image = [UIImage imageNamed:@"里程奖励选中"];
    [image drawInRect:CGRectMake(55 - 5,28,10,10)];
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
/*
 *   三角路径
 */
- (void)drawTriangleView{
    CGFloat cornerRadius = 4.0f;
    CAShapeLayer *borderLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef borderPathRef = CGPathCreateMutable();
    CGRect bounds0 =  bgView.bounds;
    CGPathMoveToPoint(borderPathRef, NULL, CGRectGetMinX(bounds0), bounds0.size.height / 4.0);
    CGPathAddArcToPoint(borderPathRef,  NULL, CGRectGetMinX(bounds0), CGRectGetMinY(bounds0), CGRectGetMidX(bounds0), CGRectGetMinY(bounds0), cornerRadius);
    CGPathAddArcToPoint(borderPathRef,  NULL, CGRectGetMaxX(bounds0), CGRectGetMinY(bounds0), CGRectGetMaxX(bounds0), CGRectGetMidY(bounds0), cornerRadius);
    CGPathAddArcToPoint(borderPathRef,  NULL, CGRectGetMaxX(bounds0), CGRectGetMaxY(bounds0), CGRectGetMidX(bounds0), CGRectGetMaxY(bounds0), cornerRadius);
    CGPathAddArcToPoint(borderPathRef,  NULL, CGRectGetMinX(bounds0), CGRectGetMaxY(bounds0), CGRectGetMinX(bounds0), CGRectGetMidY(bounds0), cornerRadius);
    CGPathAddLineToPoint(borderPathRef,  NULL, CGRectGetMinX(bounds0), bounds0.size.height / 4.0 * 2);
    CGPathAddLineToPoint(borderPathRef,  NULL, CGRectGetMinX(bounds0) - 6, bounds0.size.height / 8.0 * 3);
    CGPathAddLineToPoint(borderPathRef,  NULL,CGRectGetMinX(bounds0), bounds0.size.height / 4.0);
    borderLayer.path = borderPathRef;
    CFRelease(borderPathRef);
    borderLayer.zPosition = 0.0f;
    borderLayer.fillColor = [UIColor whiteColor].CGColor;
    borderLayer.lineWidth = .5;
    borderLayer.lineCap = kCALineCapRound;
    borderLayer.lineJoin = kCALineJoinRound;
    [bgView.layer insertSublayer:borderLayer atIndex:0];
}
@end
