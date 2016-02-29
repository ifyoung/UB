//
//  UBRegisterViewController.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/19.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import "UBRegisterViewController.h"
#import "ZPCountDownButton.h"
#import "UBIRegisterView.h"

@interface UBRegisterViewController (){
 
    ZPCountDownButton *vertify;
    UIButton *logbutton;
    UBIRegisterView *resgister;
    UITextField *mobile ;
    UITextField *vertifycode;
    UITextField *code ;
    UITextField *comfirm;
    
    BOOL isRegisterSuccess;
    NSDictionary *registerSuccResult;
}

@end

@implementation UBRegisterViewController

- (void)loadView{
    [super loadView];
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectZero];
    scrollView.contentSize = CGSizeMake(KSCREEWIDTH,KSCREEHEGIHT - 64 + 1);
    scrollView.showsVerticalScrollIndicator = NO;
    self.view = scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = bggrayColor;
    
    [self createSubViews];
}


/*
 *   createSubViews
 */
- (void)createSubViews{
    
    resgister = [UBIRegisterView shareUBIRegisterView];
    mobile = (UITextField *)[resgister viewWithTag:1000];
    vertifycode = (UITextField *)[resgister viewWithTag:1001];
    code = (UITextField *)[resgister viewWithTag:1002];
    comfirm = (UITextField *)[resgister viewWithTag:1003];
    [self.view addSubview:resgister];
    
    [mobile addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    
    vertify = [ZPCountDownButton buttonWithType:UIButtonTypeCustom];
    vertify.layer.cornerRadius = 4;
    vertify.layer.masksToBounds = YES;
    vertify.layer.borderWidth = 1.0f;
    vertify.layer.borderColor = kColor.CGColor;
    vertify.userInteractionEnabled  = YES;
    vertify.showsTouchWhenHighlighted = YES;
    vertify.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    
    [vertify setTitleColor:kColor  forState:UIControlStateNormal];
    [vertify setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateHighlighted];
    [vertify setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    [vertify addTarget:self action:@selector(highlightBorder) forControlEvents:UIControlEventTouchDown];

    [vertify addTarget:self action:@selector(getVertifyCodeLogAction) forControlEvents:UIControlEventTouchUpInside];
    vertify.frame = CGRectMake(0,70, 80, 30);
    vertify.right = KSCREEWIDTH - 20;
    [self.view addSubview:vertify];
    vertify.enabled = NO;
    
    
    [vertify addToucheHandler:^(ZPCountDownButton*sender, NSInteger tag) {
 
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
    
    
    logbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    logbutton.layer.cornerRadius = 4;
    logbutton.layer.masksToBounds = YES;
    logbutton.userInteractionEnabled  = YES;
    logbutton.showsTouchWhenHighlighted = YES;
    logbutton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [logbutton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    [logbutton addTarget:self action:@selector(resAndLogAction) forControlEvents:UIControlEventTouchUpInside];
    logbutton.backgroundColor = [UIColor lightGrayColor];
    [logbutton setTitle:@"注册并登录" forState:UIControlStateNormal];
    logbutton.enabled = NO;
    logbutton.frame = CGRectMake(10, resgister.bottom + 20, KSCREEWIDTH - 20, 40);
    [self.view addSubview:logbutton];
    
    
    acceptButton *accept = [acceptButton buttonWithType:UIButtonTypeCustom];
    accept.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [accept setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
    [accept setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [accept setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    [accept addTarget:self action:@selector(acceptAction:) forControlEvents:UIControlEventTouchUpInside];
    [accept setTitle:@"我已经接受并阅读" forState:UIControlStateNormal];
    accept.frame = CGRectMake(10, logbutton.bottom + 20, 140, 20);
    [self.view addSubview:accept];
    //accept.backgroundColor = [UIColor greenColor];
    
    
    bottomlineButton *bottomline = [bottomlineButton buttonWithType:UIButtonTypeCustom];
    bottomline.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [bottomline setTitleColor:kColor  forState:UIControlStateNormal];
    [bottomline addTarget:self action:@selector(bottomlineAction) forControlEvents:UIControlEventTouchUpInside];
    bottomline.showsTouchWhenHighlighted = YES;
    [bottomline setTitle:@"车圣U宝相关协议" forState:UIControlStateNormal];
    bottomline.frame = CGRectMake(accept.right, logbutton.bottom + 20, 110, 20);
    bottomline.height = 20;
    //bottomline.backgroundColor = [UIColor redColor];

    [self.view addSubview:bottomline];
}


- (void)textFieldWithText:(UITextField *)textField{
    if(textField.text.length == 11){
        vertify.enabled = YES;
    }else{
        vertify.enabled = NO;
    }
}

/*
 *   getVertifyCodeLogAction
 */
- (void)highlightBorder
{
    vertify.layer.borderColor = [[UIColor lightGrayColor]CGColor];
}

- (void)getVertifyCodeLogAction{
    
    vertify.layer.borderColor = [kColor CGColor];
    [Interface vertifyCodeWithcallLetter:mobile.text type:1 block:^(id result) {
        
        NSLog(@"%@",result);
        if([[result objectForKey:KServererrorCodeStr]  isEqual: @0]){
            vertify.isCodeSuccess = YES;
        }else{
            vertify.isCodeSuccess = NO;
        
        }
    }];
}


/*
 *   resAndLogAction
 */
- (void)resAndLogAction{

    if(![NSString isValidatePhone:mobile.text]){
        [self showAlert:@"请出入正确的手机号"];
        return;
    }
    if(vertifycode.text.length == 0){
        [self showAlert:@"验证码不能为空"];
        return;
    }
    if(code.text.length == 0){
        [self showAlert:@"密码不能为空"];
        return;
    }
    if(code.text.length  < 6){
        
        [self showAlert:@"密码6-16位"];
        return;
    }
    if(comfirm.text.length == 0 || comfirm.text.length  < 6){
        [self showAlert:@"密码不一致"];
        return;
    }
    if(comfirm.text.length  < 6){
    
    }
    if(![code.text isEqualToString:comfirm.text]) return;
    
    
    [MBProgressHUD showMessage:KIndicatorStr];
    if(isRegisterSuccess){
       
        [self getBindingVehicleList];
    }else{
    
        [self regist];
    }
}

/*
 *   注册
 */
- (void)regist{

     __weak typeof(self) this = self;
    [Interface registerWithCallLetter:mobile.text  password:code.text sms:vertifycode.text block:^(id result) {
        
        isRegisterSuccess = YES;
        registerSuccResult = result;
        
        //请求设备列表
        [this getBindingVehicleList];
        
    }failblock:^(id result) {
        
        isRegisterSuccess = NO;
        
        //获取提示信息
        NSString *indicatorstr;
        if([result objectForKey:KServererrorMsgStr] == nil ||
           [[result objectForKey:KServererrorMsgStr] isKindOfClass:[NSNull class]]){
            indicatorstr = KRegisterError;
        }else{
            indicatorstr = [result objectForKey:KServererrorMsgStr];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showError:indicatorstr delay:1.0];
        });
    }];
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

            //请求列表成功存储登录信息
            [this storeLoginMessage:registerSuccResult];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [appdelegate MainrootViewController];
            });
        }
        
    }failblock:^(id result){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showError:KRegisterError delay:1.0];
        });

    }];
}



