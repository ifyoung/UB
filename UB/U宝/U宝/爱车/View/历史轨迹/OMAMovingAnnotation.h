

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import "OMAStructs.h"

@class OMAMovePath;

@interface OMAMovingAnnotation : NSObject <MAAnnotation>

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





@property (nonatomic, strong) OMAMovePath *movePath;

@property (nonatomic, assign, readonly) OMAMovePathSegment currentSegment;

@property (nonatomic, assign, getter = isMoving) BOOL moving;

@property (nonatomic, assign, readonly) float angle;


- (void)moveStep;

@end
