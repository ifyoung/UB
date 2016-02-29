//
//  MessageCenterCell.m
//  UBI
//
//  Created by 冥皇剑 on 15/9/16.
//  Copyright (c) 2015年 minghuangjian. All rights reserved.
//

#import "MessageCenterCell.h"
#import "ProNewsModel.h"

@implementation MessageCenterCell

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    MessageCenterCell *centerCell = [[[NSBundle mainBundle]loadNibNamed:@"MessageCenterCell" owner:nil options:nil]firstObject];

    //使用xib 重用cell方法,若注册了，xib的第四检查器的Identifier必须与注册的（centerCell）相同或者为空;若不同则会报错。
    [tableView registerNib:[UINib nibWithNibName:@"MessageCenterCell" bundle:nil] forCellReuseIdentifier:@"centerCell"];
    centerCell = [tableView dequeueReusableCellWithIdentifier:@"centerCell"];
    
    return centerCell;
}


-(void)setNewsModel:(ProNewsModel *)newsModel{
    _newsModel = newsModel;
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _imgUrl = _newsModel.imgUrl;
    _read = _newsModel.read;
    _badgeIcon.contentMode = UIViewContentModeCenter;
    _createTime.adjustsFontSizeToFitWidth = YES;
    _line.backgroundColor = IWColor(239, 239, 239);
    
    if (_read == NO) {
        _badgeIcon.image = [UIImage imageNamed:@"未浏览"];
    }else{
        _badgeIcon.image = [UIImage imageNamed:@"已浏览"];
    }
    
    [self getCreateTime];
    NSURL *url = [NSURL URLWithString:_imgUrl];
    [self.messageImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_00"] options:SDWebImageRefreshCached];
}

//获取创建时间
-(void)getCreateTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shenzhen"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:_newsModel.createTime / 1000];
    NSString *createTime = [formatter stringFromDate:confromTimesp];
    self.createTime.text = createTime;
    
}


@end
