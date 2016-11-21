//
//  SuperWebViewController.h
//  idea
//
//  Created by caochungui on 16/1/26.
//  Copyright © 2016年 mobisoft. All rights reserved.
//

#import "SuperViewController.h"

@class SuperWebViewController;

@protocol WebViewControllerDelegate <NSObject>

@optional
/**
 *  @brief 界面跳转
 *
 *  @param jumpName  跳转名称
 *  @param paramInfo 参数信息
 *
 *  @return
 */
- (void)webViewVC:(SuperWebViewController *)webViewVC jumpName:(NSString *)jumpName jsonParam:(NSString *)jsonParam;

/**
 *  @brief 界面弹出
 *
 *  @param popupName  弹出名称
 *  @param paramInfo  参数信息
 *  @param callback   回调名
 *
 *  @return
 */
- (void)webViewVC:(SuperWebViewController *)webViewVC popupName:(NSString *)popupName jsonParam:(NSString *)jsonParam callback:(NSString *)callback;

/**
 *  @brief 方法调用
 *
 *  @param invokeName  调用名称
 *  @param paramInfo   参数信息
 *  @param callback    回调名
 *
 *  @return
 */
- (void)webViewVC:(SuperWebViewController *)webViewVC invokeName:(NSString *)invokeName jsonParam:(NSString *)jsonParam callback:(NSString *)callback;

/**
 *  @brief 提交表单
 *
 *  @param commitName  提交名称
 *  @param paramInfo   参数信息
 *
 *  @return
 */
- (void)webViewVC:(SuperWebViewController *)webViewVC commitName:(NSString *)commitName jsonParam:(NSString *)jsonParam;

@end

/// 父类WebViewController
@interface SuperWebViewController : SuperViewController

@property(nonatomic, assign) id<WebViewControllerDelegate> delegate;
/// webView
@property (nonatomic, strong) UIWebView *webView;
/// url地址
@property (nonatomic, copy) NSString *urlString;
/// json填充数据
@property (nonatomic, copy) NSString *jsonData;

#pragma mark - 初始化方法
/**
 *  @brief 初始化方法
 *
 *  @param htmlName 网页名称
 *
 *  @return
 */
- (instancetype)initWithHtmlName:(NSString *)htmlName;

#pragma mark - 自定义方法
/**
 *  @brief 刷新
 *
 *  @return
 */
- (void)reload;

/**
 *  @brief 刷新
 *
 *  @param jsonData json数据
 *
 *  @return
 */
- (void)reloadWithJsonData:(NSString *)jsonData;

/**
 *  @brief 设置jsonData(对界面其他值赋值)
 *
 *  @param jsonData json数据
 *
 *  @return
 */
- (void)setJsonData:(NSString *)jsonData;

/**
 *  @brief 提交表单，获取界面参数
 *
 *  @return
 */
- (void)submitPage;

/**
 *  @brief 执行回调方法
 *
 *  @param callback 回调名称
 *  @param param    参数
 *
 *  @return
 */
- (void)invokeCallback:(NSString *)callback param:(NSString *)param;

/**
 *  @brief 根据操作名称执行回调方法
 *
 *  @param operation 操作名称
 *  @param param     参数
 *
 *  @return
 */
- (void)invokeCallbackWithOperation:(NSString *)operation param:(NSString *)param;

@end
