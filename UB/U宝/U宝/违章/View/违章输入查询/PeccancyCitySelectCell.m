//
//  PeccancyCitySelectCell.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/6/26.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "PeccancyCitySelectCell.h"

@interface PeccancyCitySelectCell ()

{
    
    UILabel *leftLabel;
    UILabel *rightLabel;
}
@end
@implementation PeccancyCitySelectCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"PeccancyCitySelectCell";
    PeccancyCitySelectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PeccancyCitySelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        [self createSubViews];
    }
    return self;
}



- (void)createSubViews{
    
    leftLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    leftLabel.font = [UIFont systemFontOfSize:13.0f];
    leftLabel.text = @"违章城市";
    [self.contentView addSubview:leftLabel];
    
    rightLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    
    rightLabel.textColor = kColor;
    rightLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:rightLabel];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    leftLabel.frame = CGRectMake(10, 0, 60, self.height);
    rightLabel.frame = CGRectMake(leftLabel.right + 20, 0,KSCREEWIDTH - leftLabel.right - 20 - 60, self.height);
    
//    NSMutableArray *citys = [SeekparamModel shareInstance].citys;
//    NSString *city = @"";
//    for(NSString *str in citys){
//        
//        city = [city stringByAppendingFormat:@" %@",str];
//    }
    rightLabel.text =  [SeekparamModel shareInstance].city;
}
@end
