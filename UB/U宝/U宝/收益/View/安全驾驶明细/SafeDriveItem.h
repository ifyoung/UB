//
//  SafeDriveItem.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/25.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SafeDriveItem : UIView


@property(nonatomic,copy)  NSString *number;
@property(nonatomic,copy)  NSString *unit;
@property(nonatomic,copy)  NSString *title;
@property(nonatomic,copy)  NSString *speedUpOrDownSVG;
@property(nonatomic,assign)BOOL hidemiddle;

@end
