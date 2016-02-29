//
//  HelpView.h
//  车圣U宝
//
//  Created by 冥皇剑 on 15/11/3.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeaderView,QuestionModel;

@protocol HeaderViewDelegate <NSObject>

@optional
- (void)headerViewDidClickHeaderView:(HeaderView *)headerView;

@end

@interface HeaderView : UITableViewHeaderFooterView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)NSString *question;
@property(nonatomic,weak)id <HeaderViewDelegate>delegate;

@property(nonatomic,strong)QuestionModel *questionGroup;

@end
