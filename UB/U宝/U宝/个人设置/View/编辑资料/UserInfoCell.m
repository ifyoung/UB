//
//  UserInfoCell.m
//  赛格车圣
//
//  Created by 冥皇剑 on 15/9/28.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import "UserInfoCell.h"
#import "phoneNumModel.h"

@interface UserInfoCell ()
/**
 *  右边默认label数组
 */
@property(nonatomic,strong)NSArray *rightTitles;
/**
 *  左边label数组
 */
@property(nonatomic,strong)NSArray *leftTitles;

/**
 *  手机号码
 */
@property(nonatomic,strong)NSString *callLetter;



@end

@implementation UserInfoCell


//重写set方法设置cell的y偏移量
//-(void)setFrame:(CGRect)frame{
//    frame.origin.y -=10;
//    [super setFrame:frame];
//}

//-(void)setModel:(phoneNumModel *)model{
//    _model = model;
//    [self setNeedsLayout];
//}
//
//-(void)layoutSubviews{
//    [super layoutSubviews];
//    [self settings];
//}
//
//-(void)settings{
//    _callLetter = _model.callLetter;
//}

#pragma mark - lazy
- (NSArray *)leftTitles{
    if(!_leftTitles){
        _leftTitles = @[@[@"姓名："],@[@"所在地：",@"手机："]];
        
    }
    return _leftTitles;
}


-(NSArray *)rightTitles{
    if(!_rightTitles){
        //获取定位城市
      NSString *location = [SFHFKeychainUtils getPasswordForUsername:@"UserLocationCity" andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL];
        //获取手机号码，即账户名
        NSString *callLetter = [SFHFKeychainUtils getPasswordForUsername:KCSUBUSERACCOUNT andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:nil];
        if (location == nil) {
            _rightTitles = @[@[@"U宝君"],@[@"定位失败",callLetter]];
        }else{
        _rightTitles = @[@[@"U宝君"],@[location,callLetter]];
        }
    }
    return _rightTitles;
}


+(instancetype)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath phoneModel:(phoneNumModel *)phoneModel{
    
    static NSString *identifier = @"PersonalSettingsVCCell";
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[self alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        
        CGFloat w = KSCREEWIDTH;
        CGFloat h = cell.contentView.height;
        CGFloat x = 0;
        CGFloat y = 0;

        UITextField *rightText = [[UITextField alloc]initWithFrame:CGRectMake(x, y, w, h)];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, w)];
        rightText.leftView = view;
        rightText.leftViewMode = UITextFieldViewModeAlways;
        rightText.tag = 200;
        [cell.contentView addSubview:rightText];
    }
    
    
    cell.textLabel.text = cell.leftTitles[indexPath.section][indexPath.row];
    cell.rightText = (UITextField *)[cell.contentView viewWithTag:200];
    
    if (indexPath.section == 0) {
        cell.rightText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [cell.rightText addTarget:cell action:@selector(changeName) forControlEvents:UIControlEventEditingChanged];
    }
    
//    cell.model = phoneModel;
    
    cell.rightText.text = cell.rightTitles[indexPath.section][indexPath.row];
    
    NSString *name = [[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
    if (name && indexPath.section == 0) {
        cell.rightText.text = name;
    }
    
    cell.rightText.allowsEditingTextAttributes = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 1) {
        
        cell.userInteractionEnabled = NO;
    }
    return cell;
    
}


//监听文本框内容并保存
-(void)changeName{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.rightText.text forKey:@"name"];
    [defaults synchronize];
    
}


@end
