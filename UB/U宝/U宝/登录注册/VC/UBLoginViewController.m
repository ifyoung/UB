//
//  UBLoginViewController.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/19.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import "UBLoginViewController.h"
#import "UBILogView.h"
#import "MillegeRewardSelectVC.h"


@interface UBLoginViewController (){
  
    UBILogView *loginView;
    
     BOOL isLoginSuccess;
    NSDictionary *loginSuccResult;
}
@end

@implementation UBLoginViewController
- (void)loadView{
    [super loadView];
    
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectZero];
    scrollView.contentSize = CGSizeMake(KSCREEWIDTH,KSCREEHEGIHT - 64 + 1);
    scrollView.showsVerticalScrollIndicator = NO;
    self.view = scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = bggrayColor;
 
    [self createSubViews];
    
}


/*
 *   createSubViews
 */
- (void)createSubViews{
    UIImageView *head = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 60, 60)];
    head.center = CGPointMake(KSCREEWIDTH / 2.0 , head.center.y);
    head.image = [UIImage imageNamed:@"默认头像"];
    head.layer.cornerRadius = 30;
    head.layer.borderColor = [UIColor lightGrayColor].CGColor;
    head.layer.borderWidth = 1.0f;
    head.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self.view addSubview:head];
    
    loginView = [UBILogView shareUBILogView];
    [self.view addSubview:loginView];
    
    loginView.user = [SFHFKeychainUtils getPasswordForUsername:KCSUBUSERACCOUNT andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL];
    loginView.code = [SFHFKeychainUtils getPasswordForUsername:KCSUBPASSWORD andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL];
    
    UIButton *button = [self customButton:@"登录"];
    button.frame = CGRectMake(10, loginView.bottom + 20, KSCREEWIDTH - 20, 40);
    [self.view addSubview:button];
    
    //注册、忘记密码
    for(NSInteger i=0;i < 2;i++){
        UIButton *registerbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        registerbutton.showsTouchWhenHighlighted = YES;
        registerbutton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [registerbutton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        [registerbutton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
        [registerbutton setTitleColor:i == 0? kColor:[UIColor grayColor] forState:UIControlStateNormal];
        [registerbutton setTitle:i == 0? @"注册":@"忘记密码？" forState:UIControlStateNormal];
        registerbutton.frame = CGRectMake(KSCREEWIDTH - 120 + 40 * i, button.bottom + 10, 40, 20);
        [registerbutton sizeToFit];
        [self.view addSubview:registerbutton];
        if(i == 0){
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(registerbutton.right  + 5, button.bottom + 13,1, 20)];
            line.backgroundColor = [UIColor lightGrayColor];
            [self.view addSubview:line];
        }
     }
}


/*
 *   登录
 */
- (void)customButtonAction:(UIButton *)button{
    if(![NSString isValidatePhone:loginView.user]){
        [self showAlert:@"请输入正确的手机号"];
        return;
    }
    if(loginView.code.length == 0 || loginView.code.length < 6){
        [self showAlert:@"密码少于6位"];
        return;
    }
    
    if(isLoginSuccess){
    
        [self getBindingVehicleList];
    }else{
        [self loginRequest];
    
    }
    
}


/*
 *   登录请求
 data =     {
         days = 10;
         imgUrl = "<null>";
         lastLogin = 1444275642744;
         nickname = "<null>";
 };
 errorCode = 0;
 errorMsg = "<null>";
 */
- (void)loginRequest{
    
    if(![UIDevice checkNowNetworkStatus]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showIndicator:KNetworkError];
        });
        return;
    }
    
    __weak typeof(self) this = self;
    
    [MBProgressHUD showMessage:KIndicatorStr];
    
    
    //-2用户名 密码错误
    [Interface loginWithName:loginView.user password:loginView.code block:^(id result) {
        
        isLoginSuccess = YES;
        loginSuccResult = result;
        
        //请求设备列表
        [this getBindingVehicleList];
        
   }failblock:^(id result) {
       
       
       isLoginSuccess = NO;
       
       //登录失败
       //获取提示信息
       NSString *indicatorstr;
       if([result objectForKey:KServererrorMsgStr] == nil ||
          [[result objectForKey:KServererrorMsgStr] isKindOfClass:[NSNull class]]){
           indicatorstr = KLoginError;
       }else{
           indicatorstr = [result objectForKey:KServererrorMsgStr];
       }
       dispatch_async(dispatch_get_main_queue(), ^{
           [MBProgressHUD showError:indicatorstr delay:1.0];
       });

   }];
}


/*
 *   存储登录后信息
 */
- (void)storeLoginMessage:(NSDictionary *)result{

    //2.记住账号密码
    [SFHFKeychainUtils storeUsername:KCSUBUSERACCOUNT andPassword:loginView.user forServiceName:[[NSBundle mainBundle] bundleIdentifier] updateExisting:YES error:NULL];
    [SFHFKeychainUtils storeUsername:KCSUBPASSWORD andPassword:loginView.code forServiceName:[[NSBundle mainBundle] bundleIdentifier] updateExisting:YES error:NULL];
    
    
    //1.缓存登录信息
    [ZPUiutsHelper storeNowMobileLoginResult:result];
}


/*
 *   1.获取绑定设备车辆列表
 */
- (void)getBindingVehicleList{
    
    __weak typeof(self) this = self;
    __block AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    __block ProceedsVC *proceedVC =  [ProceedsVC shareInstance];
    __block CarViewController *carVC = [CarViewController shareInstance];
    __block PeccancyListVC *peccancyVC = [PeccancyListVC shareInstance];

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
            [this storeLoginMessage:loginSuccResult];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(this.logAgain){ ////退出登录后
                    
                    [MBProgressHUD hideHUD];
                    proceedVC.isLoadDataCompete = NO;
                    carVC.isLoadDataCompete = NO;
                    peccancyVC.isLoadDataCompete = NO;
                }
                
                delegate.mainViewController = nil;
                
                [delegate MainrootViewController];
            });
        }
        
    }failblock:^(id result){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showError:KLoginError delay:1.0];
            });
    }];
}


/*
 *   进入注册/忘记密码
 */
- (void)registerAction:(UIButton *)button{
    if([button.titleLabel.text isEqualToString:@"注册"]){
        [self pushToViewController:@"UBRegisterViewController"];
    }else{
        [self pushToViewController:@"UBIForgetLogpasswordVC"];
    }
}
@end
