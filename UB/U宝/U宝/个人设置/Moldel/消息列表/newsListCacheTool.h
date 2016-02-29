//
//  newsListCacheTool.h
//  U宝
//
//  Created by 冥皇剑 on 15/11/18.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProNewsModel;
@interface newsListCacheTool : NSObject

/**
 *  存储消息数据到沙盒中
 *
 *  @param news 消息数据
 */
+(void)saveNews:(NSArray *)news;


/**
 *  添加消息模型
 *
 *  @param proNewsModel 消息模型
 */
+(void)addNewsModel:(ProNewsModel *)proNewsModel;

/**
 *  查询消息
 *
 *  @return 消息模型数组
 */
+(NSMutableArray *)readNewsModel;

/**
 *  删除一条消息
 */
+ (void)deleteNewsModelWithNewsID:(long)newsID;

/**
 *  删除所有消息
 */
+ (void)deleteAllNews;

@end
