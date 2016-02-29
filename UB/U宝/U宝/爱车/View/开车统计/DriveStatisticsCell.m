//
//  DriveStatisticsCell.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/14.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "DriveStatisticsCell.h"

@implementation DriveStatisticsCell
@synthesize frequcy,bgView,origin,destination,duration;

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


- (void)setModel:(CarDriveStatisticsModel *)model{
    _model = model;
    
    [self setNeedsLayout];
}


- (void)subViewSettings{
  
    frequcy.text = [NSString stringWithFormat:@"第%ld次",_indexPath.row + 1];
    frequcy.font = [UIFont systemFontOfSize:12.0];
    [frequcy setTextColor:kColor898989 range:NSMakeRange(0, frequcy.text.length)];
    [frequcy setTextColor:kColor008ce8 range:NSMakeRange(1, frequcy.text.length - 2)];
    
    
    origin.text = [NSString stringWithFormat:@"%@\n%@",[_model.driveStart substringToIndex:11],[_model.driveStart substringFromIndex:_model.driveStart.length - 9]];
    origin.lineBreakMode = NSLineBreakByWordWrapping;
    origin.textAlignment = NSTextAlignmentRight;
    origin.numberOfLines = 2;
    [origin setFont:[UIFont systemFontOfSize:8.0f]  range:NSMakeRange(0,origin.text.length - 8)];
    [origin setFont:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(origin.text.length - 8,8)];
    [origin setTextColor:kColor7d7d7d   range:NSMakeRange(0,origin.text.length - 8)];
    [origin setTextColor:kColor00a0e9                     range:NSMakeRange(origin.text.length - 8,8)];
    
    destination.text = [NSString stringWithFormat:@"%@\n%@",[_model.driveEnd substringToIndex:11],[_model.driveEnd substringFromIndex:_model.driveEnd.length - 9]];
    destination.lineBreakMode = NSLineBreakByWordWrapping;
    destination.textAlignment = NSTextAlignmentRight;
    destination.numberOfLines = 2;
    [destination setFont:[UIFont systemFontOfSize:8.0f]  range:NSMakeRange(0,destination.text.length - 8)];
    [destination setFont:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(destination.text.length - 8,8)];
    [destination setTextColor:kColor7d7d7d   range:NSMakeRange(0,destination.text.length - 8)];
    [destination setTextColor:kColor00a0e9                     range:NSMakeRange(destination.text.length - 8,8)];
    
    duration.text = [NSString stringWithFormat:@"时长  %@",_model.driverTime];
    
    bgView.frame = CGRectMake(81, 8, KSCREEWIDTH - 81 - 10, 91);
    float margin = (bgView.width - 70 -  15 - 20 - 90) / 5.0;
    origin.left = destination.left =   margin;
    _originImg.left = _destinationImg.left = origin.right + margin;
    _durationImg.left = _originImg.right + margin;
    duration.left = _durationImg.right + margin;
    bgView.backgroundColor = [UIColor whiteColor];
    frequcy.backgroundColor = [UIColor clearColor];
    origin.backgroundColor = [UIColor whiteColor];
    _originImg.backgroundColor = [UIColor whiteColor];
    destination.backgroundColor = [UIColor whiteColor];
    destination.center = CGPointMake(destination.center.x, _destinationImg.center.y);
    _destinationImg.backgroundColor = [UIColor whiteColor];
    duration.backgroundColor = [UIColor whiteColor];
    _durationImg.backgroundColor = [UIColor whiteColor];
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

//绘制一张图片
- (void)drawImage{
    UIImage *image = [UIImage imageNamed:@"里程奖励选中"];
    [image drawInRect:CGRectMake(55 - 5,20,10,10)];
}

/*
 *   三角路径
 */
- (void)drawTriangleView{
    
    CGFloat cornerRadius = 5.0f;
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    CGMutablePathRef borderPathRef = CGPathCreateMutable();
    CGRect bounds0 =  bgView.bounds;  //CGRectInset(bgView.bounds, 0, 0);
    CGPathMoveToPoint(borderPathRef, NULL, CGRectGetMinX(bounds0), bounds0.size.height / 4.0);
    CGPathAddArcToPoint(borderPathRef,  NULL, CGRectGetMinX(bounds0), CGRectGetMinY(bounds0), CGRectGetMidX(bounds0), CGRectGetMinY(bounds0), cornerRadius);
    CGPathAddArcToPoint(borderPathRef,  NULL, CGRectGetMaxX(bounds0), CGRectGetMinY(bounds0), CGRectGetMaxX(bounds0), CGRectGetMidY(bounds0), cornerRadius);
    CGPathAddArcToPoint(borderPathRef,  NULL, CGRectGetMaxX(bounds0), CGRectGetMaxY(bounds0), CGRectGetMidX(bounds0), CGRectGetMaxY(bounds0), cornerRadius);
    CGPathAddArcToPoint(borderPathRef,  NULL, CGRectGetMinX(bounds0), CGRectGetMaxY(bounds0), CGRectGetMinX(bounds0), CGRectGetMidY(bounds0), cornerRadius);
    CGPathAddLineToPoint(borderPathRef,  NULL, CGRectGetMinX(bounds0), 20);
    CGPathAddLineToPoint(borderPathRef,  NULL, CGRectGetMinX(bounds0) - 6,15);
    CGPathAddLineToPoint(borderPathRef,  NULL,CGRectGetMinX(bounds0), 10);
    CGPathCloseSubpath(borderPathRef);
    borderLayer.path = borderPathRef;
    CFRelease(borderPathRef);
    borderLayer.zPosition = 0.0f;
    borderLayer.fillColor = [UIColor whiteColor].CGColor;
    borderLayer.lineWidth = .5;
    borderLayer.lineCap = kCALineCapRound;
    borderLayer.lineJoin = kCALineJoinRound;
    borderLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInteger:2], [NSNumber numberWithInteger:2], nil];
    [bgView.layer insertSublayer:borderLayer atIndex:0];
    

    CAShapeLayer *dashLayer = [CAShapeLayer layer];
    CGMutablePathRef dashLayerpath = CGPathCreateMutable();
    CGPathMoveToPoint(dashLayerpath, NULL, _originImg.center.x, _originImg.bottom + 2);
    CGPathAddLineToPoint(dashLayerpath, NULL, _destinationImg.center.x, _destinationImg.top - 2);
    dashLayer.path = dashLayerpath;
    CFRelease(dashLayerpath);
    dashLayer.zPosition = 0.0f;
    dashLayer.strokeColor = IWColor(56, 150, 0).CGColor;
    dashLayer.lineWidth = .5;
    dashLayer.lineCap = kCALineCapRound;
    dashLayer.lineJoin = kCALineJoinRound;
    dashLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInteger:2], [NSNumber numberWithInteger:2], nil];
    [bgView.layer addSublayer:dashLayer];
}
@end
