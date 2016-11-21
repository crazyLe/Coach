//
//  LoginViewController.m
//  Coach
//
//  Created by LL on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "JpushManager.h"
#import "JPUSHService.h"
#import "LoginRegisterCell.h"
#import "LoginViewController.h"

@interface LoginViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation LoginViewController
{
    UISegmentedControl *segmentedControl;
    UITableView *bg_TableView;
    
    NSString *phoneStr;
    NSString *pswStr;
    
    NSArray *iconImgNameArr1;
    NSArray *placeHolderArr1;
    NSArray *iconImgNameArr2;
    NSArray *placeHolderArr2;
    
    NSArray *iconImgNameArr;
    NSArray *placeHolderArr;
}

- (id)init
{
    if (self = [super init]) {
        iconImgNameArr1 = @[@"iconfont-loginphone",@"iconfont-loginlock"];
        placeHolderArr1 = @[@"请输入手机号",@"请输入密码"];
        iconImgNameArr2 = @[@"iconfont-loginphone",@"captcha"];
        placeHolderArr2 = @[@"请输入手机号",@"请输入验证码"];
        iconImgNameArr  = @[iconImgNameArr1,iconImgNameArr2];
        placeHolderArr  = @[placeHolderArr1,placeHolderArr2];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigation];
    [self setUI];
}

- (void)setNavigation
{
    UIView *navBgView = [UIView new];
    [self.view addSubview:navBgView];
    [navBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(64);
    }];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navBgView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.bottom.offset(0);
        make.width.height.offset(25);
    }];
    [backBtn setImage:[UIImage imageNamed:@"iconfont-loginback"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"密码登录",@"验证码登录"]];
    segmentedControl.bounds = CGRectMake(0, 0, 200, 30);
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"ffffff" ],NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:rgb(51, 57, 61),NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateSelected];
    segmentedControl.tintColor = [UIColor colorWithHexString:@"ffffff"];
    segmentedControl.selectedSegmentIndex = 0;
    [navBgView addSubview:segmentedControl];
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.width.offset(210*kWidthScale);
        make.height.offset(30);
        make.centerY.equalTo(backBtn);
    }];
}

- (void)setUI
{
    [self setBg_TableView];
}

- (void)setBg_TableView
{
    bg_TableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:bg_TableView];
    [self.view sendSubviewToBack:bg_TableView];
    [bg_TableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    bg_TableView.delegate = self;
    bg_TableView.dataSource = self;
    bg_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [bg_TableView registerClass:[LoginRegisterCell class] forCellReuseIdentifier:@"LoginRegisterCell"];
    bg_TableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Layer-5"]];
}

