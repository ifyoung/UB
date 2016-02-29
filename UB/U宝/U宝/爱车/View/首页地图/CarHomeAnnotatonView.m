
#import "CarHomeAnnotatonView.h"
#import "CarHomeAnnotaton.h"
#import "CarAnnotationModel.h"
#import "ZPCircleLabelView.h"

#define selrudius  120.0f
@interface CarHomeAnnotatonView (){
    
    UIImageView *car;
    ZPCircleLabelView *zpCircleLabelView;
    CAShapeLayer *circleShape;
}
@end

@implementation CarHomeAnnotatonView

+ (instancetype)annotationViewWithMapView:(MAMapView *)mapView
{
    static NSString *ID = @"CarHomeAnnotatonView";
    CarHomeAnnotatonView *annoView = (CarHomeAnnotatonView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[CarHomeAnnotatonView alloc] initWithAnnotation:nil reuseIdentifier:ID];
    }
    return annoView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        self.frame = CGRectMake(0, 0, selrudius, selrudius);
 
        car = [[UIImageView alloc]initWithFrame:CGRectZero];
        car.size = CGSizeMake(15, 30);
        car.center = self.center;
       [self addSubview:car];
        car.backgroundColor = [UIColor clearColor];
    
    }
    return self;
}

- (void)setAnnotation:(id<MAAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    CarHomeAnnotaton *anno = (CarHomeAnnotaton *)annotation;
   
    car.image =  [UIImage imageNamed:anno.carmodel.icon];
    
    car.transform = CGAffineTransformMakeRotation(M_PI_4 * anno.carmodel.direction);
    
    
    
    [self XMCircleTypeView:anno.carmodel];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self startWaveAnimation];
    
    [zpCircleLabelView startAnimation];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //画渐变小圆
    [self drawRadialGradient:rect];
}

#pragma mark draws
- (void)XMCircleTypeView:(CarAnnotationModel *)model{
    if (zpCircleLabelView == nil)
        zpCircleLabelView = [[ZPCircleLabelView alloc]initWithFrame:self.bounds];
    zpCircleLabelView.backgroundColor = self.backgroundColor;
    zpCircleLabelView.userInteractionEnabled = NO;
    zpCircleLabelView.text = model.gpstime;
    zpCircleLabelView.text1 =  model.speed;
    [self addSubview:zpCircleLabelView];
}



#pragma mark private method  self.superview.layer动画
- (void)startWaveAnimation{
    CGRect pathFrame = CGRectMake(
                                  -30,
                                  -30,
                                  60,
                                  60);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:30];
    if(circleShape == nil)
    circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    circleShape.fillColor = IWColorAlpha(25, 144, 232, .6).CGColor;
    circleShape.opacity = 0;
    circleShape.strokeColor =  kColor.CGColor;
    circleShape.lineWidth = .5;
    [self.layer addSublayer:circleShape];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = 1.50f;
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape addAnimation:animation forKey:nil];
}


//渐变色圆圈
- (void)drawRadialGradient:(CGRect)rect{
    CGPoint _c = CGPointMake(rect.size.width / 2.0, rect.size.width / 2.0);
    CGFloat _r = rect.size.width / 2.0;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef imgCtx = UIGraphicsGetCurrentContext();
    CGContextSetFillColor(imgCtx, CGColorGetComponents(kColor.CGColor));
    CGContextSetStrokeColorWithColor(imgCtx, kColor.CGColor);
    
    //CGContextAddEllipseInRect(imgCtx, CGRectInset(rect, 15, 15));
    CGContextAddEllipseInRect(imgCtx, CGRectInset(rect, 30, 30));

    CGContextDrawPath(imgCtx, kCGPathFillStroke);
    CGContextClosePath(imgCtx);
    CGImageRef mask = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    CGContextClipToMask(ctx, rect, mask);
    
    //绘制颜色渐变
    //创建色彩空间对象
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef beginColor = CGColorCreate(colorSpaceRef, (CGFloat[]){24 / 255.0, 142 / 255.0, 232 / 255.0, 0.5});
    CGColorRef endColor =   CGColorCreate(colorSpaceRef, (CGFloat[]){24 / 255.0, 142 / 255.0, 232 / 255.0, 0.0});
    CFArrayRef colorArray = CFArrayCreate(kCFAllocatorDefault, (const void*[]){beginColor, endColor}, 2, nil);
    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, colorArray, (CGFloat[]){
        0.0f,
        1.0f
    });
    
    CGContextDrawRadialGradient(ctx, gradientRef, _c, _r - 15, _c, 0.0f, kCGGradientDrawsBeforeStartLocation);
    CFRelease(colorArray);
    CGColorRelease(beginColor);
    CGColorRelease(endColor);
    CGColorSpaceRelease(colorSpaceRef);
    CGGradientRelease(gradientRef);
    
    CGContextClosePath(ctx);
}



@end
