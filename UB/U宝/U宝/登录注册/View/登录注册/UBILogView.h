//
//  UBILogView.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/20.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UBILogView : UIView

@property(nonatomic,copy)NSString *user;
@property(nonatomic,copy)NSString *code;

+ (UBILogView *)shareUBILogView;

@end
