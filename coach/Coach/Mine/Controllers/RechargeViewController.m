//
//  RechargeViewController.m
//  Coach
//
//  Created by apple on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "WithdrawRecordController.h"
#import "UPPaymentControl.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LLWithdrawDesCell.h"
#import "LLRechargeCell.h"
#import "RechargeViewController.h"

@interface RechargeViewController () <UIActionSheetDelegate>

@end

@implementation RechargeViewController
{
    NSString *rechargeMoneyStr;
    
    NSString *earnBeansStr;
    
//    NSDictionary *proportionInfoDic;
    NSDictionary * _proportionDic;
    
    NSString *_tnMode;
}

- (id)init
{
    if (self = [super init]) {
#warning  银联支付模式 上线后要改为00
        _tnMode = @"00";  // "00" 表示线上环境"01"表示测试环境
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self setNavigation];
    [self setUI];
//    [self getProportionRequest];
    [self getCashCasebeforeRequest];
}

#pragma mark - Setup

- (void)setNavigation
{
    [self setTitleText: @"充值" textColor:nil];
    [self setLeftText:nil textColor:nil ImgPath:@"Navigation_Return"];
    [self setRightText:@"充值记录" textColor:nil ImgPath:nil];
//    [self setRightText:nil textColor:nil ImgPath:@"Navigation_Add"];
}

- (void)setUI
{
    [self setBg_TableView];
}

- (void)setBg_TableView
{
    [self setBg_TableViewWithConstraints:nil];
    [self registerClassWithClassNameArr:@[@"LLRechargeCell",@"LLWithdrawDesCell"] cellIdentifier:nil];
}

#pragma mark - UITableViewDelegate && UITableViewDateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 400*kHeightScale;
    }
    else
    {
        return 165*kHeightScale;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        LLRechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLRechargeCell"];
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        cell.bgImgView.image = [UIImage imageNamed:@"iconfont-rechargebg"];
        NSMutableAttributedString *remainAttStr = [NSMutableAttributedString attributeStringWithText:@"赚豆余额" attributes:@[[UIColor whiteColor],[UIFont boldSystemFontOfSize:25*kWidthScale]]];
        [remainAttStr appendBreakLineWithInterval:0.01f];
        [remainAttStr appendText:_proportionDic[@"beans"] withAttributesArr:@[[UIColor colorWithHexString:@"ffffff" alpha:0.8f],[UIFont boldSystemFontOfSize:35*kWidthScale]]];
        cell.beansRemainLbl.attributedText = remainAttStr;
        NSMutableAttributedString *desAttStr = [NSMutableAttributedString attributeStringWithText:@"充值赚豆" attributes:@[[UIColor colorWithHexString:@"4c4c4c"],[UIFont boldSystemFontOfSize:14*kWidthScale]]];
        NSString * str = nil;
        if (isEmptyStr(_proportionDic[@"proportion"])) {
            str = @"10";
        }else{
            str = [NSString stringWithFormat:@"%ld",(long)(1/[_proportionDic[@"proportion"] floatValue])];
        }
        [desAttStr appendText:[NSString stringWithFormat:@" (1元=%@赚豆)",str] withAttributesArr:@[[UIColor colorWithRed:40/255.0 green:120/255.0 blue:255/255.0 alpha:1],kFont14]];
        cell.desLbl.attributedText = desAttStr;
        cell.amountInputView.titleLbl.text = @"金额";
        cell.amountInputView.unitLbl.text = @"元";
        cell.rechargeBeansNumView.titleLbl.text = @"赚豆";
        cell.rechargeBeansNumView.unitLbl.text = @"赚豆";
        [cell.rechargeBtn setTitle:@"充值0.00元" forState:UIControlStateNormal];
        cell.rechargeBeansNumView.textField.userInteractionEnabled = NO;
//        cell.rechargeBeansNumView.textField.text = @"0";
        cell.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
        //    cell.bgView.layer.shadowOffset = CGSizeMake(-3, 3);
        cell.bgView.layer.shadowOpacity = 0.3;
        
//        cell.amountInputView.textField.text = @"0";
//        cell.amountInputView.accessoryBtn.hidden = NO;
        cell.amountInputView.textField.keyboardType = UIKeyboardTypeDecimalPad;
        return cell;
    }
    else
    {
        LLWithdrawDesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLWithdrawDesCell"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.titleLbl.text = @"充值说明：";
        
        NSString *contentStr1 = _proportionDic[@"intro"];
//        NSString *contentStr1 = @"• 充值比例：";
////        NSString *contentStr2 = @"1元=10赚豆";
//        NSString *contentStr2 = [NSString stringWithFormat:@"1元=%ld赚豆",(NSInteger)(1/[_proportionDic[@"proportion"] floatValue])];
//        NSString *contentStr3 = @"；\n• 只能充值整数金额；\n• 充值成功后若赚豆未到账请联系客服\n   TEL:400-000-000；";
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:10.0f*kHeightScale];
        
        NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithText:contentStr1 attributes:@[@{NSParagraphStyleAttributeName:style},[UIColor colorWithHexString:@"c8c8c8"],kFont14]];
