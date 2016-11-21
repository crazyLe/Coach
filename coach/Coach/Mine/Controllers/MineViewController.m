//
//  MineViewController.m
//  Coach
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "AlreadyBindBankCardVC.h"
#import "BindBankCardVC.h"
#import "JPUSHService.h"
#import "AboutKZController.h"
#import "MineViewController.h"
#import <EXPhotoViewer.h>
#import "AppointListVC.h"
#import "LoginRegisterVC.h"
#import <YYKit/YYKit.h>
#import "UITableView+NoExtraLine.h"
#import "WithdrawViewController.h"
#import "RechargeViewController.h"
#import "PersonSettingVC.h"

#import "LLRightAccessoryCell.h"
#import "LLBaseInfoView.h"
#import "NSMutableAttributedString+LLExtension.h"
#import "CoachProveVC.h"
#import "AccountSecurityVC.h"

#define kHeadImageHeight 226*kHeightScale

#import "MyCircleViewController.h"

@interface MineViewController () <UITableViewDelegate,UITableViewDataSource,LLBaseInfoViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation MineViewController
{
    NSArray *registerCellArr;
    NSDictionary *infoDic;
    
    NSDictionary *personInfoDic;
    
    LLBaseInfoView *baseInfoView;
}

- (id)init
{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = NO;
        registerCellArr = @[@"LLRightAccessoryCell"];
        
        [NOTIFICATION_CENTER addObserver:self selector:@selector(loginStateChanged) name:kCoachUserLoginStateChangedNotificationName object:nil];
    }
    return self;
}

- (void)loginStateChanged
{
    if (isLogin) {
        [self requestData];
    }
    else
    {
        [_tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    //导航栏变为透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    //让黑线消失的方法
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    
    if (isLogin) {
        [self requestData];
        [self getPersonSettingRequest];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    self.navigationController.navigationBar.barTintColor = kAppThemeColor;
    [self.navigationController.navigationBar setTranslucent:YES];
}

- (void)setNavigation
{
    self.navigationItem.title = @"个人中心";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}

- (void)setUI
{
    [self setBg_TableView];
    [self addTableHeadView];
    [self setBaseInfoView];
}

- (void)setBg_TableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabBarHeight) style:UITableViewStylePlain];
    
    self.tableView = tableView;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView setCellLineFullInScreen];
    
    tableView.backgroundColor = kBackgroundColor;
    
    tableView.separatorColor = kLineWhiteColor;
    
    tableView.sectionHeaderHeight = 15*kHeightScale;
    
    [self.view addSubview:tableView];
    
    [tableView setContentOffset:CGPointMake(0, -kHeadImageHeight)];
    
    for (NSString *className in registerCellArr) {
        [_tableView registerClass:NSClassFromString(className) forCellReuseIdentifier:className];
    }
}

-(void)addTableHeadView
{
    
    self.imageView = [[UIImageView alloc]init];
    
    self.imageView.frame = CGRectMake(0, -kHeadImageHeight, kScreenWidth, kHeadImageHeight);
    
    self.imageView.image = [UIImage imageNamed:@"iconfont-metopbg"];
    
    [self.tableView addSubview:self.imageView];
    
    //设置图片的模式
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    //解决设置UIViewContentModeScaleAspectFill图片超出边框的问题
    self.imageView.clipsToBounds = YES;
    
    self.tableView.contentInset = UIEdgeInsetsMake(kHeadImageHeight, 0, 0, 0);
    
}

