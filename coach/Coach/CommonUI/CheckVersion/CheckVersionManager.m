//
//  CheckVersionManager.m
//  学员端
//
//  Created by zuweizhong  on 16/8/26.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "AddressManager.h"
#import "CheckVersionManager.h"
#import "XIAlertView.h"
#import "HJHttpManager.h"
#import "HttpParamManager.h"
@implementation CheckVersionManager

singletonImplementation(CheckVersionManager)

-(void)checkVersion
{
    [self loadVersion];
}
-(void)loadVersion
{
    NSString *url = self.interfaceManager.checkVersion;
    NSString *time = [HttpParamManager getTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    param[@"version"] = kAppVersion;
    param[@"channel"] = @(1);
    param[@"time"] = time;
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        if (code == 1)
        {
            NSString *updateCode = dict[@"info"][@"updateCode"];
            NSString *updateInfo = dict[@"info"][@"updateInfo"];
            NSString *updateUrl = dict[@"info"][@"updateUrl"];
            
            NSString * serverTimeStr = dict[@"info"][@"serverTime"];
            
            BOOL beansShow = [dict[@"info"][@"beans_show"] boolValue];
            
            [USER_DEFAULT setObject:@(beansShow) forKey:@"BeansShow"];
            [USER_DEFAULT synchronize];
            NSLog(@"dsddcc-----%d",kBeansShow);
            
            NSString *area_ver = dict[@"info"][@"area_ver"];
            
            area_ver = [NSString stringWithFormat:@"%@",area_ver];
            
            NSString *old_area_ver = [kUserDefault objectForKey:@"CoachAreaVersion"];
            
            BOOL isCacheProvinceData = [[kUserDefault objectForKey:cacheProvinceDataKey] boolValue];
            BOOL isCacheCityData = [[kUserDefault objectForKey:cacheCityDataKey] boolValue];
            BOOL isCacheCountyData = [[kUserDefault objectForKey:cacheCountyDataKey] boolValue];
            
            if ((!isStartUpdaeDB)&&(!old_area_ver || !isCacheProvinceData || !isCacheCityData || !isCacheCountyData || ![area_ver isEqualToString:old_area_ver])) {
                //更新地址数据
                [kUserDefault setBool:YES forKey:@"AreaStartUpdateFlag"];//标记地址开始更新
                [[AddressManager sharedAddressManager] updateAddressInfo];
            }
            [kUserDefault synchronize];
            
            
            //存储地区版本号
            [kUserDefault setObject:area_ver forKey:@"CoachAreaVersion"];
            
            if ([updateCode isEqualToString:@"1"]) {//建议升级
                

                XIAlertView *alertView = [[XIAlertView alloc] initWithTitle:@"有新版本"
                                                                    message:updateInfo
                                                          cancelButtonTitle:@"取消"];

            
                [alertView addDefaultStyleButtonWithTitle:@"立即更新" handler:^(XIAlertView *alertView, XIAlertButtonItem *buttonItem) {
                    [alertView dismiss];
                    // 通过获取到的url打开应用在appstore，并跳转到应用下载页面
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:updateUrl]];
                }];
                
                [alertView show];
            }
            if ([updateCode isEqualToString:@"2"]) {//强制升级
                XIAlertView *alertView = [[XIAlertView alloc] initWithTitle:@"有新版本"
                                                                    message:updateInfo
                                                          cancelButtonTitle:@"立即更新"];
                
                alertView.customCancelBtnHandler = ^(XIAlertView *alertView,XIAlertButtonItem *buttonItem){
                    [alertView dismiss];
                    // 通过获取到的url打开应用在appstore，并跳转到应用下载页面
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:updateUrl]];
                    
                    
                };
                
                [alertView show];
            }

            long long i = [serverTimeStr longLongValue];
            long long j = [[NSDate date] timeIntervalSince1970];
            long long k = i-j;

//            NSTimeInterval current = k + j;
//            NSInteger currentTime = current;
            
//            NSLog(@"%f",[[NSDate date] timeIntervalSince1970]);
            NSString * str = [NSString stringWithFormat:@"%lld",k];
            [kUserDefault setObject:str forKey:@"CoachTimeDifference"];
            
            [kUserDefault synchronize];
        }

    } failed:^(NSError *error) {
        
    }];

    
}

//比较日期的方法
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //    [df setDateFormat:@"yyyy-MM-dd"];
    [df setDateFormat:@"HH:mm"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}

@end