//        [attStr appendText:contentStr2 withAttributesArr:@[@{NSParagraphStyleAttributeName:style},[UIColor colorWithHexString:@"c8c8c8"],[UIFont boldSystemFontOfSize:14*kWidthScale]]];
//        [attStr appendText:contentStr3 withAttributesArr:@[@{NSParagraphStyleAttributeName:style},[UIColor colorWithHexString:@"c8c8c8"],kFont14]];
        
        cell.contentLbl.attributedText = attStr;
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - LLRechargeCellDelegate
- (void)LLRechargeCell:(LLRechargeCell *)cell moneyTextFieldDidChanged:(UITextField *)textField;
{
    //限制最大输入6位数
    
    int maxLength = 7;
    if (textField.text.length>maxLength) {
        textField.text = [textField.text substringToIndex:maxLength];
    }
    
    rechargeMoneyStr = textField.text;
    cell.rechargeBeansNumView.textField.text = [NSString stringWithFormat:@"%.0f",([rechargeMoneyStr doubleValue]/[_proportionDic[@"proportion"] doubleValue])];
    [cell.rechargeBtn setTitle:[NSString stringWithFormat:@"充值%.1f元",[rechargeMoneyStr doubleValue]] forState:UIControlStateNormal];

    earnBeansStr = cell.rechargeBeansNumView.textField.text;
}

//- (void)LLRechargeCell:(LLRechargeCell *)cell earnBeansTextFieldDidChanged:(UITextField *)textField;
//{
//    earnBeansStr = textField.text;
//}

- (void)LLRechargeCell:(LLRechargeCell *)cell clickRechargeBtn:(UIButton *)rechargeBtn;
{
    if (isEmptyStr(rechargeMoneyStr)) {
        [LLUtils showErrorHudWithStatus:@"请输入充值金额"];
        return;
    }
    else if (isEmptyStr(earnBeansStr))
    {
        return;
    }
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信",@"银联", nil];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex==>%ld",buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            //支付宝
            
        }
            break;
        case 1:
        {
            //微信
            
        }
            break;
        case 2:
        {
            //银联
            
        }
            break;
            
        default:
            break;
    }
//    if (buttonIndex < 3) {
//        NSArray *payWayArr = @[@"1",@"3",@"2"];
//        [self rechargeRequestWithPayWay:payWayArr[buttonIndex]];
//    }
    if (buttonIndex < 2) {
        NSArray *payWayArr = @[@"1",@"3"];
        [self rechargeRequestWithPayWay:payWayArr[buttonIndex]];
    }
}

- (void)clickRightBtn:(UIButton *)rightBtn
{
    WithdrawRecordController *vc = [[WithdrawRecordController alloc]init];
    vc.type = WithdrawRecordControllerTypeRecharge;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Network

//获取赚豆比例 以及 赚豆余额
//- (void)getProportionRequest
//{
//    [NetworkEngine sendAsynPostRequestRelativeAdd:@"/getProportion" paraNameArr:@[@"uid",@"time",@"deviceInfo",@"sign"] paraValueArr:@[kUid,kTimeStamp,kDeviceInfo,kSignWithIdentify(@"/getProportion")] completeBlock:^(BOOL isSuccess, id jsonObj) {
//        if (isSuccess) {
//            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
//                //请求成功
//                proportionInfoDic = jsonObj[@"info"][@"proportionInfo"];
//                [self updateUI];
//            }
//            else if([jsonObj[@"code"] isEqualToNumber:@(2)])
//            {
//                //需要登录
//                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
//            }
//            else
//            {
//                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
//            }
//        }
//    }];
//}

- (void)getCashCasebeforeRequest
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = kTimeStamp;
    param[@"sign"] = kSignWithIdentify(@"/getCash/casebefore");
    param[@"type"] = @"0";
    
    [NetworkEngine postRequestWithRelativeAdd:@"/getCash/casebefore" paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                NSString * jstr = [LLUtils jsonStrWithJSONObject:jsonObj];
                NSString * str = [LLUtils replaceUnicode:jstr];
                NSLog(@"%@",str);
//                bankListArr = jsonObj[@"info"][@"Banks"];
                _proportionDic = jsonObj[@"info"];
                [self.bg_TableView reloadData];
            }
            else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                //需要登录
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
            else
            {
                //失败
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
        }
    }];
}

