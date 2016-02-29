//
//  ProceedsTotailCacheTool.m
//  车圣U宝
//
//  Created by 朱鹏的Mac on 15/10/22.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import "ProceedsTotailCacheTool.h"
#import "FMDB.h"

@implementation ProceedsTotailCacheTool

static FMDatabaseQueue *_queue;

+ (void)initialize
{
    // 0.获得沙盒中的数据库文件名
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ProceedsTotailCacheTool.sqlite"];
    // NSLog(@"%@",path);
    // 1.创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    // 2.创表
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists ProceedsTotail_List (id integer primary key autoincrement, vehicleId integer, ProceedsTotalModel blob);"];
    }];
}

+ (void)addProceedsTotalModel:(ProceedsTotalModel *)proceedsTotalModel vehicleId:(long)vehicleId{

    [_queue inDatabase:^(FMDatabase *db) {
        
        // 1.获得需要存储的数据
        NSNumber *vehicleIdd =  [NSNumber numberWithLong:vehicleId];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:proceedsTotalModel];
        
        // 1.执行查询语句
        FMResultSet *resultSet = [db executeQuery:@"select * from ProceedsTotail_List where vehicleId = ?;",vehicleIdd];
        
        // 2.遍历结果
        while ([resultSet next]) {
            [db executeUpdate:@"delete from ProceedsTotail_List where vehicleId = ?;",vehicleIdd];
        }
        
        // 2.存储数据
        [db executeUpdate:@"insert into ProceedsTotail_List (vehicleId, ProceedsTotalModel) values(?, ?);",vehicleIdd, data];
    }];
}

+ (void)deleteProceedsTotalModelWithvehicleId:(long)vehicleId{
   
    NSNumber *vehicleIdd = [NSNumber numberWithLong:vehicleId];
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from ProceedsTotail_List where vehicleId = ?;",vehicleIdd];
    }];
}

+ (ProceedsTotalModel *)proceedsTotalModel:(long)vehicleId{

   __block ProceedsTotalModel *proceedsTotalModel = nil;
    [_queue inDatabase:^(FMDatabase *db) {

        // 1.执行查询语句
        FMResultSet *resultSet = [db executeQuery:@"select * from ProceedsTotail_List;"];
        // 2.遍历结果
        while ([resultSet next]) {
            
            //long vehicleId = [resultSet longForColumn:@"vehicleId"];
            NSData *data = [resultSet dataForColumn:@"ProceedsTotalModel"];
            proceedsTotalModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }];
    // 3.返回数据
    return proceedsTotalModel;
}
@end
