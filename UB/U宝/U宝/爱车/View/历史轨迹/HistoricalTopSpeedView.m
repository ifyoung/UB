//
//  HistoricalTopSpeedView.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/9/14.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "HistoricalTopSpeedView.h"

@interface HistoricalTopSpeedView (){

    UIImageView *leftImg;
    UILabel *leftLabel;
    UIImageView *rightImg;
    UILabel *rightLabel;

}

@end

@implementation HistoricalTopSpeedView

- (id)init{
 
    self = [super initWithFrame:CGRectMake(0, 0, KSCREEWIDTH, 40)];
    if(self){
    
    
        [self createSubViews];
    }
    return self;
}


+ (HistoricalTopSpeedView *)historicalTopSpeedView{

    HistoricalTopSpeedView *his = [[self alloc]init];
    
    return his;
}


/*
 *   createSubViews
 */
- (void)createSubViews{

    UIImageView *leftI = [[UIImageView alloc]initWithFrame:CGRectZero];
    UILabel *leftL = [[UILabel alloc]initWithFrame:CGRectZero];
    
    
    UIImageView *rightI = [[UIImageView alloc]initWithFrame:CGRectZero];
    UILabel *rightL = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:leftI];
    [self addSubview:leftL];
    [self addSubview:rightI];
    [self addSubview:rightL];
    
    leftImg   = leftI;
    leftLabel = leftL;
    rightImg  = rightI;
    rightLabel=rightL;
    
    [self addShadow];
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:.8];
}

- (void)setttings{

    leftImg.frame = CGRectMake(20, (self.height - 20) / 2.0, 20, 20);
    leftImg.image = [UIImage imageNamed:@"iconfont-yiqiyibiao"];
    
    leftLabel.frame = CGRectMake(leftImg.right + 10, (self.height - 20) / 2.0, self.width / 2.0 - leftImg.right - 20, 20);
    if(!self.speed) self.speed = @"0";
    leftLabel.text = [NSString stringWithFormat:@"速度：%@km/h",self.speed];
    leftLabel.adjustsFontSizeToFitWidth = YES;
    [leftLabel setFont:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, 3)];
    [leftLabel setFont:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(3, leftLabel.text.length - 3)];
    [leftLabel setTextColor:[UIColor blackColor] range:NSMakeRange(0, 3)];
    [leftLabel setTextColor:kColor range:NSMakeRange(3, leftLabel.text.length - 3)];
    
    
    rightImg.frame = CGRectMake(self.width / 2.0, (self.height - 20) / 2.0, 20, 20);
    rightImg.image = [UIImage imageNamed:@"iconfont-shijian-(1)"];
    rightLabel.frame = CGRectMake(rightImg.right + 10, (self.height - 20) / 2.0, self.width  - rightImg.right - 10 - 10, 20);
    if(!self.date) self.date = @"00-00 00:00";
    rightLabel.text = [NSString stringWithFormat:@"时间：%@",self.date];
    rightLabel.adjustsFontSizeToFitWidth = YES;
    [rightLabel setFont:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, 3)];
    [rightLabel setFont:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(3, rightLabel.text.length - 3)];
    [rightLabel setTextColor:[UIColor blackColor] range:NSMakeRange(0, 3)];
    [rightLabel setTextColor:kColor range:NSMakeRange(3, rightLabel.text.length - 3)];
}


- (void)setSpeed:(NSString *)speed{
    _speed = speed;
    
    [self setNeedsLayout];
}

- (void)setDate:(NSString *)date{
    _date = date;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [self setttings];
}

@end
