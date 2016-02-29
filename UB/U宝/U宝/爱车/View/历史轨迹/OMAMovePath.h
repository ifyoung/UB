

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "OMAStructs.h"

/*
 * Annotation will move along OMAMovePath which consists of multiple
 * OMAMovePathSegment struct values
 */
@interface OMAMovePath : NSObject

//@property (nonatomic, readonly) NSArray *segments;

- (OMAMovePathSegment)popSegment;

- (BOOL)isEmpty;

- (void)addSegment:(OMAMovePathSegment)segment;
- (void)addSegments:(NSArray *)segments;

- (void)clearPath;

@end
