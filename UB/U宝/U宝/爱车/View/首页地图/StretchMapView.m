//
//  StretchMapView.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/2.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "StretchMapView.h"

#define StretchWidth  (78 / 2.0 + 6)
#define StretchHeight (190 / 2.0 + 6)

@interface StretchMapView ()

@property(nonatomic,assign)StretchMapViewType type;
@end
@implementation StretchMapView

- (id)initWithDelegate:(id)delegate type:(StretchMapViewType)type{
  
    CGFloat y;
    if(type == StretchMapViewLastLocation){
    
        y = KSCREEHEGIHT  - 64 - 49 - 30 - StretchHeight;
    }else{
    
        y = KSCREEHEGIHT  - 64 - 30 - StretchHeight;
    }
    CGRect frame = CGRectMake(10, y, StretchWidth, StretchHeight);
   
    self = [super initWithFrame:frame];
    
    if(self){
        
        
        self.backgroundColor = [UIColor clearColor];
        self.delegate = delegate;
        
        [self createSubViews];
    }
    return self;
}


- (void)createSubViews{
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    //self.layer.contents = (id)[UIImage imageNamed:@"伸缩地图背景"].CGImage;
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 78 / 2.0, 190 / 2.0)];
    img.backgroundColor = [UIColor clearColor];
    img.contentMode = UIViewContentModeScaleToFill;
    img.userInteractionEnabled = YES;
    img.image = [UIImage imageNamed:@"伸缩地图背景"];
    [self addSubview:img];
    
    

    for(NSInteger  i = 0;i < 2;i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(2, 2 + (img.height  - 4) / 2.0 * i , img.width - 4, (img.height  - 4) / 2.0);
        button.tag = 200 + i;
        button.backgroundColor = [UIColor clearColor];
        if(i == 0){
            [button drawSelectSinGleCornersLeft:YES];
            [button setImage:[UIImage imageNamed:@"伸缩地图加"] forState:UIControlStateNormal];
        }else{
            [button drawSelectSinGleCornersLeft:NO];
            [button setImage:[UIImage imageNamed:@"伸缩地图减"] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(clickdown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [img addSubview:button];
    }
}

- (void)clickdown:(UIButton *)button{
    button.backgroundColor = [UIColor lightGrayColor];
}
- (void)clickAction:(UIButton *)button{
    button.backgroundColor = [UIColor clearColor];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectStretchMapViewIndex:)]){
        [self.delegate didSelectStretchMapViewIndex:button.tag - 200];
    }
}
@end
