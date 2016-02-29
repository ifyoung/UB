//
//  WebViewController.m
//  车圣U宝
//
//  Created by 朱鹏的Mac on 15/11/5.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>{
    
    UIWebView *_webView;
    UIActivityIndicatorView *_actView;
}

@end

@implementation WebViewController
- (BOOL)hidesBottomBarWhenPushed{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self webViewLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"轮播图内容"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"轮播图内容"];
}

/*!
 *  3.webView
 */
-(void)webViewLoad{
    _webView = [[UIWebView alloc]init];
    _webView.frame = CGRectMake(0, 0, KSCREEWIDTH, KSCREEHEGIHT - 64);
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    //_webView.detectsPhoneNumbers = YES;
    [self.view addSubview:_webView];
    
    _actView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //设置大小
    _actView.frame = CGRectMake(0, 0, 44, 44);
    _actView.center = CGPointMake(KSCREEWIDTH / 2.0, (KSCREEHEGIHT - 64) / 2.0 - 100);
    [self.view addSubview:_actView];
    //停止动画
    [_actView startAnimating];
    
    //NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    //NSURL *url = [NSURL fileURLWithPath:path];
    NSURL *url = [NSURL URLWithString:self.url];
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
