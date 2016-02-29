//
//  LoveCarManageVC.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/19.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import "LoveCarManageVC.h"
#import "BindingCarListModel.h"
#import "ScanfOBDbarCodeVC.h"
#import "MyCarManageCell.h"
#import "ProceedsVC.h"
#import "PeccancyListVC.h"
#import "CarViewController.h"
#import "BindingCarListCacheTool.h"

@interface LoveCarManageVC ()<UIAlertViewDelegate>{
    NSMutableArray *dataArray;
    BindingCarListModel *carModel;
}
  
@property(nonatomic,strong)UITableView *tbView;

@property(nonatomic,assign)BOOL firstSelect;


@end

@implementation LoveCarManageVC

-(UITableView *)tbView{
    if (_tbView == nil) {

        //减去导航栏高度才能滚动到底部，减去底部View高度使其不被View遮盖
        _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSCREEWIDTH, KSCREEHEGIHT - 64 - 64) style:UITableViewStylePlain];
        _tbView.dataSource = self;
        _tbView.delegate = self;
        _tbView.rowHeight = 155;
        _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbView.backgroundColor = IWColor(237, 238, 239);
        [self.view addSubview:_tbView];
    }
    return _tbView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车辆管理";
    NSLog(@"%f",KSCREEWIDTH);
    [self leftButtonItem];
    [self swipeGestureRecognizer];
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
//    if(![UIDevice checkNowNetworkStatus]){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD showIndicator:KNetworkError];
//            });
//        return;
//    }
//    
//    [self getBindingVehicle];
//}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if(![UIDevice checkNowNetworkStatus]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showIndicator:KNetworkError];
        });
        return;
    }
    
    [self getBindingVehicle];
}

/**
 *  获取绑定车辆信息
 */
- (void)getBindingVehicle{
    
    if(![UIDevice checkNowNetworkStatus]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showIndicator:KNetworkError];
            });
        return;
    }
    
//    NSArray *arr = [BindingCarListCacheTool carModel];
//    if (arr.count) {
//        dataArray = (NSMutableArray *)arr;
//        [self tbView];
//        return;
//    }
    
    __weak typeof(self) this = self;
    [MBProgressHUD showMessage:KIndicatorStr];
    
    [Interface getBindingVehicleWithType:1 block:^(id result) {
    
        dataArray = [NSMutableArray array];
        for(NSDictionary *dic in [result objectForKey:KServerdataStr]){
        
            carModel = [BindingCarListModel objectWithKeyValues:dic];
            [dataArray addObject:carModel];
//            [dataArray insertObject:carModel atIndex:0];
            
        }
//        [BindingCarListCacheTool addCarModels:dataArray];
         NSLog(@"fail === %@",result);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (dataArray.count == 0) {//没有车辆，重新扫码
                [MBProgressHUD hideHUD];
                [self scanCode];
            }else{
            
                /**
                 *  刷新界面要回到主线程才能有效果
                 */
                self.firstSelect = YES;
                [this.tbView reloadData];
                [this createTableFooterView];
                [MBProgressHUD hideHUD];
//                [self carListChangedNotification];
            }
            
        });
    }failblock:^(id result){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [this createTableFooterView];
        });
    }];
    
   
}

-(void)createTableFooterView{
    
    CGFloat w = KSCREEWIDTH;
    CGFloat h = 64;
    CGFloat x = 0;
    CGFloat y = KSCREEHEGIHT - 2 * h;
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(x, y, w, h)];
    footerView.backgroundColor = IWColor(237, 238, 239);
    [self.view addSubview:footerView];
    
    for (int i = 0; i<2; i++) {
        
        UIButton *btn = [[UIButton alloc]init];
        
        btn.tag = 400 + i;
        btn.backgroundColor = i == 0 ? [UIColor colorWithRed:225/255.0 green:70/255.0 blue:80/255.0 alpha:1.0] : [UIColor colorWithRed:50/255.0 green:200/255.0 blue:80/255.0 alpha:1.0];
        [btn setTitle:i == 0 ? @"解除绑定" :@"添加爱车" forState:UIControlStateNormal];
        
        CGFloat btnW = (KSCREEWIDTH - 60)/2;
        CGFloat btnH = 44;
        CGFloat btnX = 20 + ((KSCREEWIDTH - 60)/2 + 20)*i;
        CGFloat btnY = (footerView.height - btnH) / 2;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [btn addTarget:self action:@selector(addCarAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 10;
        btn.layer.masksToBounds = YES;
        btn.userInteractionEnabled = YES;
        btn.showsTouchWhenHighlighted = YES;
        
        [footerView addSubview:btn];
    }
    
}


- (void)addCarAction:(UIButton *)button{
    
    if(button.tag == 400){//解绑爱车

        if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0){
            
#ifdef __IPHONE_8_0

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要解绑？" message:@"提示: 再次绑定需要 重新登录并扫描设备"preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
               
            }];
            
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                NSLog(@"%ld",carModel.vehicleId);

                [self unbingCar];
                
            }];
            
            [alert addAction:cancelAction];
            [alert addAction:confirm];
            [self presentViewController:alert animated:YES completion:NULL];
