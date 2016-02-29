//
//  PeccancyListVC.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/18.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "PeccancyListVC.h"
#import "PeccancyVC.h"
#import "PeccancyListCell.h"
#import "ZPBorderView.h"
#import "BindingCarListModel.h"
#import "XTTableDataDelegate.h"
#import "AFNetworking.h"

static NSString *const MyCellIdentifier = @"PeccancyListCell" ;

@interface PeccancyListVC (){
    UITableView *table;
    NSMutableArray *dataArray;
    UIImageView *bannner;
    UIView *borderView;
}
@property (nonatomic,strong)XTTableDataDelegate *tableDataDelegate ;
@property (nonatomic,strong)SRRefreshView *slimeView;
@end
@implementation PeccancyListVC
+ (PeccancyListVC *)shareInstance{
    static PeccancyListVC *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = IWColorAlpha(226, 228, 229, 1);
    [self rightButtonItem];
    [MBProgressHUD showMessage:KIndicatorStr];
    
    [self afnetworking];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"违章查询_爱车列表"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"违章查询_爱车列表"];
}


/*
 *  请求状态
 */
- (void)setIsLoadDataCompete:(BOOL)isLoadDataCompete{
    _isLoadDataCompete = isLoadDataCompete;
    //更换车辆
    if(!_isLoadDataCompete && [CurrentDeviceModel shareInstance].callLetter && table){
        [self afnetworking];
    }
}
/*
 *  网络连接成功
 */
- (void)networkreachableHander{
    __weak typeof(self) this = self;
    self.networkreachableBlock = ^{
        if(!this.isLoadDataCompete){
            [this afnetworking];
        }
    };
}
/*
 *  1.获取绑定车辆列表
 */
- (void)afnetworking{
    if(![UIDevice checkNowNetworkStatus]) return;
    
    AFHTTPSessionManager *SessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:BASE_URL]];;
    //session.responseSerializer = [AFJSONResponseSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    //session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [SessionManager.requestSerializer setTimeoutInterval:20];
    //申明请求的数据是json类型
    SessionManager.requestSerializer  = [AFJSONRequestSerializer serializer];
    
    
    //HTTPHeader
    NSString *get32bitString = [ZPAFDataService get32bitString];
    NSString *timeInterval = [NSString stringWithFormat:@"%lld",(long long)([[NSDate date] timeIntervalSince1970] * 1000)];
    NSString *getsignatureString = [ZPAFDataService getsignatureString:get32bitString time:timeInterval];
    [SessionManager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [SessionManager.requestSerializer setValue:get32bitString     forHTTPHeaderField:@"nonce"];
    [SessionManager.requestSerializer setValue:timeInterval       forHTTPHeaderField:@"stamp"];
    [SessionManager.requestSerializer setValue:getsignatureString forHTTPHeaderField:@"signature"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithLong:-1] forKey:@"hasUnit"];
    
    __weak __typeof__ (self) wself = self;//[NSString stringWithFormat:@"%@%@",BASE_URL,BINDINGCARLIST]
    [SessionManager POST:BINDINGCARLIST
       parameters:params
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              __strong __typeof__(wself) strongSelf = wself;
              
              NSLog(@"JSON: %@", responseObject);
              dataArray = [NSMutableArray array];
              for(NSDictionary *dic in [responseObject objectForKey:KServerdataStr]){
                  BindingCarListModel *model = [BindingCarListModel objectWithKeyValues:dic];
                  [dataArray addObject:model];
              }
              dispatch_async(dispatch_get_main_queue(), ^{
                  _isLoadDataCompete = YES;
                  [MBProgressHUD hideHUD];
                  
                  [strongSelf  inittableView];
              });
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              NSLog(@"Error: %@", error);
              _isLoadDataCompete = NO;
              dispatch_async(dispatch_get_main_queue(), ^{
                  [MBProgressHUD showError:@"查询失败" delay:1.0];
              });
              
    }];
    
    

}
/*
 *  2.inittableView
 */
