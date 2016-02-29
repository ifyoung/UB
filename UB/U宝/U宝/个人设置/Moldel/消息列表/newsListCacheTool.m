//
//  newsListCacheTool.m
//  U宝
//
//  Created by 冥皇剑 on 15/11/18.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import "newsListCacheTool.h"
#import "FMDB.h"
#import "ProNewsModel.h"

@implementation newsListCacheTool

static FMDatabase *_db;
+ (void)initialize
{
    // 0.获得沙盒中的数据库文件名
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"news.sqlite"];
    // NSLog(@"%@",path);
    // 1.创建队列
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    // 2.创表
    [_db executeUpdate:@"create table if not exists News_List (id integer primary key autoincrement, newsID integer, NewsModel blob);"];

}

+(void)saveNews:(NSArray *)news{
    for (ProNewsModel *carModel in news) {
        [self addNewsModel:carModel];
    }

}

+(void)addNewsModel:(ProNewsModel *)proNewsModel{
    
        // 1.获得需要存储的数据
        NSNumber *newsID =  [NSNumber numberWithLong:proNewsModel.id];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:proNewsModel];
        
        // 1.执行查询语句
        FMResultSet *resultSet = [_db executeQuery:@"select * from News_List where newsID = ?;",newsID];
        
        // 2.遍历结果
        while ([resultSet next]) {
            [_db executeUpdate:@"delete from News_List where newsID = ?;",newsID];
        }
        
        // 2.存储数据
        [_db executeUpdate:@"insert into News_List (newsID, NewsModel) values(?, ?);",newsID, data];

}

+(NSMutableArray *)readNewsModel{
    
    // 1.定义数组
    __block NSMutableArray *newsArray = nil;
    // 2.使用数据库
        // 2.0.创建数组
        newsArray = [NSMutableArray array];
        // 2.1.执行查询语句
        FMResultSet *resultSet = [_db executeQuery:@"select * from News_List;"];
        // 2.2.遍历结果
        while ([resultSet next]) {
            NSData *data = [resultSet dataForColumn:@"NewsModel"];
            ProNewsModel *newsModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [newsArray addObject:newsModel];
        }
    
    // 3.返回数据
    return newsArray;
}

+ (void)deleteNewsModelWithNewsID:(long)newsID{
    
    NSNumber *news = [NSNumber numberWithLong:newsID];
        [_db executeUpdate:@"delete from News_List where newsID = ?;",news];

}


+ (void)deleteAllNews{
    
        [_db executeUpdate:@"delete from News_List;"];
}

@end
