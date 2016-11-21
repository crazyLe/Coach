//
//  WithdrawViewController.m
//  学员端
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "MMPickerView.h"
#import "LLWithdrawDesCell.h"
#import "LLLeftLblRightTFCell.h"
#import "LLWithdrawAmountCell.h"
#import "LLEarnBeansRemainCell.h"
#import "WithdrawViewController.h"
#import "WithdrawRecordController.h"

@interface WithdrawViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation WithdrawViewController
{
    NSArray *registerCellArr;
    
    NSArray *bankListArr;
    NSMutableArray *rightTextArr;
//    NSDictionary * proportionInfoDic;
    NSDictionary * _proportionDic;
}

- (id)init
{
    if (self = [super init]) {
        registerCellArr = @[@"LLEarnBeansRemainCell",@"LLWithdrawAmountCell",@"LLWithdrawDesCell"];
        rightTextArr = [@[@"",@"",@"",@""] mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self setNavigation];
    [self setUI];
//    [self getBankListRequest];
//    [self getProportionRequest];
    [self getCashCasebeforeRequest];
}

#pragma mark - Setup

- (void)setNavigation
{
    [self setTitleText: @"提现" textColor:nil];
    [self setLeftText:nil textColor:nil ImgPath:@"Navigation_Return"];
    [self setRightText:@"提现记录" textColor:nil ImgPath:nil];
//    [self setRightText:nil textColor:nil ImgPath:@"Navigation_Add"];
}

- (void)setUI
{
    [self setTableView];
}

- (void)setTableView
{
    [self setBg_TableViewWithConstraints:nil];
    [self registerClassWithClassNameArr:registerCellArr cellIdentifier:nil];
    [self setSeparatorInsetZeroWithTableView:self.bg_TableView];
    self.bg_TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.bg_TableView.separatorColor = kLineColor;
}

#pragma mark - UITableViewDelegate && UITableViewDateSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section==0?15.0f:0.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [@[@(2),@(4),@(1),@(1)][section] longValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [@[@[@(52),@(52)],@[@(52),@(52),@(52),@(52)],@[@(74*kHeightScale)],@[@(250*kHeightScale)]][indexPath.section][indexPath.row] floatValue];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            LLEarnBeansRemainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLEarnBeansRemainCell"];
            cell.leftLbl.text = indexPath.row==0?@"赚豆余额：":@"可提现金额：";
            cell.rightLbl.attributedText = [NSMutableAttributedString attributeStringWithText:indexPath.row==0?[NSString stringWithFormat:@"%@",isNull(_proportionDic[@"beans"])?@"":_proportionDic[@"beans"]]:[NSString stringWithFormat:@"%.2f元",(float)([_proportionDic[@"beans"] longValue]*[_proportionDic[@"proportion"] floatValue])] attributes:@[[UIColor colorWithHexString: indexPath.row==0?@"2f82ff":@"4c4c4c"],[UIFont boldSystemFontOfSize:indexPath.row==0?18:15]]];
            return cell;
        }
            break;
        case 1:
        {
            LLWithdrawAmountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLWithdrawAmountCell"];
            cell.indexPath = indexPath;
            cell.delegate = self;
            NSArray *leftLblTextArr = @[@"提现金额：",@"提现银行：",@"银行卡号：",@"账户名："];
            NSArray *rightTFPlaceHolderArr = @[@"请输入提现金额",@"",@"请输入银行卡号",@"请输入本人绑定银行卡姓名"];
            cell.leftLbl.text = leftLblTextArr[indexPath.row];
            cell.textField.text = rightTextArr[indexPath.row];
            cell.textField.placeholder = rightTFPlaceHolderArr[indexPath.row];
            if (indexPath.row==1) {
                cell.textField.userInteractionEnabled = NO;
                cell.accessoryImgView.hidden = NO;
                cell.accessoryImgView.image = [UIImage imageNamed:@"iconfont-meselect"];
                [cell.textField mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(-(10*kWidthScale+30));
                }];
                
            }
            else
            {
                cell.textField.userInteractionEnabled = YES;
                cell.accessoryImgView.hidden = YES;
                [cell.textField mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(-15*kWidthScale);
                }];
            }
            if (indexPath.row==0||indexPath.row==2) {
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            }
            else if(indexPath.row==3)
            {
                cell.textField.keyboardType = UIKeyboardTypeDefault;
            }
            return cell;
        }
            break;
        case 2:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.backgroundColor = [UIColor clearColor];
            UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cell.contentView addSubview:exitBtn];
            [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(15*kHeightScale, 22*kHeightScale, 15*kHeightScale, 22*kHeightScale));
            }];
            exitBtn.backgroundColor = [UIColor colorWithHexString:@"2e83ff"];
            exitBtn.layer.masksToBounds = YES;
            exitBtn.layer.cornerRadius = 5.0f;
            [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [exitBtn setTitle:@"申请提现" forState:UIControlStateNormal];
            exitBtn.titleLabel.font = kFont18;
            [exitBtn addTarget:self action:@selector(clickWithdrawBtn:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
            break;
        case 3:
        {
            LLWithdrawDesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLWithdrawDesCell"];
            cell.backgroundColor = [UIColor whiteColor];
            cell.titleLbl.text = @"提现说明：";
            
//            NSString *contentStr1 = @"• 提现比例：";
//            NSString *contentStr2 = nil;
//            if (!isEmptyStr(_proportionDic[@"proportion"])) {
//               contentStr2 = [NSString stringWithFormat:@"1元=%ld赚豆",(NSInteger)(1/[_proportionDic[@"proportion"] floatValue])];
//            }
//            else
//            {
//                contentStr2 = @"1元=10赚豆";
//            }
            
//            NSString *contentStr3 = @"；\n• 提现最低标准1000赚豆,即100元；\n• 提现赚豆必须为1000的整数倍；\n• 提现申请提交后一般12小时内到账，遇节假日顺延\n• 提现暂不收取任何手续费；\n• 提现超过48小时未到账时，请联系客服。";
            NSString * contentStr3 = _proportionDic[@"intro"];
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            [style setLineSpacing:10.0f*kHeightScale];
            
            NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithText:contentStr3 attributes:@[@{NSParagraphStyleAttributeName:style},[UIColor colorWithHexString:@"c8c8c8"],kFont14]];
//            [attStr appendText:contentStr2 withAttributesArr:@[@{NSParagraphStyleAttributeName:style},[UIColor colorWithHexString:@"c8c8c8"],[UIFont boldSystemFontOfSize:14*kWidthScale]]];
//            [attStr appendText:contentStr3 withAttributesArr:@[@{NSParagraphStyleAttributeName:style},[UIColor colorWithHexString:@"c8c8c8"],kFont14]];
            
            cell.contentLbl.attributedText = attStr;
            return cell;
        }
            break;
            
        default:
            break;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 1)&&(indexPath.row==1)) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in bankListArr) {
            [arr addObject:dic[@"name"]];
        }
        if (arr.count==0) {
            return;
        }
        LLWithdrawAmountCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [MMPickerView showPickerViewInView:self.view
                               withStrings:arr
                               withOptions:@{MMbackgroundColor: [UIColor whiteColor],
                                             MMtextColor: [UIColor blackColor],
                                             MMtoolbarColor: [UIColor whiteColor],
                                             MMbuttonColor: [UIColor blueColor],
                                             MMfont: [UIFont systemFontOfSize:18],
                                             MMvalueY: @3,
                                             MMselectedObject:isEmptyStr(cell.textField.text)?arr[0]:cell.textField.text,
                                             }
                                completion:^(NSString *selectedString) {
//                                    NSLog(@"selectStr==>%@",selectedString);
                                    rightTextArr[indexPath.row] = selectedString;
                                    cell.textField.text = selectedString;
                                }];
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)clickNavLeftBtn:(UIButton *)leftBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightBtn:(UIButton *)rightBtn
{
    WithdrawRecordController *vc = [[WithdrawRecordController alloc]init];
    vc.type = WithdrawRecordControllerTypeWithdraw;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark  - LLWithdrawAmountCellDelegate

- (void)LLWithdrawAmountCell:(LLWithdrawAmountCell *)cell textFieldDidChange:(UITextField *)textField;
{
    if (rightTextArr.count>cell.indexPath.row) {
        rightTextArr[cell.indexPath.row] = textField.text;
    }
}

- (void)clickWithdrawBtn:(UIButton *)withdrawBtn
{
    [self withdrawRequest];
}

#pragma mark Network

- (void)getCashCasebeforeRequest
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = kTimeStamp;
    param[@"sign"] = kSignWithIdentify(@"/getCash/casebefore");
    param[@"type"] = @"1";
    
    [NetworkEngine postRequestWithRelativeAdd:@"/getCash/casebefore" paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                NSString * jstr = [LLUtils jsonStrWithJSONObject:jsonObj];
                NSString * str = [LLUtils replaceUnicode:jstr];
                NSLog(@"%@",str);
                bankListArr = jsonObj[@"info"][@"Banks"];
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

////获取银行列表
//- (void)getBankListRequest
//{
//    [NetworkEngine postRequestWithRelativeAdd:@"/bank" paraDic:@{@"uid":kUid,@"time":kTimeStamp,@"deviceInfo":kDeviceInfo,@"sign":kSignWithIdentify(@"/bank")} completeBlock:^(BOOL isSuccess, id jsonObj) {
//        if (isSuccess) {
//            if (isEqualValue(jsonObj[@"code"], 1)) {
//                //成功
//                bankListArr = jsonObj[@"info"][@"Banks"];
//            }
//            else
//            {
//                
//            }
//        }
//        else
//        {
//            
//        }
//    }];
//}

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

//提现
- (void)withdrawRequest
{
//    if ([proportionInfoDic[@"balanceBeans"] longValue]<=0) {
//        [LLUtils showErrorHudWithStatus:@"余额不足，无法提现"];
//        return;
//    }
    
    WeakObj(self)
    
    NSArray *promptArr = @[@"请输入提现金额"
                          ,@"请选择提现银行"
                          ,@"请输入银行卡号"
                          ,@"请输入本人绑定银行卡姓名"
                           ];
    for (int i = 0; i < rightTextArr.count; i++) {
        if (isEmptyStr(rightTextArr[i])) {
            [LLUtils showErrorHudWithStatus:promptArr[i]];
            return;
        }
    }
    
    //设置bankId
    NSString *bankId = @"";
    for (NSDictionary *bankDic in bankListArr) {
        if ([bankDic[@"name"] isEqualToString:rightTextArr[1]]) {
            bankId = bankDic[@"id"];
            break;
        }
    }
    
    NSMutableDictionary * paraDic = [@{@"uid":kUid,@"time":kTimeStamp,@"sign":kSignWithIdentify(@"/getCash"),@"bankId":bankId} mutableCopy];
    NSArray *paraNameArr = @[@"totalBeans",@"bankAccount",@"bankCard",@"bankTrueName"];
    for (int i = 0; i < rightTextArr.count; i++) {
        [paraDic setObject:rightTextArr[i] forKey:paraNameArr[i]];
    }
    [NetworkEngine postRequestWithRelativeAdd:@"/getCash" paraDic:paraDic completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if (isEqualValue(jsonObj[@"code"], 1)) {
                //成功
                [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [selfWeak clickRightBtn:nil];
                });
            }
            else
            {
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
        }
        else
        {
            
        }
    }];
}

- (void)updateUI
{
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndex:0];
    [indexSet addIndex:3];
    [self.bg_TableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

@end
