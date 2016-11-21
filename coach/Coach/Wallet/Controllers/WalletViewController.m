//
//  WalletViewController.m
//  Coach
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <EXPhotoViewer.h>
#import "RechargeViewController.h"
#import "WithdrawViewController.h"
#import "LLWebViewController.h"
#import "ExtraMoneyVC.h"
#import "LLWalletCell.h"
#import "NSMutableAttributedString+LLExtension.h"
#import "LLMyCouponCell.h"
#import "LLStageBillCell.h"
#import "LLStudentTaskCell.h"
#import "LLEarnBeansCell.h"
#import "WalletViewController.h"

#import "WalletViewController.h"

@interface WalletViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation WalletViewController
{
    UITableView *bg_TableView;
    
    NSArray *heightForRowArr;
    NSArray *registerCellArr;
    
    NSDictionary *infoDic;
}

- (id)init
{
    if (self = [super init]) {
        heightForRowArr = @[@(135),@(120),@(120)];
        registerCellArr = @[@"LLEarnBeansCell",@"LLWalletCell"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:kCoachUserLoginStateChangedNotificationName object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isLogin) {
      [self myWalletRequest];
    }
}

- (void)setNavigation
{
     self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"2e82ff"]];
    //  NSArray *barBtnArr =  [self createNavWithLeftBtnImageName:nil leftHighlightImageName:nil leftBtnSelector:nil andCenterTitle:@"钱袋" andRightBtnImageName:@"图层-110" rightHighlightImageName:nil rightBtnSelector:@selector(clickNavRightBtn:)];
    
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 30, 30);
//    [rightBtn setImage:[UIImage imageNamed:@"图层-110"] forState:UIControlStateNormal];
//    UILabel *messageLbl = [UILabel new];
//    [rightBtn addSubview:messageLbl];
//    [rightBtn addTarget:self action:@selector(clickNavRightBtn:) forControlEvents:UIControlEventTouchDown];
//    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
//    [messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.offset(11);
//        make.top.offset(0);
//        make.height.width.offset(15);
//    }];
//    messageLbl.text = @"1";
//    messageLbl.textColor = [UIColor whiteColor];
//    messageLbl.textAlignment = NSTextAlignmentCenter;
//    messageLbl.font = [UIFont systemFontOfSize:15];
//    messageLbl.backgroundColor = [UIColor colorWithRed:254/255.0 green:83/255.0 blue:83/255.0 alpha:1];
//    messageLbl.layer.masksToBounds = YES;
//    messageLbl.layer.cornerRadius = 7.5;
//    
//    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
}

- (void)setUI
{
    [self setBg_TableView];
}

- (void)setBg_TableView
{
    bg_TableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:bg_TableView];
    [bg_TableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    bg_TableView.delegate = self;
    bg_TableView.dataSource = self;
    bg_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    bg_TableView.backgroundColor = kBackgroundColor;
    for (NSString *className in registerCellArr) {
        [bg_TableView registerClass:NSClassFromString(className) forCellReuseIdentifier:className];
    }
}


