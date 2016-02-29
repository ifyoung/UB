

#import <Foundation/Foundation.h>


/*
 * Animator uses timer for updating it's annotations positions 
 * according to frameInterval.
 */
@class OMAMovingAnnotation;

extern NSInteger const OMAMovingAnnotationsAnimatorFrameIntervalDefault;

@interface OMAMovingAnnotationsAnimator : NSObject

- (instancetype)initWithFrameInterval:(NSInteger)frameInterval;
- (instancetype)init;

- (void)addAnnotation:(OMAMovingAnnotation *)annotation;
- (void)addAnnotations:(NSSet *)annotations;

- (void)removeAnnotation:(OMAMovingAnnotation *)annotation;
- (void)removeAnnotations:(NSSet *)annotations;
- (void)removeAllAnnotations;

- (void)startAnimating;
- (void)stopAnimating;

@end
