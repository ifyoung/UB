//
//  PersonalSettingsVC.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/17.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "PersonalSettingsVC.h"
#import "ZPBaseNavigationController.h"
#import "UserInfoVC.h"
#import "PersonalSettingsHeadrerView.h"
#import "PersonalSettingCell.h"
#import "newsListCacheTool.h"
#import "ProNewsModel.h"

@interface PersonalSettingsVC ()<UserInfoVCDelegate>{

    UITableView *table;
    PersonalSettingsHeadrerView *banner;

}
@end

@implementation PersonalSettingsVC

+ (PersonalSettingsVC *)shareInstance{
    static PersonalSettingsVC *_instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
//    [self getMessage];
   
}

-(void)viewWillAppear:(BOOL)animated{
    [self getMessage];
}


//获取消息中心消息，判断是否有新消息以显示红点
-(void)getMessage{
   
    __weak typeof(self) this = self;
    [Interface getTopUrlInfotype:0 block:^(id result) {
        
        NSMutableArray *requestArr = [NSMutableArray array];
        for(NSDictionary *dic in [result objectForKey:KServerdataStr]){
            
            ProNewsModel *newModel = [ProNewsModel objectWithKeyValues:dic];
            [requestArr addObject:newModel];
        }
        
        [PersonalSettingsVC shareInstance].newsArr = requestArr;
        
        //取出id最大的模型
        ProNewsModel *newsM = [requestArr firstObject];
        
        NSMutableArray *cacheArr = [newsListCacheTool readNewsModel];
        ProNewsModel *cacheNewsM;
        
        if (cacheArr.count) {//有缓存
            //取出id最大的模型
            cacheNewsM = [cacheArr firstObject];
            
            if (newsM.id > cacheNewsM.id) {//有新的消息
                
                //移除key，显示消息中心红点
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults removeObjectForKey:@"isClick"];
                [defaults synchronize];
                }

        }
        
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            /**
             *  刷新界面要回到主线程才能有效果
             */
            [this createTBView];
            
        });
        
    } failblock:^(id result) {

        dispatch_async(dispatch_get_main_queue(), ^{

            [this createTBView];
        });
    }];
}

/*
 *   UITableView
 */
- (void)createTBView{
    //菜单栏左边距
    CGFloat left = KSCREEWIDTH * 0.7 /  2.0 - 30;
    //根据屏幕高度适配frame
    CGFloat top = 0;
    if (KSCREEHEGIHT == 480) top = KSCREEHEGIHT * 0.1 / 2;
    if (KSCREEHEGIHT == 568) top = KSCREEHEGIHT * 0.13 / 2;
    if (KSCREEHEGIHT == 667) top = KSCREEHEGIHT * 0.16 / 2;
    if (KSCREEHEGIHT > 667) top = KSCREEHEGIHT * 0.18 / 2;
    
    CGRect rect =  CGRectMake(left, top, KSCREEWIDTH - left, KSCREEHEGIHT);
    table = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    table.backgroundColor = SettingColor;
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [UIView new];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.contentInset = UIEdgeInsetsMake(ImageHight, 0, 0, 0);
    [self.view addSubview:table];
    
    [table addSubview:({
        banner = kLOADNIBWITHNAME(@"PersonalSettingsHeadrerView", self);
        banner.contentMode = UIViewContentModeScaleToFill;
        
        banner.frame = CGRectMake(0, -ImageHight, table.width, ImageHight);
        banner.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToUserInfo)];
        [banner addGestureRecognizer:tap];
        banner;
    })];
}
- (void)tapToUserInfo{
    
    UserInfoVC *userInfo = [[UserInfoVC alloc]init];
    [self.sideMenuViewController setContentViewController:[[ZPBaseNavigationController alloc] initWithRootViewController:userInfo] animated:YES];
    userInfo.delegate = self;

    [self.sideMenuViewController hideMenuViewController];
}


#pragma mark tableView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    if (y < -ImageHight) {
        CGRect frame = banner.frame;
        frame.origin.y = y;
        frame.size.height =  -y;
        banner.frame = frame;
    }
}

#pragma mark UITableView delegate  and dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    PersonalSettingCell *cell = [[PersonalSettingCell alloc]init];
    return cell.leftTitles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonalSettingCell *cell = [PersonalSettingCell cellWithTableView:tableView indexPath:indexPath];
    return cell;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];  
    if(indexPath.row == 0){
    
         [self pushToViewController:@"LoveCarManageVC"];
    }else if(indexPath.row == 1){
    
        [self pushToViewController:@"NewsViewController"];
    }else if (indexPath.row == 2){
    
        [self pushToViewController:@"FeedbacksVC"];
    }else if (indexPath.row == 3){
    
         [self pushToViewController:@"HelpViewController"];
    }else{
    
        [self pushToViewController:@"PersonnalSettingDetail"];
    }
}

- (void)pushToViewController:(NSString *)vcName{
    id myObj = [[NSClassFromString(vcName) alloc] init];
    [self.sideMenuViewController setContentViewController:[[ZPBaseNavigationController alloc] initWithRootViewController:myObj] animated:YES];
   [self.sideMenuViewController hideMenuViewController];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
#ifdef __IPHONE_8_0
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
#endif
}

#pragma mark - UserInfoVCDelegate
-(void)userInfoVC:(UserInfoVC *)info changeImage:(UIImage *)image{
    
    banner.userImg.image = image;
}

-(void)userInfoVC:(UserInfoVC *)info changeName:(NSString *)name{
    banner.name.text = name;
}

@end
