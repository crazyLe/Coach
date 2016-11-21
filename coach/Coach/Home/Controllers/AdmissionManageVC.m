//
//  AdmissionManageVC.m
//  Coach
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "RechargeViewController.h"
#import "LLAdmissionAlertView.h"
#import "LLPopoverView.h"
#import "AdmissionManageCell.h"
#import "ShowColNameCell.h"
#import "AdmissionManageVC.h"

@interface AdmissionManageVC ()

@end

@implementation AdmissionManageVC
{
    NSArray *popoverViewTitleArr;
    
    NSDictionary *proportionInfoDic;
    
    LLAdmissionAlertView *admissionAlertView;
}

- (id)init
{
    if (self = [super init]) {
        popoverViewTitleArr = @[@"奖励",@"移除"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self setNav];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getProportionRequest]; //获取赚豆余额
}

- (void)setNav
{
    [self setTitleText:@"招生团管理" textColor:nil];
    [self setLeftText:nil textColor:nil ImgPath:@"Navigation_Return"];
//    [self setRightText:nil textColor:nil ImgPath:@"Navigation_Add"];
}

- (void)setUI
{
    ShowColNameCell *cell = [[ShowColNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShowColNameCell"];
    [self.view addSubview:cell];
    cell.backgroundColor = [UIColor whiteColor];
    [cell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(kTopBarTotalHeight);
        make.height.offset(60);
    }];
    cell.nameLbl.text = @"学员";
    cell.statusLbl.text = @"状态";
    cell.totolNumLbl.text = @"累计招生";
    cell.setLbl.text = @"设置";
    
    [self setBg_TableViewWithConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.top.offset(kTopBarTotalHeight+60);
    }];
    [self registerClassWithClassNameArr:@[@"AdmissionManageCell"]  cellIdentifier:nil];
    
    NSString *relativeAdd = @"/recruit/retrieve";
    NSDictionary *paraDic = @{@"uid":kUid,@"typeId":@"2",@"time":kTimeStamp,@"sign":kSignWithIdentify(relativeAdd)};
    [self setNetworkRelativeAdd:relativeAdd paraDic:paraDic pageFiledName:@"pageId" parseDicKeyArr:@[@"info",@"recruit"]];
    [self.bg_TableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdmissionManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdmissionManageCell"];
    cell.delegate = self;
    cell.indexPath = indexPath;
    NSDictionary *dic = self.contentArr[indexPath.row];
    [cell.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:kHandleEmptyStr(dic[@"face"])]  forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"iconfont-defaultheadimage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            [cell.headBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-defaultheadimage"] forState:UIControlStateNormal];
        }
    }];
    cell.nameLbl.text = dic[@"userName"];
    NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithImg:[UIImage imageNamed:@"InviteStudent_Stage"] bounds:CGRectMake(0, -3, 15, 15)];
    
    NSString *subjectStr = nil;
    switch ([dic[@"subject"] intValue]) {
        case 1:
        {
            subjectStr = @" 科目一";
        }
            break;
        case 2:
        {
            subjectStr = @" 科目二";
        }
            break;
        case 3:
        {
            subjectStr = @" 科目三";
        }
            break;
        case 4:
        {
            subjectStr = @" 科目四";
        }
            break;
            
        default:
            subjectStr = @"科目一";
            break;
    }
    [attStr appendText:subjectStr withAttributesArr:@[[UIColor colorWithHexString:@"c8c8c8"],kFont12]];
    cell.statusLbl.attributedText = attStr;
    cell.totolNumLbl.text = [NSString stringWithFormat:@"%@人",dic[@"peopleNum"]];
    [cell.phoneBtn setImage:[UIImage imageNamed:@"InviteStudent_Phone"] forState:UIControlStateNormal];
    [cell.setBtn setImage:[UIImage imageNamed:@"AdmissionManage_Set"] forState:UIControlStateNormal];
    if (indexPath.row==[tableView numberOfRowsInSection:indexPath.section]-1) {
        cell.lineView.backgroundColor = kLineGrayColor;
    }
    else
    {
        cell.lineView.backgroundColor = kLineWhiteColor;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - AdmissionManageCellDelegate

- (void)AdmissionManageCell:(AdmissionManageCell *)cell clickHeadBtn:(UIButton *)headBtn
{
    
}

- (void)AdmissionManageCell:(AdmissionManageCell *)cell clickPhoneBtn:(UIButton *)phoneBtn
{
    NSDictionary *dic = self.contentArr[cell.indexPath.row];
    [LLUtils callPhoneWithPhone:kHandleEmptyStr(dic[@"phone"])];
}

- (void)AdmissionManageCell:(AdmissionManageCell *)cell clickSetBtn:(UIButton *)setBtn
{
    CGFloat popViewWidth = 85.0f;
    CGRect originRect = CGRectMake(setBtn.frame.origin.x+setBtn.frame.size.width-popViewWidth
                        , setBtn.frame.origin.y+setBtn.frame.size.height-15.0f, popViewWidth, 85);
    CGRect targetRect = [cell.contentView convertRect:originRect toView:self.view];
    
    [LLPopoverView showAtRect:targetRect inView:self.view withItemArr:@[@"奖励",@"移除"] delegate:self object:cell];
}

#pragma mark - LLPopoverViewDelegate

- (void)LLPopoverView:(LLPopoverView *)view didSelectItemAtIndex:(NSInteger)index;
{
    NSLog(@"index==%ld",index);
    if (index==0) {
        //奖励
        AdmissionManageCell *cell = view.object;
        
        NSMutableAttributedString *beansRemainAtt = [NSMutableAttributedString attributeStringWithText:@"赚豆余额:  " attributes:@[kAppThemeColor,kFont13]];
        [beansRemainAtt appendText:proportionInfoDic[@"balanceBeans"] withAttributesArr:@[kGrayHex99,kFont13]];
        admissionAlertView = [LLAdmissionAlertView showWithTitle:[NSString stringWithFormat:@"给%@的招生奖励",cell.nameLbl.text] textFieldPlaceHolder:@"请输入奖励豆子数" confirmBtnTitle:nil rechargeBtnTitle:nil beansUnit:nil beansRemain:beansRemainAtt object:cell.indexPath userInfo:nil delegate:self];
    }
    else
    {
        //移除
        AdmissionManageCell *cell = view.object;
        
        NSDictionary *dic = self.contentArr[cell.indexPath.row];
        [self deleteRequestWithPhone:dic[@"phone"] withIndexPath:cell.indexPath];
    }
}

- (void)popoverViewDidDismiss:(LLPopoverView *)view;
{
    NSLog(@"popoverViewDidDismiss");
}

#pragma mark - LLAdmissionAlertViewDelegate

//点击警告框充值按钮
- (void)LLAdmissionAlertView:(LLAdmissionAlertView *)view clickRechargeBtn:(UIButton *)btn;
{
    [view dismiss];
    RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

//点击警告框底部保存按钮
- (void)LLAdmissionAlertView:(LLAdmissionAlertView *)view clickConfirmSelectBtn:(UIButton *)btn;
{
    if (isEmptyStr(view.textField.text)) {
        [LLUtils showErrorHudWithStatus:@"请输入奖励豆子数"];
        return;
    }
    
    NSString *rewardBeans = view.textField.text;
    
    NSIndexPath *indexPath = view.object;
    
    NSDictionary *infoDic = self.contentArr[indexPath.row];
    
    NSString *relativeAdd = @"/recruit/bonuses";
    
    NSDictionary *paraDic = @{@"uid":kUid,@"userId":infoDic[@"userId"],@"beans":rewardBeans,@"time":kTimeStamp,@"sign":kSignWithIdentify(relativeAdd)};
    
    [self rewardRequestWithParaDic:paraDic];
}

#pragma mark - Network

//奖励请求
- (void)rewardRequestWithParaDic:(NSDictionary *)paraDic
{
    [LLUtils showTextAndProgressHud:@"请求中..."];
    [NetworkEngine postRequestWithRelativeAdd:@"/recruit/bonuses" paraDic:paraDic completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if (isEqualValue(jsonObj[@"code"], 1)) {
                //成功
                [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
                [self getProportionRequest]; //重新获取赚豆余额
            }
            else
            {
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
        }
        else
        {
            [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
        }
        [admissionAlertView dismiss];
    }];
}

//获取赚豆比例 以及 赚豆余额
- (void)getProportionRequest
{
    [NetworkEngine sendAsynPostRequestRelativeAdd:@"/getProportion" paraNameArr:@[@"uid",@"time",@"deviceInfo",@"sign"] paraValueArr:@[kUid,kTimeStamp,kDeviceInfo,kSignWithIdentify(@"/getProportion")] completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                proportionInfoDic = jsonObj[@"info"][@"proportionInfo"];
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
    }];
}

//移除请求
- (void)deleteRequestWithPhone:(NSString *)phone withIndexPath:(NSIndexPath *)indexPath
{
    [NetworkEngine sendAsynPostRequestRelativeAdd:@"/recruit/delete" paraNameArr:@[@"uid",@"time",@"phone",@"sign"] paraValueArr:@[kUid,kTimeStamp,phone,kSignWithIdentify(@"/recruit/delete")] completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
                //刷新UI
                [self.contentArr removeObjectAtIndex:indexPath.row];
                [self.bg_TableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationBottom];
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
    }];
}


@end
