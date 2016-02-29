//
//  BaseViewController.h
//  Meeting
//
//  Created by midu Mac on 14-11-24.
//  Copyright (c) 2014年 midu Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NetworkUnReachableHander)();
typedef void(^NetworkReachableHander)();


@interface ZPBaseController : UIViewController

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
   <UITableViewDelegate,UITableViewDataSource>
#pragma clang diagnostic pop

/**
 *  swipeGestureRecognizer
 */
- (void)swipeGestureRecognizer;
/*
 *   rightBarButtonItem
 */
- (void)rightButtonItem;

/*
 *   leftButtonItem
 */
- (void)leftButtonItem;

/*
 *   顶部查询信息有误提示
 */
- (void)createTopWrong;

/*
 *   customButton
 */
- (UIButton *)customButton:(NSString *)title;
- (void)customButtonAction:(UIButton *)button;


/**
 *   Reachability
 *
 *  @param animated
 */
- (void)ReachabilitySettings;
@property (nonatomic,copy)NetworkUnReachableHander  networkUnreachableBlock;
@property (nonatomic,copy)NetworkReachableHander    networkreachableBlock;



#pragma mark - NSNotification 通知
- (void)keyboardWillShow:(CGFloat)keyboardHeight;
- (void)keyboardWillHide;

@end

