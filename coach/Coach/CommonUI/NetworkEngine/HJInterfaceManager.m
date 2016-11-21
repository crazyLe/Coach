//
//  HJInterfaceManager.m
//  醉了么
//
//  Created by zuweizhong  on 16/6/3.
//  Copyright © 2016年 Hefei JiuYi Network Technology Co.,Ltd. All rights reserved.
//

#import "HJInterfaceManager.h"

@implementation HJInterfaceManager

singletonImplementation(HJInterfaceManager)


//-(NSString *)loginUrl
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/user/login"];
//    
//}
//
//-(NSString *)getRegisterCode
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/user/getVerificationCode"];
//
//}
//-(NSString *)registerUrl
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/user/register"];
//}
//-(NSString *)searchSchools {
//    
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/Search/SearchSchools"];
//    
//}
//-(NSString *)mainUrl
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/main/index"];
//}
//
//-(NSString *)subjectThird
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/subjectThird"];
//
//}
//-(NSString *)searchCoachs
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/Search/SearchCoachs"];
//}
//-(NSString *)subjectsMainPage
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/subjectsMainPage"];
//}
//
//-(NSString *)partnerTrainUrl{
//    
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/search/Teachings"];
//    
//}
//-(NSString *)examAreaUrl {
//    
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/examinationRoomList"];
//}
//
//-(NSString *)coachsSerachTagUrl
//{
//
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/search/CoachsSerachTag"];
//
//}
//-(NSString *)getAddressUrl
//{
//    
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/getAddress"];
//    
//}
//
//-(NSString *)questionsCommentList
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/questions/commentList"];
//}
//-(NSString *)questionSayUrl
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/questions/questionSay"];
//    
//}
//-(NSString *)vouchersList
//{
//    
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/coupon/index"];
//    
//}
//-(NSString *)myVoucher
//{
//    
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/coupon/Mycoupon"];
//    
//}
//-(NSString *)reveiveVouchers
//{
//    
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/coupon/ReceiveVouchers"];
//    
//}
////钱袋接口
//-(NSString *)getMypurseUrl
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/Mypurse/Purse"];
//}
////分期账单还款界面
//- (NSString *)getOrderinfo
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/Orderinfo/reimbursement"];
//}
////分期还款记录
//- (NSString *)getRepayment
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/Orderinfo/repayment"];
//}
//
//- (NSString *)submitPersonalInfo
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/personalInformation"];
//}
//- (NSString *)myOrderList
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/Orderinfo/orderList"];
//}
//- (NSString *)realNameState
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/userAuth"];
//}
//- (NSString *)memberInfo
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/member/info"];
//}
//
//-(NSString *)getErrorRate
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/errorRate"];
//}
//-(NSString *)synchronousScoreUrl
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/questions/synchronousScore"];
//}
//
////向服务器验证支付金额
//- (NSString *)getValidationAmount
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/Orderinfo/validationAmount"];
//}
-(NSString *)communityCreateUrl
{
    return [NSString stringWithFormat:@"%@%@",HOST_ADDR,@"/community/create"];

}
////修改密码
//- (NSString *)getEditPassword
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/editPassword"];
//}
////我的教练
//- (NSString *)myCoach
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/myCoach"];
//}
////检索教练
//- (NSString *)mineCoach
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/mineCoach"];
//}
////绑定教练
//- (NSString *)bindingCoach
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/bindingCoach"];
//}
//
////获取验证码
//- (NSString *)getSendCode
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/user/sendCode"];
//}
//
////修改手机
//- (NSString *)getEditPhone
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/editPhone"];
//}
//
//// 驾考维权
//- (NSString *)getFend
//{
//    return [NSString stringWithFormat:@"%@%@",TESTBASICURL,@"/fend"];
//}

//
- (NSString *)getMemberInfo
{
    return [NSString stringWithFormat:@"%@%@",HOST_ADDR,@"/member/info"];
}

//平台圈
- (NSString *)getCommunity
{
    return [NSString stringWithFormat:@"%@%@",HOST_ADDR,@"/community"];
}

//订单删除
- (NSString *)getDelorder
{
    return [NSString stringWithFormat:@"%@%@",HOST_ADDR,@"/Orderinfo/delorder"];
}

- (NSString *)memberCommunityList
{
    return [NSString stringWithFormat:@"%@%@",HOST_ADDR,@"/member/communitylist"];
}

- (NSString *)userPics {
    
    return [NSString stringWithFormat:@"%@%@",HOST_ADDR,@"/userPics"];
}


-(NSString *)createCommunity
{
    return [NSString stringWithFormat:@"%@%@",HOST_ADDR,@"/community/create"];

}

-(NSString *)communitySubmitPics
{
    return [NSString stringWithFormat:@"%@%@",HOST_ADDR,@"/community/submitPics"];
    
}

//订单详情
- (NSString *)getOrderdetails
{
    return [NSString stringWithFormat:@"%@%@",HOST_ADDR,@"/Orderinfo/Orderdetails"];
}

-(NSString *)memberCommunity
{
    return [NSString stringWithFormat:@"%@%@",HOST_ADDR,@"/member/community"];
}

-(NSString *)circleDetailUrl
{
    return [NSString stringWithFormat:@"%@%@",WAP_HOST_ADDR,@"/community/show"];
    
}

-(NSString *)memberRecharge
{
    return [NSString stringWithFormat:@"%@%@",HOST_ADDR,@"/member/recharge"];
}

-(NSString *)checkVersion
{
    return [NSString stringWithFormat:@"%@%@",HOST_ADDR,@"/checkVersion"];
    
}


@end
