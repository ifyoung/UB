//
//  ASOButtonView.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/2.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "ASOButtonView.h"

@interface ASOButtonView (){
 
    NSMutableArray *arrMenuItemButtons;
}
@end
@implementation ASOButtonView
- (void)layoutSubviews{
    [super layoutSubviews];

    [self createSubViews];
}
- (void)setBoundFrame:(CGRect)boundFrame{
   
    _boundFrame = boundFrame;
    
    [self setNeedsLayout];
}
- (void)createSubViews{

    if(_type == ASOButtonViewTypeNormal){
        
        //[self createRoundSubViews];
        
    }else if (_type == ASOButtonViewHistoricalTrack || _type ==  ASOButtonViewHistoricalTrack1){
        
        [self createLineSubView];
    }
}


//历史轨迹直线弹出
- (void)createLineSubView{
    NSArray *titles;
    if(_type == ASOButtonViewHistoricalTrack){
          titles = @[@"今天",@"昨天",@"前天",@"本周",@"上周",@"本月",@"上月"];
    }else{
          titles = @[@"今天",@"昨天",@"前天"];
    }
    
    arrMenuItemButtons = [NSMutableArray array];
    CGRect oriFrame = _boundFrame;
    for(NSInteger i = 0; i < titles.count;i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGRect frame = oriFrame;
        frame.origin.y =  oriFrame.origin.y - _boundFrame.size.height - 10;
        oriFrame = frame;
        
        button.frame = CGRectMake(
                                  oriFrame.origin.x,
                                  oriFrame.origin.y,
                                  oriFrame.size.width,
                                  oriFrame.size.height   
                                  );
        
        
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [button setBackgroundImage:[UIImage imageNamed:@"时间弹出蓝色"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"时间弹出灰色"] forState:UIControlStateNormal];
        [button setTitle:titles[i]forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:button];
        if(_type ==ASOButtonViewHistoricalTrack){
             if(i == 1) button.selected = YES;
        }else{
             if(i == 0) button.selected = YES;
        }
        
        [arrMenuItemButtons addObject:button];
    }
    [self addBounceButtons:arrMenuItemButtons];
    [self setAnimationStartFromHere:_boundFrame];
    [self setSpeed:[NSNumber numberWithFloat:0.3f]];
    [self setBouncingDistance:[NSNumber numberWithFloat:0.3f]];
    [self setAnimationStyle:ASOAnimationStyleRiseProgressively];
    self.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];

}

- (void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;

    for(UIButton *button in arrMenuItemButtons){
        if([button isEqual:[arrMenuItemButtons objectAtIndex:selectIndex]]){
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
}


/**
 *
 *   圆弧坐标
 */
/*
- (NSMutableArray *)CenterCircle:(CGPoint)centerCircle{
    
    CGFloat radius = 100.0f;
    NSMutableArray *pointArray = [NSMutableArray array];
    double  angel = 30;
    for(NSInteger i = 0;i < 4;i++){
        CGFloat x = 0.0f;
        if(angel == 90){
            x = centerCircle.x;
        }else{
            x = centerCircle.x + radius * cos(angel / 180.0 * M_PI);
        }
        CGFloat  y = centerCircle.y - radius * sin(angel / 180.0 * M_PI);
        NSValue *value =  [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [pointArray addObject:value];
        angel += 40;
    }
    return pointArray;
}
 //爱车首页 圆弧
 - (void)createRoundSubViews{
 NSArray *titles = @[@"里程统计",@"开车统计",@"能耗",@"历史轨迹"];
 NSMutableArray *arrMenuItemButtons = [NSMutableArray array];
 
 [arrMenuItemButtons removeAllObjects];
 
 for(NSInteger i = 0; i < 4;i++){
 
 ASOButtonViewItem *button = [ASOButtonViewItem buttonWithType:UIButtonTypeCustom];
 
 CGPoint buttoncenter = [[self CenterCircle:CGPointMake(_boundFrame.origin.x + 25, _boundFrame.origin.y + 25)][i] CGPointValue];
 button.frame = CGRectMake(0, 0, 40, 70);
 button.center = buttoncenter;
 
 button.titleLabel.font = [UIFont systemFontOfSize:8.0f];
 [button setImage:[UIImage imageNamed:titles[i]] forState:UIControlStateNormal];
 [button setTitle:titles[i]forState:UIControlStateNormal];
 button.titleLabel.textAlignment = NSTextAlignmentCenter;
 [self addSubview:button];
 [arrMenuItemButtons addObject:button];
 }
 [self addBounceButtons:arrMenuItemButtons];
 [self setAnimationStartFromHere:_boundFrame];
 [self setSpeed:[NSNumber numberWithFloat:0.5f]];
 [self setBouncingDistance:[NSNumber numberWithFloat:0.3f]];
 [self setAnimationStyle:ASOAnimationStyleRiseConcurrently];
 self.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
 
 }
 */
@end


@implementation ASOButtonViewItem
// 内部图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.width;
    return CGRectMake(0, 0, imageW, imageH);
}
// 内部文字的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height - 20;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = 20;
    return CGRectMake(0, titleY, titleW, titleH);
}
@end