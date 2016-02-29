//
//  PersonalSettingCell.m
//  赛格车圣
//
//  Created by 冥皇剑 on 15/10/10.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import "PersonalSettingCell.h"

@interface PersonalSettingCell ()

@property(nonatomic,strong)UIImageView *accessoryImg;

@end

@implementation PersonalSettingCell


+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"PersonalCell";
    PersonalSettingCell *personalCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (personalCell == nil) {
        personalCell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        personalCell.backgroundView = nil;
        personalCell.backgroundColor = [UIColor clearColor];
        personalCell.contentView.backgroundColor = [UIColor clearColor];
        personalCell.selectionStyle = UITableViewCellSelectionStyleBlue;

        personalCell.textLabel.highlightedTextColor = kColor;
        personalCell.textLabel.backgroundColor = [UIColor clearColor];
        
        //accessoryView
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.frame = CGRectMake(0, 0, 12, 12);
        imgView.contentMode = UIViewContentModeCenter;
        imgView.image = [UIImage imageNamed:@"未触发"];
        imgView.highlightedImage = [UIImage imageNamed:@"触发时"];
        personalCell.accessoryImg = imgView;
        personalCell.accessoryView = personalCell.accessoryImg;
        personalCell.accessoryView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        personalCell.accessoryView.clipsToBounds = YES;
        
        //cell分割线
        UIView *line = [[UIView alloc]init];
        CGFloat x = 50;
        line.frame = CGRectMake(x, personalCell.height - 1, tableView.width - 1.5 * x, 1);
        line.backgroundColor = IWColor(217, 218, 219);
        [personalCell.contentView addSubview:line];
    }
    
    personalCell.textLabel.text = personalCell.leftTitles[indexPath.row];
    personalCell.textLabel.textColor = IWColor(119, 120, 121);
    switch (indexPath.row) {
        case 0:
            personalCell.imageView.image = [UIImage imageNamed:@"爱车管理"];
            personalCell.imageView.highlightedImage = [UIImage imageNamed:@"爱车管理蓝色"];
            break;
        case 1:
            personalCell.imageView.image = [UIImage imageNamed:@"消息中心"];
            personalCell.imageView.highlightedImage = [UIImage imageNamed:@"消息中心蓝色"];
            [personalCell createBadgeView];
            break;
        case 2:
            personalCell.imageView.image = [UIImage imageNamed:@"反馈"];
            personalCell.imageView.highlightedImage = [UIImage imageNamed:@"反馈蓝色"];

            break;
        case 3:
            personalCell.imageView.image = [UIImage imageNamed:@"帮助"];
            personalCell.imageView.highlightedImage = [UIImage imageNamed:@"帮助蓝色"];
            break;
        case 4:
            personalCell.imageView.image = [UIImage imageNamed:@"设置"];
            personalCell.imageView.highlightedImage = [UIImage imageNamed:@"设置蓝色"];
            break;
            
    }

    return personalCell;
}

- (NSArray *)leftTitles{
    if(!_leftTitles){
        _leftTitles = @[@"爱车管理",@"消息中心",@"反馈建议",@"帮助",@"设置"];
    }
    return _leftTitles;
}

//提示小红点
-(void)createBadgeView{
    
    BOOL isClick = [[NSUserDefaults standardUserDefaults] boolForKey:@"isClick"];
    
    if (!isClick) {
        
        UIImageView * badgeView = [[UIImageView alloc]init];
        CGFloat w = 8;
        CGFloat h = 8;
        CGFloat x = 16;
        CGFloat y = -3;
        badgeView.frame = CGRectMake(x, y, w, h);
        badgeView.image = [UIImage imageNamed:@"椭圆-2"];
        self.badgeIcon = badgeView;
        [self.imageView addSubview:self.badgeIcon];
    }
    
}


@end
