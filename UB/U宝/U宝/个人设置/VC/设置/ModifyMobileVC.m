//
//  ModifyMobileVC.m
//  赛格车圣
//
//  Created by 冥皇剑 on 15/9/30.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import "ModifyMobileVC.h"
#import "ZPCountDownButton.h"

@interface ModifyMobileVC ()<UITextFieldDelegate>

/**手机号*/
@property(nonatomic,strong)UITextField *callText;
/**验证码*/
@property(nonatomic,strong)UITextField *codeText;
/**
 *  获取验证码按钮
 */
@property(nonatomic,strong)ZPCountDownButton *codeBtn;
/**
 *  提交按钮
 */
@property (weak, nonatomic)UIButton *submitBtn;
@end

@implementation ModifyMobileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = IWColorAlpha(238, 238, 238, 1.0);
    self.title = @"更换手机号码";
    [self createSubview];
}

-(void)createSubview{
    
    CGFloat pading = 20.0;
    CGFloat W = KSCREEWIDTH;
    CGFloat H = 44;
    
    //手机号码相关
    UIImageView *callIcon = [[UIImageView alloc] init];
    callIcon.image = [UIImage imageNamed:@"手机号"];
    callIcon.width = 60;
    callIcon.height = 30;
    callIcon.contentMode = UIViewContentModeCenter;
    
    UITextField *callText = [[UITextField alloc]init];
    callText.frame = CGRectMake(0, pading, W, H);
    callText.backgroundColor = [UIColor whiteColor];
    callText.borderStyle = UITextBorderStyleRoundedRect;
    callText.placeholder = @"请输入新的手机号码";
    callText.leftView = callIcon;
    callText.leftViewMode = UITextFieldViewModeAlways;
    callText.keyboardType = UIKeyboardTypeNumberPad;
    callText.clearButtonMode = UITextFieldViewModeAlways;
    callText.delegate = self;
    self.callText = callText;
    [self.callText addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:callText];
    
    //验证码相关
    UIImageView *codeIcon = [[UIImageView alloc] init];
    codeIcon.image = [UIImage imageNamed:@"短信"];
    codeIcon.width = 60;
    codeIcon.height = 30;
    codeIcon.contentMode = UIViewContentModeCenter;
    
    UIView *codeView = [[UIView alloc]init];
    codeView.width = W / 3;
    codeView.height = H / 2;
    
    //验证码按钮
    //验证码按钮
    ZPCountDownButton *codeBtn = [ZPCountDownButton buttonWithType:UIButtonTypeCustom];
    codeBtn.width = codeView.width / 1.5;
    codeBtn.height = 25;
    codeBtn.center = codeView.center;
    codeBtn.layer.borderColor = kColor.CGColor;
    codeBtn.layer.borderWidth = 1;
    [codeBtn setTitleColor:kColor forState:UIControlStateNormal];
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    codeBtn.layer.cornerRadius = 5;
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [codeView addSubview:codeBtn];
    codeBtn.enabled = NO;
    _codeBtn = codeBtn;
    [codeBtn addToucheHandler:^(ZPCountDownButton*sender, NSInteger tag) {
        
        sender.enabled = NO;
        sender.width = 80;
        
        [sender startWithSecond:60];
        
        [sender didChange:^NSString *(ZPCountDownButton *countDownButton,int second) {
            NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
            return title;
        }];
        [sender didFinished:^NSString *(ZPCountDownButton *countDownButton, int second) {
            countDownButton.enabled = YES;
            countDownButton.width = 90;
            return @"点击重新获取";
            
        }];
        
    }];
   
        
    CGFloat codeTextY = CGRectGetMaxY(self.callText.frame);
    UITextField *codeText = [[UITextField alloc]init];
    codeText.frame = CGRectMake(0, codeTextY + pading, W, H);
    codeText.backgroundColor = [UIColor whiteColor];
    codeText.placeholder = @"请输入验证码";
    codeText.delegate = self;
    codeText.rightView = codeView;
    codeText.borderStyle = UITextBorderStyleRoundedRect;
    codeText.rightViewMode = UITextFieldViewModeAlways;
    codeText.leftViewMode = UITextFieldViewModeAlways;
    codeText.leftView = codeIcon;
    codeText.keyboardType = UIKeyboardTypeNumberPad;
    [codeText rightViewRectForBounds:self.codeBtn.bounds];
    self.codeText = codeText;
    [self.codeText addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:codeText];
    
    //提交信息按钮
    CGFloat submitY = CGRectGetMaxY(codeText.frame) + pading;
    UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake(pading, submitY, W - 2 *pading, H)];
    submit.backgroundColor = kColor;
    [submit setTitle:@"确定" forState:UIControlStateNormal];
    submit.layer.cornerRadius = 5;
    [submit addTarget:self action:@selector(SubmitCallLetter) forControlEvents:UIControlEventTouchUpInside];
    self.submitBtn = submit;
    [self.view addSubview:submit];
}

