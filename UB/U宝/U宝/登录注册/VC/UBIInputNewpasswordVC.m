//
//  UBIInputNewpasswordVC.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/9/17.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "UBIInputNewpasswordVC.h"
#import "ZPLeftViewTextField.h"

@interface UBIInputNewpasswordVC ()<UITextFieldDelegate>{
    ZPLeftViewTextField *code;
    ZPLeftViewTextField *comfirmCode;
   UIButton *comfirmButton;
    
    BOOL isLoookBackSuccess;
    NSDictionary *modifyResult;
}

@end

@implementation UBIInputNewpasswordVC
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
    
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    topLabel.text = @"输入新密码";
    topLabel.textColor = IWColor(91, 91, 91);
    topLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:topLabel];
    
    NSArray *imgs = @[@"密码",@"密码"];
    NSArray *places = @[@"请输入6-16位密码",@"确认您的密码"];
    for(int i = 0;i < 2;i++){
        
        float margin = 10;
        float itemheight = 50;
        CGRect rect =  CGRectMake(0, topLabel.bottom +  margin + (itemheight + margin) * i, KSCREEWIDTH, itemheight);
        ZPLeftViewTextField *text = [[ZPLeftViewTextField alloc]initWithFrame:rect];
        text.returnKeyType = UIReturnKeyDone;
        text.placeholder = [places objectAtIndex:i];
        text.delegate = self;
        text.secureTextEntry = YES;
        [text addLeftImgViewText:[imgs objectAtIndex:i]];
        [self.view addSubview:text];
        if(i ==0) code = text;
        if(i == 1)comfirmCode = text;
    }
    
    comfirmButton = [self customButton:@"确定"];
    comfirmButton.frame = CGRectMake(10, 160, KSCREEWIDTH - 20, 40);
    [self.view addSubview:comfirmButton];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    int kMaxLength = 16;
    NSInteger strLength = textField.text.length - range.length + string.length;
    //输入内容的长度 - textfield区域字符长度（一般=输入字符长度）+替换的字符长度（一般为0）
    return (strLength <= kMaxLength);
}

- (BOOL)textFieldShouldReturn:(nonnull UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

/*
 *   手机号能用,通过验证码找回密码
 */
- (void)customButtonAction:(UIButton *)button{
    if(code.text.length < 6){
        [self showAlert:@"密码少于6位"];
        return;
    }
    if(![code.text isEqualToString:comfirmCode.text]){
        [self showAlert:@"两次输入不统一"];
        return;
    }
    
    if(self.mobileUnuseful){
    
        if(isLoookBackSuccess){
        
            [self getBindingVehicleList];
        }else{
            [self modifyPasswordMobileUnUseful];
        
        }
    }else{
    
        if(isLoookBackSuccess){
        
            [self getBindingVehicleList];
        }else{
        
        
            [self modifyPasswordMobileUseful];
        }
    }
}


/*
 *   手机号不能用
 */
- (void)modifyPasswordMobileUnUseful{
    
    //找回密码  手机号不能用
    __weak typeof(self) this = self;
    [MBProgressHUD showMessage:KIndicatorStr];
    [Interface newMobileResetNumberAndPasswordcallLetter:_mobile password:comfirmCode.text sms:_vertifyCode block:^(id result) {
        
        isLoookBackSuccess = YES;
        modifyResult = result;
        
        //请求设备列表
        [this getBindingVehicleList];
        
        
    }failblock:^(id result) {
        
        isLoookBackSuccess = NO;
        
         [this modifyFailureHand:result];
    }];
}


/*
 *   手机号能用
 */
- (void)modifyPasswordMobileUseful{

    //找回密码 手机号能用
    __weak typeof(self) this = self;
    [MBProgressHUD showMessage:KIndicatorStr];
    [Interface lookBackPassword:_mobile password:comfirmCode.text sms:_vertifyCode block:^(id result) {
        
        isLoookBackSuccess = YES;
        modifyResult = result;
        
        //请求设备列表
        [this getBindingVehicleList];
        
        
    }failblock:^(id result) {
        
        isLoookBackSuccess = NO;
        
        [this modifyFailureHand:result];
    }];

}


//登录且列表请求成功
- (void)modifySuccessHand:(NSDictionary *)result{

    if(self.mobileUnuseful){
        
        //0.删除旧账号登录信息
        [ZPUiutsHelper deletelastMobileMessage];
    
        
        //1.记住新账号密码
        [SFHFKeychainUtils storeUsername:KCSUBPASSWORD andPassword:_mobile forServiceName:[[NSBundle mainBundle] bundleIdentifier] updateExisting:YES error:NULL];
        [SFHFKeychainUtils storeUsername:KCSUBPASSWORD andPassword:comfirmCode.text forServiceName:[[NSBundle mainBundle] bundleIdentifier] updateExisting:YES error:NULL];
        
    }
    
    //2.缓存新账号登录信息
    [ZPUiutsHelper storeNowMobileLoginResult:result];
}

//登录失败
- (void)modifyFailureHand:(NSDictionary *)result{
    //获取提示信息
    NSString *indicatorstr;
    if([result objectForKey:KServererrorMsgStr] == nil ||
       [[result objectForKey:KServererrorMsgStr] isKindOfClass:[NSNull class]]){
        indicatorstr = KLookCodeError;
    }else{
        indicatorstr = [result objectForKey:KServererrorMsgStr];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showError:indicatorstr delay:1.0];
    });
}



/*
 *   1.获取绑定设备车辆列表
 */
- (void)getBindingVehicleList{
    
    __weak typeof(self) this = self;
    [Interface getBindingVehicleWithType:1 block:^(id result) {
        
        NSLog(@"%@",result);
        NSArray *data = [result objectForKey:KServerdataStr];
        if(data.count == 0){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                [this.navigationController pushViewController:[[BindOBDTerminalVC alloc]init] animated:YES ];
            });
        }else{
            
            NSDictionary *dic = [[result objectForKey:KServerdataStr] firstObject];
            [[CurrentDeviceModel shareInstance] setKeyValues:dic];
            
            [this modifySuccessHand:modifyResult];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [appdelegate MainrootViewController];
            });
        }
        
    }failblock:^(id result){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showError:KLookCodeError delay:1.0];
        });
    }];
}

@end
