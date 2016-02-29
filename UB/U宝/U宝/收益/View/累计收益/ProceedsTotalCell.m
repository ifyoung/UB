//
//  ProceedsTotalCell.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/27.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import "ProceedsTotalCell.h"

@implementation ProceedsTotalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setModel:(PrpceedsTotailDetailModel *)model{
    _model = model;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _time.text = [NSString stringWithFormat:@"%@\n%@",[self.model.date substringToIndex:4],[self.model.date substringFromIndex:5]];
 
    
    _mileM.text  = [NSString stringWithFormat:@"%g元",self.model.distanceIncome];
    _greenM.text = [NSString stringWithFormat:@"%g元",self.model.greenIncome];
    _safeM.text  = [NSString stringWithFormat:@"%g元",self.model.safeIncome];
    _totalMoney.text = [NSString stringWithFormat:@"%g元",self.model.income];
    
    [_time setTextColor:kColor range:NSMakeRange(4, _time.text.length - 4)];

    
    _totalMoney.textColor = IWColor(240, 70, 47);
    [_totalMoney setTextColor:IWColor(74, 75, 75) range:NSMakeRange(_totalMoney.text.length - 1, 1)];
    [_totalMoney setFont:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(_totalMoney.text.length - 1, 1)];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [self drawLine];
    
    [self drawImage];
    
    [self drawTriangleView];
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
    [image drawInRect:CGRectMake(55 - 5,36 - 5,10,10)];
}


/*
 *   三角路径
 */
- (void)drawTriangleView{
    
    CGFloat cornerRadius = 4.0f;
    CGRect bounds0 = CGRectMake(70, 12, KSCREEWIDTH - 90, 100 - 12);
    CGMutablePathRef borderPathRef = CGPathCreateMutable();
    CGPathMoveToPoint(borderPathRef, NULL, CGRectGetMinX(bounds0), 30);
    
    CGPathAddArcToPoint(borderPathRef,  NULL, CGRectGetMinX(bounds0), CGRectGetMinY(bounds0), CGRectGetMidX(bounds0), CGRectGetMinY(bounds0), cornerRadius);
    CGPathAddArcToPoint(borderPathRef,  NULL, CGRectGetMaxX(bounds0), CGRectGetMinY(bounds0), CGRectGetMaxX(bounds0), CGRectGetMidY(bounds0), cornerRadius);
    CGPathAddArcToPoint(borderPathRef,  NULL, CGRectGetMaxX(bounds0), CGRectGetMaxY(bounds0), CGRectGetMidX(bounds0), CGRectGetMaxY(bounds0), cornerRadius);
    CGPathAddArcToPoint(borderPathRef,  NULL, CGRectGetMinX(bounds0), CGRectGetMaxY(bounds0), CGRectGetMinX(bounds0), CGRectGetMidY(bounds0), cornerRadius);
    
    CGPathAddLineToPoint(borderPathRef,  NULL, CGRectGetMinX(bounds0), 40);
    CGPathAddLineToPoint(borderPathRef,  NULL, CGRectGetMinX(bounds0) - 6, 35);
    CGPathAddLineToPoint(borderPathRef,  NULL,CGRectGetMinX(bounds0), 30);
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetStrokeColorWithColor(context, IWColor(234, 235, 236).CGColor);
    CGContextSetLineWidth(context, 1);
    
    CGContextAddPath(context, borderPathRef);
    CGContextFillPath(context);
    
    CGPathMoveToPoint(borderPathRef, NULL,    _totalMoney.left + 5 , CGRectGetMinY(bounds0) + 5);
    CGPathAddLineToPoint(borderPathRef,  NULL,_totalMoney.left+ 5, CGRectGetMaxY(bounds0) - 5);
    
    CGContextAddPath(context, borderPathRef);
    CGContextStrokePath(context);
    
    CGContextClosePath(context);
    CGPathRelease(borderPathRef);
}
@end
