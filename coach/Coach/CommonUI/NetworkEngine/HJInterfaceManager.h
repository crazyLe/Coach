//
//  HJInterfaceManager.h
//  醉了么
//
//  Created by zuweizhong  on 16/6/3.
//  Copyright © 2016年 Hefei JiuYi Network Technology Co.,Ltd. All rights reserved.
//  项目接口文档

#import <Foundation/Foundation.h>

#import "CONST.h"
//#define TESTBASICURL @"http://192.168.5.216/index.php/student"//注释掉就是正式版，打开就是测试版
//#ifndef TESTBASICURL
//#define TESTBASICURL @""
//#endif
//
//#define IPADDRESS @"http://192.168.5.216/"

@interface HJInterfaceManager : NSObject

singletonInterface(HJInterfaceManager)

//@property(nonatomic,strong)NSString * loginUrl; ///登录
//
//@property(nonatomic,strong)NSString * getRegisterCode;
//
//@property(nonatomic,strong)NSString * registerUrl;
//
//@property(nonatomic,strong)NSString * searchSchools; ///找驾校
//
//@property(nonatomic,strong)NSString * mainUrl;
//
//@property(nonatomic,strong)NSString * subjectThird;
//
//@property(nonatomic,strong)NSString * searchCoachs;
//
//@property(nonatomic,strong)NSString * subjectsMainPage;///科目一四
//
//@property(nonatomic,strong)NSString * getAddressUrl;
//
//@property(nonatomic,strong)NSString * partnerTrainUrl;///学时陪练
//
//@property(nonatomic,strong)NSString * examAreaUrl;///科二、科三场地模考
//
//@property(nonatomic,strong)NSString * coachsSerachTagUrl;
//
//@property(nonatomic,strong)NSString * questionsCommentList;
//
//@property(nonatomic,strong)NSString * questionSayUrl;
//
//
//@property(nonatomic,strong)NSString * vouchersList; ///代金券列表
//
//@property(nonatomic,strong)NSString * reveiveVouchers; ///领取代金券
//
//@property(nonatomic,strong)NSString * getMypurseUrl;   //钱袋
//
//@property(nonatomic,strong)NSString * myVoucher; ///我的代金券
//
//@property(nonatomic,strong)NSString * getOrderinfo;    //分期账单还款界面
//
//@property(nonatomic,strong)NSString * submitPersonalInfo; //保存个人设置
//
//@property(nonatomic,strong)NSString * myOrderList; //我的订单,订单列表12121212121212121212121212
//
//@property(nonatomic,strong)NSString * getErrorRate;
//
//@property(nonatomic,strong)NSString * realNameState; ///实名认证状态
//
//@property(nonatomic,strong)NSString * synchronousScoreUrl;
//
//@property(nonatomic,strong)NSString * memberInfo; ///个人信息
//
//@property(nonatomic,strong)NSString * getRepayment;
//
//@property(nonatomic,strong)NSString * communityCreateUrl;
//
////我的教练
//@property(nonatomic,strong)NSString *myCoach;
////检索我的教练列表
//@property(nonatomic,strong)NSString *mineCoach;
////绑定教练
//@property(nonatomic,strong)NSString *bindingCoach;
////解除绑定教练
////@property(nonatomic,strong)NSString *bindingCoach;
//@property(nonatomic,strong)NSString * getValidationAmount;
//
//@property(nonatomic,strong)NSString * getEditPassword;
//
//@property (nonatomic, strong) NSString * getSendCode;   //获取验证码
//
//@property (nonatomic, strong) NSString * getEditPhone;
//
//@property (nonatomic, strong) NSString * getFend;
//
//@property (nonatomic, strong) NSString * getMemberInfo;
//
@property (nonatomic, strong) NSString * getCommunity;
//
//@property (nonatomic, strong) NSString * getDelorder;


@property(nonatomic,strong)NSString * memberCommunityList;

@property(nonatomic,strong)NSString * createCommunity;

@property(nonatomic,strong)NSString * communitySubmitPics;


@property (nonatomic, strong) NSString * userPics; //上传用户头像

@property (nonatomic, strong) NSString * getOrderdetails;

@property(nonatomic,strong)NSString * memberCommunity;

@property(nonatomic,strong)NSString * circleDetailUrl;

@property(nonatomic,strong)NSString * memberRecharge;

@property(nonatomic,strong)NSString * checkVersion;

@end
