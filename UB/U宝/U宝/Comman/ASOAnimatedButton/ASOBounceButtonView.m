

#import "ASOBounceButtonView.h"
#import "ASOBounceButtonViewDelegate.h"

#define DEFAULT_ANIMATION_SPEED ((float) 0.1)
#define DEFAULT_ANIMATION_FADEOUT_DURATION ((float) 0.1)
#define DEFAULT_ANIMATION_BOUNCING_DISTANCE ((float) 0.6)

@interface ASOBounceButtonView()

@property (strong, nonatomic) NSMutableArray *bounceButtons;
@property (nonatomic) CGPoint startAnimationPoint;
@property (strong, readwrite, nonatomic) NSNumber *collapsedViewDuration;

@end

@implementation ASOBounceButtonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setAnimationStartFromHere:(CGRect)startingViewFrame
{
    [self layoutIfNeeded];
    self.startAnimationPoint = CGPointMake(startingViewFrame.origin.x + (startingViewFrame.size.width/2), startingViewFrame.origin.y + (startingViewFrame.size.height/2));
}

- (void)initBounceButtons
{
    self.bounceButtons = [[NSMutableArray alloc] init];
    
    // Set to default values
    self.speed = [NSNumber numberWithFloat:DEFAULT_ANIMATION_SPEED];
    self.fadeOutDuration = [NSNumber numberWithFloat:DEFAULT_ANIMATION_FADEOUT_DURATION];
    self.bouncingDistance = [NSNumber numberWithFloat:DEFAULT_ANIMATION_BOUNCING_DISTANCE];
}

- (void)didSelectBounceButtonFrom:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectBounceButtonAtIndex:)]) {
        [self.delegate didSelectBounceButtonAtIndex:[sender tag]];
    }
}

