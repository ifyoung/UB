//
//  PeccancyProvinceView.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/6/19.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PeccancyProvinceViewDelegate <NSObject>

- (void)didSelectProvince:(NSString *)province;

@end
@interface PeccancyProvinceView : UIControl

@property(nonatomic,assign)id<PeccancyProvinceViewDelegate>delegate;

//显示
- (void)show;


@end
