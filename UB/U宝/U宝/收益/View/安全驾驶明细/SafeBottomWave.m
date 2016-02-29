//
//  SafeBottomWave.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/9/9.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "SafeBottomWave.h"

@implementation SafeBottomWave

- (void)drawRect:(CGRect)rect{
   
    CGFloat width = KSCREEWIDTH / 11.0;
    CGFloat strat = self.height;
    
    UIBezierPath *trackPath = [UIBezierPath bezierPath];
    CGPoint controlPoint1 = CGPointMake(width / 2.0,     strat - 15);
    CGPoint controlPoint2 = CGPointMake(width * 2, strat - 25);
    CGPoint controlPoint3 = CGPointMake(width * 6, strat - 50);
    CGPoint controlPoint4 = CGPointMake(width * 9, strat - 25);
    CGPoint controlPoint5 = CGPointMake(width * 11.5,strat - 40);
    
    
   CGPoint startPoint1 = CGPointMake(0,         strat - 5);
   CGPoint startPoint2 = CGPointMake(width,     strat - 5);
   CGPoint startPoint3 = CGPointMake(width * 3, strat - 5);
   CGPoint startPoint4 = CGPointMake(width * 8, strat - 5);
   CGPoint startPoint5 = CGPointMake(width * 10, strat - 5);
   CGPoint startPoint6 = CGPointMake(width * 11,strat - 5);
    
    [trackPath moveToPoint:CGPointMake(self.right, self.bottomRight.y - 5)];
    [trackPath addLineToPoint:self.bottomRight];
    [trackPath addLineToPoint:self.bottomLeft];
    
    [trackPath addLineToPoint:startPoint1];
   [trackPath addQuadCurveToPoint:startPoint2 controlPoint:controlPoint1];
   [trackPath addQuadCurveToPoint:startPoint3 controlPoint:controlPoint2];
   [trackPath addQuadCurveToPoint:startPoint4 controlPoint:controlPoint3];

   [trackPath addQuadCurveToPoint:startPoint5 controlPoint:controlPoint4];
   [trackPath addQuadCurveToPoint:startPoint6 controlPoint:controlPoint5];

   [trackPath closePath];
   [kColor setFill];
   [trackPath fill];
}
@end
