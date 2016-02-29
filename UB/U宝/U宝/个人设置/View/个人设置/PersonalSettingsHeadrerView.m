//
//  PersonalSettingsHeadrerView.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/21.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "PersonalSettingsHeadrerView.h"

@implementation PersonalSettingsHeadrerView


- (void)awakeFromNib{
    [super awakeFromNib];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imgData = [defaults objectForKey:@"userImg"];
    self.userImg.contentMode = UIViewContentModeScaleAspectFill;
    if (imgData) {
        self.userImg.image = [UIImage imageWithData:imgData];
    }else{
        self.userImg.image = [UIImage imageNamed:@"组-21"];
    }
    NSString *name= [defaults objectForKey:@"name"];
    if (name) {
        self.name.text = name;
    }else{
        self.name.text = @"U宝君";
    }
    
    self.plateNo.textColor = IWColor(27, 162, 230);
    self.plateNo.text = [CurrentDeviceModel shareInstance].plateNo;
    
    NSString *timeStr = [NSString stringWithFormat:@"上次登录：%@",[ZPUiutsHelper getlastLoginTimeFromNowMobile]];
    self.time.text = timeStr;
    //根据宽度适应字体大小
    self.time.adjustsFontSizeToFitWidth = YES;
    self.current.adjustsFontSizeToFitWidth = YES;
    self.plateNo.adjustsFontSizeToFitWidth = YES;
}



- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
}





@end
