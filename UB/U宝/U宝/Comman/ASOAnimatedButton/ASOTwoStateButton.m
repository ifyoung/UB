

#import "ASOTwoStateButton.h"

#define DEFAULT_DURATION 0.6;

const int16_t kOnStateViewTag = 700;
const int16_t kOffStateViewTag = 701;
const int16_t kCustomViewTag = 702;

@interface ASOTwoStateButton()

@property (readwrite, nonatomic) BOOL isOn;

@end

@implementation ASOTwoStateButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.onStateImageName = @"iconfont-guanbi";
        self.offStateImageName = @"时间弹出灰色";
    }
    return self;
}

#pragma mark - Animation methods
- (void)addCustomView:(UIView *)customView
{
    [customView setTag:kCustomViewTag];
    [customView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[self superview] insertSubview:customView belowSubview:self];
    
//    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:customView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
//    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:customView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
//    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:customView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
//    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:customView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}


- (void)removeCustomView:(UIView *)customView interval:(double)delayInSeconds
{
    self.userInteractionEnabled = NO;
    
    dispatch_time_t removeTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(removeTime, dispatch_get_main_queue(), ^(void){
        
        [customView  removeFromSuperview];

        self.userInteractionEnabled  = YES;
     });
}
@end
