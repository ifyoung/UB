//
//  IWantSharePopView.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/19.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import "IWantSharePopView.h"

#define contentHeight 150.0f

@interface IWantSharePopView (){
 
    UIView *bgView;

}

@end
@implementation IWantSharePopView

- (id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if(self){
     
        [self createSubView];
    }
    return self;
}

+ (IWantSharePopView *)showShareViewDelegate:(id)delegate{
 
    IWantSharePopView *shareView = [[self alloc]init];
    shareView.delegate = delegate;
    [shareView show];
    return shareView;
}


- (void)createSubView{

    UIWindow *keywindow = [[UIApplication sharedApplication] windows][0];
    CGRect windowBounds = keywindow.bounds;
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, windowBounds.size.height + contentHeight, windowBounds.size.width, contentHeight)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    
    NSArray *titles = @[@"微信好友",@"朋友圈",@"QQ好友",@"手机短信"];
    for(NSInteger i =0;i < 5;i ++){
    
        if(i < 4){
            CGFloat x = i * windowBounds.size.width / 4.0;
            ShareButton *shbutton = [ShareButton buttonWithType:UIButtonTypeCustom];
            shbutton.frame = CGRectMake(x, 0, windowBounds.size.width / 4.0, contentHeight /2.0);
            shbutton.tag = 500 + i;
            [shbutton setImage:[UIImage imageNamed:titles[i]] forState:UIControlStateNormal];
            shbutton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            shbutton.titleLabel.textAlignment = NSTextAlignmentCenter;
            [shbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [shbutton setTitle:titles[i] forState:UIControlStateNormal];
            [shbutton addTarget:self action:@selector(selctAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:shbutton];
        }else{
        
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(20, contentHeight / 2.0 + 18 , windowBounds.size.width - 40, 40);
            button.tag = 500 + i;
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.borderWidth = 1.0;
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [button setTitle:@"取消" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(selctAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:button];
        }
    }
    
    
    //3.
    self.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    [self addTarget:self
             action:@selector(dismiss)
   forControlEvents:UIControlEventTouchUpInside];
}

- (void)selctAction:(UIButton *)button{

    if(button.tag == 504) {
    
        [self dismiss];
        
        return;
    }
    if([self.delegate respondsToSelector:@selector(didselectPlateform:)] && self.delegate){
    
        [self.delegate didselectPlateform:button.tag];
    }

    [self dismiss];
}

- (void)show{
    UIWindow *keywindow = [[UIApplication sharedApplication] windows][0];
    CGRect windowBounds = keywindow.bounds;
    [keywindow addSubview:self];
    [keywindow addSubview:bgView];
    [UIView animateWithDuration:.35 animations:^{
        bgView.frame = CGRectMake(0, windowBounds.size.height - contentHeight, windowBounds.size.width, contentHeight);
    } completion:^(BOOL finished) {
    }];
}


- (void)dismiss{
    
    UIWindow *keywindow = [[UIApplication sharedApplication] windows][0];
    CGRect windowBounds = keywindow.bounds;
    [UIView animateWithDuration:.35 animations:^{
        
        bgView.frame = CGRectMake(0, windowBounds.size.height + contentHeight, windowBounds.size.width, contentHeight);
        
    } completion:^(BOOL finished){
        
        [self removeAllSubviews];
        [self removeFromSuperview];
        
        [bgView removeAllSubviews];
        [bgView removeFromSuperview];
        
        bgView = nil;
    }];
}
@end





@implementation ShareButton
// 内部图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat w = 40.0f;
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.width - 30;
    return CGRectMake((imageW - w) / 2.0, (imageH - w) / 2.0, w, w);
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
