//
//  ChangePasswordVC.m
//  车圣U宝
//
//  Created by 冥皇剑 on 15/10/13.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "ZPCountDownButton.h"
#import "phoneNumModel.h"

@interface ChangePasswordVC ()<UITextFieldDelegate>

/**新密码*/
@property(nonatomic,strong)UITextField *pwdText;
/**确认新密码*/
@property(nonatomic,strong)UITextField *confirmPWD;
/**验证码*/
@property(nonatomic,strong)UITextField *codeText;

@property(nonatomic,strong)UIButton *submitBtn;

@property(nonatomic,assign)BOOL selected;

@property(nonatomic,strong)phoneNumModel *phoneModel;

@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = IWColorAlpha(238, 238, 239, 1.0);
    self.title = @"修改密码";
    self.selected = NO;
    [self getUserInfo];
    [self createSubview];
    
}

-(void)getUserInfo{
    [Interface getUserDetailMessageWithblock:^(id result) {
        
        NSDictionary *dic = [result objectForKey:KServerdataStr];
        
        _phoneModel = [phoneNumModel phoneWithDict:dic];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
    }];
    
}

-(void)createSubview{

    
    CGFloat pading = 20.0;
    CGFloat W = KSCREEWIDTH;
    CGFloat H = 44;
    
    //密码相关
    UILabel *callLabel = [[UILabel alloc]init];
    callLabel.frame = CGRectMake(pading, pading, W, H);
    callLabel.text = @"新密码";
    callLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:callLabel];
    
//    UIImageView *callIcon = [[UIImageView alloc] init];
//    callIcon.image = [UIImage imageNamed:@"密码"];
//    callIcon.width = 50;
//    callIcon.height = 30;
//    callIcon.contentMode = UIViewContentModeCenter;
    
    CGFloat callTextY = CGRectGetMaxY(callLabel.frame);
    for (int i = 0; i<2; i++) {
        
        UITextField *callText = [[UITextField alloc]init];
        callText.frame = CGRectMake(0, callTextY + i * H, W, H);
        callText.backgroundColor = [UIColor whiteColor];
        callText.borderStyle = UITextBorderStyleRoundedRect;
        callText.placeholder = i == 0 ?@"6-16个字符，区分大小写" : @"请再输入一次";
        callText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
        callText.leftViewMode = UITextFieldViewModeAlways;
        callText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        callText.clearButtonMode = UITextFieldViewModeWhileEditing;
        callText.delegate = self;
        [callText addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:callText];
        if (i == 0) {
            
            self.pwdText = callText;
        }else{
            self.confirmPWD = callText;
        }
    }
    
