//
//  DACircularProgressView.m
//  DACircularProgress
//
//  Created by Daniel Amitay on 2/6/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import "DACircularProgressView.h"

#import <QuartzCore/QuartzCore.h>

@interface DACircularProgressLayer : CALayer

@property(nonatomic, strong) UIColor *trackTintColor;
@property(nonatomic, strong) UIColor *progressTintColor;
@property(nonatomic, strong) UIColor *innerTintColor;
@property(nonatomic) NSInteger roundedCorners;
@property(nonatomic) CGFloat thicknessRatio;
@property(nonatomic) CGFloat yesProceeds;
@property(nonatomic) CGFloat yesscores;
@property(nonatomic) CGFloat totalProceeds;
@property(nonatomic) NSInteger clockwiseProgress;

@end

@implementation DACircularProgressLayer

@dynamic trackTintColor;
@dynamic progressTintColor;
@dynamic innerTintColor;
@dynamic roundedCorners;
@dynamic thicknessRatio;
@dynamic yesProceeds,yesscores,totalProceeds;
@dynamic clockwiseProgress;

//+ (BOOL)needsDisplayForKey:(NSString *)key
//{
//    if ([key isEqualToString:@"yesProceeds"] || [key isEqualToString:@"yesscores"] || [key isEqualToString:@"totalProceeds"]) {
//        return YES;
//    } else {
//        return [super needsDisplayForKey:key];
//    }
//}


