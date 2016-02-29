//
//  MessageCenterCell.h
//  UBI
//
//  Created by 冥皇剑 on 15/9/16.
//  Copyright (c) 2015年 minghuangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProNewsModel;
@interface MessageCenterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *badgeIcon;
@property (weak, nonatomic) IBOutlet UILabel *createTime;

@property (weak, nonatomic) IBOutlet UIImageView *messageImg;
@property (weak, nonatomic) IBOutlet UIView *line;

@property(nonatomic,assign,getter=isRead)BOOL read;
@property (nonatomic,strong)NSString *imgUrl;
@property (nonatomic,strong)ProNewsModel *newsModel;

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
