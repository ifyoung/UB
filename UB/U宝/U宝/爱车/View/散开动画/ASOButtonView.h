//
//  ASOButtonView.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/2.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

@interface ASOButtonViewItem : UIButton
@end


typedef NS_ENUM(NSInteger, ASOButtonViewType) {
    ASOButtonViewTypeNormal = 0,
    ASOButtonViewHistoricalTrack,
    ASOButtonViewHistoricalTrack1
};


#import "ASOBounceButtonView.h"

@interface ASOButtonView : ASOBounceButtonView

@property(nonatomic,assign)ASOButtonViewType type;
@property(nonatomic,assign)CGRect  boundFrame;
@property(nonatomic,assign)NSInteger selectIndex;

@end