- (void)drawInContext:(CGContextRef)context{
    
    CGRect rect = self.bounds;
    CGPoint centerPoint = CGPointMake(rect.size.width / 2.0f, rect.size.height / 2.0f);
    CGFloat radius = MIN(rect.size.height, rect.size.width) / 2.0f - 40;
    //CGFloat progress = MIN(self.progress, 1.0f - FLT_EPSILON);
    
    //赛道
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, IWColor(209, 211, 212).CGColor);
    CGContextSetFillColorWithColor(context, self.trackTintColor.CGColor);
    CGContextSetLineWidth(context, 2);
    
    CGMutablePathRef trackPath = CGPathCreateMutable();
    //CGPathMoveToPoint(trackPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius, (float)(2.0f * M_PI), 0.0f, TRUE);
    CGPathCloseSubpath(trackPath);
    CGContextAddPath(context, trackPath);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGPathRelease(trackPath);

    
    {
        float dash = radius * 0.1 / 7.0;
        const CGFloat length[] = {dash, dash};
        CGContextSaveGState(context);
        CGContextSetLineWidth(context, 2);
        CGContextSetLineDash(context, 0, length, 2);
        CGContextMoveToPoint(context,     centerPoint.x - 2, centerPoint.y - radius + dash);
        CGContextAddLineToPoint(context,  centerPoint.x - 2, centerPoint.y - radius + radius * 0.1 - dash);
        CGContextStrokePath(context);
        CGContextClosePath(context);
        CGContextRestoreGState(context);
        
        
        //昨日收益
        if(self.yesProceeds < 0) self.yesProceeds = 0.0;
        if(self.yesProceeds > 5.0) self.yesProceeds = 5.0;
        
        float total =           M_PI_2 / 3.0 * 4;
        float yesProceed =      -M_PI_2 + self.yesProceeds / 5.0 * total + 0.0001 / 180.0 * M_PI;
        CGContextSetFillColorWithColor(context, self.progressTintColor.CGColor);
        CGMutablePathRef progressPath = CGPathCreateMutable();
        CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
        //CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius,-M_PI_2 / 3.0,(float)(3.0f * M_PI_2), YES);
        CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius,yesProceed,(float)(3.0f * M_PI_2), TRUE);
        CGPathCloseSubpath(progressPath);
        CGContextAddPath(context, progressPath);
        CGContextFillPath(context);
        CGPathRelease(progressPath);
        
        
        double dash2oriX = (radius- dash) * cos(M_PI_2 / 3.0 - degreesToRadian(1)) + centerPoint.x;
        double dash2oriY = (radius- dash) * sin(M_PI_2 / 3.0 - degreesToRadian(1)) + centerPoint.y;
        double dash3oriX = radius * 0.9 * cos(M_PI_2 / 3.0 - degreesToRadian(1)) + centerPoint.x;
        double dash3oriY = radius * 0.9 * sin(M_PI_2 / 3.0 - degreesToRadian(1)) + centerPoint.y;
        CGContextSaveGState(context);
        CGContextSetLineWidth(context, 2);
        CGContextSetLineDash(context, 0, length, 2);
        CGContextMoveToPoint(context,   dash2oriX,  dash2oriY );
        CGContextAddLineToPoint(context,dash3oriX,  dash3oriY);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
        
        
        //累计收益
        if(self.totalProceeds < 0) self.totalProceeds = 0.0;
        if(self.totalProceeds > 500.0) self.totalProceeds = 500.0;
        
        float totalProceed =   M_PI_2 / 3.0 + self.totalProceeds / 500 * total + 0.0001 / 180.0 * M_PI;
        CGContextSetFillColorWithColor(context, kColor.CGColor);
        CGMutablePathRef progressPath2 = CGPathCreateMutable();
        CGPathMoveToPoint(progressPath2, NULL, centerPoint.x, centerPoint.y);
        CGPathAddArc(progressPath2, NULL, centerPoint.x, centerPoint.y, radius,M_PI_2 / 3.0,totalProceed, NO);
        CGPathCloseSubpath(progressPath2);
        CGContextAddPath(context, progressPath2);
        CGContextFillPath(context);
        CGPathRelease(progressPath2);
        

        
        double dash4oriX = (radius- dash) * cos(M_PI_2 / 3.0 * 5 - degreesToRadian(1)) + centerPoint.x;
        double dash4oriY = (radius- dash) * sin(M_PI_2 / 3.0 * 5 - degreesToRadian(1)) + centerPoint.y;
        double dash5oriX = radius * 0.9 * cos(M_PI_2 / 3.0 * 5 - degreesToRadian(1)) + centerPoint.x;
        double dash5oriY = radius * 0.9 * sin(M_PI_2 / 3.0 * 5 - degreesToRadian(1)) + centerPoint.y;
        CGContextSaveGState(context);
        CGContextSetLineWidth(context, 2);
        CGContextSetLineDash(context, 0, length, 2);
        CGContextMoveToPoint(context,   dash4oriX,  dash4oriY );
        CGContextAddLineToPoint(context,dash5oriX,  dash5oriY);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
        
        //昨日得分
        if(self.yesscores < 0) self.yesscores = 0.0;
        if(self.yesscores > 100.0) self.yesscores = 100.0;
        
        float yesscore =   M_PI_2 / 3.0 * 5.0  + self.yesscores / 100 * total + 0.0001 / 180.0 * M_PI;
        CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
        CGMutablePathRef progressPath3 = CGPathCreateMutable();
        CGPathMoveToPoint(progressPath3, NULL, centerPoint.x, centerPoint.y);
        CGPathAddArc(progressPath3, NULL, centerPoint.x, centerPoint.y, radius,M_PI_2 / 3.0 * 5,yesscore, NO);
        CGPathCloseSubpath(progressPath3);
        CGContextAddPath(context, progressPath3);
        CGContextFillPath(context);
        CGPathRelease(progressPath3);
    }
    

    //CGContextSetBlendMode(context, kCGBlendModeClear);//混合颜色
    CGContextSetFillColorWithColor(context,     IWColor(227, 243, 254).CGColor);
    CGFloat innerRadius = radius * (1.0f - 0.1);
    CGRect clearRect = (CGRect) {
        .origin.x = centerPoint.x - innerRadius,
        .origin.y = centerPoint.y - innerRadius,
        .size.width = innerRadius * 2.0f,
        .size.height = innerRadius * 2.0f
    };
    CGContextAddEllipseInRect(context, clearRect);
    CGContextDrawPath(context, kCGPathFillStroke);
}
@end



