//
//  UBIMobileUnusefulVC.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/9/17.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "UBIMobileUnusefulVC.h"
#import "UBIForgetLogpasswordVC.h"
#import "UBIInputNewpasswordVC.h"
#import "UBILookCodePlateNumberCell.h"
#import "UBILookCodeEngineCell.h"
#import "PeccancayPopToCarDetailView.h"
#import "PeccancyProvinceView.h"
#import "UBIMobileUnusefulModel.h"

@interface UBIMobileUnusefulVC ()<PeccancyProvinceViewDelegate,UITextFieldDelegate>{
 
    TPKeyboardAvoidingTableView *table;
    PeccancayPopToCarDetailView *lisence;
    PeccancyProvinceView *provinceView;
    UIView *topWrongbgView;
}

@end

@implementation UBIMobileUnusefulVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    
    [self createTBView];
}



/*
 *   UITableView
 */
- (void)createTBView{
    
    CGRect rect =  CGRectMake(0, 0, KSCREEWIDTH, KSCREEHEGIHT - 49);
    table = [[TPKeyboardAvoidingTableView alloc]initWithFrame:rect style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    table.tableFooterView = [self createViewForFooter];
}


/**
 *   查询按钮
 *
 *  @return
 */
- (UIView *)createViewForFooter{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEWIDTH, 120)];
    for(int i = 0;i < 1;i++){
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 400 + i;
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = YES;
        button.userInteractionEnabled  = YES;
        button.showsTouchWhenHighlighted = YES;
        
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [button setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        [button addTarget:self action:@selector(footerAction:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = i == 0 ? kColor : IWColor(83, 215, 105);
        [button setTitle: i == 0? @"下一步" : @"我的订单" forState:UIControlStateNormal];
        button.frame = CGRectMake(10, 10 + (40 + 10) * i  , KSCREEWIDTH - 20, 40);
        [view addSubview:button];
    }
    return view;
}
- (void)footerAction:(UIButton *)button{
    NSString *mobile =   [UBIMobileUnusefulModel shareInstance].mobile;
    NSString *plate =  [NSString stringWithFormat:@"%@%@",[UBIMobileUnusefulModel shareInstance].cityNickName,[UBIMobileUnusefulModel shareInstance].plateNo];
    NSString *vin   =    [UBIMobileUnusefulModel shareInstance].vin;
    NSString *engineNo = [UBIMobileUnusefulModel shareInstance].engineNo;
    
    if(mobile.length == 0){
        [self showAlert:@"手机号不能为空"];
        return;
    }
    if(![NSString isValidatePhone:mobile]){
        [self showAlert:@"请输入正确的手机号"];
        return;
    }
    if(plate.length == 0 || vin.length == 0 ){
        
        if(plate.length == 0){
            [self showAlert:@"车牌号不能为空"];
            return;
        }else if(vin.length == 0){
            [self showAlert:@"车架号不能为空"];
            return;
        }
    }else if (engineNo.length == 0){
    
        [self showAlert:@"请输入发动机号"];
        return;
    }
//    else if ([engineNo IsChinese]){
//        
//        [self showAlert:@"请输入正确的发动机号"];
//        return;
//    }//
    
    //丢失手机  验证身份 成功后跳转  -2验证失败
    [MBProgressHUD showMessage:KIndicatorStr];
    [Interface vertifyUserIdentity:mobile plateNo:plate vin:vin engineNo:engineNo block:^(id result) {
        
        
        if(![[result objectForKey:KServererrorCodeStr]  isEqual: @0]){
        
            NSString *indicaitorstr;
            if([result objectForKey:KServererrorMsgStr] == nil ||
               [[result objectForKey:KServererrorMsgStr] isKindOfClass:[NSNull class]]){
                indicaitorstr = KVertifyError;
            }else{
                indicaitorstr = [result objectForKey:KServererrorMsgStr];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
              [MBProgressHUD showError:indicaitorstr];
            });
 
        }else{
        
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                UBIForgetLogpasswordVC *vc = [[UBIForgetLogpasswordVC alloc]init];
                vc.mobileUnuseful = YES;
                [self.navigationController pushViewController:vc animated:YES];
            });
        }
    }];
}


