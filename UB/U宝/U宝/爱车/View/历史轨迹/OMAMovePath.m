

#import "OMAMovePath.h"
#import "NSValue+OMAMovePathSegment.h"

@interface OMAMovePath()

@property (nonatomic, strong) NSMutableArray *mutableSegments;

@end

@implementation OMAMovePath

- (instancetype)init{
    self = [super init];
    if (self) {
        
        _mutableSegments = [NSMutableArray array];
    }
    return self;
}

- (BOOL)isEmpty{
    
    return (self.mutableSegments.count == 0);
}

- (OMAMovePathSegment)popSegment{
    
    if ([self isEmpty]) {
        return OMAMovePathSegmentNull;
    }
    OMAMovePathSegment segment = [self.mutableSegments.firstObject OMAMovePathSegmentValue];
    [self.mutableSegments removeObjectAtIndex:0];
    
    return segment;
}
- (void)addSegment:(OMAMovePathSegment)segment{
    
    [self.mutableSegments addObject:[NSValue valueWithOMAMovePathSegment:segment]];
}

- (void)addSegments:(NSArray *)segments{
    
    [self.mutableSegments addObjectsFromArray:segments];
}

- (void)clearPath{
    
    [self.mutableSegments removeAllObjects];
}
@end
