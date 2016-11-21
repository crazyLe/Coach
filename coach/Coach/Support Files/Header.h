//
//  Header.h
//  Coach
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 sskz. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define kStatusBarHeight 20
#define kNavBarHeight 44
#define kTabBarHeight 49
#define kSideBtnWidth 60
#define kTopBarTotalHeight (kStatusBarHeight+kNavBarHeight)

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

//比例缩放
#define HCoachWidth  kScreenWidth/375.0

/****************自定义日志输出****************/
#ifdef DEBUG
#define CGLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define CGLog(...)
#endif

// 教练端APP色值
#define kBackgroundColor [UIColor colorWithHexString:@"#EDEDEF"] //背景颜色
#define kLineWhiteColor [UIColor colorWithHexString:@"#E7E7E7"] //白色底部线条颜色
#define kLineGrayColor [UIColor colorWithHexString:@"#cccccc"] //灰色底部线条颜色
//************字体大小************/
#define Font10 [UIFont systemFontOfSize:10.0]
#define Font11 [UIFont systemFontOfSize:11.0]
#define Font12 [UIFont systemFontOfSize:12.0]
#define Font13 [UIFont systemFontOfSize:13.0]
#define Font14 [UIFont systemFontOfSize:14.0]
#define Font15 [UIFont systemFontOfSize:15.0]
#define Font16 [UIFont systemFontOfSize:16.0]
#define Font17 [UIFont systemFontOfSize:17.0]
#define Font18 [UIFont systemFontOfSize:18.0]
#define Font19 [UIFont systemFontOfSize:19.0]
#define Font20 [UIFont systemFontOfSize:20.0]
#define Font22 [UIFont systemFontOfSize:22.0]

#define WeakObj(o) __weak typeof(o) o##Weak = o;

//预设颜色
#define kRedColor        [UIColor colorWithHexString:@"0Xfd5e5e"]
#define kOrangeColor     [UIColor colorWithHexString:@"0Xffab33"]
#define kBlueColor       [UIColor colorWithHexString:@"0X5db5ff"]
#define kGreenColor      [UIColor colorWithHexString:@"0X6ccd3e"]
#define kPromptTextColor [UIColor colorWithHexString:@"0Xc5b594"]
#define kBlackTextColor  [UIColor colorWithHexString:@"0X646464"]
#define kLineColor       [UIColor colorWithHexString:@"0Xf0f0f0"] //分割线 颜色
#define kTableBgColor    [UIColor colorWithHexString:@"0Xf2f2f2"] //表 背景颜色
#define kAppThemeColor   [UIColor colorWithHexString:@"0X2e82ff"] //APP 主题色
#define kDarkGrayColor   [UIColor colorWithHexString:@"0X333333"] //深灰
#define kLightGreyColor  [UIColor colorWithHexString:@"0X999999"] //浅灰

#define kGrayHex33          [UIColor colorWithHexString:@"333333"]
#define kGrayHex88          [UIColor colorWithHexString:@"888888"]
#define kGrayHex66          [UIColor colorWithHexString:@"666666"]
#define kGrayHex99          [UIColor colorWithHexString:@"999999"]
#define kGrayHex64          [UIColor colorWithHexString:@"646464"]

//RGB色值
#define RGBColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

//IPHONE 6
//#define kWidthScale kScreenWidth/375.0f
//#define kHeightScale kScreenHeight/667.0f

//IPHONE 4S
#define Scale       [UIScreen mainScreen].bounds.size.width/320.0//放大比
#define widthScale  [UIScreen mainScreen].bounds.size.width/320.0//宽度放大比
#define heightScale [UIScreen mainScreen].bounds.size.height/480.0//高度放大比

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

#define kLineWidth 0.5f  //分割线宽
#define kSepViewHeight 12.5f

#define kUserDefault [NSUserDefaults standardUserDefaults]

//提交按钮
#define ButtonH 44
#define CommonButtonBGColor kAppThemeColor
//粗体
#define BoldFontWithSize(f) [UIFont fontWithName:@"Helvetica-Bold" size:f]
//验证号码
#define validationPhoneNum @"400-800-6533"


/*******************请求常用宏，以及用户信息宏*************************/

//时间戳
//#define kTimeStamp [NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]]
#define kTimeStamp  [NSString stringWithFormat:@"%lld",[[kUserDefault objectForKey:@"CoachTimeDifference"] intValue]+(long long)[[NSDate date] timeIntervalSince1970]]