- (void)setBaseInfoView
{
    baseInfoView = [[LLBaseInfoView alloc] initWithFrame:CGRectMake(0, -kHeadImageHeight, kScreenWidth, kHeadImageHeight)];
    [self.tableView addSubview:baseInfoView];
    baseInfoView.delegate = self;
    baseInfoView.rechargeBtn.hidden = !kBeansShow;
    [baseInfoView.headBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-defaultheadimage"] forState:UIControlStateNormal];
    [baseInfoView.certificationBtn setBackgroundImage:[UIImage imageNamed:@"person_certification"] forState:UIControlStateNormal];
    [baseInfoView.certificationBtn setTitle:@"未认证" forState:UIControlStateNormal];
//    NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithText:@"徐熙弟天黑黑" attributes:@[[UIColor whiteColor],[UIFont boldSystemFontOfSize:18*kWidthScale]]];
//    [attStr appendImg:[UIImage imageNamed:@"iconfont-circle-renzheng"] bounds:CGRectMake(5, 0, 13*kWidthScale, 13*kWidthScale)];
//    [baseInfoView.nameLbl setAttributedText:attStr];
    
//    baseInfoView.infoLbl.text = @"24岁  安徽 合肥";
    
//    NSMutableAttributedString *idAttStr = [NSMutableAttributedString attributeStringWithImg:[UIImage imageNamed:@"关于康庄"] bounds:CGRectMake(0, -2, 13*kWidthScale, 13*kWidthScale)];
//    [idAttStr appendText:@" 康庄学员ID：89757" withAttributesArr:@[[UIColor colorWithHexString:@"ffffff" alpha:1.0f],kFont12]];
//    [baseInfoView.studentIdLbl setAttributedText:idAttStr];
    
    NSMutableAttributedString *remainAttStr = [NSMutableAttributedString attributeStringWithImg:[UIImage imageNamed:@"iconfont-center-dou"] bounds:CGRectMake(0, -3, 17, 17)];
    [remainAttStr appendText:@"  赚豆余额：" withAttributesArr:@[[UIColor whiteColor],kFont15]];
    [remainAttStr appendText:@"0" withAttributesArr:@[[UIColor whiteColor],[UIFont boldSystemFontOfSize:15*kWidthScale]]];
    if (kBeansShow) {
        [baseInfoView.remainLbl setAttributedText:remainAttStr];
    }
    
    [baseInfoView.rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    [baseInfoView.withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
}

/**
 *  核心代码
 *
 *  @param scrollView scrollView
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%f",self.tableView.contentOffset.y);
    
    CGFloat offSet_Y = self.tableView.contentOffset.y;
    
    if (offSet_Y<-kHeadImageHeight) {
        //获取imageView的原始frame
        CGRect frame = self.imageView.frame;
        //修改y
        frame.origin.y = offSet_Y;
        //修改height
        frame.size.height = -offSet_Y;
        //重新赋值
        self.imageView.frame = frame;
        
    }
    //tableView相对于图片的偏移量
    CGFloat reoffSet = offSet_Y + kHeadImageHeight;
    
//    NSLog(@"%f",reoffSet);
    //kHeadImageHeight-64是为了向上拉倒导航栏底部时alpha = 1
    CGFloat alpha = reoffSet/(kHeadImageHeight-64);
    
//    NSLog(@"%f",alpha);
    
    if (alpha>=1) {
        alpha = 0.99;
    }
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithHexString:@"2e82ff" alpha:alpha]];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    
}

#pragma mark - UITableViewDelegate && UITableViewDateSource

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [@[@(5),@(2),@(1)][section] longValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < 2) {
        return 53*kHeightScale;
    }
    else
    {
        return 70*kHeightScale;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
//        case 0:
//        {
//            LLEarnBeanInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLEarnBeanInfoCell"];
//            cell.delegate = self;
//            cell.leftImgView.image = [UIImage imageNamed:@"iconfont-center-dou"];
//            cell.leftLbl.text = @"赚豆余额：10000";
//            [cell.rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
//            [cell.withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
//            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
//            
//            return cell;
//        }
//            break;
        case 0: case 1:
        {
            LLRightAccessoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLRightAccessoryCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            NSArray *leftImgNameArr = @[@[@"iconfont-personsetting",@"ic-appointlist",@"iconfont-memycircle",@"iconfont-meperson",@"iconfont-bangdingyinhangka"],@[@"iconfont-accountsecurity",@"iconfont-aboutsskz"]];
            NSArray *leftLblTextArr = @[@[@"个人设置",@"预约列表",@"我的圈子",@"教练认证",@"绑定银行卡"],@[@"账号安全",@"关于康庄"]];
            cell.leftImgView.image = [UIImage imageNamed:leftImgNameArr[indexPath.section][indexPath.row]];
            cell.leftLbl.text = leftLblTextArr[indexPath.section][indexPath.row];
            cell.accessoryImgView.image = [UIImage imageNamed:@"iconfont-jiantou"];
            if ((indexPath.section==0)&&(indexPath.row==1)) {
//                [cell setMessageNum:@"15"];
            }
            else
            {
//                [cell setAccessoryLblText:indexPath.row==2?@"张大师":indexPath.row==5?@"已认证":@""];
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
                make.edges.insets(UIEdgeInsetsMake(10*kHeightScale, 10*kHeightScale, 10*kHeightScale, 10*kHeightScale));
            }];
            exitBtn.backgroundColor = [UIColor colorWithHexString:@"ff5d5d"];
            exitBtn.layer.masksToBounds = YES;
            exitBtn.layer.cornerRadius = 25.0f*kHeightScale;
            [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [exitBtn setTitle:isLogin?@"退出登录":@"登录" forState:UIControlStateNormal];
            exitBtn.titleLabel.font = kFont15;
            [exitBtn addTarget:self action:@selector(clickLogoutBtn:) forControlEvents:UIControlEventTouchUpInside];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
//        checkLogin()
        switch (indexPath.row) {
            case 0:
            {
                //个人设置
                checkLogin()
                PersonSettingVC *personSettingVC = [[PersonSettingVC alloc] init];
                personSettingVC.settingSuccessBlock = ^{
                    [self requestData];
                };
                [self.navigationController pushViewController:personSettingVC animated:YES];
            }
                break;
            case 1:
            {
                //预约列表
                AppointListVC *appointListVC = [[AppointListVC alloc] init];
                [self.navigationController pushViewController:appointListVC animated:YES];
            }
                break;
            case 2:
            {
                //我的圈子
                checkLogin()
                MyCircleViewController * vc = [[MyCircleViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {
                //教练认证
                checkLogin()
                CoachProveVC * vc = [[CoachProveVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4:
            {
                //银行卡
                checkLogin()
                
                if (isNull(personInfoDic)) {
                    [LLUtils showErrorHudWithStatus:@"数据异常，请稍后重试"];
                    return;
                }
                
                int isbindBack = [personInfoDic[@"isbindBack"] intValue];
                if (isbindBack == 1) {
                    //已绑定
                    AlreadyBindBankCardVC *vc = [[AlreadyBindBankCardVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else if (isbindBack == 0)
                {
                    //未绑定
                    BindBankCardVC *vc = [[BindBankCardVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
                
            default:
                break;
        }
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row==0) {
//            checkLogin()
            //账号安全
            checkLogin()
            WeakObj(self)
            AccountSecurityVC * vc = [[AccountSecurityVC alloc]init];
            vc.successBlock = ^{
                [selfWeak clickLogoutBtn:nil];
                checkLogin()
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            //关于康庄
            AboutKZController *aboutKZVC = [[AboutKZController alloc] init];
            [self.navigationController pushViewController:aboutKZVC animated:YES];
        }
    }
}

#pragma mark - LLBaseInfoViewDelegate

- (void)LLBaseInfoView:(LLBaseInfoView *)view clickHeadBtn:(UIButton *)headBtn;
{
    [EXPhotoViewer showImageFrom:headBtn.imageView];
}

- (void)LLBaseInfoView:(LLBaseInfoView *)view clickRechargeBtn:(UIButton *)rechargeBtn;
{
    checkLogin()
    RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

- (void)LLBaseInfoView:(LLBaseInfoView *)view clickWithdrawBtn:(UIButton *)withdrawBtn;
{
    checkLogin()
    WithdrawViewController *withdrawVC = [[WithdrawViewController alloc] init];
    [self.navigationController pushViewController:withdrawVC animated:YES];
}

#pragma mark - 点击登出

- (void)clickLogoutBtn:(UIButton *)logoutBtn
{
    if (isLogin) {
        //清除用户数据
        clearUserData
        [self.tableView reloadRow:0 inSection:2 withRowAnimation:UITableViewRowAnimationFade];
        
        //清除设置的别名
        [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            
        }];
        
        [logoutBtn setTitle:@"登录" forState:UIControlStateNormal];
        
        //发送登录状态改变通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kCoachUserLoginStateChangedNotificationName object:nil];
        
        infoDic = nil; //数据源置空
        [self updateUI]; //更新UI
    }
    else
    {
        //弹出登录窗口
        LoginRegisterVC *loginRegisterVC = [[LoginRegisterVC alloc] init];
        loginRegisterVC.successBlock = ^(){
            [logoutBtn setTitle:isLogin?@"退出登录":@"登录" forState:UIControlStateNormal];
        };
        [self presentViewController:loginRegisterVC animated:YES completion:nil];
    }
}

#pragma mark - Network

- (void)requestData
{
//    NSLog(@"=====>%@",[NSString stringWithFormat:@"%@%@%@%@%@",kUUID,@"/member",kUid,kToken,kTimeStamp]);
    [NetworkEngine sendAsynPostRequestRelativeAdd:@"/member" paraNameArr:@[@"uid",@"time",@"deviceInfo",@"sign"] paraValueArr:@[kUid,kTimeStamp,kDeviceInfo,kSignWithIdentify(@"/member")] completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                infoDic = jsonObj[@"info"];
                [self updateUI];
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

#pragma mark - updateUI

- (void)updateUI
{
    //更新本地缓存数据
    [kUserDefault setObject:kHandleEmptyStr(infoDic[@"face"]) forKey:@"CoachFace"];
    [kUserDefault setObject:kHandleEmptyStr(infoDic[@"nickName"]) forKey:@"CoachNickName"];
    [kUserDefault setObject:numToStr(infoDic[@"state"]) forKey:@"CoachAuthState"];
    
    //更新UI
    [baseInfoView.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:infoDic[@"face"]] forState:UIControlStateNormal  placeholderImage:[UIImage imageNamed:@"iconfont-defaultheadimage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            [baseInfoView.headBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-defaultheadimage"] forState:UIControlStateNormal];
        }
    }];
    
    NSMutableAttributedString *remainAttStr = [NSMutableAttributedString attributeStringWithImg:[UIImage imageNamed:@"iconfont-center-dou"] bounds:CGRectMake(0, -3, 17, 17)];
    [remainAttStr appendText:@"  赚豆余额：" withAttributesArr:@[[UIColor whiteColor],kFont15]];
    [remainAttStr appendText:kEmptyStrToZero(infoDic[@"beans"]) withAttributesArr:@[[UIColor whiteColor],[UIFont boldSystemFontOfSize:15*kWidthScale]]];
    [baseInfoView.remainLbl setAttributedText:remainAttStr];
    
    NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithText:infoDic[@"nickName"] attributes:@[[UIColor whiteColor],[UIFont boldSystemFontOfSize:18*kWidthScale]]];
    if (isEqualValue(infoDic[@"state"], 1)) {
        //已认证
        [attStr appendImg:[UIImage imageNamed:@"iconfont-circle-renzheng"] bounds:CGRectMake(5, 0, 13*kWidthScale, 13*kWidthScale)];
        [baseInfoView.certificationBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-rezhengbg"] forState:UIControlStateNormal];
        [baseInfoView.certificationBtn setTitle:@"实名认证" forState:UIControlStateNormal];
    }else if(isEqualValue(infoDic[@"state"], 0)){
        [baseInfoView.certificationBtn setBackgroundImage:[UIImage imageNamed:@"person_certification"] forState:UIControlStateNormal];
        [baseInfoView.certificationBtn setTitle:@"审核中" forState:UIControlStateNormal];
    }else{
        [baseInfoView.certificationBtn setBackgroundImage:[UIImage imageNamed:@"person_certification"] forState:UIControlStateNormal];
        [baseInfoView.certificationBtn setTitle:@"未认证" forState:UIControlStateNormal];
    }
    [baseInfoView.nameLbl setAttributedText:attStr];
    
    if (isEmptyStr(kUid)) {
        [baseInfoView.studentIdLbl setAttributedText:nil];
    }
    else
    {
        NSMutableAttributedString *idAttStr = [NSMutableAttributedString attributeStringWithImg:[UIImage imageNamed:@"iconfont-aboutsskz"] bounds:CGRectMake(0, -2, 13*kWidthScale, 13*kWidthScale)];
        [idAttStr appendText:[NSString stringWithFormat:@" 康庄教练ID：%@",kUid] withAttributesArr:@[[UIColor colorWithHexString:@"ffffff" alpha:1.0f],kFont12]];
        [baseInfoView.studentIdLbl setAttributedText:idAttStr];
    }
    
    [_tableView reloadData];
}

//获取个人设置请求
- (void)getPersonSettingRequest
{
    [NetworkEngine sendAsynPostRequestRelativeAdd:@"/member/info" paraNameArr:@[@"uid",@"time",@"deviceInfo",@"sign"] paraValueArr:@[kUid,kTimeStamp,kDeviceInfo,kSignWithIdentify(@"/member/info")] completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                personInfoDic = jsonObj[@"info"];
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
