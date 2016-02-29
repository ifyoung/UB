

#import "BindingCarListCacheTool.h"
#import "FMDB.h"

@implementation BindingCarListCacheTool
static FMDatabaseQueue *_queue;



+ (void)initialize
{
    // 0.获得沙盒中的数据库文件名
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"BindingCarListCacheTool.sqlite"];
   // NSLog(@"%@",path);
    // 1.创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    // 2.创表
      [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists BindingCar_List (id integer primary key autoincrement, vehicleId integer, BindingCarModel blob);"];
      }];
}

+ (void)addCarModels:(NSArray *)carModelArray;
{
    for (BindingCarListModel *carModel in carModelArray) {
        [self addCarModel:carModel];
    }
}

//插入一条汽车模型
+ (void)addCarModel:(BindingCarListModel *)bindingCarModel
{
    [_queue inDatabase:^(FMDatabase *db) {
        
        // 1.获得需要存储的数据
        NSNumber *vehicleId =  [NSNumber numberWithLong:bindingCarModel.vehicleId];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:bindingCarModel];
        
        // 1.执行查询语句
        FMResultSet *resultSet = [db executeQuery:@"select * from BindingCar_List where vehicleId = ?;",vehicleId];
        
        // 2.遍历结果
        while ([resultSet next]) {
             [db executeUpdate:@"delete from BindingCar_List where vehicleId = ?;",vehicleId];
        }
        
        // 2.存储数据
        [db executeUpdate:@"insert into BindingCar_List (vehicleId, BindingCarModel) values(?, ?);",vehicleId, data];
    }];
}


//删除一条汽车模型
+ (void)deleteCarModelWithVehicleId:(long)vehicleId{
    NSNumber *vehicleID = [NSNumber numberWithLong:vehicleId];
    [_queue inDatabase:^(FMDatabase *db) {
         [db executeUpdate:@"delete from BindingCar_List where vehicleId = ?;",vehicleID];
    }];
}


+ (void)deleteAllCar{
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from BindingCar_List;"];
    }];
}


//查询汽车模型
+ (NSArray *)carModel{
    
    // 1.定义数组
    __block NSMutableArray *statusArray = nil;
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        // 创建数组
        statusArray = [NSMutableArray array];
        // 1.执行查询语句
        FMResultSet *resultSet = [db executeQuery:@"select * from BindingCar_List;"];
        // 2.遍历结果
        while ([resultSet next]) {
            //NSInteger ID = [resultSet longForColumn:@"vehicleId"];
            NSData *data = [resultSet dataForColumn:@"BindingCarModel"];
            BindingCarListModel *status = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [statusArray addObject:status];
        }
    }];
    // 3.返回数据
    return statusArray;
}
@end
