//
//  HelpCell.h
//  车圣U宝
//
//  Created by 冥皇剑 on 15/11/3.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuestionFrameModel;

@interface HelpCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong)QuestionFrameModel *questionFrameModel;
@property(nonatomic,strong)NSArray *answers;
@end
