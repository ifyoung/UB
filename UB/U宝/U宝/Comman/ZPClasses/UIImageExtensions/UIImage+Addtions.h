
#import <UIKit/UIKit.h>

@interface UIImage (Addtions)

/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;


//改变图片大小
+ (UIImage *)changeImg:(UIImage *)img  size:(CGSize)size;

/*!
 *   通过颜色制作图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color rect:(CGSize)size;


// 设置图片的方向
+ (UIImage *)fixOrientation:(UIImage *)aImage;


//圆形图片
+ (UIImage*)circleImage:(UIImage*) image withParam:(CGFloat) inset;


@end