#define animateDuration   3.0
@interface DACircularProgressView (){
    UIImageView *yesproceeds;
    UIImageView *totalproceeds;
    UIImageView *yesturdaygrade;
}
@end
@implementation DACircularProgressView
+ (void)initialize
{
    if (self == [DACircularProgressView class]) {
        DACircularProgressView *circularProgressViewAppearance = [DACircularProgressView appearance];
        [circularProgressViewAppearance setTrackTintColor: [UIColor whiteColor]];
        [circularProgressViewAppearance setProgressTintColor:IWColor(35, 195, 72)];
        [circularProgressViewAppearance setInnerTintColor: [UIColor clearColor]];
        [circularProgressViewAppearance setRoundedCorners:NO];
        [circularProgressViewAppearance setBackgroundColor:[UIColor clearColor]];
    }
}
+ (Class)layerClass
{
    return [DACircularProgressLayer class];
}
- (DACircularProgressLayer *)circularProgressLayer
{
    return (DACircularProgressLayer *)self.layer;
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    CGFloat windowContentsScale = self.window.screen.scale;
    self.circularProgressLayer.contentsScale = windowContentsScale;
    [self.circularProgressLayer setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if(self){
        
        [self createSubCarViews];
        
        [self createSubCarViews2];
        
        [self createSubCarViews3];
    }
    return self;
}

/*
 *   创建三个小车
 */
- (void)createSubCarViews{
    yesproceeds = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 30, 15)];
    yesproceeds.center =CGPointMake(self.center.x, 20);
    //yesproceeds.transform = CGAffineTransformMakeRotation(M_PI_2);
    yesproceeds.image  = [UIImage imageNamed:@"Pgreen-car-right"];
    [self addSubview:yesproceeds];
}
- (void)startCaroneAnimation:(CGFloat)yesProceeds{
  
    if(yesProceeds < 0) yesProceeds = 0.0;
    if(yesProceeds > 5.0) yesProceeds = 5.0;
    
    float total =           M_PI_2 / 3.0 * 4;
    float yesProceed =      -M_PI_2 + yesProceeds / 5.0 * total + 0.0001 / 180.0 * M_PI;
    CGPoint centerPoint = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
    CGFloat radius = MIN(self.frame.size.height, self.frame.size.width) / 2.0f - 20;
    CGMutablePathRef trackPath = CGPathCreateMutable();
    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius,
                 -M_PI_2,
                 yesProceed,
                 NO);
    CAKeyframeAnimation * yesproceedsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    yesproceedsAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    yesproceedsAnimation.fillMode = kCAFillModeForwards;
    yesproceedsAnimation.duration = animateDuration + 1;
    yesproceedsAnimation.rotationMode = kCAAnimationRotateAuto;
    yesproceedsAnimation.removedOnCompletion = NO;
    yesproceedsAnimation.path = trackPath;
    [yesproceeds.layer addAnimation:yesproceedsAnimation forKey:@"yesproceedsposition"];
    CGPathRelease(trackPath);
}


- (void)createSubCarViews2{
    CGPoint centerPoint = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
    CGFloat radius = MIN(self.frame.size.height, self.frame.size.width) / 2.0f - 20;
    double oriX = radius * cos(M_PI_2 / 3.0) + centerPoint.x;
    double oriY = radius * sin(M_PI_2 / 3.0) + centerPoint.y;
    totalproceeds = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 15)];
    totalproceeds.center = CGPointMake(oriX,oriY);
    //totalproceeds.transform = CGAffineTransformMakeRotation(145 * (M_PI / 180.0f));
    totalproceeds.image  = [UIImage imageNamed:@"Pblue-car--right"];
    [self addSubview:totalproceeds];
}
- (void)startCarTwoAnimation:(CGFloat)totalProceeds{
    
    if(totalProceeds < 0) totalProceeds = 0.0;
    if(totalProceeds > 500.0) totalProceeds = 500.0;
    
    float total =           M_PI_2 / 3.0 * 4;
    float totalProceed =    M_PI_2 / 3.0 + totalProceeds / 500 * total  + 0.0001 / 180.0 * M_PI;
    CGPoint centerPoint = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
    CGFloat radius = MIN(self.frame.size.height, self.frame.size.width) / 2.0f - 20;
    CGMutablePathRef trackPath = CGPathCreateMutable();
    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius,
                 M_PI_2 / 3.0,
                totalProceed,
                 NO);
    CAKeyframeAnimation * yesproceedsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //决定当前对象在非active时间段的行为.比如动画开始之前,动画结束之后 .
    yesproceedsAnimation.fillMode = kCAFillModeForwards;
    //速度控制函数，控制动画运行的节奏 .
    yesproceedsAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    yesproceedsAnimation.rotationMode = kCAAnimationRotateAuto;
    yesproceedsAnimation.duration = animateDuration+ 1;
    //默认为YES，代表动画执行完毕后就从图层上移除，图形会恢复到动画执行前的状态。如果想让图层保持显示动画执行后的状态，那就设置为NO，不过还要设置fillMode为kCAFillModeForwards .
    yesproceedsAnimation.removedOnCompletion = NO;
    yesproceedsAnimation.path = trackPath;
    [totalproceeds.layer addAnimation:yesproceedsAnimation forKey:@"totalproceedsposition"];
    CGPathRelease(trackPath);

}

