//
//  PeccancyCitySeekTBView.m
//  赛格车圣
//
//  Created by 朱鹏 on 15/6/10.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "PeccancyCitySeekTBView.h"

@interface PeccancyCitySeekTBView (){


    
}
@end

@implementation PeccancyCitySeekTBView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if(self){
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)setCityNames:(NSArray *)cityNames{
    _cityNames = cityNames;
    [self reloadData];
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return _cityNames.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"PeccancyCitySeekTBView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = _cityNames[indexPath.row];
    if([[SeekparamModel shareInstance].city isEqualToString:_cityNames[indexPath.row]]){
        cell.accessoryView = [self accessoryViewSelf];
    }else{
        cell.accessoryView = nil;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![[SeekparamModel shareInstance].city isEqualToString:_cityNames[indexPath.row]]){
        if(self.citydelegate && [self.citydelegate respondsToSelector:@selector(didSelectCitys:)]){
            [self.citydelegate didSelectCitys:_cityNames[indexPath.row]];
        }
        [self.viewController.navigationController popViewControllerAnimated:YES];
    }
}

- (UIView *)accessoryViewSelf{
    UIImage *img = [UIImage imageNamed:@"违章查询-问号"];
    UIImageView *imgv = [[UIImageView alloc]initWithImage:[UIImage changeImg:img size:CGSizeMake(30, 30)]];
    return (UIView *)imgv;
}
@end
