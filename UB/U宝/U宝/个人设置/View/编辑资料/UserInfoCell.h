//
//  UserInfoCell.h
//  赛格车圣
//
//  Created by 冥皇剑 on 15/9/28.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class phoneNumModel;
@interface UserInfoCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath phoneModel:(phoneNumModel *)phoneModel;

@property(nonatomic,strong)UITextField *rightText;

@property(nonatomic,strong)phoneNumModel *model;

@end
