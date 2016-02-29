

#import <Foundation/Foundation.h>

@protocol ASOBounceButtonViewDelegate <NSObject>

@optional

/**
 *  Delegation method of ASOBounceButtonView, which will be called when each bounce button defined in ASOBounceButtonView instance is tapped
 *
 *  @param index Bounce button index to identify which bounce button is tapped
 */
- (void)didSelectBounceButtonAtIndex:(NSInteger)index;

@end
