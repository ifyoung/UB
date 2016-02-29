//
//  PeccancyVC.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/6/10.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "PeccancyVC.h"
#import "PeccancyListVC.h"
#import "PeccancySeekResultVC.h"
#import "PeccancyResultModel.h"
#import "PeccancyCityseekVC.h"

#import "PeccancyCitySelectCell.h"
#import "PeccancyPlatenumberCell.h"
#import "PeccancyEngineCell.h"
#import "PeccancayPopToCarDetailView.h"
#import "PeccancyProvinceView.h"

@interface PeccancyVC ()<PeccancyProvinceViewDelegate>{
    
    UIView *topWrongbgView;
    UIView *bgView;
    TPKeyboardAvoidingTableView *table;
    NSInteger selectCarIndex;
    PeccancayPopToCarDetailView *lisence;
    PeccancyProvinceView *provinceView;
}
@end

@implementation PeccancyVC
- (BOOL)hidesBottomBarWhenPushed{
    return YES;
}
- (void)viewDidLoad{
    [super viewDidLoad];
   
    self.title = @"查询";
    
    [self location];
    
    [self createTBView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"违章查询_输入车辆信息"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"违章查询_输入车辆信息"];
}

/**
 *   定位
 *
 *  @return
 */
- (void)location{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(delegate.userlocation) return;
    [delegate getUserLocation];
     delegate.block = ^{
         [SeekparamModel shareInstance].city = [SFHFKeychainUtils getPasswordForUsername:@"UserLocationCity" andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL];
         [SeekparamModel shareInstance].cityNickName = [SFHFKeychainUtils getPasswordForUsername:@"UserProvinceNickName1" andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL];
         
         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
         NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:1];
         [table reloadRowsAtIndexPaths:@[indexPath,indexPath1] withRowAnimation:UITableViewRowAnimationNone];
     };
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"JUHEprovincesAndCitys"]){
        [delegate loadAllCitys];
    }
}


/**
 *   查询数据
 *
 *  @return
 */
- (void)loadRecodListFromInputParams{
    [MBProgressHUD showMessage:KIndicatorStr];
    [self seekPeccancyList:[NSString stringWithFormat:@"%@%@",
                            [SeekparamModel shareInstance].cityNickName,[SeekparamModel shareInstance].plateNo]
                       vin:[SeekparamModel shareInstance].vin
                  engineNo:[SeekparamModel shareInstance].engineNo];
    
}
- (void)seekPeccancyList:(NSString *)plateNo vin:(NSString *)vin engineNo:(NSString *)engineNo{
    __weak PeccancyVC *this = self;
    __block PeccancyListVC *pecclistvc = [PeccancyListVC shareInstance];
    __block PeccancySeekResultVC *resultVC = [[PeccancySeekResultVC alloc]init];
    [Interface UBIIlegalQueryWithvehicleId:self.vehicleId
                                   plateNo:plateNo
                                       vin:vin
                                  engineNo:engineNo block:^(id result) {
       NSLog(@"%@",result);
       NSDictionary *resdic = (NSDictionary *)result;
       if(resdic &&  ![resdic isKindOfClass:[NSNull class]] && ![[result objectForKey:KServererrorCodeStr]  isEqual: @0]){
           dispatch_async(dispatch_get_main_queue(), ^{
               [MBProgressHUD hideHUD];
               
               NSString *indicatorstr;
               if([result objectForKey:KServererrorMsgStr] == nil ||
                  [[result objectForKey:KServererrorMsgStr] isKindOfClass:[NSNull class]]){
                   indicatorstr = KPeecanError;
               }else{
                   indicatorstr = [result objectForKey:KServererrorMsgStr];
               }
               
               [self createTopWrong:indicatorstr];
               
           });
       }else{
           if(resdic &&  ![resdic isKindOfClass:[NSNull class]]  && ![[resdic objectForKey:KServerdataStr] isKindOfClass:[NSNull class]]){
               //如果有记录信息
                  NSDictionary *datas = [resdic objectForKey:KServerdataStr];
                   NSMutableArray *dataArray = [NSMutableArray array];
                   PeccancyResultModel *resmodel = [PeccancyResultModel objectWithKeyValues:datas];
                   NSMutableArray *recModelArray = [NSMutableArray array];
                   for(NSDictionary *dic  in resmodel.details){
                       PeccancyResultFrame *frame = [[PeccancyResultFrame alloc]init];
                       PeccancyRecordModel *recModel = [PeccancyRecordModel objectWithKeyValues:dic];
                       CGFloat locaitonHeight = [recModel.address   sizeWithFont:[UIFont systemFontOfSize:14.0f] maxSize:CGSizeMake(KSCREEWIDTH - 20 - 45 - 10 , MAXFLOAT)].height  + 1;
                       CGFloat reseaonsHeight = [recModel.reason   sizeWithFont:[UIFont systemFontOfSize:14.0f] maxSize:CGSizeMake(KSCREEWIDTH - 20 - 45 - 10 , MAXFLOAT)].height + 1;
                       frame.locationHeight = locaitonHeight;
                       frame.resonHeight    = reseaonsHeight;
                       frame.height = locaitonHeight + reseaonsHeight + 100 - 6;
                       frame.model = recModel;
                       [dataArray addObject:frame];
                       [recModelArray addObject:recModel];
                   }
                   resultVC.frameArray = dataArray;
                   resmodel.details = [recModelArray copy];
                   resultVC.resultModel =  resmodel;
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [MBProgressHUD hideHUD];
                       if(_vehicleId == 0){
                           pecclistvc.isLoadDataCompete = NO;
                       }
                       [this.navigationController pushViewController:resultVC animated:YES];
                   });
             }
       }
   }];
}


