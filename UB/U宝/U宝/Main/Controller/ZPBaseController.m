//
//  BaseViewController.m
//  Meeting
//
//  Created by midu Mac on 14-11-24.
//  Copyright (c) 2014年 midu Mac. All rights reserved.
//

#import "ZPBaseController.h"
#import "ZPBaseNavigationController.h"


@interface ZPBaseController ()

@property(nonatomic,strong)UIView *topWrongbgView;

@end
@implementation ZPBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    /*
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeTop;
        //UIScorll设置
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
     */

    
    [self setUpForDismissKeyboard];
    
    [self ReachabilitySettings];
}

/*
 *   rightBarButtonItem
 */
- (void)rightButtonItem{
    self.navigationItem.rightBarButtonItem = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"me_icon"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 40, 40);
        [button addTarget:self action:@selector(presentRightMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        barItem;
    });
}
/*
 *   leftButtonItem
 */
- (void)leftButtonItem{
    self.navigationItem.leftBarButtonItems = ({
        UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        flexSpacer.width = -15;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"back_ico"] forState:UIControlStateNormal];
        button.frame = CGRectMake(-20, 0, 30, 30);
        [button addTarget:self action:@selector(backToMainviewcontroller) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        @[flexSpacer,barItem];
    });
}
- (void)backToMainviewcontroller{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.sideMenuViewController setContentViewController:delegate.mainViewController
                                                 animated:YES];
    //回到侧边栏
    [self presentRightMenuViewController:nil];
    
}
#pragma mark - GestureRecognizer
-(void)swipeGestureRecognizer{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backToMainviewcontroller)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
}

/*
 *   customButton
 */
- (UIButton *)customButton:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    button.userInteractionEnabled  = YES;
    button.showsTouchWhenHighlighted = YES;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [button setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    [button addTarget:self action:@selector(customButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = kColor;
    [button setTitle:title forState:UIControlStateNormal];
    [self.view addSubview:button];
    return button;
}
- (void)customButtonAction:(UIButton *)button{
}



/**
 *   Reachability
 *
 *  @param animated
 */
- (void)ReachabilitySettings{
    __weak typeof(self) this = self;
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    reach.reachableBlock = ^(Reachability * reachability)
    {
        
        if(reachability.isReachableViaWiFi){
        
            NSLog(@"Wi-Fi");
            
        }else if (reachability.isReachableViaWWAN){
        
            NSLog(@"运营商网络");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [this backToTop];
        });
        
        if(_networkreachableBlock)
            _networkreachableBlock();
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
         
            [this createTopWrong];
            NSLog(@"没有网络");
        });
        
        if(_networkUnreachableBlock)
            _networkUnreachableBlock();
        
    };
    
    [reach startNotifier];
}


/*
 *   顶部查询信息有误提示
 */
- (void)createTopWrong{
    if(_topWrongbgView == nil){
        _topWrongbgView = [[UIView alloc]initWithFrame:CGRectMake(0, -40, KSCREEWIDTH, 40)];
        _topWrongbgView.tag = 20151108;
        _topWrongbgView.backgroundColor =  IWColorAlpha(223, 143, 146, .8);
        
        UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 20, 20)];
        leftImg.image = [UIImage imageNamed:@"违章信息错误叹号"];
        [_topWrongbgView addSubview:leftImg];
        
        UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftImg.right + 10, 0, KSCREEWIDTH - leftImg.right - 10 - 50, 40)];
        topLabel.text = @"您的网络出了点问题，请检查网络~";
        topLabel.textColor = [UIColor whiteColor];
        topLabel.adjustsFontSizeToFitWidth = YES;
        [_topWrongbgView addSubview:topLabel];
        [self.view addSubview:_topWrongbgView];
        
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _topWrongbgView.top = 0;
        } completion:^(BOOL finished) {
            
        }];
    }
}
- (void)backToTop{
    [UIView animateWithDuration:1 delay:3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _topWrongbgView.top = - 40;
    } completion:^(BOOL finished) {
        [_topWrongbgView removeAllSubviews];
        [_topWrongbgView removeFromSuperview];
        _topWrongbgView = nil;
    }];
}






/**
 *  键盘通知
 *
 *  @param animated
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //监听键盘弹出的通知，通知名：UIKeyboardWillShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideAction:) name:UIKeyboardWillHideNotification object:nil];
    
    
    //[MobClick beginLogPageView:<#(NSString *)#>]
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    //[MobClick endLogPageView:<#(NSString *)#>]
}
#pragma mark - NSNotification 通知
- (void)keyboardWillShowAction:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    NSValue *animationCurveObject = [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSUInteger animationCurve;
    [animationCurveObject getValue:&animationCurve];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    [self keyboardWillShow:keyboardRect.size.height];
    [UIView commitAnimations];
}
- (void)keyboardWillHideAction:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    NSValue *animationCurveObject =[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSUInteger animationCurve;
    [animationCurveObject getValue:&animationCurve];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    [self keyboardWillHide];
    [UIView commitAnimations];
}
- (void)keyboardWillShow:(CGFloat)keyboardHeight{
}
- (void)keyboardWillHide{
}
@end
