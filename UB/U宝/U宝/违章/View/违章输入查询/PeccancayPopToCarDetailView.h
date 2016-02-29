//
//  PeccancayPopToCarDetailView.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/6/18.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCenterPopupListViewHeight 80.0f
#define kCenterPopupListViewWidth  200.0f
#define kDefalutPopupAnimationDuration 0.1f


typedef NS_ENUM(NSInteger, PeccancayPopToCarDetailViewType) {
    PeccancayPopToCarList = 0,
    PeccancayPopToCarAlert,
    PeccancayPopToCarDrivingLicense
};


@protocol PeccancayPopToCarDetailViewDelegate <NSObject>

- (void)didSelectIndex:(NSInteger)index;

@end

@interface PeccancayPopToCarDetailView : UIControl


@property(nonatomic,assign)id<PeccancayPopToCarDetailViewDelegate>delegate;
@property(nonatomic,assign)PeccancayPopToCarDetailViewType type;


- (id)initWithTitles:(NSArray *)titles type:(PeccancayPopToCarDetailViewType)type;


//显示
- (void)show;


- (void)dismiss;


@end
