//
//  PersonalSettingsHeadrerView.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/21.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalSettingsHeadrerView : UIView
/**用户头像*/
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
/**用户昵称*/
@property (weak, nonatomic) IBOutlet UILabel *name;
/**上次登陆时间*/
@property (weak, nonatomic) IBOutlet UILabel *time;
/**车牌号*/
@property (weak, nonatomic) IBOutlet UILabel *plateNo;
@property (weak, nonatomic) IBOutlet UILabel *current;
@end
