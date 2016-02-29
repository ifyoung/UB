//
//  SafeDviveHeader.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/25.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import "SafeDviveHeader.h"

@interface SafeDviveHeader (){
    UILabel *topLabel;
    UILabel *middleLabel;
    UILabel *bottomLabel;
    UILabel *rightLabel;
    UILabel *rigBottomLabel;
}
@end

@implementation SafeDviveHeader
- (id)init{
    self = [super initWithFrame:CGRectMake(0, 0, KSCREEWIDTH, 120)];
    if(self){
        [self createSubViews];
    }
    return self;
}


- (void)createSubViews{
    for(int i=0;i < 4;i++){
        if(i < 3){
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 15 + 35 * i, 80, 20)];
            [self addSubview:label];
            label.backgroundColor = [UIColor clearColor];//IWColor(38, 210, 77);
            if(i==0){
                topLabel = label;
            }else if (i==1){
                middleLabel = label;
            }else{
                bottomLabel = label;
            }
        }
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.width - 100, 0, 80, 40)];
    [self addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.center = CGPointMake(label.center.x, self.height / 2.0);
    label.textColor = IWColor(38, 210, 77);
    rightLabel = label;
    
    rigBottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, label.bottom , 20, 15)];
    rigBottomLabel.textColor =  IWColor(74, 75, 75);
    rigBottomLabel.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:rigBottomLabel];
}
- (void)setModel:(SafeDriveDetailModel *)model{
    _model = model;
    
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];

    topLabel.text = [CurrentDeviceModel shareInstance].plateNo;
    topLabel.textColor = kColor;
    [topLabel sizeToFit];

    middleLabel.text = @"昨日驾驶得分";
    [middleLabel sizeToFit];

    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-24*60*60];
    NSString *dateString =  [NSDate stringFromDate:date formate:@"yyyy-MM-dd"];
    bottomLabel.text =  dateString;
    bottomLabel.textColor = [UIColor lightGrayColor];
    [bottomLabel sizeToFit];
    
   
    if([self.model.score floatValue] < 60) rightLabel.textColor = [UIColor redColor];
    rightLabel.text = [NSString stringWithFormat:@"%@分",self.model.score];
    [rightLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [rightLabel setFont:[UIFont boldSystemFontOfSize:20.0f] range:NSMakeRange(0, rightLabel.text.length - 1)];
    [rightLabel sizeToFit];
    
    if(self.model.bestScore == nil || [self.model.bestScore isKindOfClass:[NSNull class]]){
        rigBottomLabel.text =  [NSString stringWithFormat:@"最高%@分",self.model.score];
    }else{
        rigBottomLabel.text =  [NSString stringWithFormat:@"最高%@分",self.model.bestScore];
    }
    [rigBottomLabel sizeToFit];
    rigBottomLabel.center = CGPointMake(rightLabel.center.x + 5, rigBottomLabel.center.y);
    rigBottomLabel.top = rightLabel.bottom + 10;
    
    
    //得分
    float total =      M_PI_2 / 3.0 * 8;
    float score =     -M_PI_2 / 3.0 * 7 + [self.model.score     floatValue] / 100.0 * total;
    float topscore =  -M_PI_2 / 3.0 * 7 + [self.model.bestScore floatValue] / 100.0 * total;
    
    [self reDrawWithColor:IWColor(169, 215, 245)  width:3 score: M_PI_2 / 3.0]; //满分
    
    [self reDrawWithColor:IWColor( 94, 237, 250)  width:6 score: topscore];     //最高
    
    [self reDrawWithColor:[self.model.score floatValue] < 60? [UIColor redColor] : IWColor( 38, 210, 77)   width:6 score: score];    //当前
}


- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //最高最低分
    [@"0" drawAtPoint:CGPointMake(rigBottomLabel.left - 25, rigBottomLabel.bottom + 10)
       withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],
                        NSForegroundColorAttributeName:[UIColor grayColor]}];
    
    [@"100" drawAtPoint:CGPointMake(rigBottomLabel.right , rigBottomLabel.bottom + 10)
       withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],
                        NSForegroundColorAttributeName:[UIColor grayColor]}];
    
    //画绿点
    CGContextRef context =  UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, IWColor(94, 237, 250).CGColor);
    CGContextBeginPath(context);
    CGRect ciclerect = CGRectMake(0,0, 8, 8);
    ciclerect = CGRectMoveToCenter(ciclerect, CGPointMake(rigBottomLabel.left - 10, rigBottomLabel.center.y));
    CGContextFillEllipseInRect(context, ciclerect);
    CGContextClosePath(context);
}




- (void)reDrawWithColor:(UIColor *)color width:(float)width score:(float)score
 {
//     if (chartLine  !=  nil){
//         [chartLine removeAllAnimations];//这样就能重复绘制饼状图了
//     }
     //float angle = M_PI * (score / 100.0);
     
     CAShapeLayer *chartLine = [CAShapeLayer layer];
     chartLine.lineWidth = 5;
     chartLine.lineCap = kCALineCapRound;
     chartLine.lineJoin = kCALineJoinRound;
     chartLine.strokeColor = color.CGColor;
     chartLine.fillColor = nil;
     self.clipsToBounds = NO;
     [self.layer addSublayer:chartLine];
   
     //path
     CGMutablePathRef pathRef  = CGPathCreateMutable();
     CGPathAddArc(pathRef, &CGAffineTransformIdentity,
     rightLabel.center.x,
     rightLabel.bottom,
     55,
     -M_PI_2 / 3.0 * 7,
     score,
     NO
     );
     
     
     chartLine.path = pathRef;
     CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
     pathAnimation.duration = 1.1;
     pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
     pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
     pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
     pathAnimation.fillMode = kCAFillModeBoth;
     //pathAnimation.autoreverses = YES;
     //pathAnimation.repeatCount = HUGE_VALF;
     pathAnimation.removedOnCompletion = YES;
     
     if(![color isEqual: IWColor(169, 215, 245)])
     [chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
     CGPathRelease(pathRef);
     chartLine.strokeEnd = 1.0f;//表示绘制到百分比多少就停止，这个我们用1表示完全绘制
}
@end
