//
//  UBIProtecolVC.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/20.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "UBIProtecolVC.h"

@interface UBIProtecolVC ()<UIWebViewDelegate>{

    UIWebView *_webView;
    UIActivityIndicatorView *_actView;
}

@end

@implementation UBIProtecolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"车圣U宝相关协议";
    
    [self webViewLoadDocument:@"用户安全驾驶奖.docx"];
}


/*!
 *  3.webView
 */
-(void)webViewLoadDocument:(NSString*)documentName{
    _webView = [[UIWebView alloc]init];
    _webView.frame = CGRectMake(0, 0, KSCREEWIDTH, KSCREEHEGIHT);
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scalesPageToFit = YES;
    //_webView.detectsPhoneNumbers = YES;
    [self.view addSubview:_webView];
    
    
    //----------------------创建视图加载动画-----------------------
    _actView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    //停止动画
    [_actView stopAnimating];
    //设置大小
    _actView.frame = CGRectMake(0, 0, 44, 44);
    
    
    //创建导航视图
    UIBarButtonItem *actItem = [[UIBarButtonItem alloc]initWithCustomView:_actView];
    //添加到导航栏上
    self.navigationItem.rightBarButtonItem = actItem;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}


#pragma mark - UIWebView Delegate
//可以监听webView的事件
/*
 网页 －监听命令－> 客户端
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //navigationType = UIWebViewNavigationTypeFormSubmitted;
    return YES;
}
//加载开始
- (void)webViewDidStartLoad:(UIWebView *)webView{
    //开启风火轮
    [_actView startAnimating];
    
    //状态栏的加载动画
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
//加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //关闭风火轮
    [_actView stopAnimating];
    
    //状态栏的加载动画
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //原网页的
    //@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '50%'"
    //@"document.getElementsByTagName('body')[0].style.zoom= '0.5'"
    //@"document.body.style.zoom='0.5'"
    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.zoom= '0.5'"];
}
//加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}
@end