/*
 *   存储登录后信息
 */
- (void)storeLoginMessage:(NSDictionary *)result{
    
    //0.记住账号密码
    [SFHFKeychainUtils storeUsername:KCSUBUSERACCOUNT andPassword:mobile.text forServiceName:[[NSBundle mainBundle] bundleIdentifier] updateExisting:YES error:NULL];
    [SFHFKeychainUtils storeUsername:KCSUBPASSWORD andPassword:code.text forServiceName:[[NSBundle mainBundle] bundleIdentifier] updateExisting:YES error:NULL];
    
    
    //1.缓存登录信息
    [ZPUiutsHelper storeNowMobileLoginResult:result];
}


/*
 *   acceptAction
 */
- (void)acceptAction:(UIButton *)button{
    button.selected = !button.selected;
    logbutton.enabled = button.selected;
    logbutton.backgroundColor = button.selected? kColor:[UIColor lightGrayColor];
}

/*
 *   bottomlineAction
 */
- (void)bottomlineAction{
    [self pushToViewController:@"UBIProtecolVC"];
}


@end


@implementation acceptButton
// 内部图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 20;
    CGFloat imageH = 20;
    return CGRectMake(0, 0, imageW, imageH);
}
// 内部文字的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height;
    CGFloat titleW = contentRect.size.width;
    return CGRectMake(25, 0, titleW, titleY);
}
@end

@implementation bottomlineButton
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [self addLineOfTop:NO b:YES l:NO r:NO color:kColor wid:.5];
}


@end

