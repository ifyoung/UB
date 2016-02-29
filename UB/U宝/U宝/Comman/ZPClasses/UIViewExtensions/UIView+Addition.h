

#import <UIKit/UIKit.h>

@interface UIView (Addition)

- (UIViewController *)viewController;

- (void)removeAllSubviews;


//圆角和边框
- (void)addBorderAndCornerousWithCorlor:(UIColor *)color width:(float)width;

//切成圆
- (void)addCornerousCircle;

//添加阴影
- (void)addShadow;

//添加细线
- (void)addLineOfTop:(BOOL)top b:(BOOL)bottom  l:(BOOL)left r:(BOOL)right color:(UIColor *)color wid:(float)width;

//添加虚线
- (void)addDashLineFrom:(CGPoint)point1 to:(CGPoint)point2 color:(UIColor *)color;

//指定圆角
- (void)drawSelectSinGleCornersLeft:(BOOL)top;
@end