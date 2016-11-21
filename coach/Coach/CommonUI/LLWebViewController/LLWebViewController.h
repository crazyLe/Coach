//
//  LLWebViewController.h
//  Coach
//
//  Created by LL on 16/8/6.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLWebViewController;
@class JSInteractiveManager;

@protocol LLWebViewControllerDelegate <NSObject>

- (void)LLWebViewController:(LLWebViewController *)vc clickLeftBtn:(UIButton *)leftBtn;

- (void)LLWebViewController:(LLWebViewController *)vc clickRightBtn:(UIButton *)rightBtn;

@end

@interface LLWebViewController : SuperViewController

@property (nonatomic,strong) NSURL *url;

@property (nonatomic,copy)   NSString *navTitle;

@property (nonatomic,copy)   NSString *rightImgName;

@property (nonatomic,copy)   NSString *leftImgName;

@property (nonatomic,copy)   NSString *leftText;

@property (nonatomic,copy)   NSString *rightText;

@property (nonatomic,copy)   NSString *htmlStr;

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) JSInteractiveManager *js_Manager; //处理和JS交互的Model

@property (nonatomic,strong) id object;  //携带的对象

@property (nonatomic,assign) id delegate;

- (id)initWithUrl:(NSURL *)url title:(NSString *)title rightImgName:(NSString *)rightImgName;

- (id)initWithHtmlStr:(NSString *)html title:(NSString *)title rightImgName:(NSString *)rightImgName;

- (void)loadFailWeb;

@end
