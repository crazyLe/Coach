//
//  SuperWebViewController.m
//  idea
//
//  Created by caochungui on 16/1/26.
//  Copyright © 2016年 mobisoft. All rights reserved.
//

#import "SuperWebViewController.h"

@interface SuperWebViewController () <UIWebViewDelegate, WebViewControllerDelegate>
{
    NSMutableDictionary *_operationDictionary;
}

@end

@implementation SuperWebViewController

#pragma mark - 初始化方法
- (instancetype)initWithHtmlName:(NSString *)htmlName
{
    self = [super init];
//    _urlString = [NSString bunldPath:htmlName];
    _urlString = [[NSBundle mainBundle] pathForResource:htmlName ofType:nil];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initWithUI
{
    [super initWithUI];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    [self.view addSubview:_webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
    [_webView loadRequest:request];
}

- (void)initWithData
{
    [super initWithData];
    
    _operationDictionary = [NSMutableDictionary dictionary];
}

- (void)initWithInterface
{
    [super initWithInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self invokeCallback:@"inintPage" param:_jsonData];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"html load fail:%@",error);
    // 如果失败重新加载
    if ([error code] == NSURLErrorCancelled) {
        return;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    // 符合条件则进行代理事件处理
    if ([url hasPrefix:@"kitapps://"] && url.length >= 10) {
        NSString *key = [[request.URL.absoluteString substringFromIndex:10] componentsSeparatedByString:@"/"][2];
        NSString *operation = [key componentsSeparatedByString:@"?"][0];
        NSString *jsonParam = [key componentsSeparatedByString:@"="][1];
        jsonParam = [jsonParam substringToIndex:[jsonParam rangeOfString:@"&func"].location];
        NSString *callback = [key componentsSeparatedByString:@"="][2];
        
        // 存储操作与回调的名称
        [_operationDictionary setObject:callback forKey:operation];
        
        // 判断操作类型分别执行对应代理
        if ([operation hasPrefix:@"jump"]) {
            if ([_delegate respondsToSelector:@selector(webViewVC:jumpName:jsonParam:)]) {
                [_delegate webViewVC:self jumpName:operation  jsonParam:jsonParam];
            }
        } else if ([operation hasPrefix:@"popup"]) {
            if ([_delegate respondsToSelector:@selector(webViewVC:popupName:jsonParam:callback:)]) {
                [_delegate webViewVC:self popupName:operation jsonParam:jsonParam callback:callback];
            }
        } else if ([operation hasPrefix:@"invoke"]) {
            if ([_delegate respondsToSelector:@selector(webViewVC:invokeName:jsonParam:callback:)]) {
                [_delegate webViewVC:self invokeName:operation jsonParam:jsonParam callback:callback];
            }
        } else if ([operation hasPrefix:@"commit"]) {
            if ([_delegate respondsToSelector:@selector(webViewVC:commitName:jsonParam:)]) {
                [_delegate webViewVC:self commitName:operation jsonParam:jsonParam];
            }
        }
    }
    
    return YES;
}

#pragma mark - 自定义方法
- (void)reload
{
    [_webView reload];
}

- (void)reloadWithJsonData:(NSString *)jsonData
{
    _jsonData = jsonData;
    [self reload];
}

- (void)setJsonData:(NSString *)jsonData
{
    _jsonData = jsonData;
    [self invokeCallback:@"inintPage" param:_jsonData];
}

- (void)submitPage
{
    [self invokeCallback:@"commitPage" param:@""];
}

- (void)invokeCallback:(NSString *)callback param:(NSString *)param
{
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('%@')", callback, param]];
}

- (void)invokeCallbackWithOperation:(NSString *)operation param:(NSString *)param
{
    NSString *callback = [_operationDictionary objectForKey:operation];
    if (callback && ![callback isEqualToString:@""]) {
        [self invokeCallback:callback param:param];
    } else {
        CGLog(@"该操作没有回调函数可以执行!!!");
    }
}

@end
