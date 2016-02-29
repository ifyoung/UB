


#import "NSValue+OMAMovePathSegment.h"

@implementation NSValue (OMAMovePathSegment)



+ (NSValue *)valueWithOMAMovePathSegment:(OMAMovePathSegment)segment {
    
    return [NSValue valueWithBytes:&segment objCType:@encode(OMAMovePathSegment)];
}

- (OMAMovePathSegment)OMAMovePathSegmentValue {
    
    OMAMovePathSegment segment;
    [self getValue:&segment];
    return segment;
}


+ (NSValue *)valueWithCLLocationCoordinate2D:(CLLocationCoordinate2D)Coordinate2D {
    
    return [NSValue valueWithBytes:&Coordinate2D objCType:@encode(CLLocationCoordinate2D)];
}

- (CLLocationCoordinate2D)CLLocationCoordinate2DValue {
    
    CLLocationCoordinate2D Coordinate2D;
    [self getValue:&Coordinate2D];
    return Coordinate2D;
}


@end