/*
 *   顶部查询信息有误提示
 */
- (void)createTopWrong:(NSString *)error{

    if(topWrongbgView != nil) return;
        
    topWrongbgView = [[UIView alloc]initWithFrame:CGRectMake(0, -40, KSCREEWIDTH, 40)];
    topWrongbgView.backgroundColor =  IWColorAlpha(223, 143, 146, .8);
    
    UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 20, 20)];
    leftImg.image = [UIImage imageNamed:@"违章信息错误叹号"];
    [topWrongbgView addSubview:leftImg];
    
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftImg.right + 10, 0, KSCREEWIDTH - leftImg.right - 10 - 50, 40)];
    topLabel.text = error;
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


/*
 *   UITableView
 */
- (void)createTBView{
    
    if(!_vehicleId){
    
       
    }
    
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
        [button setTitle: i == 0? @"查询" : @"我的订单" forState:UIControlStateNormal];
        button.frame = CGRectMake(10, 10 + (40 + 10) * i  , KSCREEWIDTH - 20, 40);
        [view addSubview:button];
    }
    return view;
}
- (void)footerAction:(UIButton *)button{
//    if(button.tag == 401){
//        [self pushToViewController:@"MyOrderListStatusVC"];
//        return;
//    }
    NSString *plate = [SeekparamModel shareInstance].plateNo;
    NSString *vin   = [SeekparamModel shareInstance].vin;
    NSString *engineNo = [SeekparamModel shareInstance].engineNo;
    if(plate.length == 0 || vin.length == 0 || engineNo.length == 0){
        
        if(plate.length == 0){
            [self showAlert:@"车牌号不能为空"];
            return;
        }else if(vin.length == 0){
            [self showAlert:@"车架号不能为空"];
            return;
        }else{
            [self showAlert:@"发动机号不能为空"];
        }
        
    }else if ([plate IsChinese]){
    
        [self showAlert:@"请输入正确的车架号"];
          return;
    }else if ([engineNo IsChinese]){
    
        [self showAlert:@"请输入正确的发动机号"];
          return;
    }
    else{
        

        [self loadRecodListFromInputParams];
    }
}


#pragma mark tableView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    if (y < -ImageHight) {
        CGRect frame = bgView.frame;
        frame.origin.y = y;
        frame.size.height =  -y;
        bgView.frame = frame;
    }
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
        
        return  [PeccancyCitySelectCell  cellWithTableView:tableView];
    }else if(indexPath.section == 2){
      
        PeccancyEngineCell *cell = [PeccancyEngineCell cellWithTableView:tableView];
        cell.indexPath = indexPath;
        return cell;
    }
    return [PeccancyPlatenumberCell cellWithTableView:tableView];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        //选择城市
        
        [self pushToViewController:@"PeccancyCityseekVC"];
        
    }else if (indexPath.section == 1){
        
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


#pragma mark  PeccancyProvinceViewDelegate
- (void)didSelectProvince:(NSString *)province{
    
    [SeekparamModel shareInstance].cityNickName = province;
    
    [table reloadData];
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