/**
 *  判断两个文本框的内容
 */
-(void)textChange{
    _codeBtn.enabled = _callText.text.length == 11;
//    _submitBtn.enabled = _callText.text.length == 11 && _codeText.text.length == 4;
//    _submitBtn.showsTouchWhenHighlighted = _submitBtn.enabled;

}

//修改手机号码成功退出登录
//-(void)logout{
//
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    //和下面代码顺序调换的话蒙板会先显示
//    UBLoginViewController *loagin =  [[UBLoginViewController alloc]init];
//    loagin.logAgain = YES;
//    ZPBaseNavigationController *navi = [[ZPBaseNavigationController alloc]initWithRootViewController:loagin];
//    delegate.window.rootViewController  = navi;
//    //[delegate.window makeKeyAndVisible];
//    
//}

#pragma mark - 退出登录
-(void)logout{
    //显示蒙板
    [MBProgressHUD showMessage:@"修改成功，请重新登录"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUD];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //和下面代码顺序调换的话蒙板会先显示
        
        [delegate loginRootViewController];
        [self.sideMenuViewController setContentViewController:delegate.mainViewController animated:YES];
        [self.sideMenuViewController hideMenuViewController];
        
    });
    
}


//提交手机信息
-(void)SubmitCallLetter{
    
    if(![UIDevice checkNowNetworkStatus]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showIndicator:KNetworkError];
            });
        return;
    }
    
    [Interface modifyMobile:self.callText.text sms:self.codeText.text block:^(id result) {
        NSNumber *num = [result objectForKey:@"errorCode"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([num isEqualToNumber:@0]) {
                    //删除原来账户信息
                    [ZPUiutsHelper deletelastMobileMessage];
                    
                    [SFHFKeychainUtils storeUsername:KCSUBPASSWORD andPassword:_callText.text forServiceName:[[NSBundle mainBundle] bundleIdentifier] updateExisting:YES error:NULL];
                    //保存新的账户信息
                    [ZPUiutsHelper storeNowMobileLoginResult:result];
                    
                    [self logout];

                }else if([num isEqualToNumber:@-2]){
                    [self warningWithTitle:@"手机已被注册"];
                    
                }else{
                    [self warningWithTitle:@"验证码错误"];

                }
            });
    }];
}

//warning蒙版
-(void)warningWithTitle:(NSString *)title{
    [MBProgressHUD showMessage:title];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
}

//获取验证码
-(void)getCode{
    
    if(![UIDevice checkNowNetworkStatus]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showIndicator:KNetworkError];
            });
        return;
    }
    
    [Interface vertifyCodeWithcallLetter:self.callText.text type:3 block:^(id result) {
    
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    int kMaxLength = 11;
    if(textField == self.codeText){
        kMaxLength = 4;
    }
    NSInteger strLength = textField.text.length - range.length + string.length;
    //输入内容的长度 - textfield区域字符长度（一般=输入字符长度）+替换的字符长度（一般为0）
    return (strLength <= kMaxLength);
   
}


@end
