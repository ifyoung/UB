//
//  MillegeRewardSelectVC.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/19.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import "MillegeRewardSelectVC.h"
#import "BindTopPregress.h"
@interface MillegeRewardSelectVC ()<UIAlertViewDelegate>{
  
    float left;
    UIButton *selectedB;
    BOOL isBindingSuccess;
}

@end

@implementation MillegeRewardSelectVC
- (void)loadView{
    [super loadView];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    scrollView.contentSize = CGSizeMake(KSCREEWIDTH,KSCREEHEGIHT - 64 + 1);
    scrollView.showsVerticalScrollIndicator = NO;
    self.view = scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定智能终端";
    
    [self createTopPregress];
    
    [self createMilegeReward];
    
    [self createBottomButton];
}


/*
 *   头部进度
 */
- (void)createTopPregress{
    BindTopPregress *pregress = [BindTopPregress bindTopPregress:2];
    [self.view addSubview:pregress];
}


/*
 *   选择里程
 */
- (void)createMilegeReward{
    NSArray *titles = @[@"5,000km/年",@"10,000km/年",@"15,000km/年",@"20,000km/年",@"25,000km/年"];
    NSArray *monneys= @[@"返300元",@"返200元",@"返100元",@"返50元",@"返20元"];
    for(int i = 0;i < 5;i++){
        
        MillegeRewardSelectButton *button = [MillegeRewardSelectButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + 1;
        button.titleLabel.textAlignment = NSTextAlignmentLeft;
        [button setImage:[UIImage imageNamed:@"临时未选中绑定"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"临时选中绑定"] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        [self.view addSubview:button];
        //button.backgroundColor = [UIColor redColor];
        button.frame = CGRectMake(20, 100 + 30 * i, (KSCREEWIDTH - 40) / 3.0 * 2, 20);
        
        UILabel *rightL = [[UILabel alloc]init];
        rightL.textAlignment = NSTextAlignmentLeft;
        rightL.text = [monneys objectAtIndex:i];
        [rightL setTextColor:kColor range:NSMakeRange(1, rightL.text.length - 2)];
        [self.view addSubview:rightL];
        rightL.frame = CGRectMake(0, button.top, button.width, button.height);
        [rightL sizeToFit];
        rightL.right = KSCREEWIDTH - 30;
        if(i == 0){
            left = rightL.left;
            button.selected = NO;
        }else{
            button.selected = NO;
        }
        if(i == 2){
            button.selected = YES;
            selectedB = button;
        }
        rightL.left = left;
    }
}


/*
 *   选择里程奖励
 */
- (void)selectedAction:(UIButton *)button{
    selectedB.selected = !selectedB.selected;
    button.selected = !button.selected;
    selectedB = button;
}


/*
 *   下一步按钮
 */
- (void)createBottomButton{
    UIButton *bobutton = [self customButton:@"提交"];
    bobutton.frame = CGRectMake(20, KSCREEHEGIHT - 64 - 80, KSCREEWIDTH - 40, 40);
    [self.view addSubview:bobutton];
}
- (void)customButtonAction:(UIButton *)button{
    [MBProgressHUD showMessage:KIndicatorStr];
    
    
    if(!self.isAddMoreCar){
       
        if(isBindingSuccess){
        
            [self getBindingVehicleList];
        }else{
        
            [self bindingCar];
        }
    }else{
    
        if(isBindingSuccess){
        
            [self popToCarManagerVC];
        }else{
        
            [self bindingCar];
        }
    }
    
}


- (void)bindingCar{
    __weak typeof(self) this = self;
    [Interface swipeQRCodeBindCarWithimei:self.qrcode plateNo:self.plateNo distanceLevel:[NSString stringWithFormat:@"%ld",(long)selectedB.tag] block:^(id result) {
        
        NSLog(@"%@",result);
        
        if([[result objectForKey:KServererrorCodeStr]  isEqual: @0]){
            isBindingSuccess = YES;
            
            
            //绑第一辆车  获取绑定设备车辆列表
            if(!this.isAddMoreCar){
                [this getBindingVehicleList];
            }else{
                [this popToCarManagerVC];
            }
            
            
        }else{
            isBindingSuccess = NO;
            
            //绑定失败
            //获取提示信息
            NSString *indicatorstr;
            if([result objectForKey:KServererrorMsgStr] == nil ||
               [[result objectForKey:KServererrorMsgStr] isKindOfClass:[NSNull class]]){
                indicatorstr = KBindingError;
            }else{
                indicatorstr = [result objectForKey:KServererrorMsgStr];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showError:indicatorstr delay:1.0];
            });
        }
    }];
}



/*
 *   2。 添加更多辆爱车
 */
- (void)popToCarManagerVC{
    __weak typeof(self) this = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD:0];
        
#ifdef __IPHONE_8_0
        //弹出绑定成功界面
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜你！" message:@"成功录入相关信息\n系统将在2小时内给您审核" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [this.navigationController popToRootViewControllerAnimated:YES];
            });
        }];
        [alert addAction:cancelAction1];
        [this presentViewController:alert animated:YES completion:NULL];
#else
        
        
       UIAlertView *alertView  = [ZPUiutsHelper showAlertView:@"恭喜你！" Message:@"成功录入相关信息\n系统将在2小时内给您审核" delegate:self];
        alertView.tag = 3000;

#endif
        
    });
}

/*
 *   1.获取绑定设备车辆列表 添加第一辆爱车
 */
- (void)getBindingVehicleList{
    __weak typeof(self) this = self;
    [Interface getBindingVehicleWithType:1 block:^(id result) {
        
        NSLog(@"%@",result);
        NSArray *data = [result objectForKey:KServerdataStr];
        if(data.count == 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showError:KBindingError delay:1.0];
                });
                
            });
        }else{
            
            NSDictionary *dic = [[result objectForKey:KServerdataStr] firstObject];
            [[CurrentDeviceModel shareInstance] setKeyValues:dic];

            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD:0];
                
                
                #ifdef __IPHONE_8_0
                //弹出绑定成功界面
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜你！" message:@"成功录入相关信息\n系统将在2小时内给您审核"preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [appdelegate MainrootViewController];
                    });
                }];
                [alert addAction:cancelAction1];
                [this presentViewController:alert animated:YES completion:NULL];
                #else
                
                UIAlertView *alertView  = [ZPUiutsHelper showAlertView:@"恭喜你！" Message:@"成功录入相关信息\n系统将在2小时内给您审核" delegate:self];
                alertView.tag = 1000;
                                
                #endif
                
            });
            
            
        }
    }failblock:^(id result){
 
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showError:KBindingError delay:1.0];
        });
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1000){
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [appdelegate MainrootViewController];
        });

    }else if (alertView.tag == 3000){
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }
}

@end


@implementation MillegeRewardSelectButton
//内部图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(0, 0, imageH, imageH);
}
//内部文字的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat margin = 10;
    CGFloat width  = contentRect.size.width;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleH + margin, 0,width - titleH - margin , titleH);
}
@end