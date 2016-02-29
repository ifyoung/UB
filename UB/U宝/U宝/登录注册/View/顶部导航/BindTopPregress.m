//
//  BindTopPregress.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/9/7.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "BindTopPregress.h"

@interface BindTopPregress (){
    
    CGPoint binaryCode[3];
}

@end

@implementation BindTopPregress

- (id)init{
    CGRect  frame = CGRectMake(0, 0, KSCREEWIDTH, 80);
    self = [super initWithFrame:frame];
    if(self){
        
        
        [self createSubViews];
    }
    return self;
}

+ (BindTopPregress *)bindTopPregress:(int)pregress{
    BindTopPregress *bindTopPregress = [[self alloc]init];
    bindTopPregress.pregress = pregress;
    bindTopPregress.backgroundColor = [UIColor whiteColor];
    return bindTopPregress;
}

- (void)setPregress:(int)pregress{
    
    _pregress = pregress;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    for(int i = 0;i < 3;i ++){
        UILabel *label = (UILabel *)[self viewWithTag:400 + i];
        if(_pregress >= i ){
            label.textColor = IWColor(10, 210, 47);
        }else{
            label.textColor = [UIColor grayColor];
        }
    }
}

- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    for(int i =0;i < 3;i ++){
        UIColor *clo;
        if(_pregress >= i){
            clo = IWColor(10, 210, 47);
        }else{
            clo = [UIColor grayColor];
        }
        
        //画圈圈
        CGContextSetStrokeColorWithColor(context, clo.CGColor);
        CGRect rrrxct = CGRectMoveToCenter(CGRectMake(0, 0, 10, 10), binaryCode[i]);
        CGContextStrokeEllipseInRect(context, rrrxct);
        
        UILabel *label = [[UILabel alloc]initWithFrame:rrrxct];
        label.text = [NSString stringWithFormat:@"%d",i + 1];
        //label.adjustsFontSizeToFitWidth = YES;
        label.font = [UIFont systemFontOfSize:10.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = clo;
        [self addSubview:label];
        
        //3.画点点
        if(i > 1) return;
        const CGFloat length[] = {1, 5};
        CGContextSaveGState(context);
        CGContextSetLineDash(context, 0, length, 2);
        CGContextMoveToPoint(context, binaryCode[i].x + 10, binaryCode[i].y);
        CGContextAddLineToPoint(context, binaryCode[i + 1].x - 10,binaryCode[i + 1].y);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
    }
    
    CGContextClosePath(context);
}




- (void)createSubViews{
    
    NSArray *titles = @[@"扫描OBD条形码",@"填写车牌号",@"选择里程奖励"];
    CGFloat xmargin = 20.0f;
    CGFloat width = (self.width - 20 * 6) / 3.0;
    for(int i =0;i < 3;i ++){
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xmargin, 0, width, xmargin)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = IWColor(10, 210, 47);
        label.font = [UIFont systemFontOfSize:14.0];
        label.text = [titles objectAtIndex:i];
        label.tag = 400 + i;
        [label sizeToFit];
        label.center = CGPointMake(label.center.x, self.center.y + 10);
        [self addSubview:label];
        //label.backgroundColor = [UIColor redColor];
        
        if(i == 0) label.left = 20;
        if(i == 1) label.center =  CGPointMake(self.center.x, self.center.y + 10);
        if(i == 2) label.right = KSCREEWIDTH - 20;
        
        binaryCode[i] = CGPointMake(label.center.x, label.center.y - 20);
    }
}
@end
