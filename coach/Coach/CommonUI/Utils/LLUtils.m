//
//  LLUtils.m
//  Coach
//
//  Created by LL on 16/8/8.
//  Copyright © 2016年 sskz. All rights reserved.
//

#define ex_s_Color kAppThemeColor
#define co_s_TextSize (13)
#define we_s_Color [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]
#define UIControlViewTag 100

CGFloat const hudDismissTime = 1.5f;

#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MBProgressHUD.h>
#import "LLUtils.h"
#import "Autofit_Label.h"

@implementation LLUtils

+ (void)showAutoHideMsg:(NSString *)noticeStr
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat width = 200;
        CGFloat height = 40 ;
        UIView * noticeMsgView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - width)/2.0, kScreenHeight *2 /3.0 , width, height)];
        noticeMsgView.backgroundColor = ex_s_Color;
        noticeMsgView.layer.cornerRadius = 8.0;
        Autofit_Label * noticelab = [[Autofit_Label alloc] initWithText:noticeStr Size:co_s_TextSize Frame:CGRectMake(5, 0, width, height)];
        noticelab.text = noticeStr;
        noticelab.textColor = we_s_Color;
        noticelab.textAlignment = NSTextAlignmentCenter;
        width = noticelab.frame.size.width;
        noticeMsgView.frame = CGRectMake((kScreenWidth - width)/2, kScreenHeight/2, width+10, height);
        [noticeMsgView addSubview:noticelab];
        noticeMsgView.tag = UIControlViewTag + 1234;
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        UIView *temp = [keyWindow viewWithTag:UIControlViewTag+1234];
        if (!temp) {
            
            [keyWindow addSubview:noticeMsgView];
            [keyWindow bringSubviewToFront:noticeMsgView];
        }
        else
        {
            [temp removeFromSuperview];
            [keyWindow addSubview:noticeMsgView];
            [keyWindow bringSubviewToFront:noticeMsgView];
        }
        [UIView animateWithDuration:2.0f animations:^{
            noticeMsgView.alpha = 0;
        }completion:^(BOOL finished) {
            [noticeMsgView removeFromSuperview];
        }];
    });
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate tag:(NSInteger)tag type:(AlertViewType)type
{
    UIAlertView *alertView = nil;
    if (type == AlertViewTypeOnlyYes || type == AlertViewTypeOnlyConfirm) {
        alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:type == AlertViewTypeOnlyYes ? @"是" : @"确定" otherButtonTitles:nil, nil];
    }
    else
    {
        alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:type==AlertViewTypeYesAndNo?@"是":@"确定" otherButtonTitles:type==AlertViewTypeYesAndNo?@"否":@"取消", nil];
    }
    alertView.tag = tag;
    [alertView show];
}

+ (void)callPhoneWithPhone:(NSString *)phoneStr
{
    if (isEmptyStr(phoneStr)) {
        return;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneStr]]];
}

