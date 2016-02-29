//
//  ProNewsModel.h
//  车圣U宝
//
//  Created by 朱鹏的Mac on 15/11/5.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProNewsModel : NSObject

/*
createTime = 1446690189000;
id = 1;
imgUrl = "http://ww2.sinaimg.cn/bmiddle/699d71c9jw1exopx6xrkqj20u01hcwm0.jpg";
url = "http://mp.weixin.qq.com/s?__biz=MjM5NjI4OTU3OQ==&mid=400452217&idx=1&sn=8b69df74e7f028e9f17754bad7bd8ff7#rd";
*/

@property (nonatomic,assign)double createTime;
@property (nonatomic,assign)long   id;
@property (nonatomic,copy)NSString *imgUrl;
@property (nonatomic,copy)NSString *url;
/**
 *  是否已读
 */
@property(nonatomic,assign,getter=isRead)BOOL read;

@end