/*
 *   顶部查询信息有误提示
 */
- (void)createTopWrong{
    
    if(topWrongbgView != nil) return;
    
    topWrongbgView = [[UIView alloc]initWithFrame:CGRectMake(0, -40, KSCREEWIDTH, 40)];
    topWrongbgView.backgroundColor =  IWColorAlpha(223, 143, 146, .8);
    
    UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 20, 20)];
    leftImg.image = [UIImage imageNamed:@"违章信息错误叹号"];
    [topWrongbgView addSubview:leftImg];
    
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftImg.right + 10, 0, KSCREEWIDTH - leftImg.right - 10 - 50, 40)];
    topLabel.text = @"您的车辆信息有误，请核对后继续查询";
    topLabel.textColor = [UIColor whiteColor];
    topLabel.adjustsFontSizeToFitWidth = YES;
    [topWrongbgView addSubview:topLabel];
    [self.view addSubview:topWrongbgView];
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        topWrongbgView.top = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 delay:3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            topWrongbgView.top = - 40;
        } completion:^(BOOL finished) {
            
            [topWrongbgView removeAllSubviews];
            [topWrongbgView removeFromSuperview];
            topWrongbgView = nil;
        }];
    }];
}



#pragma mark  PeccancyProvinceViewDelegate
- (void)didSelectProvince:(NSString *)province{
    [UBIMobileUnusefulModel shareInstance].cityNickName = province;
    [table reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 2) return 2;
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section == 0){
    
        static NSString *identifier = @"UBIMobileUnusefulVCCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil){
         
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            UILabel  *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, cell.height)];
            leftLabel.font = [UIFont systemFontOfSize:13.0f];
            leftLabel.text = @"登录帐号";
            [cell.contentView addSubview:leftLabel];
            
            UITextField *middleTextF =  [[UITextField alloc]initWithFrame:CGRectMake(leftLabel.right + 20, 0, KSCREEWIDTH - leftLabel.right - 10 - 70, cell.height)];
            middleTextF.delegate = self;
            middleTextF.tag = 3000;
            middleTextF.font = [UIFont systemFontOfSize:13.0f];
            middleTextF.placeholder = @"您注册时使用的手机号";
            middleTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:middleTextF];
        }
        
        UITextField *middleTextF = (UITextField *)[cell.contentView viewWithTag:3000];
        middleTextF.returnKeyType = UIReturnKeyDone;
        [middleTextF addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        
        middleTextF.text = [UBIMobileUnusefulModel shareInstance].mobile;
        return cell;
        
    }else if (indexPath.section == 1){
    
        UBILookCodePlateNumberCell *cell = [UBILookCodePlateNumberCell cellWithTableView:tableView];
        return cell;
    }else{
     
        UBILookCodeEngineCell *cell = [UBILookCodeEngineCell cellWithTableView:tableView];
        cell.indexPath =  indexPath;
        return cell;
    }
    return nil;
}

/*
 *    您注册时使用的手机号
 */
- (void)textFieldWithText:(UITextField *)textField{
    [UBIMobileUnusefulModel shareInstance].mobile = textField.text;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField  resignFirstResponder];
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0) return;
    if (indexPath.section == 1){
        
        //弹出省简称
        provinceView = [[PeccancyProvinceView alloc]init];
        provinceView.delegate = self;
        [provinceView show];
    }else{
        
        //弹出驾驶证
        lisence = [[PeccancayPopToCarDetailView alloc]initWithTitles:nil type:PeccancayPopToCarDrivingLicense];
        [lisence show];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger) section{
    return [UIView new];
}
@end