+ (NSString *)jsonStrWithJSONObject:(id)jsonObj
{
    if (!jsonObj || ![NSJSONSerialization isValidJSONObject:jsonObj]) {
        return @"";
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObj options:0 error:&error];
    if (error || !jsonData) {
        return @"";
    }
    else
    {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

+ (id)jsonObjectWithJSONStr:(NSString *)jsonStr
{
    if (!jsonStr) {
        return @{};
    }
    NSError *error = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if (!error && jsonObj) {
        return jsonObj;
    }
    else
    {
        return @{};
    }
}

+ (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    // NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"%u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [ NSPropertyListSerialization  propertyListFromData:tempData
                                                             mutabilityOption:NSPropertyListImmutable
                                                                       format:NULL
                                                             errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

//回弹动画
//实现view由小放大再缩小，回弹效果的动画
//view : 要做动画的view
+ (void)showSpringBackAnimationView:(UIView *)view
{
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:popAnimation forKey:nil];
}

//消失动画
//alphaView   : alphaView 要做透明度变化到完全透明的View
//scaleView   : 要做缩放动画的View
//dismissBlock: alphaView从父视图移除时的回调block
+ (void)showDismissAnimationWithAlphaView:(UIView *)alphaView scaleView:(UIView *)scaleView didDismissBlock:(void(^)())dismissBlock
{
    [UIView animateWithDuration:0.2f animations:^{
        alphaView.alpha = 0;
        scaleView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    } completion:^(BOOL finished) {
        [alphaView removeFromSuperview];
        if (dismissBlock) {
            dismissBlock();
        }
    }];
}

//将时间戳转换成NSDate
//timeStamp  : 时间戳 NSString / NSNumber
//return     : 返回对应的日期 NSDate
+ (NSDate *)dateWithTimeStamp:(id)timeStamp
{
    if (isNull(timeStamp)) {
        return [NSDate date];
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    if (isNull(date)) {
        return [NSDate date];
    }
    else
    {
        return date;
    }
}

//将时间戳转换成NSString
//timeStamp  : 时间戳 NSString / NSNumber
//dateFormat : 返回的时期格式 eg. @"yyyy-MM-dd"
//return     : 返回对应的日期字符串 NSString
+ (NSString *)dateStrWithTimeStamp:(id)timeStamp dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = isNull(dateFormat)?@"yyyy-MM-dd":dateFormat;
    if (isNull(timeStamp)) {
        return [dateFormater stringFromDate:[NSDate date]];
    }
    NSDate *date = [self dateWithTimeStamp:timeStamp];
    NSString *dateStr = [dateFormater stringFromDate:date];
    if (isNull(dateStr)) {
        return [dateFormater stringFromDate:[NSDate date]];
    }
    else
    {
        return dateStr;
    }
}

//将日期转换成 制定格式的日期字符串
//date       : 待转换日期 NSDate
//dateFormat : 返回的时期格式 eg. @"yyyy-MM-dd"
//return     : 返回对应的日期字符串 NSString
+ (NSString *)dateStrWithDate:(NSDate *)date dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = isNull(dateFormat)?@"yyyy-MM-dd":dateFormat;
    if (isNull(date)) {
        return [dateFormater stringFromDate:[NSDate date]];
    }
    NSString *dateStr = [dateFormater stringFromDate:date];
    if (isNull(dateStr)) {
        return [dateFormater stringFromDate:[NSDate date]];
    }
    else
    {
        return dateStr;
    }
}

//将日期字符串 按照相应的格式 转换成对应的 日期
//dateStr    : 待转换日期字符串 NSString
//dateFormat : 返回的时期格式 eg. @"yyyy-MM-dd"  注意：dateFormat参数传入的字符串格式必须和传入的dateStr的格式一致，否则会崩溃!
//return     : 返回对应的日期 NSDate
+ (NSDate *)dateWithDateStr:(NSString *)dateStr dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = isNull(dateFormat)?@"yyyy-MM-dd":dateFormat;
    if (isNull(dateStr)) {
        return [NSDate date];
    }
    NSDate *date = [dateFormater dateFromString:dateStr];
    if (isNull(date)) {
        return [NSDate date];
    }
    else
    {
        return date;
    }
}

//获取对应日期的时间戳
//date   : NSDate
//return : 时间戳
+ (long long)timestampsWithDate:(NSDate *)date
{
    if (isNull(date)) {
        return [[NSDate date] timeIntervalSince1970];
    }
    long long timestamps = [date timeIntervalSince1970];
    if (timestamps<0) {
        return [[NSDate date] timeIntervalSince1970];
    }
    else
    {
        return timestamps;
    }
}

//获取对应日期字符串的时间戳
//dateStr   : NSString
//format    :格式化的字符串
//return    : 时间戳
+ (long long)timestampsWithDateStr:(NSString *)dateStr dateFormat:(NSString *)format
{
    if (isNull(dateStr)) {
        return [[NSDate date] timeIntervalSince1970];
    }
    NSDate *date = [self dateWithDateStr:dateStr dateFormat:format];
    long long timestamps = [self timestampsWithDate:date];
    return timestamps;
}

#pragma mark - HUD

+ (void)showOnlyProgressHud
{
    [SVProgressHUD show];
}

+ (void)showTextAndProgressHud:(NSString *)status
{
    [SVProgressHUD showWithStatus:status];
}

+ (void)showTextAndProgressHud:(NSString *)status afterDelay:(NSTimeInterval)delay
{
    [SVProgressHUD showWithStatus:status];
    [SVProgressHUD dismissWithDelay:delay];
}

+ (void)showOnlyTextHub:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    // Move to bottm center.
    //    hud.xOffset = 0.f;
    //    hud.yOffset = kScreenHeight/2-50;
    //    hud.yOffset = MBProgressMaxOffset;
    [hud hide:YES afterDelay:hudDismissTime];
}

+ (void)showSuccessHudWithStatus:(NSString *)statusStr
{
    if (isNull(statusStr)) {
        return;
    }
    [self setSVProgressHideTime];
    [SVProgressHUD showSuccessWithStatus:statusStr];
}

+ (void)showErrorHudWithStatus:(NSString *)statusStr
{
    if (isNull(statusStr)) {
        return;
    }
    [self setSVProgressHideTime];
    [SVProgressHUD showErrorWithStatus:statusStr];
}