//充值赚豆请求
- (void)rechargeRequestWithPayWay:(NSString *)payWay
{
    if ([payWay isEqualToString:@"3"]) {
        //微信支付
        if (![WXApi isWXAppInstalled]) {
            NSLog(@"没有安装微信");
            [LLUtils showErrorHudWithStatus:@"没有安装微信,请换其他支付方式"];
            return;
        }
        else if(![WXApi isWXAppSupportApi])
        {
            NSLog(@"当前版本微信不支持微信支付");
            [LLUtils showErrorHudWithStatus:@"当前版本微信不支持微信支付,请换其他支付方式"];
            return;
        }
    }
    
    [LLUtils showTextAndProgressHud:@"请求中..."];
    [NetworkEngine sendAsynPostRequestRelativeAdd:@"/topUpBeans" paraNameArr:@[@"uid",@"time",@"totalMoney",@"sign",@"totalBeans",@"payType"] paraValueArr:@[kUid,kTimeStamp,rechargeMoneyStr,kSignWithIdentify(@"/topUpBeans"),earnBeansStr,payWay] completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                [LLUtils dismiss];
                //请求成功
//                [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
//                [self getProportionRequest];
                int payWayInt = [payWay intValue];
                if (payWayInt == 1) {
                    //支付宝
                    NSString *orderString = jsonObj[@"info"][@"content"];
                    NSString *appScheme = @"alipaysskzjiaolian";
                    if (!isEmptyStr(orderString) && !isEmptyStr(appScheme)) {
                        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                            //【callback处理支付结果】
                            NSLog(@"reslut = %@",resultDic);
                            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                                //交易成功
                                NSLog(@"支付宝交易成功");
                                [LLUtils showSuccessHudWithStatus:@"充值成功"];
//                                [self getProportionRequest];
                                [self getCashCasebeforeRequest];
                            }
                            else if([resultDic[@"resultStatus"] isEqualToString:@"6001"])
                            {
                                //用户取消
                                NSLog(@"用户主动取消支付");
                            }else
                            {
                                
                            }
                        }];
                    }
                }
                else if (payWayInt == 2)
                {
                    //银联
                    //当获得的tn不为空时，调用支付接口
                    
                    NSString *tn = jsonObj[@"info"][@"content"];
                    
                    if (tn != nil && tn.length > 0)
                    {
                        [[UPPaymentControl defaultControl]
                         startPay:tn
                         fromScheme:@"unionpaysskzjiaolian"
                         mode:_tnMode
                         viewController:self]; 
                    }
                }
                else if(payWayInt == 3)
                {
                    //微信
                    NSString *encodeRetStr = jsonObj[@"info"][@"content"];
                    NSData *decodeData = [[NSData alloc] initWithBase64EncodedString:encodeRetStr options:0];
//                    NSString *decodeStr = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
                    NSDictionary *decodeDic = [NSJSONSerialization JSONObjectWithData:decodeData options:NSJSONReadingMutableContainers error:nil];
                    
                    NSLog(@"===>%@",decodeDic);
                    PayReq *payReq = [[PayReq alloc] init];
                    payReq.partnerId           = [decodeDic objectForKey:@"partnerId"];
                    payReq.prepayId            = [decodeDic objectForKey:@"prepayId"];
                    payReq.nonceStr            = [decodeDic objectForKey:@"nonceStr"];
                    payReq.timeStamp           = [[decodeDic objectForKey:@"timeStamp"] unsignedIntValue];
                    payReq.package             = [decodeDic objectForKey:@"packageValue"];
                    payReq.sign                = [decodeDic objectForKey:@"sign"];
                    [WXApi sendReq:payReq];
                }
            }
            else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                //需要登录
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
            else
            {
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
        }
        else
        {
            [LLUtils showErrorHudWithStatus:@"请求异常，请稍后重试"];
        }
    }];
}



#pragma mark - udateUI

- (void)updateUI
{
    [self.bg_TableView reloadData];
}

@end
