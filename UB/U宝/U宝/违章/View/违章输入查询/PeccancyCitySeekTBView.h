//
//  PeccancyCitySeekTBView.h
//  赛格车圣
//
//  Created by 朱鹏 on 15/6/10.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PeccancyCitySeekTBViewDelegate <NSObject>

- (void)didSelectCitys:(NSString *)city;

@end

@interface PeccancyCitySeekTBView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSArray *cityNames;

@property(nonatomic,assign)id<PeccancyCitySeekTBViewDelegate>citydelegate;

@end
