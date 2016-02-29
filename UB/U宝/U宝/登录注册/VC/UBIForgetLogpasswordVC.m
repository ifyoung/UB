//
//  UBIForgetLogpasswordVC.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/20.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "UBIForgetLogpasswordVC.h"
#import "UBIInputNewpasswordVC.h"
#import "ZPLeftViewTextField.h"
#import "ZPCountDownButton.h"

@interface UBIForgetLogpasswordVC ()<UITextFieldDelegate>{
    ZPCountDownButton *vertify;
    ZPLeftViewTextField *mobile;
    ZPLeftViewTextField *code;
    UIButton *comfirmButton;
    BOOL isCodeSuccess;
}
@end

@implementation UBIForgetLogpasswordVC

- (void)loadView{
    [super loadView];
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectZero];
    scrollView.contentSize = CGSizeMake(KSCREEWIDTH,KSCREEHEGIHT - 64 + 1);
    scrollView.showsVerticalScrollIndicator = NO;
    self.view = scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    self.view.backgroundColor = bggrayColor;
    
    [self cretaeSubViews];
}


/*
 *   cretaeSubViews
 */
- (void)cretaeSubViews{
    NSArray *imgs = @[@"手机号",@"短信"];
    NSArray *places = @[@"请输入您的手机号",@"您收到的短信验证码"];
    for(int i = 0;i < 2;i++){
        float margin = 10;
        float itemheight = 50;
        CGRect rect =  CGRectMake(0, margin + (itemheight + margin) * i, KSCREEWIDTH, itemheight);
        ZPLeftViewTextField *text = [[ZPLeftViewTextField alloc]initWithFrame:rect];
        text.placeholder = [places objectAtIndex:i];
        [text addLeftImgViewText:[imgs objectAtIndex:i]];
        text.font = [UIFont systemFontOfSize:12.0f];
        text.delegate = self;
        if(i == 0){ mobile = text;text.keyboardType = UIKeyboardTypeNumberPad;}
        if(i == 1){ code = text;text.keyboardType = UIKeyboardTypeNumberPad;}
        [self.view addSubview:text];
    }
    
     [mobile addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    
    vertify = [ZPCountDownButton buttonWithType:UIButtonTypeCustom];
    vertify.layer.cornerRadius = 4;
    vertify.layer.masksToBounds = YES;
    vertify.layer.borderWidth = 1.0f;
    vertify.layer.borderColor = kColor.CGColor;
    vertify.userInteractionEnabled  = YES;
    vertify.showsTouchWhenHighlighted = YES;
    
    vertify.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [vertify setTitleColor:kColor  forState:UIControlStateNormal];
    [vertify setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateHighlighted];
    [vertify setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    [vertify addTarget:self action:@selector(highlightBorder) forControlEvents:UIControlEventTouchDown];
    [vertify addTarget:self action:@selector(getVertifyCodeLogAction) forControlEvents:UIControlEventTouchUpInside];
    vertify.frame = CGRectMake(0,80, 70, 30);
    vertify.right = KSCREEWIDTH - 10;
    vertify.enabled = NO;
    [self.view addSubview:vertify];
    
    
    [vertify addToucheHandler:^(ZPCountDownButton*sender, NSInteger tag) {
        
           sender.enabled = NO;
           [sender startWithSecond:60];
        
            [sender didChange:^NSString *(ZPCountDownButton *countDownButton,int second) {
                NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
                return title;
            }];
            [sender didFinished:^NSString *(ZPCountDownButton *countDownButton, int second) {
                countDownButton.enabled = YES;
                countDownButton.width = 75;
                countDownButton.titleLabel.font = [UIFont boldSystemFontOfSize:11.0f];
                return @"点击重新获取";
            }];
        //}
    }];
    
    
    comfirmButton = [self customButton:@"下一步"];
    comfirmButton.frame = CGRectMake(10, 130, KSCREEWIDTH - 20, 40);
    [self.view addSubview:comfirmButton];
    
    if(_mobileUnuseful) return;
    UIButton *mobileunuseful = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *title = @"手机号不能用，请点此找回密码。";
    NSMutableAttributedString *attrstring = [[NSMutableAttributedString alloc] initWithString:title attributes:
        @{
           NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
           NSForegroundColorAttributeName:kColor
        }];
    NSString *s1 = @"手机号不能用，";
    [attrstring addAttribute:NSForegroundColorAttributeName
                       value:IWColorAlpha(91, 91, 19, 1)
                       range:[title rangeOfString:s1]];
    
    
    NSMutableAttributedString *attrstring2 = [[NSMutableAttributedString alloc] initWithString:title attributes:
                                             @{
                                               NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                               NSForegroundColorAttributeName:IWColorAlpha(91, 91, 19, 1)
                                               }];
    [mobileunuseful setAttributedTitle:attrstring forState:UIControlStateNormal];
    [mobileunuseful setAttributedTitle:attrstring2 forState:UIControlStateHighlighted];
    
    
    [mobileunuseful addTarget:self action:@selector(mobileunusefulAction) forControlEvents:UIControlEventTouchUpInside];
    mobileunuseful.showsTouchWhenHighlighted = YES;
    [mobileunuseful sizeToFit];
    mobileunuseful.top = comfirmButton.bottom + 10;
    mobileunuseful.right = KSCREEWIDTH - 10;
    [self.view addSubview:mobileunuseful];
}


- (void)textFieldWithText:(UITextField *)textField{
    if(textField.text.length != 0){
        vertify.enabled = YES;
    }else{
        vertify.enabled = NO;
    }
}

/*
 *  UITextFieldDelegate
 */
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    int kMaxLength = 11;
    if(textField == mobile){
        
        kMaxLength = 11;
    }else{
    
        kMaxLength = 4;
    }
    NSInteger strLength = textField.text.length - range.length + string.length;
    
    //输入内容的长度 - textfield区域字符长度（一般=输入字符长度）+替换的字符长度（一般为0）
    
    return (strLength <= kMaxLength);
}

- (BOOL)textFieldShouldReturn:(nonnull UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}





/*
 *   获取验证码
 */
- (void)highlightBorder
{
    vertify.layer.borderColor = [[UIColor lightGrayColor]CGColor];
}
- (void)getVertifyCodeLogAction{
    
    int type = 0;
    if(self.mobileUnuseful){
        type = 5;
    }else{
        type = 4;
    }
     vertify.layer.borderColor = [kColor CGColor];
    [Interface vertifyCodeWithcallLetter:mobile.text type:type block:^(id result) {
        
        if([[result objectForKey:KServererrorCodeStr]  isEqual: @0]){
            vertify.isCodeSuccess = YES;
        }else{
            vertify.isCodeSuccess = NO;
        }
    }];
}


/*
 *   手机号能用,通过验证码找回密码
 */
- (void)customButtonAction:(UIButton *)button{
    if(mobile.text.length == 0){
        [self showAlert:@"手机号不能为空"];
        return;
    }
    if(![NSString isValidatePhone:mobile.text]){
        [self showAlert:@"请输入正确的手机号"];
        return;
    }
    if(code.text.length == 0){
        [self showAlert:@"验证码不能为空"];
        return;
    }

    
    UBIInputNewpasswordVC *inputNew = [[UBIInputNewpasswordVC alloc]init];
    inputNew.mobile      = mobile.text;
    inputNew.vertifyCode = code.text;
    inputNew.mobileUnuseful = self.mobileUnuseful;
    [self.navigationController pushViewController:inputNew animated:YES];
}


/*
 *   手机号不能用
 */
- (void)mobileunusefulAction{

    [self pushToViewController:@"UBIMobileUnusefulVC"];
}
@end
