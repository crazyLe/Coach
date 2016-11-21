//
//  CircleJSManager.m
//  Coach
//
//  Created by LL on 16/8/22.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "ShareView.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialSnsService.h"
#import <IQKeyboardManager.h>
#import "ChatBarContainer.h"
#import "LLWebViewController.h"
#import "CircleJSManager.h"

@interface CircleJSManager ()

@property (nonatomic,strong)ShareView *shareView;

@property (nonatomic,strong)UIView *cover;

@end

@implementation CircleJSManager
{
    ChatBarContainer *_chat_Bar;
}

- (id)init
{
    if (self = [super init]) {
        WeakObj(self)
        self.block = ^(UIViewController *webViewController){
            [selfWeak.bridge registerHandler:@"objcHander" handler:^(id data, WVJBResponseCallback responseCallback) {
                NSLog(@"ObjC Echo called with: %@", data);
                responseCallback(data);
                NSDictionary *paraDic = data;
                NSArray *keyArr = paraDic.allKeys;
                if (keyArr.count>0) {
                    NSString *para = paraDic[keyArr[0]];
                    NSArray *paraArr = [para componentsSeparatedByString:@":"];
                    if (paraArr.count>0) {
                        NSString *typeStr = paraArr[0];
                        if ([typeStr isEqualToString:@"comment"]) {
                            //点击Web评论按钮
                            if (paraArr.count>1) {
                                NSString *circleId = [paraArr lastObject];
                                [selfWeak clickCommentWithCircleId:circleId webViewVC:(LLWebViewController *)webViewController];
                            }
                        }
                        else if([typeStr isEqualToString:@"like"])
                        {
                            //点击了点赞
                            NSString *circleId = [paraArr lastObject];
                            [selfWeak clickLikeWithCircleId:circleId webViewVC:(LLWebViewController *)webViewController];
                        }
                        else if ([typeStr isEqualToString:@"login"])
                        {
                            int  isLoginInt = [[paraArr lastObject] intValue];
                            if (isLoginInt==0) {
                                //需要登录
                                [webViewController showLoginRegisterWithLoginSuccessBlock:^{
                                    [selfWeak checkUrlIsContainsAppAndUidWithWebVC:(LLWebViewController *)webViewController];
                                }];
                            }
                        }
                        else if ([typeStr isEqualToString:@"Share"])
                        {
                            //分享
                            //点击了Web分享按钮
                            if (paraArr.count>1) {
                                NSMutableArray *urlArr = [paraArr mutableCopy];
                                [urlArr removeObjectAtIndex:0];
                                NSString *shareUrl = [urlArr componentsJoinedByString:@":"];
                                //                                NSString *shareUrl = [paraArr lastObject];
                                [selfWeak shareWithUrl:shareUrl webVC:webViewController];
                            }
                        }
                        else
                        {
                            
                        }
                    }
                }
            }];
        };
    }
    return self;
}

//点击评论
- (void)clickCommentWithCircleId:(NSString *)circleId webViewVC:(LLWebViewController *)webVC
{
    WeakObj(self)
    if (!isLogin) {
        [webVC showLoginRegisterWithLoginSuccessBlock:^{
            [selfWeak checkUrlIsContainsAppAndUidWithWebVC:webVC];
        }];
        return;
    }
    
    [self setComment_TextFieldWithVC:webVC];
    _chat_Bar.userInfo = @{@"circleId":circleId};
}

//点击赞
- (void)clickLikeWithCircleId:(NSString *)circleId webViewVC:(LLWebViewController *)webVC
{
    WeakObj(self)
    if (!isLogin) {
        [webVC.webView reload]; //刷新WEBVIEW
        [webVC showLoginRegisterWithLoginSuccessBlock:^{
            [selfWeak checkUrlIsContainsAppAndUidWithWebVC:webVC];
        }];
        return;
    }
    
    NSString *relativeAdd = @"/community/praise";
    NSDictionary *paraDic = @{@"uid":kUid,@"time":kTimeStamp,@"sign":kSignWithIdentify(relativeAdd),@"deviceInfo":kDeviceInfo,@"cityId":kCityID,@"address":kAddress,@"id":circleId};
    [NetworkEngine postRequestWithRelativeAdd:relativeAdd paraDic:paraDic completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if (isEqualValue(jsonObj[@"code"], 1)) {
                //成功
                //刷新页面
                [webVC.webView reload];
                if (_needRefreshBlock) {
                    _needRefreshBlock(selfWeak);
                }
            }
            else
            {
//                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
        }
        else
        {
            [LLUtils showErrorHudWithStatus:kRequestExceptionPrompt];
        }
    }];
}

