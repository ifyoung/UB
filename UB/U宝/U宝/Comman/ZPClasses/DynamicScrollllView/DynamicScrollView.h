//
//  DynamicScrollView.h
//  MeltaDemo
//
//  Created by hejiangshan on 14-8-27.
//  Copyright (c) 2014年 hejiangshan. All rights reserved.
//


#import <UIKit/UIKit.h>


@protocol DynamicScrollViewDelegate <NSObject>

- (void)didDeleteWithCity:(NSString *)city;

@end

@interface DynamicScrollView : UIView

@property(nonatomic,assign)id<DynamicScrollViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)images;

//添加一个新图片
- (void)addImageView:(NSString *)imageName;


@end
