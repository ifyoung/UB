

#import <Foundation/Foundation.h>

#import "OMAStructs.h"



@interface NSValue (OMAMovePathSegment)

+ (NSValue *)valueWithOMAMovePathSegment:(OMAMovePathSegment)segment;

- (OMAMovePathSegment)OMAMovePathSegmentValue;

@end
