

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/*
 * OMAMovePathSegment - segment of annotation's path represented by
 * line (2 points - "from" and "to") and duration in seconds.
 * Annotation will move along this line with constant speed according to
 * duration value.
 */
typedef struct {
    CLLocationCoordinate2D from;
    CLLocationCoordinate2D to;
    NSTimeInterval duration;
} OMAMovePathSegment;

extern OMAMovePathSegment const OMAMovePathSegmentNull;

extern BOOL OMAMovePathSegmentIsNull(OMAMovePathSegment segment);

extern OMAMovePathSegment OMAMovePathSegmentMake(CLLocationCoordinate2D from, CLLocationCoordinate2D to, NSTimeInterval duration);

/*
 * Angle between segment line and 0 degrees (0 degrees - right direction)
 */
float OMAMovePathSegmentGetAngle(OMAMovePathSegment segment);