//UUID设备唯一标示
#define kUUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
//设备信息
#define kDeviceInfo [NSString stringWithFormat:@"%@,%@",[UIDevice currentDevice].model,[[UIDevice currentDevice] systemVersion]]
//用户ID
#define kUid [kUserDefault objectForKey:@"CoachUid"]
//令牌
#define kToken [kUserDefault objectForKey:@"CoachToken"]
//签名
#define kSignWithIdentify(identifier) [[NSString stringWithFormat:@"%@%@%@%@%@",kUUID,identifier,kUid,kToken,kTimeStamp] md5String]
//#define kSignWithIdentify(identifier) [NSString get32BitMD5_lowercaseString:[NSString stringWithFormat:@"%@%@%@%@%@",kUUID,identifier,kUid,kToken,kTimeStamp]]

#define kSignIdentifyWithStr(identifier,string) [[NSString stringWithFormat:@"%@%@%@%@%@%@",kUUID,identifier,kUid,kToken,kTimeStamp,string] md5String]
//推送ID
#define kPushId kUUID
//#define kPushId @"ios"//暂用
//登录通道
#define kLoginChannel [kUserDefault objectForKey:@"CoachLoginChannel"]
//用户手机号
#define kPhone [kUserDefault objectForKey:@"CoachPhone"]
//用户真实姓名
#define kRealName [kUserDefault objectForKey:@"CoachRealName"]
//用户昵称
#define kNickName [kUserDefault objectForKey:@"CoachNickName"]
//用户头像
#define kFace [kUserDefault objectForKey:@"CoachFace"]
//用户认证状态
#define kAuthState [kUserDefault objectForKey:@"CoachAuthState"]
//是否登录
#define isLogin [[kUserDefault objectForKey:@"isLogin"] isEqualToNumber:@(YES)]
//是否首次启动APP
#define isFirstLaunch ![[kUserDefault objectForKey:@"isFirstLaunch"] isEqualToNumber:@(YES)]
//清空用户数据
#define clearUserData [kUserDefault setObject:@(NO) forKey:@"isLogin"];\
                      [kUserDefault setObject:@"0"forKey:@"CoachUid"];\
                      [kUserDefault setObject:@"0"forKey:@"CoachToken"];\
                      [kUserDefault setObject:@"0"forKey:@"CoachPhone"];\
                      [kUserDefault setObject:@"0"forKey:@"CoachLoginChannel"];\
                      [kUserDefault setObject:@""forKey:@"CoachNickName"];\
                      [kUserDefault setObject:@""forKey:@"CoachFace"];\
                      [kUserDefault setObject:@""forKey:@"CoachAuthState"];\
                      [kUserDefault setObject:@"" forKey:@"CoachTime"];


//检查是否登录
#define checkLogin(para) \
if (!isLogin) { \
[self showLoginRegisterWithLoginSuccessBlock:^{\
\
}];\
return;\
}\
else\
{\
    para\
}
 

/*******************异常判断/处理*************************/

//空判断相关
#define isEmptyStr(str) (!str||[str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]) //判断是否空字符串
#define isEmptyArr(arr) (!arr||((NSArray *)arr).count==0) //判断是否空数组
#define isNull(str)     (!str||[str isKindOfClass:[NSNull class]])

#define isEqualValue(String_Number,Integer) ([String_Number integerValue]==Integer) //判断参数1与参数2是否相等 适用于NSNumber,NSString类型与整型判断

//基本类型转String/Number
#define integerToStr(para) [NSString stringWithFormat:@"%ld",para]  
#define intToStr(para)     [NSString stringWithFormat:@"%d",para]
#define floatToStr(para)   [NSString stringWithFormat:@"%f",para]
#define doubleToStr(para)  [NSString stringWithFormat:@"%f",para]
#define numToStr(para)     [NSString stringWithFormat:@"%@",para]
#define strToNum(para)     [NSNumber numberWithString:para]

#define kHandleEmptyStr(str) (isEmptyStr(str)?@"":str)  //解决空字符串问题
#define kEmptyStrToZero(str) (isEmptyStr(str)?@"0":str)  //解决空字符串问题

//文件管理相关
#define kFileManager [NSFileManager defaultManager]
#define kDocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory\
                      , NSUserDomainMask, YES)[0]

/*******************城市相关*************************/

//城市相关
#define kCityName      [kUserDefault objectForKey:@"CoachAreaName"]      //城市名 全称
#define kCityID        [kUserDefault objectForKey:@"CoachAreaID"]        //城市ID
#define kCityShortName [kUserDefault objectForKey:@"CoachAreaShortName"] //城市名 简称

