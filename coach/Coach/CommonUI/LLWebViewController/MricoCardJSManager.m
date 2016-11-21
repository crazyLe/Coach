//
//  MricoCardJSManager.m
//  Coach
//
//  Created by LL on 16/8/20.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "ShareView.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialSnsService.h"

#import "MricoCardJSManager.h"

@interface MricoCardJSManager () <ShareViewDelegate,UMSocialUIDelegate>

@property (nonatomic,strong)ShareView *shareView;

@property (nonatomic,strong)UIView *cover;

@end

@implementation MricoCardJSManager

- (id)init
{
    if (self = [super init]) {
        WeakObj(self)
        self.block = ^(UIViewController *webViewVC){
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
                        if ([typeStr isEqualToString:@"Share"]) {
                            //点击了Web分享按钮
                            if (paraArr.count>1) {
                                NSMutableArray *urlArr = [paraArr mutableCopy];
                                [urlArr removeObjectAtIndex:0];
                                NSString *shareUrl = [urlArr componentsJoinedByString:@":"];
//                                NSString *shareUrl = [paraArr lastObject];
                                [selfWeak shareWithUrl:shareUrl webVC:webViewVC];
                            }
                        }
                        else if([typeStr isEqualToString:@"Coupon"])
                        {
                            //点击了代金券按钮
//                            NSString *couponIdStr =
                        }
                        else if ([typeStr isEqualToString:@"coach"])
                        {
                            //点击了在线报名
                            [LLUtils showErrorHudWithStatus:@"您不可对自己报名"];
                        }
                    }
                }
            }];
        };
    }
    return self;
}

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
    UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:shareView.shareUrl];
    
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
