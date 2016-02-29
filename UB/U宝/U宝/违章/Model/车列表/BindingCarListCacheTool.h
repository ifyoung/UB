

#import <Foundation/Foundation.h>
#import "BindingCarListModel.h"


@interface BindingCarListCacheTool : NSObject


/**
 *  缓存一条汽车模型
 *
 *  @param status 需要缓存的微博数据
 */
+ (void)addCarModel:(BindingCarListModel *)bindingCarModel;

/**
 *  缓存多条汽车模型
 *
 *  @param statusArray 需要缓存的微博数据
 */
+ (void)addCarModels:(NSArray *)carModelArray;


//删除一条汽车模型
+ (void)deleteCarModelWithVehicleId:(long)vehicleId;

//删除所有
+ (void)deleteAllCar;
 
//查询汽车模型
+ (NSArray *)carModel;

@end
