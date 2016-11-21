//
//  LLWebViewController.m
//  Coach
//
//  Created by LL on 16/8/6.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <IQKeyboardManager.h>
#import "JSInteractiveManager.h"
#import "LLWebViewController.h"

@interface LLWebViewController () <UIWebViewDelegate>

@end

@implementation LLWebViewController
{
    
}

- (id)initWithUrl:(NSURL *)url title:(NSString *)title rightImgName:(NSString *)rightImgName
{
    if (self = [super init]) {
        _url = url;
        _navTitle = title;
        _rightImgName = rightImgName;
    }
    return self;
}

- (id)initWithHtmlStr:(NSString *)html title:(NSString *)title rightImgName:(NSString *)rightImgName
{
    if (self = [super init]) {
        _htmlStr = html;
        _navTitle = title;
        _rightImgName = rightImgName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self setNavigation];
    [self setUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
}

#pragma mark - Setup

- (void)setNavigation
{
    [self setTitleText: _navTitle textColor:nil];
    [self setLeftText:_leftText textColor:nil ImgPath:_leftImgName==nil?@"Navigation_Return":_leftImgName];
    [self setRightText:_rightText textColor:nil ImgPath:_rightImgName];
}

- (void)setUI
{
    [self setWebView];
}

- (void)setWebView
{
    _webView = [[UIWebView alloc] init];
    [self.view addSubview:_webView];
    _webView.delegate = self;
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    if (_url) {
        [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
    }
    else if (!isEmptyStr(_htmlStr))
    {
        [_webView loadHTMLString:_htmlStr baseURL:nil];
    }
    if (self.js_Manager) {
        self.js_Manager.bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
        [self.js_Manager.bridge setWebViewDelegate:self];
        self.js_Manager.block(self);
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSLog(@"request HTML url ==>%@",request.URL.absoluteString);
    return YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    if (error.code == NSURLErrorCancelled) return;
    
    [self loadFailWeb];
}


- (void)loadFailWeb
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"html-loadfailed.html" ofType:nil];
    NSString *str = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:str baseURL:nil];
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    NSString *h5Title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    if (!isEmptyStr(h5Title)) {
//        self.title = h5Title;
//    }
//    NSLog(@"==>%@",[webView stringByEvaluatingJavaScriptFromString:@"document.title"]);
//}

#pragma mark - Overwirte

- (void)clickLeftBtn:(UIButton *)leftBtn
{
    if (_delegate && [_delegate respondsToSelector:@selector(LLWebViewController:clickLeftBtn:)]) {
        [_delegate LLWebViewController:self clickLeftBtn:leftBtn];
    }
    else
    {
        if ([_webView canGoBack]) {
            [_webView goBack];
        }
        else
        {
            if (self.navigationController) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
}

- (void)clickRightBtn:(UIButton *)rightBtn
{
    if (_delegate && [_delegate respondsToSelector:@selector(LLWebViewController:clickRightBtn:)]) {
        [_delegate LLWebViewController:self clickRightBtn:rightBtn];
    }
    else
    {
        [super clickRightBtn:rightBtn];
    }
}

@end
