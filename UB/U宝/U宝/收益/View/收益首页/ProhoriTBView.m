//
//  ProhoriTBView.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/31.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "ProhoriTBView.h"

@implementation ProhoriTBView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
   
        //逆时针旋转90度
        self.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
        //重新设定当前的frame
        self.frame = frame;
        
        [self setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        //去掉滑动指示器
        self.showsVerticalScrollIndicator = YES;
        
        //去掉分割线
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.pagingEnabled = YES;
        
        self.bounces = YES;
        
        self.rowHeight = KSCREEWIDTH;
    }
    
    return self;
}
@end
