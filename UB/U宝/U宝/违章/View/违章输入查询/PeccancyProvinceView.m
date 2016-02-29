//
//  PeccancyProvinceView.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/6/19.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "PeccancyProvinceView.h"


@interface PeccancyProvinceView ()

@property(nonatomic,strong)NSArray *titleNames;
@property(nonatomic,strong)UIView *bgView;

@end


@implementation PeccancyProvinceView

- (id)init{
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0.0f, 0.0f, screenBounds.size.width, screenBounds.size.height);
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleNames = @[@"京",@"沪",@"浙",@"苏",@"粤",@"鲁",@"晋",@"冀",@"豫",
                        
                        @"川",@"渝",@"辽",@"吉",@"黑",@"皖",@"鄂",@"湘",@"赣",
                        
                        @"闽",@"陕",@"甘",@"宁",@"蒙",@"津",@"贵",@"云",@"桂",
                        
                        @"琼",@"青",@"新",@"藏"
                        ];
        
        _bgView = [[UIView alloc]initWithFrame:CGRectZero];
        _bgView.backgroundColor = IWColor(216, 220, 223);
        
        self.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
        [self addTarget:self
                 action:@selector(dismiss)
       forControlEvents:UIControlEventTouchUpInside];
    }

    return self;
}


//显示
- (void)show{
    UIWindow *keywindow = [[UIApplication sharedApplication] windows][0];
    [keywindow addSubview:self];
    CGSize winSize = [UIScreen mainScreen].bounds.size;
        
        _bgView.frame = CGRectMake(0 ,0 ,winSize.width,200);
        _bgView.top = winSize.height;
         for(NSInteger i = 0;i < _titleNames.count;i++){
            
            CGFloat imgWidth = (KSCREEWIDTH  -  5 * 10) / 9.0;
            CGFloat imgHeight = (200 -  25) / 4.0;
             
            CGFloat imgX =  5 + (imgWidth + 5) * (i % 9);
            CGFloat imgY =  5 + (imgHeight + 5) * (i / 9);
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
           
            button.frame = CGRectMake(imgX, imgY, imgWidth, imgHeight);
            [button setTitle:_titleNames[i] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
             button.layer.cornerRadius = 3;
             button.layer.masksToBounds = YES;
             [button addShadow];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_bgView addSubview:button];
        }
    
        
        [self addSubview: _bgView];
        
    
        _bgView.alpha = 0;
        
        [UIView animateWithDuration:.35 animations:^{
            _bgView.alpha = 1;
            _bgView.bottom = winSize.height;
        }];
}



- (void)buttonAction:(UIButton *)button{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectProvince:)]){
        [self.delegate didSelectProvince:button.titleLabel.text];
    }
    
    [self dismiss];
}


- (void)dismiss{
    [UIView animateWithDuration:.35 animations:^{
        
        _bgView.alpha = 0;
        _bgView.top =  [UIScreen mainScreen].bounds.size.height;

    } completion:^(BOOL finished) {
        
        [self removeAllSubviews];
        [self removeFromSuperview];
    }];
    
}

@end
