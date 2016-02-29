//
//  SettingCell.m
//  UBI
//
//  Created by 冥皇剑 on 15/9/21.
//  Copyright © 2015年 minghuangjian. All rights reserved.
//

#import "SettingCell.h"

@interface SettingCell ()

@property(nonatomic,strong)NSArray *leftTitles;
@property(nonatomic,strong)NSArray *rightTitles;

@end

@implementation SettingCell

#pragma mark - lazy
-(NSArray *)rightTitles{
    if (_rightTitles == nil) {
        _rightTitles = @[@[@"暂无风险记录"],@[@"本机",[self whetherOrNotNotice]],@[@""],@[@""]];
    }
    return _rightTitles;
}

-(NSArray *)leftTitles{
    if (_leftTitles == nil) {
        
        //只能获取机型，不能获取详细型号
//        NSString *iPhoneModel = [UIDevice currentDevice].model;
//        NSLog(@"iPhoneModel=%@",iPhoneModel);
        
        NSString *iPhoneModel = [UIDevice currentDevice].machine;
        _leftTitles = @[@[@"账户安全情况"],@[iPhoneModel,@"接收消息通知"],@[@"修改用户密码"],@[@"修改预留手机"]];
    }
    return _leftTitles;
}



+(instancetype)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
        //cell右边label
        CGFloat w = 110;
        CGFloat x = KSCREEWIDTH - w -10;
        CGFloat y = 0;
        CGFloat h = cell.contentView.height;
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        rightLabel.tag = 20;
        [cell.contentView addSubview:rightLabel];
    }
    
    //cell右边label
    UILabel *rightLabel = (UILabel *)[cell.contentView viewWithTag:20];
    rightLabel.text = cell.rightTitles[indexPath.section][indexPath.row];
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.textColor = [UIColor lightGrayColor];
    
    cell.textLabel.text = cell.leftTitles[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 2 || indexPath.section == 3) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else if (indexPath.section == 1 && indexPath.row == 0){
                cell.imageView.image = [UIImage imageNamed:@"iphone"];
                [cell getNow:cell];
            }
    
    return cell;
}

/**
 *  获取当前时间
 *
 *  @param cell 把cell传过来
 */
-(void)getNow:(UITableViewCell *)cell{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shenzhen"];
    [formatter setTimeZone:timeZone];
    
    NSDate *now = [NSDate date];
    NSString *nowStr = [formatter stringFromDate:now];
    cell.detailTextLabel.text = nowStr;

}

/**
 *  判断接收通知消息状态是否开启
 *
 *  @return 开启状态
 */
-(NSString *)whetherOrNotNotice{

#ifdef __IPHONE_8_0
    
        UIUserNotificationType type = [UIApplication sharedApplication]. currentUserNotificationSettings.types;
        return type == UIUserNotificationTypeNone ? @"未开启" :@"已开启";
        
#else
        UIRemoteNotificationType type = [UIApplication sharedApplication].enabledRemoteNotificationTypes;
        return type == UIRemoteNotificationTypeNone ? @"未开启" :@"已开启";
#endif

}


@end
