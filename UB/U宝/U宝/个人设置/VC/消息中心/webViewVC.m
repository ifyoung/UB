//
//  webViewVC.m
//  车圣U宝
//
//  Created by 冥皇剑 on 15/11/6.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import "webViewVC.h"
#import "ProNewsModel.h"

@interface webViewVC ()

@property(nonatomic,strong)NSMutableArray *imgurls;;
@property(nonatomic,strong)ProNewsModel *newsModel;
@end

@implementation webViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSubview];
    self.title = @"UBI";
}

-(void)createSubview{
    
    if(![UIDevice checkNowNetworkStatus]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showIndicator:KNetworkError];
        });
        return;
    }
    
    UIWebView *web = [[UIWebView alloc]initWithFrame:self.view.bounds];
    web.scrollView.backgroundColor = [UIColor lightGrayColor];

    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    [self.view addSubview:web];

}

@end
