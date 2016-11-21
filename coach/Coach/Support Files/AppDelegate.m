//
//  AppDelegate.m
//  Coach
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>
#import "LLAddress.h"
#import "JpushManager.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "LLGuideViewController.h"
#import "UMSocialData.h"
#import "LCTabBarController.h"
#import "UMSocialSnsService.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "JPUSHService.h"
#import "UPPaymentControl.h"
#import "WXApiManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <IQKeyboardManager.h>
#import "Header.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "WalletViewController.h"
#import "MineViewController.h"
#import <RDVTabBarController.h>
#import <RDVTabBarItem.h>
#import "CircleViewController.h"
#import <Bugtags/Bugtags.h>

#import "AddressManager.h"

#import "CheckVersionManager.h"

@interface AppDelegate ()  <JPUSHRegisterDelegate>

@end

@implementation AppDelegate
{
    BMKMapManager* _mapManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    _launchOptions = launchOptions;
    
    [kUserDefault setBool:NO forKey:@"AreaStartUpdateFlag"];
    if (isFirstLaunch) {
        clearUserData
        [kUserDefault setBool:NO forKey:cacheProvinceDataKey];
        [kUserDefault setBool:NO forKey:cacheCityDataKey];
        [kUserDefault setBool:NO forKey:cacheCountyDataKey];
        
//        [kUserDefault setBool:NO forKey:@"isUpdateDataBase"];
        
        //默认不展示赚豆
        [kUserDefault setObject:@(NO) forKey:@"BeansShow"];
    }
    [kUserDefault synchronize];
    
    [self setTabBarRootViewController];
    
    [self setGuideViewController];
    
    //注册极光推送
    [self initWithJPUSH];
    
    [self initWithIQKeyboardManage];
    
    [self initWithBMK];
    
    [self initWithAddressInfo];
    
    [self initWithUMeng];
    
    [self initAddressBook];
    
    //注册微信API
    [WXApi registerApp:kWECHAT_APP_ID withDescription:@"康庄教练端"];
    
    [self initWithBugTags];
    
    NSLog(@"document===>%@",kDocumentPath); //打印沙盒地址

    [self firstLaunchInit];
    return YES;
}

#pragma mark - 初始化

- (void)firstLaunchInit
{
    if (isFirstLaunch) {
        [kUserDefault setObject:@(YES) forKey:@"isFirstLaunch"];
//        clearUserData
    }
}

//引导页
- (void)setGuideViewController
{
    if (isFirstLaunch) {
//            WeakObj(self)
        static LLGuideViewController *guideVC = nil;
        guideVC = [[LLGuideViewController alloc] initWithImgNameArr:@[@"guide-fangfayongdehao",@"guide-gaogaoxingxing",@"guide-shishifenxiang"] entryBtnTitle:@"立即进入" entryBtnBlock:^(UIButton *entryBtn) {
            //        [selfWeak setTabBarRootViewController];
            [UIView animateWithDuration:1.0f animations:^{
                guideVC.view.alpha = 0;
            } completion:^(BOOL finished) {
                [guideVC.view removeFromSuperview] , guideVC = nil;
            }];
        }];
        [_window addSubview:guideVC.view];
    }
}

-(void)setTabBarRootViewController
{
    
//    dispatch_async(dispatch_get_main_queue(), ^{
        HomeViewController *home = [[HomeViewController alloc] init];
        home.title = @"首页";
        home.tabBarItem.image = [UIImage imageNamed:@"ic_homepage_f"];
        home.tabBarItem.selectedImage = [UIImage imageNamed:@"ic_homepage_s"];
        
        WalletViewController *wallet = [[WalletViewController alloc] init];
        wallet.title = @"钱袋";
        wallet.tabBarItem.image = [UIImage imageNamed:@"ic_money_f"];
        wallet.tabBarItem.selectedImage = [UIImage imageNamed:@"ic_money_s"];
        
        CircleViewController *circle = [[CircleViewController alloc] init];
        circle.title = @"圈子";
        circle.tabBarItem.image = [UIImage imageNamed:@"ic_cricle_f"];
        circle.tabBarItem.selectedImage = [UIImage imageNamed:@"ic_cricle_s"];
        
        
        MineViewController *me = [[MineViewController alloc] init];
        me.title = @"我的";
        me.tabBarItem.image = [UIImage imageNamed:@"ic_mine_f"];
        me.tabBarItem.selectedImage = [UIImage imageNamed:@"ic_mine_s"];
        
        UINavigationController *navC1 = [[UINavigationController alloc] initWithRootViewController:home];
        
        UINavigationController *navC2 = [[UINavigationController alloc] initWithRootViewController:wallet];
        
        UINavigationController *navC3 = [[UINavigationController alloc] initWithRootViewController:circle];
        
        UINavigationController *navC4 = [[UINavigationController alloc] initWithRootViewController:me];
        
        
        LCTabBarController *tabBarC    = [[LCTabBarController alloc] init];
        tabBarC.view.backgroundColor   = [UIColor whiteColor];
        tabBarC.itemTitleFont          = [UIFont systemFontOfSize:11];
        tabBarC.itemTitleColor         = kGrayHex66;
        tabBarC.selectedItemTitleColor = kAppThemeColor;
//        tabBarC.itemTitleColor = [UIColor colorWithHexString:@"#848484"];
        tabBarC.viewControllers = @[navC1, navC2, navC3, navC4];
        self.window.rootViewController = tabBarC;
        
//    });
    
    
}

