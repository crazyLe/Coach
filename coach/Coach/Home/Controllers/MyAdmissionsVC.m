//
//  MyAdmissionsVC.m
//  Coach
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 sskz. All rights reserved.
//

#define kSegmentedControlHeight 45

#import "RechargeViewController.h"
#import "LLAdmissionAlertView.h"
#import "AdmissionManageVC.h"
#import "InviteStudentVC.h"
#import "ExamScheduleCell.h"
#import "SectionHeaderCell.h"
#import "ShowPromptCell.h"
#import "OneCenterBtnCell.h"
#import "AdmissionStatusCell.h"
#import <HMSegmentedControl.h>
#import "MyAdmissionsVC.h"

@interface MyAdmissionsVC ()

@end

@implementation MyAdmissionsVC
{
    HMSegmentedControl *segmentedControl;
    
    NSArray *segmentedControlTitleArr;
    NSArray *addmissionNumArr;
    NSArray *addmissionTextArr;
    NSArray *addmissiontintColorArr;
    
    NSArray *recruitArr;
    
    NSDictionary *proportionInfoDic;
    
    LLAdmissionAlertView *admissionAlertView;
}

- (id)init
{
    if (self = [super init]) {
        segmentedControlTitleArr = @[@"学员招生团",@"亲友招生团"];
        addmissionNumArr = @[@"450人",@"150人",@" 58 "];
        addmissionTextArr = @[@"共有学员",@"，加入招生团",@"共计招生"];
        addmissiontintColorArr = @[@"ffa82f",@"ffa82f",@"2e83ff"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNav];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getProportionRequest]; //获取赚豆余额
    [self requestData];  
}

- (void)setNav
{
    [self setTitleText:@"我的招生团" textColor:nil];
    [self setLeftText:nil textColor:nil ImgPath:@"Navigation_Return"];
    [self setRightText:@"管理" textColor:nil ImgPath:nil];
}

- (void)setUI
{
//    [self setHmSegmentedControl];
    
//    WeakObj(segmentedControl)
    [self setBg_TableViewWithConstraints:nil];
    [self registerClassWithClassNameArr:@[@"AdmissionStatusCell",@"ShowPromptCell"
        ,@"OneCenterBtnCell",@"SectionHeaderCell",@"ExamScheduleCell"]  cellIdentifier:nil];
    
}

//- (void)setHmSegmentedControl
//{
//    segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:segmentedControlTitleArr];
//    segmentedControl.frame = CGRectMake(10, 10, 300, 60);
//    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:segmentedControl];
////    segmentedControl.backgroundColor = [UIColor redColor];
//    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(kTopBarTotalHeight);
//        make.left.right.offset(0);
//        make.height.offset(kSegmentedControlHeight);
//    }];
//    segmentedControl.selectionIndicatorColor = [UIColor colorWithHexString:@"0X5cb6ff"];
//    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
//    segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0X646464"],NSFontAttributeName:[UIFont boldSystemFontOfSize:16]};
//    segmentedControl.selectionIndicatorHeight = 3.0f;
//    segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, -25, 0, -50);
//    segmentedControl.borderWidth = 1.0f;
//    segmentedControl.borderColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
//    segmentedControl.borderType = HMSegmentedControlBorderTypeBottom;
//}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 4;
        }
            break;
        case 1:
        {
            return recruitArr.count;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                return 100;
            }
                break;
            case 1:
            {
                return 70;
            }
                break;
            case 2:
            {
                return 100;
            }
                break;
            case 3:
            {
                return 45;
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        return 65;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                AdmissionStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdmissionStatusCell"];
                NSMutableAttributedString *totalStr = [NSMutableAttributedString attributeStringWithText:nil attributes:nil];
                for (int i = 0; i < 3; i++) {
                    NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithText:addmissionTextArr[i] attributes:@[[UIColor colorWithHexString:@"4c4c4c"],kFont16]];
                    [attStr appendText:addmissionNumArr[i] withAttributesArr:@[[UIColor colorWithHexString:addmissiontintColorArr[i]],[UIFont boldSystemFontOfSize:16*kWidthScale]]];
                    [totalStr appendAttributedString:attStr];
                    if (i==1) {
                        [totalStr appendText:@"。" withAttributesArr:@[[UIColor colorWithHexString:@"4c4c4c"],kFont16]];
                        [totalStr appendBreakLineWithInterval:7];
                    }
                    else if (i==2)
                    {
                        [totalStr appendText:@"名" withAttributesArr:@[[UIColor colorWithHexString:@"4c4c4c"],kFont16]];
                    }
                }
                [cell.centerLbl setAttributedText:totalStr];
                return cell;
            }
                break;
            case 1:
            {
                OneCenterBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OneCenterBtnCell"];
                [cell.centerBtn setTitle:@"邀请学员加入招生团" forState:UIControlStateNormal];
                cell.delegate = self;
                cell.centerBtn.layer.cornerRadius = 21.0f;
                return cell;
            }
                break;
            case 2:
            {
                ShowPromptCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowPromptCell"];
                cell.contentLbl.text = @"该数据仅为通过线上报名招生数据，通过线上招生每达10人，将获得平台发放的赚豆奖励（可提现）";
                cell.titleLbl.text = @"温  馨  提  示";
                return cell;
            }
                break;
            case 3:
            {
                SectionHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionHeaderCell"];
                cell.titleLbl.text = @"招生概况";
                return cell;
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        ExamScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExamScheduleCell"];
        cell.delegate = self;
        cell.indexPath = indexPath;
        
        NSDictionary *recruitDic = recruitArr[indexPath.row];
        
        [cell.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:kHandleEmptyStr(recruitDic[@"face"])] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"iconfont-defaultheadimage"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                [cell.headBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-defaultheadimage"] forState:UIControlStateNormal];
            }
        }];
