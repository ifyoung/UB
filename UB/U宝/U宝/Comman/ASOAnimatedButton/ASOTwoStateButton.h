

#import <UIKit/UIKit.h>

@interface ASOTwoStateButton : UIButton

/**
 *  Store image name for one of the state.
 *  The name of image stored in Images.xcassets.
 */
@property (strong, nonatomic) NSString *onStateImageName;

/**
 *  Store image name for the other state.
 *  The name of image stored in Images.xcassets.
 */
@property (strong, nonatomic) NSString *offStateImageName;

/**
 *  Control whether fade effect is enabled between state changing.
 *  A Boolean value, set 'YES' to enable the fade effect.
 */
@property (nonatomic) BOOL isFadeEffectEnabled;

/**
 *  Control the effect duration between state changing.
 *  Default value is '0.6'.
 */
@property (nonatomic) NSTimeInterval effectDuration;

/**
 *  A Boolean value between state (read-only).
 *  This value is to be used to indicate what is the current state.
 *
 */
@property (readonly, nonatomic) BOOL isOn;

/**
 *  Initialise all the required property to animate the button.
 *
 *  @param fadeEnabled Set 'YES' to enable the fade effect between state changing.
 */
//- (void)initAnimationWithFadeEffectEnabled:(BOOL)fadeEnabled;

/**
 *  A feature to insert a custom UIView
 *
 *  @param customView UIView object to be added underneath this ASOTwoStateButton view.
 */
- (void)addCustomView:(UIView *)customView;

/**
 *  Remove the custom UIView added by 'addCustomView' method
 *
 *  @param customView     UIView object added by 'addCustomView' method
 *  @param delayInSeconds Set delay to show animation on the customView to be completed before removing this custom UIView
 */
- (void)removeCustomView:(UIView *)customView interval:(double)delayInSeconds;




@end
