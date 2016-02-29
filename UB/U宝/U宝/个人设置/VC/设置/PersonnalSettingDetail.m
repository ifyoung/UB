//
//  PersonnalSettingDetail.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/18.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "PersonnalSettingDetail.h"
#import "SettingCell.h"
#import "MBProgressHUD+MJ.h"
#import "ChangePasswordVC.h"


@interface PersonnalSettingDetail ()

@property(nonatomic,strong)UITableView *tbView;
@property(nonatomic,strong)UIButton *exitBtn;
@property(nonatomic,strong)UILabel *versionLabel;

@end

@implementation PersonnalSettingDetail

/**
 *  获取版本号
 */
-(UILabel *)versionLabel{
    if (_versionLabel == nil) {
        _versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.exitBtn.frame), CGRectGetMinY(self.exitBtn.frame), 80, 20)];
        NSString *version = [NSString stringWithFormat:@"| 版本%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        _versionLabel.text = version;
        _versionLabel.font = [UIFont systemFontOfSize:14.0];
        _versionLabel.textColor = [UIColor darkGrayColor];
        [self.view addSubview:_versionLabel];
    }
    return _versionLabel;
}

/**
 *  退出按钮
 */
-(UIButton *)exitBtn{
    if (_exitBtn == nil) {
        _exitBtn = [[UIButton alloc]init];
        if (KSCREEHEGIHT > 480) {//根据屏幕高度适配frame
            
            _exitBtn.frame = CGRectMake(10, self.view.height-64-40-30, 50, 20);
        }else{
            _exitBtn.frame = CGRectMake(10, self.view.height-64-40, 50, 20);
        }
        [_exitBtn setTitle:@" 退出" forState:UIControlStateNormal];
        [_exitBtn setTitleColor:kColor forState:UIControlStateNormal];
        [_exitBtn setImage:[UIImage imageNamed:@"退出"] forState:UIControlStateNormal];
        _exitBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _exitBtn.showsTouchWhenHighlighted = YES;
        
        [_exitBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_exitBtn];
    }
    return _exitBtn;
}

-(UITableView *)tbView{
    if (_tbView == nil) {
        _tbView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tbView.delegate = self;
        _tbView.dataSource = self;
        _tbView.backgroundColor = IWColor(238, 238, 238);
        
        [self.view addSubview:_tbView];
    }
    return _tbView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    [self tbView];
    [self swipeGestureRecognizer];
    [self versionLabel];
    [self leftButtonItem];
}

#pragma mark - tableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SettingCell *cell = [SettingCell cellWithTableView:tableView andIndexPath:indexPath];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 2;
    }
    return 1;
}

#pragma mark - tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        [self pushToViewController:@"ChangePasswordVC"];
    }else if (indexPath.section ==3){
        [self pushToViewController:@"ModifyMobileVC"];
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 1){
        
        return @"当前在线";
    }
    
    return nil;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section == 1){
        
        return @"如果您要关闭或者开始消息通知，请在iPhone的“设置”-“通知”功能汇总，找到应用程序“U宝”更改";
    }
    
    return nil;
}

//设置分组头标高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        
        return 1;
    }
    return 20;
}
//设置分组脚标高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section ==2) {
        
        return 5;
    }else if (section == 1){
        return 55;
    }
    return 20;
}


#pragma mark - 退出登录
/**
 *  退出登录
 */
-(void)logout{
    [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:KFirtsLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //和下面代码顺序调换的话蒙板会先显示
    
    [MBProgressHUD showMessage:KIndicatorStr];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UBLoginViewController *loagin =  [[UBLoginViewController alloc]init];
        loagin.logAgain = YES;
        ZPBaseNavigationController *navi = [[ZPBaseNavigationController alloc]initWithRootViewController:loagin];
        delegate.window.rootViewController  = navi;
        //[delegate.window makeKeyAndVisible];
        [MBProgressHUD hideHUD];
    });
    
}

@end


