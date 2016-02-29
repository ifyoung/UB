
#import "UIView+Addition.h"
#define MakeColor(r,g,b) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1])
#define KBlueColor MakeColor(16,97,175)

@implementation UIView (Addition)


/** super UIViewController */
- (UIViewController *)viewController {
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

//圆角和边框
- (void)addBorderAndCornerousWithCorlor:(UIColor *)color width:(float)width{
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

//切成圆
- (void)addCornerousCircle{
    self.layer.cornerRadius = self.frame.size.width / 2.0;
    self.layer.masksToBounds = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}



//添加阴影
- (void)addShadow{

    self.layer.masksToBounds = NO;
    
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    
    self.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.layer.shadowOpacity = 1;
    
    self.layer.shadowRadius = 3;
    
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

//添加细线
- (void)addLineOfTop:(BOOL)top b:(BOOL)bottom  l:(BOOL)left r:(BOOL)right color:(UIColor *)color wid:(float)width{
   
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    if(top){
     CGContextMoveToPoint(context, 0, width);
     CGContextAddLineToPoint(context, self.width,width);
     CGContextStrokePath(context);
    }
    
    if(bottom){
     CGContextMoveToPoint(context,0, self.height - width);
     CGContextAddLineToPoint(context, self.width,self.height - width);
     CGContextStrokePath(context);
    }
    
    if(left){
     CGContextMoveToPoint(context, width, 0);
     CGContextAddLineToPoint(context, width,self.height);
     CGContextStrokePath(context);
    }
    
    if(right){
     CGContextMoveToPoint(context, 0, width);
     CGContextAddLineToPoint(context, self.width,width);
     CGContextStrokePath(context);
    }
    
    CGContextClosePath(context);
}

//添加虚线  http://blog.csdn.net/zhangao0086/article/details/7234859
- (void)addDashLineFrom:(CGPoint)point1 to:(CGPoint)point2 color:(UIColor *)color{

    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    const CGFloat length[] = {4, 4};
    CGContextSetLineDash(context, 0, length, 2);
   
    CGContextMoveToPoint(context, point1.x, point1.y);
    CGContextAddLineToPoint(context, point2.x,point2.y);
    
    CGContextStrokePath(context);
    CGContextClosePath(context);
}

/*!
 *   指定某个角为圆角
 */
- (void)drawSelectSinGleCornersLeft:(BOOL)top{
    
    UIRectCorner rectConer =   top == YES?   (UIRectCornerTopLeft | UIRectCornerTopRight) : (UIRectCornerBottomLeft | UIRectCornerBottomRight);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectConer cornerRadii:CGSizeMake(5, 5)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
