//
//  SafeDriveItem.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/25.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import "SafeDriveItem.h"


@interface SafeDriveItem (){
  
    UILabel *topLabel;
    UILabel *middlel;
    UIImageView *bottomImg;
    UILabel *bottomLabel;
    
}
@end


@implementation SafeDriveItem

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
    
        [self createSubViews];
    }
    return self;
}


- (void)createSubViews{
    UIImageView *bottomIm = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:bottomIm];
    bottomImg = bottomIm;
    
    UILabel *bottomLa = [[UILabel alloc]initWithFrame:CGRectZero];
    bottomLa.textAlignment = NSTextAlignmentCenter;
    bottomLa.textColor = IWColor(74, 75, 75);
    bottomLa.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:bottomLa];
    bottomLabel = bottomLa;
    
    UILabel *midd = [[UILabel alloc]initWithFrame:CGRectZero];
    midd.textAlignment = NSTextAlignmentCenter;
    midd.textColor = [UIColor lightGrayColor];
    midd.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:midd];
    middlel = midd;
    
    UILabel  *topLa = [[UILabel alloc]initWithFrame:CGRectZero];
    topLa.textAlignment = NSTextAlignmentCenter;
    [self addSubview:topLa];
    topLabel = topLa;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];

    
    CGFloat imgW = 20;
    bottomImg.frame = CGRectMake(0, self.height - 30, imgW, imgW);
    bottomImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"驾驶明细%@",_title]];
    
    bottomLabel.frame = CGRectMake(0, bottomImg.top,10,20);
    bottomLabel.text = _title;
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:13.0f]};
    CGSize size = [_title boundingRectWithSize:CGSizeMake(KSCREEWIDTH, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    bottomLabel.width = size.width;
    
    CGFloat total = self.width -  (20 + size.width + 10);
    bottomImg.left = total / 2.0;
    bottomLabel.left = bottomImg.right + 10;
    
    
    
    topLabel.frame = CGRectMake(0, 0, self.width,self.height / 2.0 / 2.0);
    topLabel.bottom = self.height / 2.0;
    topLabel.font = [UIFont systemFontOfSize:28];
    topLabel.adjustsFontSizeToFitWidth = YES;
    topLabel.text = [NSString stringWithFormat:@"%@%@",_number,_unit];
    [topLabel setFont:[UIFont systemFontOfSize:12.0] range:NSMakeRange(topLabel.text.length - _unit.length,_unit.length)];
    [topLabel setTextColor:IWColor(74, 75, 75) range:NSMakeRange(topLabel.text.length - _unit.length,_unit.length)];
    
    
    if(_hidemiddle){
        middlel.hidden = YES; return;
    }
    middlel.frame = CGRectMake(0, 0, self.width, 15);
    middlel.center = CGPointMake(self.width / 2.0, self.height / 2.0 + 15);
    middlel.text =  [NSString stringWithFormat:@"(%@次/100km)",self.speedUpOrDownSVG];
}
@end
