//
//  InnerShadowView.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/14.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "InnerShadowView.h"

@implementation InnerShadowView


- (void)drawRect:(CGRect)rect {
 
    [super drawRect:rect];
    
    [self innerShadow];
}


/*
 *   内阴影！！
 */
- (void)innerShadow{
    
    self.layer.cornerRadius = self.height / 2.0;
    CAShapeLayer* shadowLayer = [CAShapeLayer layer];
    [shadowLayer setFrame:self.bounds];
    
    // Standard shadow stuff
    [shadowLayer setShadowColor:kColor.CGColor];
    [shadowLayer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    [shadowLayer setShadowOpacity:1.0f];
    [shadowLayer setShadowRadius:4];
    // Causes the inner region in this example to NOT be filled.
    [shadowLayer setFillRule:kCAFillRuleEvenOdd];


    
    // Create the larger rectangle path.
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectInset(self.bounds, -5, -5));
    
    
    // Add the inner path so it's subtracted from the outer path.
    // someInnerPath could be a simple bounds rect, or maybe
    // a rounded one for some extra fanciness.
    CGPathRef someInnerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.height / 2.0].CGPath;
    CGPathAddPath(path, NULL, someInnerPath);
    CGPathCloseSubpath(path);
    [shadowLayer setPath:path];
    CGPathRelease(path);
    [[self layer] addSublayer:shadowLayer];
    
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.backgroundColor = [UIColor redColor].CGColor;
    [maskLayer setPath:someInnerPath];
    [shadowLayer setMask:maskLayer];
}

@end
