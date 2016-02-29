//
//  MyCarManageCell.h
//  UBI
//
//  Created by 冥皇剑 on 15/9/24.
//  Copyright © 2015年 minghuangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BindingCarListModel;
@interface MyCarManageCell : UITableViewCell
/**
 *  汽车图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
/**
 *  车牌号
 */
@property (weak, nonatomic) IBOutlet UILabel *plateNOLabel;
/**
 *  车型
 */
@property (weak, nonatomic) IBOutlet UILabel *carModelLabel;
/**
 *  汽车整体
 */
@property (weak, nonatomic) IBOutlet UIView *carView;
/**
 *  终端SN号
 */
@property (weak, nonatomic) IBOutlet UILabel *SNLabel;
/**
 *  选中标记
 */
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property(nonatomic ,assign)BindingCarListModel *model;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
