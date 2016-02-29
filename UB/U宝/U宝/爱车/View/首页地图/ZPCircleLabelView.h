//
//  ZPCircleLabelView.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/2.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPCircleLabelView : UIView

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *text1;
@property (strong, nonatomic) NSDictionary *textAttributes;
@property (strong, nonatomic) NSDictionary *textAttributes1;

@property (nonatomic) NSTextAlignment textAlignment;

@property (nonatomic) float radius;

@property (nonatomic) float baseAngle;
@property (nonatomic) float characterSpacing;

- (void)startAnimation;


@end
