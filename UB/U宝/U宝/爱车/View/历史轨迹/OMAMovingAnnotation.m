

#import "OMAMovingAnnotation.h"
#import "OMAMovePath.h"


static double interpolate(double from, double to, NSTimeInterval time) {
    return (to - from) * time + from;
}

static CLLocationDegrees interpolateDegrees(CLLocationDegrees from, CLLocationDegrees to, NSTimeInterval time) {
    
    return interpolate(from, to, time);
}

static CLLocationCoordinate2D interpolateCoordinate(CLLocationCoordinate2D from, CLLocationCoordinate2D to, NSTimeInterval time) {
    
    return CLLocationCoordinate2DMake(
                                      
                                interpolateDegrees(from.latitude, to.latitude, time),
                                      
                                interpolateDegrees(from.longitude, to.longitude, time)
                                      );
}



@interface OMAMovingAnnotation()

@property (nonatomic, assign, readwrite) OMAMovePathSegment currentSegment;
@property (nonatomic, assign, readwrite) float angle;

@end

@implementation OMAMovingAnnotation {
    CFTimeInterval _lastStep;
    NSTimeInterval _timeOffset;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _currentSegment = OMAMovePathSegmentNull;
    }
    return self;
}

/*
 *   开始轨迹运动
 */
- (void)moveStep{
    
    //开始出发
    if (![self isMoving]) {
     
        // CFTimeInterval
        _lastStep = CACurrentMediaTime();
        
        if (OMAMovePathSegmentIsNull(_currentSegment)) {
            
            _currentSegment = [self.movePath popSegment];
        }
        
        if (!OMAMovePathSegmentIsNull(_currentSegment)) {
            
            self.moving = YES;
            
            //一次完整轨迹 完成之后
            [self updateAngle];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OMAMovingAnnotationAngleChangedNocaiton" object:[NSNumber numberWithFloat:self.angle]];
        }
    }
    
    
    
    
    if (OMAMovePathSegmentIsNull(_currentSegment)) {
        
        if (self.moving) {
            
            self.moving = NO;
        }
        _timeOffset = 0;
        return;
    }
    
    CFTimeInterval thisStep = CACurrentMediaTime();
    
    CFTimeInterval stepDuration = thisStep - _lastStep;
    
    _lastStep = thisStep;
    
    //NSTimeInterval
    _timeOffset = MIN(_timeOffset + stepDuration, _currentSegment.duration);
    
    NSTimeInterval time = _timeOffset / _currentSegment.duration;
    
    self.coordinate =  interpolateCoordinate(_currentSegment.from, _currentSegment.to, time);
    
    if (_timeOffset >= _currentSegment.duration) {
        
        _currentSegment = [self.movePath popSegment];
        
        _timeOffset = 0;
        
        BOOL isCurrentSegmentNull = OMAMovePathSegmentIsNull(_currentSegment);
        
        if (isCurrentSegmentNull && self.moving) {
            
            self.moving = NO;
        }
        
        if (!isCurrentSegmentNull) {
            
            //一小段轨迹完成之后
            [self updateAngle];
            
             [[NSNotificationCenter defaultCenter] postNotificationName:@"OMAMovingAnnotationAngleChangedNocaiton" object:[NSNumber numberWithFloat:self.angle]];
        }
    }
}

- (void)updateAngle {
    
    self.angle = OMAMovePathSegmentGetAngle(_currentSegment);
}

@end
