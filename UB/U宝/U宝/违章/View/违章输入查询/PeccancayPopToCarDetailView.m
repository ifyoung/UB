//
//  PeccancayPopToCarDetailView.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/6/18.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "PeccancayPopToCarDetailView.h"


@interface PeccancayPopToCarDetailView ()

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIImageView *liceseImgView;
@property(nonatomic,strong)NSArray *titleNames;

@end

@implementation PeccancayPopToCarDetailView

- (id)initWithTitles:(NSArray *)titles type:(PeccancayPopToCarDetailViewType)type{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0.0f, 0.0f, screenBounds.size.width, screenBounds.size.height);
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _titleNames = titles;
        
        if(_type == PeccancayPopToCarList){
        
             [self creatListSubViews];
        }else if (_type == PeccancayPopToCarAlert){
        
             [self createAlertSubViews];
        }else{
        
             [self createLicenseSubViews];
        }
        
        self.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
        [self addTarget:self
                     action:@selector(dismiss)
           forControlEvents:UIControlEventTouchUpInside];
        }
    return self;
}



/*
 *  PeccancayPopToCarList
 */
- (void)creatListSubViews{
    _bgView = [[UIView alloc]initWithFrame:CGRectZero];
    _bgView.layer.cornerRadius = 4;
    _bgView.layer.masksToBounds = YES;
    _bgView.backgroundColor = [UIColor whiteColor];
}

/*
 *  PeccancayPopToCarDrivingLicense
 */
- (void)createAlertSubViews{


}

/*
 *  PeccancayPopToCarDrivingLicense
 */
- (void)createLicenseSubViews{
    _liceseImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
}




//显示
- (void)show{
    UIWindow *keywindow = [[UIApplication sharedApplication] windows][0];
    [keywindow addSubview:self];
    CGSize winSize = [UIScreen mainScreen].bounds.size;

    if(_type == PeccancayPopToCarList){
        
        _bgView.frame = CGRectMake((winSize.width - kCenterPopupListViewWidth)/2.0f,
                                      (winSize.height-kCenterPopupListViewHeight)/2.0f,
                                      kCenterPopupListViewWidth,
                                      kCenterPopupListViewHeight);
        
        for(NSInteger i = 0;i < _titleNames.count;i++){
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, _bgView.height / 2.0 * i, _bgView.width, _bgView.height / 2.0);
            [button setTitle:_titleNames[i] forState:UIControlStateNormal];
            button.tag = 300 + i;
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_bgView addSubview:button];
        }
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, _bgView.height / 2.0, _bgView.width - 20, .5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_bgView addSubview:lineView];
        
        [self addSubview: _bgView];
        
        _bgView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        _bgView.alpha = 0;
        
        [UIView animateWithDuration:kDefalutPopupAnimationDuration animations:^{
            _bgView.alpha = 1;
            _bgView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }else if (_type == PeccancayPopToCarAlert){
    

    }else{
    
        float imgwidth = 150 / 2.0 * 3;
        float imgheight = 91.5 / 2.0 * 3;
        UIImage *img = [UIImage imageNamed:@"发动机车架号提示样例"];
        _liceseImgView.frame = CGRectMake((KSCREEWIDTH - imgwidth ) / 2.0, (KSCREEHEGIHT - imgheight) / 2.0, imgwidth , imgheight);
        _liceseImgView.image = img;
        
        NSLog(@"%f",img.size.width);
        NSLog(@"%f",img.size.height);
        [self addSubview:_liceseImgView];
        
        _liceseImgView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        _liceseImgView.alpha = 0;
        
        [UIView animateWithDuration:kDefalutPopupAnimationDuration animations:^{
            _liceseImgView.alpha = 1;
            _liceseImgView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }
}




- (void)buttonAction:(UIButton *)button{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectIndex:)]){
        [self.delegate didSelectIndex:button.tag - 300];
    }
    
    [self dismiss];
}


- (void)dismiss{
    [self removeAllSubviews];
    [self removeFromSuperview];
}
@end