- (void)setComment_TextFieldWithVC:(LLWebViewController *)webVC
{
    if (!_chat_Bar) {
        _chat_Bar = [[ChatBarContainer alloc]init];
        _chat_Bar.max_Count = 140;
        _chat_Bar.myDelegate = self;
        [webVC.view addSubview:_chat_Bar];
        [_chat_Bar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(webVC.view.mas_left);
            make.right.equalTo(webVC.view.mas_right);
            make.bottom.equalTo(webVC.view.mas_bottom);
            make.height.offset(44);
        }];
        [_chat_Bar setNeedsLayout];
        [_chat_Bar.layer layoutIfNeeded];
        _chat_Bar.object = webVC;
        
        IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
        manager.enable = NO;
        
        webVC.webView.scrollView.delegate = self;
    }
    
    [_chat_Bar.txtView becomeFirstResponder];
}

#pragma mark - ChatBarContainerDelegate

//点击评论发送按钮
- (void)ChatBarContainer:(ChatBarContainer *)chatBar clickSendWithContent:(NSString*)content;
{
    
    WeakObj(self)
    
    LLWebViewController *webVC = chatBar.object;
    
    NSString *circelId = chatBar.userInfo[@"circleId"];
    
    NSString *relativeAdd = @"/community/commentcreate";
    NSDictionary *paraDic = @{@"uid":kUid,@"time":kTimeStamp,@"sign":kSignWithIdentify(relativeAdd),@"deviceInfo":kDeviceInfo,@"cityId":kCityID,@"address":kAddress,@"communityType":webVC.object,@"id":circelId,@"content":chatBar.txtView.text};
    [NetworkEngine postRequestWithRelativeAdd:relativeAdd paraDic:paraDic completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if (isEqualValue(jsonObj[@"code"], 1)) {
                //成功
                NSLog(@"comment msg == > %@",jsonObj[@"msg"]);
                
                //刷新页面
                [webVC.webView reload];
                
                if (_needRefreshBlock) {
                    _needRefreshBlock(selfWeak);
                }
            }
            else
            {
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
        }
        else
        {
            [LLUtils showErrorHudWithStatus:kRequestExceptionPrompt];
        }
    }];
    chatBar.alpha = 0;
    [chatBar.txtView resignFirstResponder];
}


- (void)chatBarDidBecomeActive;
{
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    [_chat_Bar.txtView resignFirstResponder];
}

//检查url中是否包含了uid和appid 如果没有包含 则传入 重新加载webView
- (void)checkUrlIsContainsAppAndUidWithWebVC:(LLWebViewController *)webVC
{
    BOOL needChange = NO;
    NSMutableString *urlStr = [webVC.webView.request.URL.absoluteString mutableCopy];
    if (![urlStr containsString:@"app"]) {
        [urlStr appendString:@"&app=1"];
        needChange = YES;
    }
    NSString *uidValue = [LLUtils getParaValueWithParaName:@"uid" url:urlStr];
    if (![urlStr containsString:@"uid"]) {
        [urlStr appendString:[NSString stringWithFormat:@"&uid=%@",kUid]];
        needChange = YES;
    }
    else if ( isEmptyStr(uidValue) )
    {
        //含有uid但为空字符串
        NSRange range = [urlStr rangeOfString:@"uid="];
        if (range.location != NSNotFound) {
            [urlStr replaceCharactersInRange:range withString:[NSString stringWithFormat:@"uid=%@",kUid]];
            needChange = YES;
        }
    }
    else if ([uidValue isEqualToString:@"0"])
    {
        //含有uid但为0
        NSRange range = [urlStr rangeOfString:@"uid=0"];
        if (range.location != NSNotFound) {
            [urlStr replaceCharactersInRange:range withString:[NSString stringWithFormat:@"uid=%@",kUid]];
            needChange = YES;
        }
    }
    if (needChange) {
        [webVC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    }
}

/****************分享相关************/

- (ShareView *)shareView
{
    if (!_shareView) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        self.shareView = [[[NSBundle mainBundle]loadNibNamed:@"ShareView" owner:nil options:nil]lastObject];
        self.shareView.delegate = self;
        self.cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _cover.backgroundColor = [UIColor darkGrayColor];
        _cover.userInteractionEnabled = YES;
        _cover.alpha = 0.0f;
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(translucentCoverViewSingleTap:)];
        [_cover addGestureRecognizer:singleTapGesture];
        //    [self.view addSubview:_cover];
        [window addSubview:_cover];
    }
    return _shareView;
}

