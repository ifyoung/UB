

#import "OMAMovingAnnotationsAnimator.h"

#import "OMAMovingAnnotation.h"

NSInteger const OMAMovingAnnotationsAnimatorFrameIntervalDefault = 2;

@interface OMAMovingAnnotationsAnimator()

@property (nonatomic, strong) CADisplayLink *timer;

@end

@implementation OMAMovingAnnotationsAnimator {
    
    
    NSMutableSet *_annotations;
    NSInteger _frameInterval;
    
    NSMutableSet *_annotationsToRemove;
    NSMutableSet *_annotationsToAdd;
}


- (instancetype)initWithFrameInterval:(NSInteger)frameInterval {
    self = [super init];
    if (self) {
        
        _annotations = [NSMutableSet set];
        _frameInterval = frameInterval;
        _annotationsToRemove = [NSMutableSet set];
        _annotationsToAdd = [NSMutableSet set];
    }
    return self;
}

- (instancetype)init {
    
    return [self initWithFrameInterval:OMAMovingAnnotationsAnimatorFrameIntervalDefault];
}



/*
 *  添加、移除annotation
 */
- (void)addAnnotation:(OMAMovingAnnotation *)annotation{
    
    NSParameterAssert(annotation);
    [_annotationsToAdd addObject:annotation];
}

- (void)addAnnotations:(NSSet *)annotations {
    
    NSParameterAssert(annotations);
    [_annotationsToAdd unionSet:annotations];
}

- (void)removeAnnotation:(OMAMovingAnnotation *)annotation {
    
    NSParameterAssert(annotation);
    [_annotationsToRemove addObject:annotation];
}

- (void)removeAnnotations:(NSSet *)annotations {
    
    NSParameterAssert(annotations);
    [_annotationsToRemove unionSet:annotations];
}

- (void)removeAllAnnotations {
    [_annotationsToRemove unionSet:_annotations];
}


/*
 *   开始、结束动画
 */
- (void)startAnimating {
    
    [self.timer invalidate];
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(doStep)];
    self.timer.frameInterval = _frameInterval;
    
    NSRunLoop *mainRunLoop = [NSRunLoop mainRunLoop];
    [self.timer addToRunLoop:mainRunLoop forMode:NSDefaultRunLoopMode];
    [self.timer addToRunLoop:mainRunLoop forMode:UITrackingRunLoopMode];
}


- (void)stopAnimating{
    
    [self.timer invalidate];
    self.timer = nil;
    
    for (OMAMovingAnnotation *annotation in _annotations){
        
        [annotation setMoving:NO];
    }
}


- (void)doStep{
    
    [_annotations minusSet:_annotationsToRemove];
    [_annotations unionSet:_annotationsToAdd];
    [_annotationsToAdd removeAllObjects];
    [_annotationsToRemove removeAllObjects];
    
    for (OMAMovingAnnotation *annotation in _annotations){
        
        [annotation moveStep];
    }
}

@end
