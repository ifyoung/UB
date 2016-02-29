//
//  StretchMapView.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/2.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, StretchMapViewType) {
    StretchMapViewLastLocation = 0,
    StretchMapViewHistoryLocation
};

@protocol StretchMapViewDelegate <NSObject>

- (void)didSelectStretchMapViewIndex:(NSInteger)index;

@end

@interface StretchMapView : UIView

@property(nonatomic,assign)id<StretchMapViewDelegate>delegate;

- (id)initWithDelegate:(id)delegate type:(StretchMapViewType)type;

@end