//        cell.nameLbl.text = @"钱晨";
//        cell.stageLbl.text = @"2016-07-01";
        
        cell.nameLbl.text = recruitDic[@"userName"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd";
        cell.stageLbl.text = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:[recruitDic[@"date"] doubleValue]]];
        
        [cell.phoneBtn setTitle:[NSString stringWithFormat:@"招生%@人",recruitDic[@"peopleNum"]] forState:UIControlStateNormal];
        
        cell.stageLbl.textAlignment = NSTextAlignmentCenter;
        cell.stageLbl.textColor = kBlackTextColor;
//        [cell.phoneBtn setTitle:@"招生10人" forState:UIControlStateNormal];
        cell.phoneBtn.titleLabel.font = Font13;
        cell.stageLbl.font = Font13;
        [cell.phoneBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.notifyBtn.mas_left);
        }];
        [cell.notifyBtn setTitle:@"给奖励" forState:UIControlStateNormal];
        [cell.notifyBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffa82f"]] forState:UIControlStateNormal];
//        [cell.notifyBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffa82f"]] forState:UIControlStateSelected];
        return cell;
    }
    return [UITableViewCell new];
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

- (void)segmentedControlChangedValue:(HMSegmentedControl *)setmentedContorl
{
    
}

#pragma mark - OneCenterBtnCellDelegate

- (void)centerBtnCell:(OneCenterBtnCell *)cell clickCenterBtn:(UIButton *)centerBtn
{
    checkLogin()
    InviteStudentVC *inviteStudentVC = [[InviteStudentVC alloc] init];
    [self.navigationController pushViewController:inviteStudentVC animated:YES];
}

#pragma mark - ExamScheduleCellDelegate

//点击头像
- (void)ExamScheduleCell:(ExamScheduleCell *)cell clickHeadBtn:(UIButton *)headBtn;
{
    
}

//给奖励
- (void)ExamScheduleCell:(ExamScheduleCell *)cell clickNotifyBtn:(UIButton *)notifyBtn;
{
    NSMutableAttributedString *beansRemainAtt = [NSMutableAttributedString attributeStringWithText:@"赚豆余额:  " attributes:@[kAppThemeColor,kFont13]];
    [beansRemainAtt appendText:proportionInfoDic[@"balanceBeans"] withAttributesArr:@[kGrayHex99,kFont13]];
    admissionAlertView = [LLAdmissionAlertView showWithTitle:[NSString stringWithFormat:@"给%@的招生奖励",cell.nameLbl.text] textFieldPlaceHolder:@"请输入奖励豆子数" confirmBtnTitle:nil rechargeBtnTitle:nil beansUnit:nil beansRemain:beansRemainAtt object:cell.indexPath userInfo:nil delegate:self];
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
    
    NSDictionary *infoDic = recruitArr[indexPath.row];
    
    NSString *relativeAdd = @"/recruit/bonuses";
    
    NSDictionary *paraDic = @{@"uid":kUid,@"userId":infoDic[@"userId"],@"beans":rewardBeans,@"time":kTimeStamp,@"sign":kSignWithIdentify(relativeAdd)};
    
    [self rewardRequestWithParaDic:paraDic];
}

#pragma mark - overwrite

- (void)clickRightBtn:(UIButton *)rightBtn
{
    AdmissionManageVC *addmissionManageVC = [[AdmissionManageVC alloc] init];
    [self.navigationController pushViewController:addmissionManageVC animated:YES];
}

#pragma mark - Network

//获取招生团首页请求
- (void)requestData
{
    WeakObj(self)
    [NetworkEngine sendAsynPostRequestRelativeAdd:@"/recruit" paraNameArr:@[@"uid",@"deviceInfo",@"time",@"sign"] paraValueArr:@[kUid,kDeviceInfo,kTimeStamp,kSignWithIdentify(@"/recruit")] completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                NSDictionary *recInfoDic = jsonObj[@"info"];
                addmissionNumArr = @[isNull(recInfoDic[@"studentNum"])?@"":[NSString stringWithFormat:@"%@",recInfoDic[@"studentNum"]]
                                     ,isNull(recInfoDic[@"recruitNum"])?@"":[NSString stringWithFormat:@"%@",recInfoDic[@"recruitNum"]]
                                     ,isNull(recInfoDic[@"peopleNum"])?@"":[NSString stringWithFormat:@"%@",recInfoDic[@"peopleNum"]]
                                     ];
                recruitArr = jsonObj[@"info"][@"recruitData"];
                [selfWeak.bg_TableView reloadData];
            }
            else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                //需要登录
                
            }
            else
            {
                //失败
                
            }
        }
    }];
}

#pragma mark - Network

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

@end
