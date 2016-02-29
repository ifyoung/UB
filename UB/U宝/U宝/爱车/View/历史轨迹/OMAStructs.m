

#import "OMAStructs.h"

OMAMovePathSegment const OMAMovePathSegmentNull = { {0, 0}, {0, 0}, 0 };

BOOL OMAMovePathSegmentIsNull(OMAMovePathSegment segment) {
    
    return (segment.from.latitude == 0)
    && (segment.from.longitude == 0)
    && (segment.to.latitude == 0)
    && (segment.to.longitude == 0)
    && (segment.duration == 0);
}

OMAMovePathSegment OMAMovePathSegmentMake(CLLocationCoordinate2D from, CLLocationCoordinate2D to, NSTimeInterval duration) {
    
    OMAMovePathSegment segment;
    segment.from = from;
    segment.to = to;
    segment.duration = duration;
    return segment;
}

float OMAMovePathSegmentGetAngle(OMAMovePathSegment segment){
    
    //atan2(y,x)所表达的意思是坐标原点为起点，指向(x,y)的射线在坐标平面上与x轴正方向之间的角的角度。
    return -atan2(segment.to.latitude - segment.from.latitude, segment.to.longitude - segment.from.longitude);
}