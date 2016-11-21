//
//  CONST.h
//  集客专线手机终端运维系统
//
//  Created by zwz on 15/8/20.
//  Copyright (c) 2015年 zwz. All rights reserved.
//

#ifndef _____________CONST_h
#define _____________CONST_h

//#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kNavHeight 64
#define kTabBarHeight 49
#define BG_COLOR [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]
/**
 * 以iphone6来适配
 */
#define AutoSizeScaleX (kScreenWidth/375)
#define AutoSizeScaleY (kScreenHeight/667)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_MAX_LENGTH (MAX(kScreenWidth, kScreenHeight))
#define SCREEN_MIN_LENGTH (MIN(kScreenWidth, kScreenHeight))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define kAppMainColor [UIColor colorWithHexString:@"0X2e82ff"]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

#define RandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define NOTIFICATION_CENTER [NSNotificationCenter defaultCenter]

//用于定义collectionViewCell分割线使用
#define kTableViewSeparaterLineColor [UIColor colorWithRed:0.70f green:0.70f blue:0.70f alpha:1.00f]

//字体大小 以及颜色配置
#define WHSTYLESHEET ((id)[WHStyle globalStyleSheet])

#define WHSTYLEVAR(_VARNAME) [WHSTYLESHEET _VARNAME]
//系统
#define iOS7 [[UIDevice currentDevice].systemVersion doubleValue]>=7.0
#define CurrentDeviceSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]

//Format简写
#define Format(string, args...)                  [NSString stringWithFormat:string, args]


//cell的accessory宽度常量
#define kCellAccessoryDisclosureIndicatorWidth 33


//本地化宏定义
#define LocalizedString(key, comment) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]
#define LocalizedStringFromTable(key, tbl, comment) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:(tbl)]
#define LocalizedStringFromTableInBundle(key, tbl, bundle, comment) \
[bundle localizedStringForKey:(key) value:@"" table:(tbl)]
#define LocalizedStringWithDefaultValue(key, tbl, bundle, val, comment) \
[bundle localizedStringForKey:(key) value:(val) table:(tbl)]




//单例声明
#define singletonInterface(className) + (instancetype)shared##className;

//单例实现
#define singletonImplementation(className)\
static className *_instance;\
+ (id)allocWithZone:(struct _NSZone *)zone\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [super allocWithZone:zone];\
    });\
    return _instance;\
}\
+ (instancetype)shared##className\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [[self alloc] init];\
    });\
    return _instance;\
}\
- (id)copyWithZone:(NSZone *)zone\
{\
    return _instance;\
}

//自定义Log
#ifdef DEBUG
#define HJLog(format, ...) {NSLog((@"\n输出:" format @"\n方法名:%s \n行数:%d" ),##__VA_ARGS__,__PRETTY_FUNCTION__,__LINE__);}
#else
#define HJLog(...)
#endif

//解决AFNetworking报错问题
#ifndef TARGET_OS_IOS
#define TARGET_OS_IOS TARGET_OS_IPHONE
#endif
#ifndef TARGET_OS_WATCH
#define TARGET_OS_WATCH 0
#endif


#if DEBUG
#define MCRelease(x) [x release]
#else
#define MCRelease(x) [x release], x = nil
#endif

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

/**
 *  项目
 */
#define TEXTFIELD_H 45
#define CORNERRADIUS 8
#define LINE_HEIGHT (([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))?0.5:1)

#define WeakObj(o) __weak typeof(o) o##Weak = o;

#define kWidthScale kScreenWidth/320
#define kHeightScale kScreenHeight/568

#define kFont10 [UIFont systemFontOfSize:10*kWidthScale]
#define kFont11 [UIFont systemFontOfSize:11*kWidthScale]
#define kFont12 [UIFont systemFontOfSize:12*kWidthScale]
#define kFont13 [UIFont systemFontOfSize:13*kWidthScale]
#define kFont14 [UIFont systemFontOfSize:14*kWidthScale]
#define kFont15 [UIFont systemFontOfSize:15*kWidthScale]
#define kFont16 [UIFont systemFontOfSize:16*kWidthScale]
#define kFont17 [UIFont systemFontOfSize:17*kWidthScale]
#define kFont18 [UIFont systemFontOfSize:18*kWidthScale]
#define kFont19 [UIFont systemFontOfSize:19*kWidthScale]
#define kFont20 [UIFont systemFontOfSize:20*kWidthScale]

#endif