/*
- (void)initWithRootViewController
{
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    WalletViewController *walletVC = [[WalletViewController alloc] init];
    UINavigationController   *walletNav = [[UINavigationController alloc] initWithRootViewController:walletVC];
    
    CircleViewController * momentVC = [[CircleViewController alloc]init];
    UINavigationController * momentNav =[[UINavigationController alloc]initWithRootViewController:momentVC];
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    UINavigationController  *mineNav = [[UINavigationController alloc] initWithRootViewController:mineVC];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    
    tabBarController.viewControllers = @[homeNav,walletNav,momentNav,mineNav];
    
    NSArray *tabBarItemImages = @[@"ic_homepage", @"ic_money", @"ic_cricle",@""];
    NSArray *tabBarItemTitles = @[@"首页",@"钱袋",@"圈子",@"我的"];
    
    homeVC.title = @"首页";
    walletVC.title = @"钱袋";
    momentVC.title = @"圈子";
    mineVC.title = @"我的";
    
    RDVTabBar *tabBar = [tabBarController tabBar];
    
    [tabBar setFrame:CGRectMake(CGRectGetMinX(tabBar.frame), CGRectGetMinY(tabBar.frame), CGRectGetWidth(tabBar.frame), 63)];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_s",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_f",
                                                        [tabBarItemImages objectAtIndex:index]]];
        item.title = tabBarItemTitles[index];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        item.titlePositionAdjustment = UIOffsetMake(0, 3);
        [item setSelectedTitleAttributes:@{NSForegroundColorAttributeName:kAppThemeColor}];
        [item setUnselectedTitleAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0X666666"]}];
        item.backgroundColor = [UIColor whiteColor];
        index++;
    }
    [tabBar setHeight:kTabBarHeight];
    [tabBar setNeedsDisplay];
    [tabBar.layer displayIfNeeded];
    
    UIView *lineView = [UIView new];
    [tabBar addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(kLineWidth);
    }];
    lineView.backgroundColor = kLineGrayColor;
    
    self.window.rootViewController = tabBarController;
    
    tabBarController.selectedIndex = 0;
}

 */

/*
- (void)initWithAddressInfo
{
//    NSArray *cityDicArr = [kUserDefault objectForKey:@"cityDict"];
    BOOL isCacheProvinceData = [[kUserDefault objectForKey:cacheProvinceDataKey] boolValue];
    BOOL isCacheCityData = [[kUserDefault objectForKey:cacheCityDataKey] boolValue];
    BOOL isCacheCountyData = [[kUserDefault objectForKey:cacheCountyDataKey] boolValue];
    NSString *areaVersion = [kUserDefault objectForKey:@"CoachAreaVersion"];
    if (!isCacheProvinceData || !isCacheCityData || !isCacheCountyData)
    {
        [[AddressManager sharedAddressManager] updateAddressInfo];
    }
}
 
*/

- (void)initWithBugTags
{
    //崩溃日志收集
    BugtagsOptions *options = [[BugtagsOptions alloc] init];
    options.trackingCrashes = YES;
    options.trackingNetwork = YES;
    [Bugtags startWithAppKey:kBugTag_KEY invocationEvent:BTGInvocationEventNone options:options];
}

- (void)initWithAddressInfo
{
    if (isFirstLaunch)
    {
        [LLAddress loadAddress];
    }
}

- (void)initWithJPUSH
{
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    //Required
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:_launchOptions appKey:kJPUSH_APP_KEY
                          channel:@"Publish channel"
                 apsForProduction:YES];
    
    if (isLogin) {
        [[JpushManager sharedJpushManager] startMonitor];
    }
}