#pragma mark - UITableViewDelegate && UITableViewDateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [heightForRowArr[indexPath.section] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            LLEarnBeansCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLEarnBeansCell"];
            cell.delegate = self;
            cell.backgroundColor = [UIColor clearColor];
            CGFloat fontSize = 13.0;
            [cell.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:kFace] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"iconfont-defaultheadimage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error) {
                    [cell.headBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-defaultheadimage"] forState:UIControlStateNormal];
                }
            }];
            
            NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithText:kNickName attributes:@[[UIColor colorWithHexString:@"4c4c4c"],[UIFont boldSystemFontOfSize:fontSize*kWidthScale]]];
            [attStr appendText:@" " withAttributesArr:nil];
            if ([kAuthState intValue]==1) {
                [attStr appendImg:[UIImage imageNamed:@"iconfont-circle-renzheng"] bounds:CGRectMake(0, -2, 12*kWidthScale, 13*kWidthScale)];
                [attStr appendText:@" " withAttributesArr:nil];
            }
            [attStr appendImg:[UIImage imageNamed:@"iconfont-yinxingqiarenzheng"] bounds:CGRectMake(0, -2, 17*kWidthScale, 12*kWidthScale)];
            [attStr appendBreakLineWithInterval:4];
            
            if (kBeansShow) {
                [attStr appendText:@"赚豆余额：" withAttributesArr:@[[UIColor colorWithHexString:@"999999"],@(fontSize*kWidthScale)]];
                [attStr appendText:kEmptyStrToZero(infoDic[@"beans"]) withAttributesArr:@[[UIColor colorWithHexString:@"ff5e5c"],[UIFont boldSystemFontOfSize:fontSize*kWidthScale]]];
            }
            
            [cell.nameLbl setAttributedText:attStr];
            
            [cell.rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
            cell.rechargeBtn.hidden = !kBeansShow;
            [cell.withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
            
            NSArray *btnImgNameArr = @[@"iconfont-cf-c42",@"iconfont-money-rule",@"iconfont-money-why"];
            NSArray *btnTitleArr = @[@"查询账单",@"赚豆规则",@"如何获得赚豆"];
            int i = 0;
            for (UIButton *btn in @[cell.recordBtn,cell.ruleBtn,cell.helpBtn]) {
                [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:btnImgNameArr[i]] forState:UIControlStateNormal];
                btn.hidden = !kBeansShow;
                i++;
            }
            
            return cell;
        }
            break;
        case 1: case 2:
        {
            LLWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLWalletCell"];
            cell.delegate = self;
            cell.indexPath = indexPath;
            NSMutableAttributedString *titleAttStr = [NSMutableAttributedString attributeStringWithText:indexPath.section==1?@"招生收入":@"赚外快" attributes:@[[UIColor colorWithHexString:indexPath.section==1?@"226cff":@"ffab33"],[UIFont boldSystemFontOfSize:13*kWidthScale]]];
            [titleAttStr appendText:indexPath.section==1?@"":[NSString stringWithFormat:@" (当前已发布%@个陪练学时)",kEmptyStrToZero(infoDic[@"appointmentNum"])] withAttributesArr:@[[UIColor colorWithHexString:@"999999"],kFont11]];
            [cell.titleLbl setAttributedText:titleAttStr];
           
            NSMutableAttributedString *orderAttStr = [NSMutableAttributedString attributeStringWithText:@"累计订单：" attributes:@[[UIColor colorWithHexString:@"666666"],kFont13]];
            [orderAttStr appendText:indexPath.section==1?kEmptyStrToZero(infoDic[@"OrderNum"]):kEmptyStrToZero(infoDic[@"appointmentOrderNum"]) withAttributesArr:@[[UIColor colorWithHexString:@"666666"],[UIFont boldSystemFontOfSize:13*kWidthScale]]];
            [cell.orderNumBtn setAttributedTitle:orderAttStr forState:UIControlStateNormal];
            
            NSMutableAttributedString *earnBeansAttStr = [NSMutableAttributedString attributeStringWithText:@"已赚：" attributes:@[[UIColor colorWithHexString:@"666666"],kFont13]];
            [earnBeansAttStr appendText:indexPath.section==1?(isNull(infoDic[@"OrderBeans"])?@"0":numToStr(infoDic[@"OrderBeans"])):(isNull(infoDic[@"appointmentBeans"])?@"0":numToStr(infoDic[@"appointmentBeans"])) withAttributesArr:@[[UIColor colorWithHexString:@"666666"],[UIFont boldSystemFontOfSize:13*kWidthScale]]];
            [earnBeansAttStr appendText:@" 元" withAttributesArr:@[[UIColor colorWithHexString:@"666666"],kFont13]];
            [cell.earnBeansNumBtn setAttributedTitle:earnBeansAttStr forState:UIControlStateNormal];
            [cell.detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
            [cell.detailBtn setImage:[UIImage imageNamed:@"Wallet_Detail"] forState:UIControlStateNormal];
            
            cell.leftView.backgroundColor = [UIColor colorWithHexString:indexPath.section==1?@"a1c7ff":@"2e82ff"];
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
    
    
    
    switch (indexPath.section) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            //学员任务
            
        }
            break;
        case 2:
        {
            //分期账单

            
        }
            break;
        case 3:
        {
            
            //我的代金券

            
        }
            break;
            
        default:
            break;
    }
}