- (void)shareWithUrl:(NSString *)url webVC:(UIViewController *)webViewVC
{
    NSLog(@"====>share url %@",url);
    //使用UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite分别代表微信好友、微信朋友圈、微信收藏
    
    if (isEmptyStr(url)) {
        NSLog(@"share url is a empty string , please check!");
        return;
    }
    
    //    UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeWeb url:url];
    //
    //    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"下载康庄教练端有惊喜哦" image:[UIImage imageNamed:@"组-1"] location:nil urlResource:resource presentedController:nil completion:^(UMSocialResponseEntity *response){
    //        if (response.responseCode == UMSResponseCodeSuccess) {
    //            NSLog(@"分享成功！");
    //            [LLUtils showSuccessHudWithStatus:@"分享成功!"];
    //        }
    //        else{
    //            NSLog(@"分享失败! ");
    //            [LLUtils showSuccessHudWithStatus:@"分享失败!"];
    //        }
    //    }];
    
    //    [UMSocialSnsService presentSnsIconSheetView:_vc
    //                                         appKey:kUMENG_APP_KEY
    //                                      shareText:@"这是一个分享测试"
    //                                     shareImage:[UIImage imageNamed:@"icon.png"]
    //                                shareToSnsNames:@[UMShareToWechatSession,UMShareToQQ]
    //                                       delegate:self];
    
    self.shareView.shareUrl = url;
    self.shareView.object = webViewVC;
    self.cover.alpha = 0.8;
    [self.shareView show];
}

-(void)translucentCoverViewSingleTap:(UITapGestureRecognizer *)tap
{
    [self.shareView dismissWithCompletionBlock:^(ShareView *view) {
        self.cover.alpha = 0.0;
    }];
    
}
-(void)shareViewDidClickCancelButton:(ShareView *)shareView
{
    [self.shareView dismissWithCompletionBlock:^(ShareView *view) {
        self.cover.alpha = 0.0;
    }];
    
}
-(void)shareView:(ShareView *)shareView didClickButtonWithType:(ShareViewBtnType)type
{
    shareView.transform = CGAffineTransformIdentity;
    [shareView removeFromSuperview];
    self.cover.alpha = .0f;
    
    NSString *shareType = nil;
    
    UIViewController *webVC = shareView.object;
    
    switch (type) {
        case ShareViewBtnWeChatQuan:
        {
            
            shareType = UMShareToWechatTimeline;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareView.shareUrl;
        }
            break;
        case ShareViewBtnWeChat:
        {
            //使用UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite分别代表微信好友、微信朋友圈、微信收藏
            
            
            //            [UMSocialSnsService presentSnsIconSheetView:self
            //                                                 appKey:kUMENG_APP_KEY
            //                                              shareText:@"这是一个分享测试"
            //                                             shareImage:[UIImage imageNamed:@"icon.png"]
            //                                        shareToSnsNames:@[UMShareToWechatSession]
            //                                               delegate:self];
            shareType = UMShareToWechatSession;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = shareView.shareUrl;
        }
            break;
        case ShareViewBtnWeBo:
        {
            shareType = UMShareToQQ;
            [UMSocialData defaultData].extConfig.qqData.url = shareView.shareUrl;
        }
            break;
        case ShareViewBtnQQZone:
        {
            
            shareType = UMShareToQzone;
            [UMSocialData defaultData].extConfig.qzoneData.url = shareView.shareUrl;
        }
            break;
            
        default:
            break;
    }
    
    
    
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault url:shareView.shareUrl];
    [UMSocialData defaultData].extConfig.title = @"康庄学车";
    [UMSocialData defaultData].shareText = @"康庄教练微名片";
    [UMSocialData defaultData].shareImage = [UIImage imageNamed:@"iconfont-kzjlicon"];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:shareType];
    snsPlatform.snsClickHandler(webVC,[UMSocialControllerService defaultControllerService],YES);
    
    /*
    UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeWeb url:@"www.sskz.com.cn"];
    
    UIViewController *webVC = shareView.object;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[shareType] content:@"下载康庄教练端有惊喜哦" image:[UIImage imageNamed:@"组-1"] location:nil urlResource:resource presentedController:webVC completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
            [LLUtils showSuccessHudWithStatus:@"分享成功!"];
        }
        else{
            NSLog(@"分享失败! ");
            //            [LLUtils showErrorHudWithStatus:@"分享失败!"];
        }
    }];
     
    */
    
}

//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

@end