- (void)addBounceButton:(UIButton *)bounceButton
{
    if (!self.bounceButtons) {
        
        [self initBounceButtons];
    }
    
    [self.bounceButtons addObject:bounceButton];
    [[self.bounceButtons lastObject] setTag:[self.bounceButtons count] - 1];
    
    // Add control event to the last added bounce button
    [[self.bounceButtons lastObject] addTarget:self action:@selector(didSelectBounceButtonFrom:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addBounceButtons:(NSArray *)arrBounceButtons
{
    if (!self.bounceButtons) {
        
        [self initBounceButtons];
    }
    [self.bounceButtons addObjectsFromArray:arrBounceButtons];
    
    // Add control event to all of the bounce buttons
    for (int16_t idx = 0; idx < [self.bounceButtons count]; idx++) {
        [[self.bounceButtons objectAtIndex:idx] setTag:idx];
        [[self.bounceButtons objectAtIndex:idx] addTarget:self action:@selector(didSelectBounceButtonFrom:) forControlEvents:UIControlEventTouchUpInside];
    }
}




- (void)expandWithAnimationStyle:(ASOAnimationStyle)animationStyle
{
    
    [self layoutIfNeeded];
    
    //Process and animates all the buttons
    CGPoint previousButtonPosition = CGPointZero;
    CGPoint currentButtonPosition = CGPointZero;
    CGPoint bouncePosition = CGPointZero;
    int16_t startIdx = 0;
    
    for (int16_t item = 0; item < [self.bounceButtons count]; item++) {
        
        CGMutablePathRef thePath = CGPathCreateMutable();
        
        CGPathMoveToPoint(thePath, NULL, self.startAnimationPoint.x, self.startAnimationPoint.y);
        
        //起点  不变
        previousButtonPosition = CGPathGetCurrentPoint(thePath);
     
        if (animationStyle != ASOAnimationStyleExpand) {
            
            startIdx = item;
        }
    
        //没必要的循环  只有一次
        for (int16_t idx = startIdx; idx <= item; idx++) {

            UIButton *bounceButton = [self.bounceButtons objectAtIndex:item];
            
            currentButtonPosition = CGPointMake(
                                                bounceButton.frame.origin.x + (bounceButton.frame.size.width / 2),
                                                bounceButton.frame.origin.y + (bounceButton.frame.size.height/ 2)
                                              );
            //绝对相等啊...
            if (idx == item) {
                
                //Calculate the bounce target point
                bouncePosition = [self bounceTargetPointWithStartPoint:previousButtonPosition EndPoint:currentButtonPosition];
                //最高点
                CGPathAddLineToPoint(thePath, NULL, bouncePosition.x, bouncePosition.y);
            }
            
            //弹簧
             CGPathAddLineToPoint(thePath, NULL, currentButtonPosition.x, currentButtonPosition.y);
             CGPathAddLineToPoint(thePath, NULL, currentButtonPosition.x, currentButtonPosition.y - 30);
             CGPathAddLineToPoint(thePath, NULL, currentButtonPosition.x, currentButtonPosition.y);
             CGPathAddLineToPoint(thePath, NULL, currentButtonPosition.x, currentButtonPosition.y - 20);
             CGPathAddLineToPoint(thePath, NULL, currentButtonPosition.x, currentButtonPosition.y);
             CGPathAddLineToPoint(thePath, NULL, currentButtonPosition.x, currentButtonPosition.y - 10);
            
            
            //最后位置  自己本身的固定位置
            CGPathAddLineToPoint(thePath, NULL, currentButtonPosition.x, currentButtonPosition.y);
            previousButtonPosition = currentButtonPosition;
        }
        
        
        //Create the animation object, specifying the position property as the key path.
        CAKeyframeAnimation * theAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        theAnimation.path = thePath;
        CGPathRelease(thePath);
        
        if (animationStyle != ASOAnimationStyleRiseConcurrently){
            
            theAnimation.duration = [self.speed floatValue] * (item + 1);
        } else {
            
            theAnimation.duration = [self.speed floatValue] + .5;
        }

        //Add the animation to the layer.
        [[self.bounceButtons objectAtIndex:item] layer].opacity = 1.0;
        [[[self.bounceButtons objectAtIndex:item] layer] addAnimation:theAnimation forKey:@"position"];
    }
}
- (CGPoint)bounceTargetPointWithStartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint
{
    float widthBounceTarget = [self.bouncingDistance floatValue] * (startPoint.x - endPoint.x);
    float heightBounceTarget = [self.bouncingDistance floatValue] * (startPoint.y - endPoint.y);
    
    CGPoint bounceTargetPoint = CGPointMake(endPoint.x - widthBounceTarget, endPoint.y - heightBounceTarget);
    
    return bounceTargetPoint;
}



- (void)collapseWithAnimationStyle:(ASOAnimationStyle)animationStyle
{
    UIButton *bounceButton = nil;
    self.collapsedViewDuration = [NSNumber numberWithFloat:0.0];
    int16_t lastIdx = 0;
    

    // Process and collapse all the buttons
    for (int16_t item = 0; item < [self.bounceButtons count]; item++) {
        
        CGMutablePathRef thePath = CGPathCreateMutable();
        
        if (animationStyle != ASOAnimationStyleExpand) {
            lastIdx = item;
        }
        
        for (int16_t idx = item; idx >= lastIdx; idx--) {
            bounceButton = [self.bounceButtons objectAtIndex:idx];
            if (idx == item) {
                CGPathMoveToPoint(thePath, NULL,
                                  bounceButton.frame.origin.x + (bounceButton.frame.size.width/2), bounceButton.frame.origin.y + (bounceButton.frame.size.height/2));
            }
            else {
                CGPathAddLineToPoint(thePath, NULL,
                                     bounceButton.frame.origin.x + (bounceButton.frame.size.width/2), bounceButton.frame.origin.y + (bounceButton.frame.size.height/2));
            }
            
        }
        
        
        CGPathAddLineToPoint(thePath,NULL,self.startAnimationPoint.x, self.startAnimationPoint.y);
        CAKeyframeAnimation * collapsedAnimation;
        collapsedAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        collapsedAnimation.path = thePath;
        CGPathRelease(thePath);
        
        
        CABasicAnimation *theFadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        theFadeOutAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        theFadeOutAnimation.toValue = [NSNumber numberWithFloat:0.0];
        
        if (animationStyle != ASOAnimationStyleRiseConcurrently) {
            theFadeOutAnimation.duration = [self.speed floatValue] * (item + 1);
        } else {
            theFadeOutAnimation.duration = [self.speed floatValue];
        }
        
        [[self.bounceButtons objectAtIndex:item] layer].opacity = 0.0;
        
        
        
        CAAnimationGroup *groupedAnimation = [CAAnimationGroup animation];
        groupedAnimation.animations = [NSArray arrayWithObjects:collapsedAnimation, theFadeOutAnimation, nil];
        
        if (animationStyle != ASOAnimationStyleRiseConcurrently) {
            groupedAnimation.duration = [self.speed doubleValue] * (item + 1);
        } else {
            groupedAnimation.duration = [self.speed doubleValue];
        }
        
        [[[self.bounceButtons objectAtIndex:item] layer] addAnimation:groupedAnimation forKey:@"collapsed-fadeout"];
        
    }

    self.collapsedViewDuration = [NSNumber numberWithDouble:[self.speed doubleValue]];

}
@end