#pragma mark - UITableViewDelegate && UITableViewDateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 2;
        }
            break;
        case 1:
        {
            return 2;
        }
            break;
        case 2:
        {
            return 1;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 100*kHeightScale;
            break;
        case 1:
            return 55*kHeightScale;
            break;
        case 2:
            return 100*kHeightScale;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==1) {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIImageView *logoImgView = [[UIImageView alloc] init];
                [cell.contentView addSubview:logoImgView];
                [logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.offset(0);
                }];
                logoImgView.image = [UIImage imageNamed:@"logo"];
                
                return cell;
            }
        }
            break;
        case 1:
        {
            LoginRegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoginRegisterCell"];
            cell.textField.keyboardType = indexPath.row==0? UIKeyboardTypePhonePad:indexPath.row==1?UIKeyboardTypeNumberPad:UIKeyboardTypeDefault;
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.backgroundColor = [UIColor clearColor];
            cell.iconImgView.image = [UIImage imageNamed:iconImgNameArr[segmentedControl.selectedSegmentIndex][indexPath.row]];
            cell.captchaBtn.hidden = indexPath.row != 1;
            cell.textField.attributedPlaceholder = [NSMutableAttributedString attributeStringWithText:placeHolderArr[segmentedControl.selectedSegmentIndex][indexPath.row] attributes:@[[UIColor colorWithHexString:@"919ea7"],kFont14]];
            if (indexPath.row == 1) {
                cell.textField.secureTextEntry = !segmentedControl.selectedSegmentIndex ? YES : NO;
                cell.captchaBtn.hidden = !segmentedControl.selectedSegmentIndex;
                cell.captchaBtn.layer.borderColor = [UIColor colorWithHexString:@"b1bdc6"].CGColor;
                [cell.captchaBtn setTitleColor:[UIColor colorWithHexString:@"b1bdc6"] forState:UIControlStateNormal];
            }
            else
            {
                cell.captchaBtn.hidden = YES;
                cell.textField.secureTextEntry = NO;
            }
            
            if (segmentedControl.selectedSegmentIndex==1) {
                [cell.textField mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(indexPath.row!=1 ? -10*kWidthScale : -(10*kWidthScale+170/2*kWidthScale+5));
                }];
            }
            else
            {
                [cell.textField mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(-10*kWidthScale);
                }];
            }
            if (segmentedControl.selectedSegmentIndex==0) {
                if (indexPath.row==0) {
                    cell.textField.keyboardType = UIKeyboardTypePhonePad;
                }
                else
                {
                    cell.textField.keyboardType = UIKeyboardTypeDefault;
                }
            }
            else
            {
                if (indexPath.row==0) {
                    cell.textField.keyboardType = UIKeyboardTypePhonePad;
                }
                else
                {
                    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                }
            }
            return cell;
        }
            break;
        case 2:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cell.contentView addSubview:registerBtn];
            [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(30*kHeightScale, 40*kWidthScale, 30*kHeightScale, 40*kWidthScale));
            }];
            registerBtn.layer.masksToBounds = YES;
            [registerBtn setBackgroundColor:kAppThemeColor];
            registerBtn.layer.cornerRadius = 20*kHeightScale;
            [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            registerBtn.titleLabel.font = kFont18;
            [registerBtn setTitle:@"登录" forState:UIControlStateNormal];
            [registerBtn addTarget:self action:@selector(clickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
            break;
            
        default:
            break;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)segmentedControlChangedValue:(UISegmentedControl *)segment
{
    LoginRegisterCell *cell0 = [bg_TableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell0.textField.text = @"";
    LoginRegisterCell *cell1 = [bg_TableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    cell1.textField.text = @"";
    
    if (segment.selectedSegmentIndex==0) {
        [cell1 stopCountdown];
    }
    
    [bg_TableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] withRowAnimation:segment.selectedSegmentIndex==0?UITableViewRowAnimationRight:UITableViewRowAnimationLeft];
}

- (void)clickBackBtn:(UIButton *)backBtn
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];  
}

- (void)clickLoginBtn:(UIButton *)loginBtn
{
    if (isEmptyStr(phoneStr)||isEmptyStr(pswStr))
    {
        [LLUtils showErrorHudWithStatus:isEmptyStr(phoneStr)?@"请输入手机号":segmentedControl.selectedSegmentIndex == 0?@"请输入密码":@"请输入验证码" ];
        return;
    }
    //点击登录
    WeakObj(self)
    NSLog(@"=====>%@",[NSString stringWithFormat:@"%@%@%@%@%@%@",kUUID,@"/user/login",kUid,kToken,kTimeStamp,phoneStr]);
    [NetworkEngine sendAsynPostRequestRelativeAdd:@"/user/login" paraNameArr:@[@"phone",@"time",@"password",@"deviceInfo",@"pushID",@"loginChannel",@"sign"] paraValueArr:@[phoneStr,kTimeStamp,pswStr,kDeviceInfo,kPushId,segmentedControl.selectedSegmentIndex==0?@"1":@"2",kSignIdentifyWithStr(@"/user/login",phoneStr)] completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            NSLog(@"jsonObj===>%@",jsonObj);
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //登录成功
                [kUserDefault setObject:@(YES) forKey:@"isLogin"]; 
                [kUserDefault setObject:jsonObj[@"info"][@"phone"] forKey:@"CoachPhone"];  //手机号
                [kUserDefault setObject:jsonObj[@"info"][@"token"] forKey:@"CoachToken"];  //令牌
                [kUserDefault setObject:jsonObj[@"info"][@"uid"] forKey:@"CoachUid"];      //用户ID
                [kUserDefault setObject:jsonObj[@"info"][@"nickname"] forKey:@"CoachNickName"];//昵称
                [kUserDefault setObject:jsonObj[@"info"][@"face"] forKey:@"CoachFace"];    //用户头像
                [kUserDefault setObject:jsonObj[@"info"][@"state"] forKey:@"CoachAuthState"]; //用户认证状态
                [kUserDefault setObject:jsonObj[@"info"][@"realname"] forKey:@"CoachRealName"]; //用户真实姓名
                [kUserDefault setObject:segmentedControl.selectedSegmentIndex==0?@"1":@"2" forKey:@"CoachLoginChannel"];
                if (selfWeak.delegate && [selfWeak.delegate respondsToSelector:@selector(loginSuccess)]) {
                    [selfWeak.delegate loginSuccess];
                }
                [self dismissToRootViewController];
                [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
                
//                if(!isEmptyStr(kUid))
//                {
//                    //设置别名
//                    [JPUSHService setTags:nil alias:kUid fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
//                        
//                    }];
//                }
                
                //监听收到消息通知
//                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessageNotification:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
                
                //jpush监听
                [[JpushManager sharedJpushManager] startMonitor];
                
                //发送登录状态改变通知
                [[NSNotificationCenter defaultCenter] postNotificationName:kCoachUserLoginStateChangedNotificationName object:nil];
                
            }
            else
            {
                //登录失败
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
        }
    }];
}

#pragma mark - didReceiveMessageNotification

- (void)didReceiveMessageNotification:(NSNotification *)notify
{
    NSDictionary *userInfo = notify.userInfo;
    NSLog(@"messageNotification UserInfo==>%@",userInfo);
}

#pragma mark - LoginRegisterCellDelegate

- (void)LoginRegisterCell:(LoginRegisterCell *)cell clickCaptchBtn:(UIButton *)captchBtn;
{
    if (isEmptyStr(phoneStr)) {
        [LLUtils showErrorHudWithStatus:@"请输入手机号"];
        return;
    }
    
    //开始倒计时
    [cell startCountdown];
    
    //点击获取验证码
    [NetworkEngine sendAsynPostRequestRelativeAdd:@"user/sendCode" paraNameArr:@[@"phone",@"time",@"flag"] paraValueArr:@[phoneStr,kTimeStamp,@"login"] completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(0)]) {
                //验证码获取失败
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
            else
            {
                [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
            }
        }
    }];
}

- (void)LoginRegisterCell:(LoginRegisterCell *)cell textFieldDidEditingChanged:(UITextField *)textField;
{
    if (cell.indexPath.row==0) {
        //账号
        phoneStr = textField.text;
    }
    else
    {
        //密码
        pswStr = textField.text;
    }
}

-(void)dismissToRootViewController
{
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)LoginRegisterCell:(LoginRegisterCell *)cell textFieldShouldReturn:(UITextField *)textField;
{
    if (cell.indexPath.row==1) {
        [self clickLoginBtn:nil];
    }
    else
    {
        //光标下移
        LoginRegisterCell *cell = [bg_TableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        [cell.textField becomeFirstResponder];
    }
    return YES;
}


@end
