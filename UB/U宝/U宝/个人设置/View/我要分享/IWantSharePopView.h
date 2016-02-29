//
//  IWantSharePopView.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/19.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol IWsharedelegate <NSObject>

- (void)didselectPlateform:(NSInteger)index;

@end

@interface IWantSharePopView : UIControl

@property(nonatomic,weak)id<IWsharedelegate>delegate;

+ (IWantSharePopView *)showShareViewDelegate:(id)delegate;

@end




@interface ShareButton : UIButton
@end