#endif
        }else{//ios7
        
            UIAlertView *AV = [[UIAlertView alloc]initWithTitle:@"确定要解绑？" message:@"提示: 再次绑定需要 重新登录并扫描设备" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            [AV show];
        }
        

    }else{//添加爱车
        
        [self scanCode];
        
    }
}

#pragma mark - UIAlertViewDelegate iOS7
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self unbingCar];
    }
}


//扫码绑车
-(void)scanCode{
    
    //跳到扫码VC
    ScanfOBDbarCodeVC *bingCarVC = [[ScanfOBDbarCodeVC alloc]init];
    bingCarVC.isAddMoreCar = YES;
    [self.navigationController pushViewController:bingCarVC animated:YES];
}


#pragma mark UITableView delegate  and dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MyCarManageCell *cell = [MyCarManageCell cellWithTableView:tableView];
    cell.model = dataArray[indexPath.row];
    if (dataArray.count != 0 && self.firstSelect == YES) {
        self.firstSelect = NO;
        [self selectFirstCell];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self changeCurrentCar:indexPath];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

//默认选中cell第一行
-(void)selectFirstCell{
    
    NSInteger selectedIndex = 0;
    
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    
    [self.tbView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}


/**
 *  更换当前设备车辆
 */
-(void)changeCurrentCar:(NSIndexPath *)indexPath{
        
        carModel = dataArray[indexPath.row];
        NSLog(@"%ld",carModel.vehicleId);
        
        //修改默认车辆
        [Interface chagngeTheTerminalDeviceVehicleId:carModel.vehicleId block:^(id result) {
            NSLog(@"uuuuuuuu%@",result);
            
            NSNumber *num = [result objectForKey:@"errorCode"];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([num isEqualToNumber:@-1]) {
                    
                    [self warningWithTitle:@"系统繁忙,请稍后"];
    
                }else if ([num isEqualToNumber:@0]) {
                    [self warningWithTitle:KIndicatorStr];
                    
                    //模型转字典
                    NSMutableDictionary *dic = [dataArray[indexPath.row] keyValues];
                    
                    NSLog(@"%@",dic);
                    
                    //字典转模型
                    [[CurrentDeviceModel shareInstance] setKeyValues:dic];
                    NSLog(@"%@",[CurrentDeviceModel shareInstance].plateNo);
                    
                    [self carListChangedNotification];
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

/**
 *  解绑车辆
 */
-(void)unbingCar{
    
    if(![UIDevice checkNowNetworkStatus]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showIndicator:KNetworkError];
            });
        return;
    }
    
    if (self.tbView.indexPathForSelectedRow) {
        
        [Interface unbindingDeviceCarvehicleId:carModel.vehicleId block:^(id result) {
            NSLog(@"%@",result);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self carListChangedNotification];
            });
            
        }];
        //获取选中cell
        NSIndexPath *indexPath = [self.tbView indexPathForSelectedRow];
        //删除选中cell
        [dataArray removeObjectAtIndex:indexPath.row];
        [self.tbView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tbView reloadData];
        
    }
    
    if (dataArray.count == 0) {//如果没有车辆，重新扫码
        [self scanCode];
        return;
    }
    
    //默认选中第一个cell
    NSInteger selectedIndex = 0;
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [self tableView:self.tbView didSelectRowAtIndexPath:selectedIndexPath];
    self.firstSelect = YES;
    [self.tbView reloadData];
    
}


/**
 *  退出登录
 */
-(void)logout{
    //显示蒙板
    [MBProgressHUD showMessage:@"解绑爱车ing..."];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUD];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //和下面代码顺序调换的话蒙板会先显示
        
        [delegate loginRootViewController];
        [self.sideMenuViewController setContentViewController:delegate.mainViewController animated:YES];
        [self.sideMenuViewController hideMenuViewController];
        
        
    });
}

/**
 *   车辆变化通知
 */
- (void)carListChangedNotification{
    ProceedsVC *proceeds = [ProceedsVC shareInstance];
    proceeds.isLoadDataCompete = NO;
    CarViewController *carViewController = [CarViewController shareInstance];
    carViewController.isLoadDataCompete = NO;
    PeccancyListVC *peeccan = [PeccancyListVC shareInstance];
    peeccan.isLoadDataCompete = NO;
    
}



@end