//- (void)clickNavRightBtn:(UIButton *)rightBarButton
//{
//    
//    
//}

#pragma mark - LLWalletCellDelegate

- (void)LLWalletCell:(LLWalletCell *)cell clickDetailBtn:(UIButton *)detailBtn;
{
//    checkLogin()
    if (cell.indexPath.section == 1) {
        //招生收入
        ExtraMoneyVC *extraMoneyVC = [[ExtraMoneyVC alloc] init];
        extraMoneyVC.type = ExtraMoneyVCTypeAdmissionEarn;
        [self.navigationController pushViewController:extraMoneyVC animated:YES];
    }
    else
    {
        //赚外快
        ExtraMoneyVC *extraMoneyVC = [[ExtraMoneyVC alloc] init];
        extraMoneyVC.type = ExtraMoneyVCTypeExtraMoney;
        [self.navigationController pushViewController:extraMoneyVC animated:YES];
    }
}

#pragma mark - LLEarnBeansCellDelegate

- (void)LLEarnBeansCell:(LLEarnBeansCell *)cell clickBtn:(UIButton *)btn;
{
    switch (btn.tag) {
        case LLEarnBeansCellBtnTypeHeadBtn:
        {
            //头像
            [EXPhotoViewer showImageFrom:btn.imageView];
        }
            break;
        case LLEarnBeansCellBtnTypeRechargeBtn:
        {
            //充值
            checkLogin()
            RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }
            break;
        case LLEarnBeansCellBtnTypeWithdrawBtn:
        {
            //提现
            checkLogin()
            WithdrawViewController *withdrawVC = [[WithdrawViewController alloc] init];
            [self.navigationController pushViewController:withdrawVC animated:YES];
        }
            break;
        case LLEarnBeansCellBtnTypeRecordBtn:
        {
            //查询账单
//            checkLogin()
            ExtraMoneyVC *extraMoneyVC = [[ExtraMoneyVC alloc] init];
            extraMoneyVC.type = ExtraMoneyVCTypeQueryBill;
            [self.navigationController pushViewController:extraMoneyVC animated:YES];
            
        }
            break;
        case LLEarnBeansCellBtnTypeRuleBtn: case LLEarnBeansCellBtnTypeHelpBtn:
        {
           //赚豆规则  //如何获得赚豆
            NSArray *urlArr = @[@"html-zhuandouguize",@"html-ruhehuoquzhuandou"];
            NSString *filePath = [[NSBundle mainBundle] pathForResource:urlArr[btn.tag-LLEarnBeansCellBtnTypeRuleBtn] ofType:@"html"];
            LLWebViewController *webViewVC = [[LLWebViewController alloc] initWithUrl:[NSURL fileURLWithPath:filePath] title:urlArr[btn.tag-LLEarnBeansCellBtnTypeRuleBtn] rightImgName:@""];
            [self.navigationController pushViewController:webViewVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)myWalletRequest
{
    NSString *relativeAdd = @"/Mypurse/Purse";
    [NetworkEngine postRequestWithRelativeAdd:relativeAdd paraDic:@{@"uid":kUid,@"time":kTimeStamp,@"sign":kSignWithIdentify(relativeAdd),@"deviceInfo":kDeviceInfo} completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if (isEqualValue(jsonObj[@"code"], 1)) {
                //成功
                infoDic = jsonObj[@"info"];
                [bg_TableView reloadData];
            }
            else
            {
                [bg_TableView reloadData];
            }
        }
        else
        {
            
        }
    }];
}

- (void)userLogout
{
    infoDic = nil;
    if (isLogin) {
        [self myWalletRequest];
    }
    else
    {
        [bg_TableView reloadData];
    }
}

@end