//    //验证码相关
//    CGFloat codeLabelY = CGRectGetMaxY(self.confirmPWD.frame);
//    UILabel *codeLabel = [[UILabel alloc]init];
//    codeLabel.frame = CGRectMake(pading, codeLabelY, W, H);
//    codeLabel.text = @"验证码";
//    codeLabel.font = [UIFont systemFontOfSize:17];
//    [self.view addSubview:codeLabel];
    
    UIImageView *codeIcon = [[UIImageView alloc] init];
    codeIcon.image = [UIImage imageNamed:@"短信"];
    codeIcon.width = 60;
    codeIcon.height = 30;
    codeIcon.contentMode = UIViewContentModeCenter;
    
    UIView *codeView = [[UIView alloc]init];
    codeView.width = W / 3;
    codeView.height = H / 2;

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
    codeBtn.enabled = YES;
    [codeView addSubview:codeBtn];
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

    
    CGFloat codeTextY = CGRectGetMaxY(self.confirmPWD.frame) + pading;
    UITextField *codeText = [[UITextField alloc]init];
    codeText.frame = CGRectMake(0, codeTextY, W, H);
    codeText.backgroundColor = [UIColor whiteColor];
    codeText.placeholder = @"您收到的手机短信";
    codeText.rightView = codeView;
    codeText.borderStyle = UITextBorderStyleRoundedRect;
    codeText.rightViewMode = UITextFieldViewModeAlways;
    codeText.leftViewMode = UITextFieldViewModeAlways;
    codeText.leftView = codeIcon;
    codeText.keyboardType = UIKeyboardTypeNumberPad;
    codeText.delegate = self;
    [codeText rightViewRectForBounds:codeBtn.bounds];
    [codeText addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    self.codeText = codeText;
    [self.view addSubview:codeText];
    
    //提交信息按钮
    CGFloat submitY = CGRectGetMaxY(codeText.frame) + pading;
    UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake(pading, submitY, W - 2 *pading, H)];
    submit.backgroundColor = kColor;
    [submit setTitle:@"确定" forState:UIControlStateNormal];
    submit.layer.cornerRadius = 5;
    [submit addTarget:self action:@selector(SubmitInformation) forControlEvents:UIControlEventTouchUpInside];

    self.submitBtn = submit;
    [self.view addSubview:submit];
    
    UIButton *showpassword = [UIButton buttonWithType:UIButtonTypeCustom];
    showpassword.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [showpassword setTitleColor:[UIColor grayColor]  forState:UIControlStateNormal];
    [showpassword addTarget:self action:@selector(showpasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [showpassword setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateNormal];
    
    
    [showpassword setTitle:@"显示密码" forState:UIControlStateNormal];
    showpassword.titleLabel.font = [UIFont systemFontOfSize:15];
    showpassword.frame = CGRectMake(pading, submit.bottom + pading, 80, H);
    [showpassword sizeToFit];
    [self.view addSubview:showpassword];
}

/**
 *  判断两个文本框的内容
 */
-(void)textChange{
//    _submitBtn.enabled = _pwdText.text.length >= 6 && _codeText.text.length == 4 && _confirmPWD.text.length >= 6;
//    _submitBtn.showsTouchWhenHighlighted = _submitBtn.enabled;
    
}

//确定Action
-(void)SubmitInformation{

    if(![UIDevice checkNowNetworkStatus]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showIndicator:KNetworkError];
            });
        return;
    }
    
    if ([_confirmPWD.text isEqualToString: _pwdText.text] && _codeText.text.length == 4 && _confirmPWD.text.length >= 6) {
        
        [Interface modifyPassword:self.confirmPWD.text sms:self.codeText.text block:^(id result) {
            NSLog(@"-----哈哈哈-----%@",result);
            NSNumber *num = [result objectForKey:@"errorCode"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([num isEqualToNumber:@0]) {
                    //保存密码
                    [SFHFKeychainUtils storeUsername:KCSUBPASSWORD andPassword:_confirmPWD.text forServiceName:[[NSBundle mainBundle] bundleIdentifier] updateExisting:YES error:NULL];

                    [self logout];
                    
                }
            });

        }];

    }else if (![_confirmPWD.text isEqualToString: _pwdText.text]){
        [self warningWithTitle:@"密码不一致，请重新输入"];
    }else{
        [self warningWithTitle:@"密码或验证码格式不正确"];
    }
    
}

//warning蒙版
-(void)warningWithTitle:(NSString *)title{
    [MBProgressHUD showMessage:title];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
}


/*
 *   showpasswordAction
 */
- (void)showpasswordAction:(UIButton *)showpassword{
    
    if (self.selected) {
        [showpassword setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        self.pwdText.secureTextEntry = self.confirmPWD.secureTextEntry = NO;
    }else{
        
        [showpassword setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        self.pwdText.secureTextEntry = self.confirmPWD.secureTextEntry = YES;
    }
    
    self.selected = !self.selected;
    
}

//获取验证码
-(void)getCode{
    
    if(![UIDevice checkNowNetworkStatus]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showIndicator:KNetworkError];
            });
        return;
    }
    
    NSLog(@"%@",_phoneModel.callLetter);
    [Interface vertifyCodeWithcallLetter:_phoneModel.callLetter type:2 block:^(id result) {
        
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - 退出登录
/**
 *  退出登录
 */
-(void)logout{
    //显示蒙板
    [MBProgressHUD showMessage:@"修改成功，请重新登录"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUD];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //和下面代码顺序调换的话蒙板会先显示
        
        [delegate loginRootViewController];
        
    });
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    int kMaxLength = 11;
    if(textField == self.pwdText || textField == self.confirmPWD){
        
        kMaxLength = 11;
    }else{
        
        kMaxLength = 4;
    }
    NSInteger strLength = textField.text.length - range.length + string.length;
    
    //输入内容的长度 - textfield区域字符长度（一般=输入字符长度）+替换的字符长度（一般为0）
    
    return (strLength <= kMaxLength);
}

@end
