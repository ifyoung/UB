//
//  CarMenuPopView.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/9/6.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "CarMenuPopView.h"

@interface CarMenuPopView (){
 
    CAShapeLayer *layer;
}

@property(nonatomic,strong)UIView *bgView;

@end

@implementation CarMenuPopView

- (id)initWithDelegate:(id)deleagte{
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0.0f, 0.0f, screenBounds.size.width, screenBounds.size.height - 49);
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = deleagte;

        _bgView = [[UIView alloc]initWithFrame:CGRectZero];
        //_bgView.backgroundColor = [UIColor redColor];
        
        self.clipsToBounds = YES;
        self.backgroundColor =  [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
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
    
    _bgView.frame = CGRectMake(0 ,self.bottom ,self.width,20 + KSCREEWIDTH  * 80 / 320.0);

    
    
    NSArray *titleNames = @[@"爱车历史轨迹",@"爱车里程统计",@"爱车行程统计"];
    for(NSInteger i = 0;i < titleNames.count;i++){
        
        CGFloat imgWidth = KSCREEWIDTH / 3.0;
        CGFloat imgHeight = KSCREEWIDTH * 80 / 320.0;
        
        CGFloat imgX =  i * imgWidth;
        CGFloat imgY =  20;
        
        CarMenuPopViewItem *button = [CarMenuPopViewItem buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        button.tag = 500 + i;
        button.frame = CGRectMake(imgX, imgY, imgWidth, imgHeight);
        button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:[titleNames[i] substringWithRange:NSMakeRange(2, [titleNames[i] length] - 2)] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:titleNames[i]] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:button];
    }
 
    
//    if(layer == nil){
//        
//        layer = [CAShapeLayer layer];
//        layer.fillColor = [UIColor greenColor].CGColor;
//        UIBezierPath *path = [UIBezierPath bezierPath];
//        [path addArcWithCenter:CGPointMake(_bgView.center.x, 140 / 4.0) radius:140 / 4.0 startAngle:0 endAngle:M_PI clockwise:NO];
//        layer.path = path.CGPath;
//    }
//    
//    //[_bgView.layer addSublayer:layer];
//    
    
    //爱车位置下箭头
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(_bgView.center.x - 140 / 4.0, 2, 140 / 2.0, 20)];
    img.userInteractionEnabled = YES;
    img.image = [UIImage imageNamed:@"爱车位置下箭头"];
    [_bgView addSubview:img];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [img addGestureRecognizer:tap];
    
    
    [self addSubview: _bgView];
    [UIView animateWithDuration:.35 animations:^{
         _bgView.bottom = self.bottom;
    }];
}

- (void)tapAction{

}


- (void)buttonAction:(UIButton *)button{
    
    
    _bgView.top = self.bottom;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectedCarMenuPopView:index:)]){
    
        [self.delegate didSelectedCarMenuPopView:self index:button.tag - 500];
    }
    
    [self removeAllSubviews];
    [self removeFromSuperview];
}


- (void)dismiss{
    [UIView animateWithDuration:.35 animations:^{
    
        
        _bgView.alpha = 0;
        _bgView.top = self.bottom;
        
    } completion:^(BOOL finished) {
        
        [self removeAllSubviews];
        [self removeFromSuperview];
    }];
}

- (void)remove{
    _bgView.alpha = 0;
    [self removeAllSubviews];
    [self removeFromSuperview];
}

@end



@implementation CarMenuPopViewItem
// 内部图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 28;
    CGFloat imageH = 28;
    return CGRectMake((contentRect.size.width - imageW) / 2.0, contentRect.size.width  / 2.0 - imageH - 10, imageW, imageH);
}
// 内部文字的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height - 30;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = 20;
    return CGRectMake(0, titleY, titleW, titleH);
}
@end
