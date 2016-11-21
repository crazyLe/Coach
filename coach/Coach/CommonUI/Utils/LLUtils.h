//
//  LLUtils.h
//  Coach
//
//  Created by LL on 16/8/8.
//  Copyright © 2016年 sskz. All rights reserved.
//

typedef enum {
    AlertViewTypeOnlyYes = 1,  //是
    AlertViewTypeYesAndNo,     //是 否
    AlertViewTypeConfirmAndCancel,//确定 取消
    AlertViewTypeOnlyConfirm   //确定
}AlertViewType;

#import <Foundation/Foundation.h>

@class AFSecurityPolicy;

@interface LLUtils : NSObject

//显示自动隐藏的消息
//noticeStr : 要显示的消息字符串
+ (void)showAutoHideMsg:(NSString *)noticeStr;

//显示警告框
//title    : 标题
//message  : 内容
//delegate : 代理
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate tag:(NSInteger)tag type:(AlertViewType)type;

/***********HUD**********************/
+ (void)showOnlyProgressHud;                      //仅仅只有进度条hud
+ (void)showTextAndProgressHud:(NSString *)status; //带进度和文本hud
+ (void)showTextAndProgressHud:(NSString *)status afterDelay:(NSTimeInterval)delay;
+ (void)showOnlyTextHub:(NSString *)text;  //只有文本hud
+ (void)showSuccessHudWithStatus:(NSString *)statusStr; //成功hud
+ (void)showErrorHudWithStatus:(NSString *)statusStr;   //失败hud
+ (void)showInfoHudWithStatus:(NSString *)statusStr;    //感叹号hud
+ (void)dismiss;                                        //移除hud

//拨打电话
//phoneStr : 电话号码
+ (void)callPhoneWithPhone:(NSString *)phoneStr;

//将json对象转换成json字符串
//jsonObj : json对象
+ (NSString *)jsonStrWithJSONObject:(id)jsonObj;

//将json字符串转换成json对象
//jsonStr : json字符串
//return  : json对象
+ (id)jsonObjectWithJSONStr:(NSString *)jsonStr;

//去除字符串中unicode编码 / unicode字符转中文字符
//unicodeStr : 含有unicode字符的字符串
//return     : 转换后的字符串（不含unicode编码）
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

//回弹动画
//实现view由小放大再缩小，回弹效果的动画
//view : 要做动画的view
+ (void)showSpringBackAnimationView:(UIView *)view;

//消失动画
//alphaView   : alphaView 要做透明度变化到完全透明的View
//scaleView   : 要做缩放动画的View
//dismissBlock: alphaView从父视图移除时的回调block
+ (void)showDismissAnimationWithAlphaView:(UIView *)alphaView scaleView:(UIView *)scaleView didDismissBlock:(void(^)())dismissBlock;

//将时间戳转换成NSDate
//timeStamp  : 时间戳 NSString / NSNumber
//return     : 返回对应的日期 NSDate
+ (NSDate *)dateWithTimeStamp:(id)timeStamp;
//将时间戳转换成NSString
//timeStamp  : 时间戳 NSString / NSNumber
//dateFormat : 返回的时期格式 eg. @"yyyy-MM-dd"
//return     : 返回对应的日期字符串 NSString
+ (NSString *)dateStrWithTimeStamp:(id)timeStamp dateFormat:(NSString *)dateFormat;
//将日期转换成 制定格式的日期字符串
//date       : 待转换日期 NSDate
//dateFormat : 返回的时期格式 eg. @"yyyy-MM-dd"
//return     : 返回对应的日期字符串 NSString
+ (NSString *)dateStrWithDate:(NSDate *)date dateFormat:(NSString *)dateFormat;
//将日期字符串 按照相应的格式 转换成对应的 日期
//dateStr    : 待转换日期字符串 NSString
//dateFormat : 返回的时期格式 eg. @"yyyy-MM-dd"  注意：dateFormat参数传入的字符串格式必须和传入的dateStr的格式一致，否则会崩溃!
//return     : 返回对应的日期 NSDate
+ (NSDate *)dateWithDateStr:(NSString *)dateStr dateFormat:(NSString *)dateFormat;

//获取对应日期的时间戳
//date   : NSDate
//return : 时间戳
+ (long long)timestampsWithDate:(NSDate *)date;
//获取对应日期字符串的时间戳
//dateStr   : NSString
//format    :格式化的字符串
//return    : 时间戳
+ (long long)timestampsWithDateStr:(NSString *)dateStr dateFormat:(NSString *)format;


/**
 *  验证手机号 以13、15、17、18开头
 *
 *  @param mobileNum 手机号
 *
 *  @return Yes手机号格式正确
 */
+(BOOL)validateMobile:(NSString *)mobileNum;


/**
 *  验证密码6-20
 *
 *  @param passWord 密码字符串
 *
 *  @return Yes密码格式正确
 */
+(BOOL) validatePassword:(NSString *)passWord;

//UIImage ===> NSData
+ (NSData *)dataWithImage:(UIImage *)image;

//获取n个月之前的日期字符串
//monthIndex : 月份索引 eg . 1 ==> 1月之前
//format     : 格式化日期的格式字符串
//return     : 返回之前的日期 
+ (NSString *)previousMonthWithProviceMonthIndex:(NSInteger)monthIndex dateFormat:(NSString *)format;

//判断字符串中是否全部是数字
//string : 要判断你的字符串
//return : YES : 纯数字
+ (BOOL)isPureNumandCharacters:(NSString *)string;

//将日期的时分秒置为0
//date   : 需要时分秒置为0的日期
//return : 时分秒置为0的日期
+ (NSDate *)setHourMinSecToZero:(NSDate *)date;

//过滤手机号的86,+86,+86·
+ (NSString *)filterPhoneNum86:(NSString *)phone;

//获取url字符串中某一参数值对应的参数值
//paraName : 要扣取的参数名
//url      : url字符串
//return   : 返回对应参数名的参数值
+ (NSString *)getParaValueWithParaName:(NSString *)paraName url:(NSString *)url;

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;

////检查有没有登陆 没有登陆弹出登录注册窗口
//+ (void)chackLoginWithJsonObj:(id)jsonObj;

+ (AFSecurityPolicy*)customSecurityPolicy;

@end
