


#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@class CarAnnotationModel;

@interface CarHomeAnnotaton : NSObject <MAAnnotation>

//协议自带
/*!
 @brief 标注view中心坐标
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/*!
 @brief 获取annotation标题
 @return 返回annotation的标题信息
 */
@property (nonatomic, copy) NSString *title;

/*!
 @brief 获取annotation副标题
 @return 返回annotation的副标题信息
 */
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) CarAnnotationModel *carmodel;

@end
