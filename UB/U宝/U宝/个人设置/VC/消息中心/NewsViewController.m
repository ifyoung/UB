//
//  NewsViewController.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/21.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "NewsViewController.h"
#import "MessageCenterCell.h"
#import "ProNewsModel.h"
#import "webViewVC.h"
#import "newsListCacheTool.h"

@interface NewsViewController ()

@property(nonatomic,strong)UITableView *tbView;
@property(nonatomic,strong)NSMutableArray *imgurls;;
@property(nonatomic,strong)ProNewsModel *newsModel;

@end

@implementation NewsViewController

-(UITableView *)tbView{
    if (_tbView == nil) {
        _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSCREEWIDTH, KSCREEHEGIHT - 64) style:UITableViewStylePlain];
        _tbView.dataSource = self;
        _tbView.delegate = self;
        _tbView.backgroundColor = [UIColor whiteColor];
        _tbView.rowHeight = KSCREEWIDTH * 344 / 640;
        _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbView.separatorColor = [UIColor orangeColor];
        [self.view addSubview:_tbView];
    }
    return _tbView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    [self leftButtonItem];
    [self getMessageCenter];
    [self swipeGestureRecognizer];

}

/**
 *  获取消息
 */
-(void)getMessageCenter{
    
    //设置key,去除红点
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"isClick"];
    [defaults synchronize];
    
    NSMutableArray *newsArr = [PersonalSettingsVC shareInstance].newsArr;
    
        //取出id最大的模型
        ProNewsModel *newsM = [newsArr firstObject];
        NSLog(@"newsM.id == %ld",newsM.id);
        
        NSMutableArray *cacheArr = [newsListCacheTool readNewsModel];
        ProNewsModel *cacheNewsM;
        
        if (cacheArr.count) {//有缓存
            //取出id最大的模型
            cacheNewsM = [cacheArr firstObject];
            
            if (newsM.id > cacheNewsM.id) {//有新的消息
                
                //此法在requestArr的ID没包含cacheArr的ID是也适用
                for (int i = 0; i < newsM.id - cacheNewsM.id; i++) {//取出比缓存ID大的消息
                    ProNewsModel *newModel = newsArr[i];
                    [_imgurls addObject:newModel];
                }
                
                for (int j = 0; j < 2; j++) {//从缓存中取2条ID最大的消息加到新消息数组中
                    ProNewsModel *cacheModel = cacheArr[j];
                    [_imgurls addObject:cacheModel];
                }
                /*
                 //requestArr的ID必须包含cacheArr的全部ID时才适用
                 long loc = requestArr.count - cacheArr.count;
                 NSRange range = NSMakeRange(loc, cacheArr.count);
                 
                 //移除与缓存id相同的模型
                 [requestArr removeObjectsInRange:range];
                 
                 _imgurls = requestArr;
                 
                 //遍历缓存的模型，把缓存模型添加到有新消息的数组中
                 for (ProNewsModel *cacheModel in cacheArr) {
                 [_imgurls addObject:cacheModel];
                 }
                 */
                [self tbView];
            }else{//没有新的消息，直接去缓存里取
                
                _imgurls = cacheArr;
                [self tbView];
            }
            
        }else{//无缓存，直接用请求返回的数据
            
            _imgurls = newsArr;
            [self tbView];
        }

}

/**
 *  获取消息
 */
/*
-(void)getMessageCenter{
    
    //检查网络状况
    if(![UIDevice checkNowNetworkStatus]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showIndicator:KNetworkError];
            });
        return;
    }
    
     //设置key,去除红点
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"isClick"];
    [defaults synchronize];
    
    __weak typeof(self) this = self;
    [MBProgressHUD showMessage:KIndicatorStr];
    
    [Interface getTopUrlInfotype:0 block:^(id result) {

        _imgurls = [NSMutableArray array];
        NSMutableArray *requestArr = [NSMutableArray array];
        for(NSDictionary *dic in [result objectForKey:KServerdataStr]){
            
            _newsModel = [ProNewsModel objectWithKeyValues:dic];
            [requestArr addObject:_newsModel];
        }
        
        //取出id最大的模型
        ProNewsModel *newsM = [requestArr firstObject];
        NSLog(@"newsM.id == %ld",newsM.id);
        
        NSMutableArray *cacheArr = [newsListCacheTool readNewsModel];
        ProNewsModel *cacheNewsM;
        
        if (cacheArr.count) {//有缓存
            //取出id最大的模型
            cacheNewsM = [cacheArr firstObject];
            
            if (newsM.id > cacheNewsM.id) {//有新的消息
                
                //此法在requestArr的ID没包含cacheArr的ID是也适用
                for (int i = 0; i < newsM.id - cacheNewsM.id; i++) {//取出比缓存ID大的消息
                    ProNewsModel *newModel = requestArr[i];
                    [_imgurls addObject:newModel];
                }
                
                for (int j = 0; j < 2; j++) {//从缓存中取2条ID最大的消息加到新消息数组中
                    ProNewsModel *cacheModel = cacheArr[j];
                    [_imgurls addObject:cacheModel];
                }
                
//                //requestArr的ID必须包含cacheArr的全部ID时才适用
//                long loc = requestArr.count - cacheArr.count;
//                NSRange range = NSMakeRange(loc, cacheArr.count);
//                
//                //移除与缓存id相同的模型
//                [requestArr removeObjectsInRange:range];
//                
//                _imgurls = requestArr;
//                
//                //遍历缓存的模型，把缓存模型添加到有新消息的数组中
//                for (ProNewsModel *cacheModel in cacheArr) {
//                    [_imgurls addObject:cacheModel];
//                }
                
            }else{//没有新的消息，直接去缓存里取
                
                _imgurls = cacheArr;
            }
            
        }else{//无缓存，直接用请求返回的数据
            
            _imgurls = requestArr;
        }
        
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //刷新界面要回到主线程才能有效果
            [this tbView];
            [MBProgressHUD hideHUD];
            
        });
        
    } failblock:^(id result) {
        
        NSMutableArray *cacheArr = [newsListCacheTool readNewsModel];
        //有缓存
        if (cacheArr.count) _imgurls = cacheArr;

        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showIndicator:@"出问题了哦，请检查您的网络"];
            [this tbView];
        });
    }];    
}
*/

#pragma mark - tableView delegate and dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _imgurls.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        MessageCenterCell *cell = [MessageCenterCell cellWithTableView:tableView indexPath:indexPath];
    /*
    //需在xib的第四个检查器设置Identifier为cell
    static NSString *ID = @"cell";
    MessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MessageCenterCell" owner:self options:nil]lastObject];

    }
    */
    //隐藏第一个cell分割线
    if (indexPath.row == 0) {
        cell.line.hidden = YES;
    }
    
    cell.newsModel = _imgurls[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    webViewVC *webView = [[webViewVC alloc]init];
    
    ProNewsModel *newsModel = _imgurls[indexPath.row];
    //设置为已读
    newsModel.read = YES;
    
    webView.url = newsModel.url;
    //把标记已读模型覆盖原来模型
    _imgurls[indexPath.row] = newsModel;
    
    //有网络，缓存数据
    if([UIDevice checkNowNetworkStatus]) [newsListCacheTool saveNews:_imgurls];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:webView animated:YES];
}

-(void)didReceiveMemoryWarning{
    //删除所以缓存消息
    [newsListCacheTool deleteAllNews];
}

@end
