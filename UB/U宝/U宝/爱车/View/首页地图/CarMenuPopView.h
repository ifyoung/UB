//
//  CarMenuPopView.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/9/6.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarMenuPopView;
@protocol CarMenuPopViewDelegate <NSObject>

- (void)didSelectedCarMenuPopView:(CarMenuPopView *)carMenuPopView index:(NSInteger)index;

@end

@interface CarMenuPopView : UIControl

@property(nonatomic,assign)id<CarMenuPopViewDelegate>delegate;

//显示
- (void)show;

- (void)dismiss;

- (void)remove;

- (id)initWithDelegate:(id)deleagte;

@end


@interface CarMenuPopViewItem : UIButton

@end