+ (void)showInfoHudWithStatus:(NSString *)statusStr
{
    if (isNull(statusStr)) {
        return;
    }
    [self setSVProgressHideTime];
    [SVProgressHUD showInfoWithStatus:statusStr];
}

+ (void)setSVProgressHideTime
{
    [SVProgressHUD setMinimumDismissTimeInterval:hudDismissTime];
}

+ (void)dismiss
{
    [SVProgressHUD dismiss];
}

+(BOOL)validateMobile:(NSString *)mobileNum
{
    NSString *pattern = @"1[3|5|7|8|][0-9]{9}";;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:mobileNum];
    return isMatch;
}

+(BOOL)validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

//UIImage ===> NSData
+ (NSData *)dataWithImage:(UIImage *)image
{
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil) {
        
        data = UIImageJPEGRepresentation(image, 1);
        
    } else {
        
        data = UIImagePNGRepresentation(image);
    }
    return data;
}

+ (NSString *)previousMonthWithProviceMonthIndex:(NSInteger)monthIndex dateFormat:(NSString *)format
{
    NSCalendar *calender = [NSCalendar currentCalendar];//获取NSCalender单例。
    NSDateComponents *cmp = [calender components:(NSMonthCalendarUnit | NSYearCalendarUnit
                                            |NSDayCalendarUnit | NSHourCalendarUnit
                                            |NSMinuteCalendarUnit
                                            |NSSecondCalendarUnit) fromDate:[[NSDate alloc] init]];// 设置属性，因为我只需要年和月，这个属性还可以支持时，分，秒。
    [cmp setMonth:[cmp month] - monthIndex];//设置上个月，即在现有的基础上减去一个月。这个地方可以灵活的支持跨年了，免去了繁琐的计算年份的工作。
    NSDate *lastMonDate = [calender dateFromComponents:cmp];//拿到上个月的NSDate，再用
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    NSString *dateStr = [formatter stringFromDate:lastMonDate];
    return dateStr;
}

+ (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;  
}

//将日期的时分秒置为0
+ (NSDate *)setHourMinSecToZero:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                    |NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    
    components.hour = components.minute = components.second = 0;
    
    return [calendar dateFromComponents:components];
}

//过滤手机号的86,+86,+86·
+ (NSString *)filterPhoneNum86:(NSString *)phone
{
    if ([phone hasPrefix:@"86"]) {
        NSString *formatStr = [phone substringWithRange:NSMakeRange(2, [phone length]-2)];
        return formatStr;
    }
    else if ([phone hasPrefix:@"+86"])
    {
        if ([phone hasPrefix:@"+86·"]) {
            NSString *formatStr = [phone substringWithRange:NSMakeRange(4, [phone length]-4)];
            return formatStr;
        }
        else
        {
            NSString *formatStr = [phone substringWithRange:NSMakeRange(3, [phone length]-3)];
            return formatStr;
        }
    }
    return phone;
}

//获取url字符串中某一参数值对应的参数值
//paraName : 要扣取的参数名
//url      : url字符串
//return   : 返回对应参数名的参数值
+ (NSString *)getParaValueWithParaName:(NSString *)paraName url:(NSString *)url
{
    NSArray *urlSepArr = [url componentsSeparatedByString:@"?"];
    if (isEmptyStr(paraName) || isEmptyStr(url) || urlSepArr.count != 2) {
        return @"";
    }
    NSString *paraListStr = [urlSepArr lastObject];
    NSArray *paraSepArr = [paraListStr componentsSeparatedByString:@"&"];
    for (NSString *paraStr in paraSepArr) {
        if ([paraStr containsString:paraName]) {
            NSArray *getArr = [paraStr componentsSeparatedByString:@"="];
            if (getArr.count==0) {
                return @"";
            }
            else if (getArr.count==1)
            {
                return @"";
            }
            else
            {
                return [getArr lastObject];
            }
        }
    }
    return @"";
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

////检查有没有登陆 没有登陆弹出登录注册窗口
//+ (void)chackLoginWithJsonObj:(id)jsonObj
//{
//    if ([jsonObj[@"code"] intValue] == 2) {
//        //未登陆
//        UIViewController *vc = [LLUtils getCurrentVC];
//        [vc showLoginRegisterWithLoginSuccessBlock:^{
//            
//        }];
//    }
//}

+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:certificate ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    NSLog(@"===>%@",certData);
    
    if (certData) {
        securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
    }
    
    return securityPolicy;
}

@end