#define kAreaVersion   [kUserDefault objectForKey:@"CoachAreaVersion"]   //地区版本号
#define cacheProvinceDataKey @"cacheProvinceDataKey"
#define cacheCityDataKey @"cacheCityDataKey"
#define cacheCountyDataKey @"cacheCountyDataKey"

//开放城市已改为市字典
#define kOpenCityTableName @"OpenCityTable"
#define kOpenCityTableColumnArr @[@"id",@"hot",@"level",@"name",@"parent_id",@"pinyin",@"short_name",@"title"]
#define kCityDict [[SCDBManager shareInstance] getAllObjectsFromTable:kOpenCityTableName KeyArr:kOpenCityTableColumnArr]

//省字典
#define kProvinceTableName @"kProviceTableName"
#define kProvinceTableCollumnArr @[@"id",@"hot",@"level",@"name",@"parent_id",@"pinyin",@"short_name",@"title"]
#define kProvinceDict [[SCDBManager shareInstance] getAllObjectsFromTable:kProvinceTableName KeyArr:kProvinceTableCollumnArr]

//县字典
#define kCountyTableName @"kCountyTableName"
#define kCountyTableCollumnArr @[@"id",@"hot",@"level",@"name",@"parent_id",@"pinyin",@"short_name",@"title"]
#define kCountryDict [[SCDBManager shareInstance] getAllObjectsFromTable:kCountyTableName KeyArr:kCountyTableCollumnArr]

#define kProvinceData [kUserDefault objectForKey:@"addressArray"]

//定位相关
#define kLatitude      [kUserDefault objectForKey:@"CoachUserLocationLatitude"]  //纬度
#define kLongitude     [kUserDefault objectForKey:@"CoachUserLocationLongitude"] //经度
#define kAddress       [NSString stringWithFormat:@"%@,%@",kLongitude,kLatitude]

/*******************接口地址,SSL*************************/

//开发环境
#define HOST_ADDR @"http://192.168.5.216:81/index.php/coach"
#define WAP_HOST_ADDR @"http://192.168.5.216:81/index.php/wap"


//生产环境 HTTPS
//#define HOST_ADDR @"https://www.kangzhuangxueche.com/index.php/coach"
//#define WAP_HOST_ADDR @"https://www.kangzhuangxueche.com/index.php/wap"
#define kAppVersion @"2"

/**
 *  是否开启https SSL 验证
 *
 *  @return YES为开启，NO为关闭
 */
#define openHttpsSSL NO
/**
 *  SSL 证书名称，仅支持cer格式。“app.bishe.com.cer”,则填“app.bishe.com”
 */
#define certificate @"www.kangzhuangxueche.com"

/*******************KEY,APP_ID,APP_SECRET*************************/

#define kJPUSH_APP_KEY     @"5ef22fe53d474279342f4835"
#define kWECHAT_APP_ID     @"wxc7ed3ed6570612ae"  //微信的APP ID
#define kWECHAT_APP_SECRET @"ed99051e553f2755146e6437a9b573c5" //微信的APP Secret
#define kQQ_APP_ID         @"1105631238"
#define kQQ_APP_KEY        @"rA9UHkZA5gjGIKP2"
#define kUMENG_APP_KEY     @"57b6d50967e58e691e0001f1"  //友盟 APP KEY
#define kBMK_AK            @"zdmMHKMolHI1MF9rYQQ671OfnMUcaSmv"
#define kBugTag_KEY        @"af215e31d6e984b9076d0af6dd3f609e"

#define kRequestExceptionPrompt @"请求异常，请稍后重试"

#define kCallPhonePrompt @"拨打电话:"

#define kLastMessageId [kUserDefault objectForKey:@"CoachLastMessageId"]

/*******************通知Key*************************/

#define kCoachUserLoginStateChangedNotificationName    @"kCoachUserLoginStateChangedNotificationName"
#define kMakeMsgIsReadNotification          @"kMakeMsgIsReadNotification"
#define kUpdateMainMsgRedPointNotification  @"kUpdateMainMsgRedPointNotification"
#define kReceiveRemotoNotification          @"kReceiveRemotoNotification"


#define kMaxMessageId @"kMaxMessageId"

#define kBeansShow ([[kUserDefault objectForKey:@"BeansShow"] boolValue])

//#define isUpdateDataBase ([[kUserDefault objectForKey:@"isUpdateDataBase"] boolValue])
#define isStartUpdaeDB ([[kUserDefault objectForKey:@"AreaStartUpdateFlag"] boolValue])

#endif /* Header_h */
