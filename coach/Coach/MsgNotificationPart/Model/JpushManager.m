//
//  JpushManager.m
//  学员端
//
//  Created by zuweizhong  on 16/8/19.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SystemMsgController.h"
#import "CoachProveVC.h"
#import "CircleJSManager.h"
#import "LLWebViewController.h"
#import "MyCircleViewController.h"
#import "MyAdmissionsVC.h"
#import "DealOrderViewController.h"
#import "JpushManager.h"
#import "JPUSHService.h"
#import "MsgModel.h"
#import "MessageDataBase.h"
@implementation JpushManager

singletonImplementation(JpushManager)

-(void)startMonitor
{
    
    if (![kUid isEqualToString:@"0"]) {
        
        [JPUSHService setTags:nil alias:kUid callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:nil];
    }
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    [defaultCenter addObserver:self selector:@selector(handleRemoteNotifyWithUserInfo:) name:kReceiveRemotoNotification object:nil];
}

- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];

    HJLog(@"%@",userInfo);
    
    int maxid = [[MessageDataBase shareInstance]getMaxIdModel].idNum;

    NSString *url = @"/message";
    NSString *time = kTimeStamp;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"maxId"] = @(maxid);
    param[@"time"] = time;
    param[@"sign"] = kSignWithIdentify(url);
    param[@"deviceInfo"] = kDeviceInfo;
    
    [NetworkEngine postRequestWithRelativeAdd:url paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] intValue] == 1)
            {
                
                NSArray *arr = [MsgModel mj_objectArrayWithKeyValuesArray:jsonObj[@"info"][@"message"]];
                
                for (int i = 0; i<arr.count; i++) {
                    MsgModel *model = arr[i];
                    [[MessageDataBase shareInstance] insertDataWithModel:model];
                }
                
                if (arr.count>0) {
                    //存储最大ID
                    MsgModel *t_MessageModel = [[MessageDataBase shareInstance] getMaxIdModel];
                    [kUserDefault setObject:intToStr(t_MessageModel.idNum) forKey:kMaxMessageId];
                }
                
                [NOTIFICATION_CENTER postNotificationName:kUpdateMainMsgRedPointNotification object:nil];
                
            }
        }
        else
        {
            
        }
    }];

    
    
    
}

-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

//处理远程通知
- (void)handleRemoteNotifyWithUserInfo:(NSNotification *)notify
{
    UIApplication *application = [UIApplication sharedApplication];
    
    BOOL isBackground =  application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground;
    
    UINavigationController *navigation = [LLUtils getCurrentVC].navigationController;
    
    NSDictionary *userInfo = notify.object;
    
    NSString *msg_id = userInfo[@"msg_id"];
    
    if (isBackground) {
        switch ([msg_id intValue]) {
            case 25:
            {
                //学员申请绑定
                //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否接受此学员的绑定请求?" message:nil delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"接受", nil];
                //            alertView.tag = 10;
                //            [alertView show];
                SystemMsgController *msgVC = [[SystemMsgController alloc] init];
                [navigation pushViewController:msgVC animated:YES];
            }
                break;
            case 26:
            {
                //学员预约学时陪练提醒
                DealOrderViewController *appointVC = [[DealOrderViewController alloc] init];
                [navigation pushViewController:appointVC animated:YES];
            }
                break;
            case 27:
            {
                //优惠券被领取通知
                SystemMsgController *msgVC = [[SystemMsgController alloc] init];
                [navigation pushViewController:msgVC animated:YES];
            }
                break;
            case 28:
            {
                //邀请学员加入招生团被接受通知（学员端接受）
                MyAdmissionsVC *myAdmissionVC = [[MyAdmissionsVC alloc] init];
                [navigation pushViewController:myAdmissionVC animated:YES];
            }
                break;
            case 29:
            {
                //圈子新消息通知
                MyCircleViewController *myCircleVC = [[MyCircleViewController alloc] init];
                [navigation pushViewController:myCircleVC animated:YES];
            }
                break;
            case 30:
            {
                //被推荐上头条通知
                NSString *momentId = userInfo[@"_j_msgid"];
                NSString *componentStr = [NSString stringWithFormat:@"/community/show/%@?uid=%@&app=1&cityid=%@&address=%@",momentId,kUid,kCityID,kAddress];
                LLWebViewController *webVC = [[LLWebViewController alloc] initWithUrl:[NSURL URLWithString:[WAP_HOST_ADDR stringByAppendingPathComponent:componentStr]] title:@"圈子详情" rightImgName:nil];
                
                CircleJSManager *js_Manager = [[CircleJSManager alloc] init];
                webVC.js_Manager = js_Manager;
                webVC.object = @(1);
                
                //            WeakObj(self)
                js_Manager.needRefreshBlock = ^(CircleJSManager *js_Manager){
                    //                //计算当前Cell所在页码
                    //                CircleMainContentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    //                NSUInteger currentPageIndex = cell.indexPath.row/_pageSize+1;
                    //
                    //                //请求并刷新UI
                    //                [selfWeak refreshDataWithPage:currentPageIndex];
                };
                
                [navigation pushViewController:webVC animated:YES];
            }
                break;
            case 31:
            {
                //充值提现成功通知
                SystemMsgController *msgVC = [[SystemMsgController alloc] init];
                [navigation pushViewController:msgVC animated:YES];
            }
                break;
            case 32:
            {
                //提现申请审核失败通知
                SystemMsgController *msgVC = [[SystemMsgController alloc] init];
                [navigation pushViewController:msgVC animated:YES];
            }
                break;
            case 33:case 34:
            {
                //教练认证审核结果通知
                CoachProveVC * vc = [[CoachProveVC alloc]init];
                [navigation pushViewController:vc animated:YES];
            }
                break;
            case 35:
            {
                //修改密码成功通知
                SystemMsgController *msgVC = [[SystemMsgController alloc] init];
                [navigation pushViewController:msgVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        //前台
    }
}

/*
{
    "_j_msgid" = 2754686040;
    aps =     {
        alert = "\U3010\U5eb7\U5e84\U5b66\U8f66\U3011\U5c0a\U656c\U7684\U5218\U4e50\U6559\U7ec3\Uff0c\U60a8\U6536\U5230\U4e00\U6761\U5708\U5b50\U65b0\U6d88\U606f\Uff0c\U8bf7\U67e5\U770b\U3002";
        badge = 6;
        "content-available" = 1;
        sound = "sound.caf";
    };
    "msg_id" = 29;
}
 */

@end
