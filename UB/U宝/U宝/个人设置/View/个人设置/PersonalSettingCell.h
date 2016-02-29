//
//  PersonalSettingCell.h
//  赛格车圣
//
//  Created by 冥皇剑 on 15/10/10.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalSettingCell : UITableViewCell

/**cell标题*/
@property(nonatomic,strong)NSArray *leftTitles;
@property(nonatomic,strong)UIImageView *badgeIcon;

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
-(void)createBadgeView;
@end