- (void)inittableView{
    CGRect rect =  CGRectMake(0, 0, KSCREEWIDTH, KSCREEHEGIHT - 49 - 64);
    if(table == nil)
    table = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    table.backgroundColor = [UIColor clearColor];
    table.showsVerticalScrollIndicator = NO;
    table.tableHeaderView = ({
        bannner = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"文明出行"]];
        bannner.frame = CGRectMake(0, 0, KSCREEWIDTH, ImageHight);
        bannner.contentMode = UIViewContentModeScaleToFill;
        bannner;
    });
    table.tableFooterView = ({
        float buttonHeight = 35.0f;
        float borderViewHeight = 50;
        CGRect rect = CGRectMake(0, 0, KSCREEWIDTH, borderViewHeight);
        borderView = [[UIView alloc]initWithFrame:rect];
        borderView.backgroundColor =  IWColorAlpha(226, 228, 229, 1);
        ZPBorderView *border = [[ZPBorderView alloc]initWithFrame:CGRectMake(buttonHeight, (borderView.height - buttonHeight) / 2.0, KSCREEWIDTH - buttonHeight * 2, buttonHeight)];
        border.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [border setTitleColor:kColor forState:UIControlStateNormal];
        [border setTitle:@"添加车辆查询违章" forState:UIControlStateNormal];
        [border addTarget:self action:@selector(addCarToCheck) forControlEvents:UIControlEventTouchUpInside];
        border.borderType = BorderTypeDashed;
        border.borderColor = [UIColor lightGrayColor];
        border.dashPattern = 4;
        border.spacePattern = 4;
        border.borderWidth = 1;
        border.cornerRadius = 20;
        [borderView addSubview:border];
        borderView;
    });
    [table addSubview:self.slimeView];
    [self.view  addSubview:table];
    [self setupTableView];
    [table reloadData];
}
- (void)setupTableView{
    
    TableViewCellConfigureBlock configureBlock = ^(NSIndexPath *indexPath, BindingCarListModel *obj, XTRootCustomCell *cell) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configure:cell customObj:obj indexPath:indexPath] ;
    } ;
    CellHeightBlock heightBlock = ^CGFloat(NSIndexPath *indexPath, id item) {
        return [PeccancyListCell getCellHeightWithCustomObj:item indexPath:indexPath] ;
    } ;
    DidSelectCellBlock selectedB = ^(NSIndexPath *indexPath, id item) {
        NSLog(@"click row : %@",@(indexPath.row)) ;
        BindingCarListModel *model = (BindingCarListModel *)item;
        [SeekparamModel shareInstance].cityNickName = [model.plateNo substringToIndex:1];
        [SeekparamModel shareInstance].plateNo = [model.plateNo substringFromIndex:1];
        [SeekparamModel shareInstance].engineNo = model.engineNo;
        [SeekparamModel shareInstance].vin = model.vin;
        [SeekparamModel shareInstance].vehicleId = model.vehicleId;
        PeccancyVC *peccancyVC = [[PeccancyVC alloc]init];
        peccancyVC.vehicleId = model.vehicleId;
        [self.navigationController pushViewController:peccancyVC animated:YES];
    } ;
    CanEditRowBlock  canEditRow = ^(NSIndexPath *indexPath){
        BindingCarListModel *model = dataArray[indexPath.row];
        if(model.callLetter.length != 0){
            return NO;}
        return YES;
    } ;
    CommitEditBlock commitEdit = ^(UITableViewCellEditingStyle editingStyle,NSIndexPath *indexPath){
        BindingCarListModel *model = dataArray[indexPath.row];
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [dataArray removeObjectAtIndex:indexPath.row];
        }
        [table reloadData];
        [Interface unbindingDeviceCarvehicleId:model.vehicleId block:^(id result) {
            NSLog(@"%@",result);
        }];
    };
    self.tableDataDelegate = [[XTTableDataDelegate alloc]initWithItems:dataArray
                                                        cellIdentifier:MyCellIdentifier
                                                    configureCellBlock:configureBlock
                                                       cellHeightBlock:heightBlock
                                                        didSelectBlock:selectedB
                                                       canEditRowBlock:canEditRow
                                                       commitEditBlock:commitEdit];
    __weak __typeof__ (self) wself = self;
    self.tableDataDelegate.scrollViewDidScrollBlock = ^(void){
         [wself.slimeView scrollViewDidScroll];
    };
    self.tableDataDelegate.scrollViewDidEndDraggingWillDecelerateBlock = ^(void){
         [wself.slimeView scrollViewDidEndDraging];
    };
    [self.tableDataDelegate handleTableViewDatasourceAndDelegate:table] ;
}
- (void)addCarToCheck{
    [SeekparamModel shareInstance].cityNickName = @"粤";
    [SeekparamModel shareInstance].plateNo = @"";
    [SeekparamModel shareInstance].engineNo = @"";
    [SeekparamModel shareInstance].vin = @"";
    [SeekparamModel shareInstance].vehicleId = 0;
    [self pushToViewController:@"PeccancyVC"];
}
/*
 *  3.slimeView
 */
- (SRRefreshView *)slimeView{
    __weak __typeof__ (self) wself = self;
    if (!_slimeView) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
        _slimeView.backgroundColor = [UIColor whiteColor];
        _slimeView.block = ^(SRRefreshView *refreshView){
            [wself afnetworking];
            [refreshView endRefresh];
        };
    }
    return _slimeView;
}
@end