- (void)initWithIQKeyboardManage
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    //    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
}

- (void)initWithBMK
{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:kBMK_AK  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

- (void)initWithUMeng
{
    //设置微信AppId、appSecret，分享url
    [UMSocialData setAppKey:@"507fcab25270157b37000010"];
    
    [UMSocialWechatHandler setWXAppId:kWECHAT_APP_ID appSecret:kWECHAT_APP_SECRET url:@"http://www.sskz.com.cn/"];
    [UMSocialQQHandler setQQWithAppId:kQQ_APP_ID appKey:kQQ_APP_KEY url:@"http://www.sskz.com.cn/"];
}

- (void)initAddressBook
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, nil);
    
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authStatus != kABAuthorizationStatusAuthorized)
    {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (error) {
//                [LLUtils showErrorHudWithStatus:@"获取通讯录权限失败"];
            }
            else if (!granted)
            {
//                [LLUtils showErrorHudWithStatus:@"请先前往设置中打开通讯录权限"];
            }
            else
            {
                //成功获取通讯录权限
                
            }
        });
    }
    else
    {
        //有权限
        
    }
}

#pragma mark - 推送

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
//    [LLUtils showAlertWithTitle:userInfo[@"aps"][@"alert"] message:nil delegate:nil tag:0 type:AlertViewTypeOnlyConfirm];
    
    [NOTIFICATION_CENTER postNotificationName:kReceiveRemotoNotification object:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [application setApplicationIconBadgeNumber:0]; //将程序角标置为0
    
    //检查版本
    [[CheckVersionManager sharedCheckVersionManager] checkVersion];
}

#pragma mark - openURL && canOpenURL

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [self handleWeiXinPayWithUrl:url];
    [self handleUMengSocialServiceWithUrl:url];
    return  YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [self handleAlipayWithUrl:url];
    [self handleWeiXinPayWithUrl:url];
    [self handleUnionPayWithUrl:url];
    [self handleUMengSocialServiceWithUrl:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    [self handleAlipayWithUrl:url];
    [self handleWeiXinPayWithUrl:url];
    [self handleUnionPayWithUrl:url];
    [self handleUMengSocialServiceWithUrl:url];
    return YES;
}

- (void)openURL:(NSURL*)url options:(NSDictionary<NSString *, id> *)options completionHandler:(void (^ __nullable)(BOOL success))completion NS_AVAILABLE_IOS(10_0) NS_EXTENSION_UNAVAILABLE_IOS("");
{
    [self handleAlipayWithUrl:url];
    [self handleWeiXinPayWithUrl:url];
    [self handleUnionPayWithUrl:url];
    [self handleUMengSocialServiceWithUrl:url];
}

#pragma mark - 支付宝 && 微信 && 银联 回调处理

//银联支付回调处理
- (void)handleUnionPayWithUrl:(nonnull NSURL *)url
{
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        
        //结果code为成功时，先校验签名，校验成功后做后续处理
        if([code isEqualToString:@"success"]) {
            
            //数据从NSDictionary转换为NSString
            NSDictionary *data;
            NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                               options:0
                                                                 error:nil];
            NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
            
            //判断签名数据是否存在
            if(data == nil){
                //如果没有签名数据，建议商户app后台查询交易结果
                return;
            }
            [LLUtils showSuccessHudWithStatus:@"支付成功"];
            //验签证书同后台验签证书
            //此处的verify，商户需送去商户后台做验签
//            if([self verify:sign]) {
//                //支付成功且验签成功，展示支付成功提示
//            }
//            else {
//                //验签失败，交易结果数据被篡改，商户app后台查询交易结果
//            }
        }
        else if([code isEqualToString:@"fail"]) {
            //交易失败
            [LLUtils showSuccessHudWithStatus:@"支付失败"];
        }
        else if([code isEqualToString:@"cancel"]) {
            //交易取消
        }
    }];

}

//阿里支付回调处理
- (void)handleAlipayWithUrl:(nonnull NSURL *)url
{
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
            [LLUtils showSuccessHudWithStatus:@"充值成功"];
        }];
    }
}

//微信支付回调处理
- (void)handleWeiXinPayWithUrl:(nonnull NSURL *)url
{
    [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (void)handleUMengSocialServiceWithUrl:(nonnull NSURL *)url
{
    [UMSocialSnsService handleOpenURL:url];
}

@end