- (void)createSubCarViews3{
    CGPoint centerPoint = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
    CGFloat radius = MIN(self.frame.size.height, self.frame.size.width) / 2.0f - 20;
    double oriX = -radius * cos(M_PI_2 / 3.0) + centerPoint.x;
    double oriY =  radius * sin(M_PI_2 / 3.0) + centerPoint.y;
    yesturdaygrade = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 15)];
    yesturdaygrade.center = CGPointMake(oriX,oriY);
    //yesturdaygrade.transform = CGAffineTransformMakeRotation(45 * (M_PI / 180.0f));
    yesturdaygrade.image  = [UIImage imageNamed:@"Porange-car--right"];
    [self addSubview:yesturdaygrade];
}
- (void)startCarThreeAnimation:(CGFloat)yesScores{
    
    if(yesScores < 0) yesScores = 0.0;
    if(yesScores > 100.0) yesScores = 100.0;
    
    float total =        M_PI_2 / 3.0 * 4;
    float yesScore =     M_PI_2 / 3.0 * 5 + yesScores / 100 * total + 0.0001 / 180.0 * M_PI;
    CGPoint centerPoint = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
    CGFloat radius = MIN(self.frame.size.height, self.frame.size.width) / 2.0f - 20;
    CGMutablePathRef trackPath = CGPathCreateMutable();
    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius,
                 M_PI_2 / 3.0 * 5,
                 yesScore,
                 NO);
    CAKeyframeAnimation * yesproceedsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    yesproceedsAnimation.fillMode = kCAFillModeForwards;
    yesproceedsAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    yesproceedsAnimation.rotationMode = kCAAnimationRotateAuto;
    yesproceedsAnimation.duration = animateDuration+1;
    yesproceedsAnimation.removedOnCompletion = NO;
    yesproceedsAnimation.path = trackPath;
    [yesturdaygrade.layer addAnimation:yesproceedsAnimation forKey:@"yesturdaygradeposition"];
    CGPathRelease(trackPath);
}


#pragma mark - Progress
- (CGFloat)yesProceeds
{
    return self.circularProgressLayer.yesProceeds;
}
- (void)setYesProceeds:(CGFloat)yesProceeds{

       [self.circularProgressLayer setNeedsDisplay];
       self.circularProgressLayer.yesProceeds = yesProceeds;

       [self startCaroneAnimation:yesProceeds];
}
- (CGFloat)totalProceeds{
    
    return self.circularProgressLayer.totalProceeds;
}
- (void)setTotalProceeds:(CGFloat)totalProceeds{
    [self.circularProgressLayer setNeedsDisplay];
    self.circularProgressLayer.totalProceeds = totalProceeds;
    
    [self startCarTwoAnimation:totalProceeds];
}
- (CGFloat)yesscores{
 
    return self.circularProgressLayer.yesscores;
}
- (void)setYesscores:(CGFloat)yesscores{

    [self.circularProgressLayer setNeedsDisplay];
    self.circularProgressLayer.yesscores = yesscores;
    
    [self startCarThreeAnimation:yesscores];
}


#pragma mark - UIAppearance methods
- (UIColor *)trackTintColor
{
    return self.circularProgressLayer.trackTintColor;
}
- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    self.circularProgressLayer.trackTintColor = trackTintColor;
    [self.circularProgressLayer setNeedsDisplay];
}
- (UIColor *)progressTintColor
{
    return self.circularProgressLayer.progressTintColor;
}
- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    self.circularProgressLayer.progressTintColor = progressTintColor;
    [self.circularProgressLayer setNeedsDisplay];
}
- (UIColor *)innerTintColor
{
    return self.circularProgressLayer.innerTintColor;
}
- (void)setInnerTintColor:(UIColor *)innerTintColor
{
    self.circularProgressLayer.innerTintColor = innerTintColor;
    [self.circularProgressLayer setNeedsDisplay];
}
@end
