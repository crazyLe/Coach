//
//  RegisterViewController.m
//  Coach
//
//  Created by LL on 16/8/3.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLWebViewController.h"
#import "LoginRegisterCell.h"
#import "RegisterViewController.h"

@interface RegisterViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation RegisterViewController
{
    NSArray *iconImgNameArr;
    NSArray *placeHolderArr;
    
    NSString *phoneStr;
    NSString *captchaStr;
    NSString *setPswStr;
    NSString *confirmPswStr;
    
    UITableView *bg_TableView;
    LLWebViewController *webVC ;
}

- (id)init
{
    if (self = [super init]) {
        iconImgNameArr = @[@"iconfont-loginphone",@"captcha",@"iconfont-loginlock",@"iconfont-loginlockchecked"];
        placeHolderArr = @[@"手机号",@"验证码",@"设置密码",@"确认密码"];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
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
}

- (void)setUI
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
            return 4;
        }
            break;
        case 2:
        {
            return 2;
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
            return 80*kHeightScale;
            break;
        case 1:
            return 55*kHeightScale;
            break;
        case 2:
            if (indexPath.row==0) {
                return 100*kHeightScale;
            }
            else
            {
                return 30;
            }
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
            cell.iconImgView.image = [UIImage imageNamed:iconImgNameArr[indexPath.row]];
            cell.captchaBtn.hidden = indexPath.row != 1;
            cell.textField.attributedPlaceholder = [NSMutableAttributedString attributeStringWithText:placeHolderArr[indexPath.row] attributes:@[[UIColor colorWithHexString:@"919ea7"],kFont14]];
            [cell.textField mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.right.offset(indexPath.row!=1 ? -10*kWidthScale : -(10*kWidthScale+170/2*kWidthScale+5));
            }];
            if (indexPath.row > 1) {
                cell.textField.secureTextEntry = YES;
            }
            return cell;
        }
            break;
        case 2:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            if (indexPath.row==0) {
                //立即注册
                UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [cell.contentView addSubview:registerBtn];
                [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.insets(UIEdgeInsetsMake(30*kHeightScale, 40*kWidthScale, 30*kHeightScale, 40*kWidthScale));
                }];
                registerBtn.layer.masksToBounds = YES;
                registerBtn.layer.cornerRadius = 20*kHeightScale;
                registerBtn.layer.borderColor = [UIColor colorWithHexString:@"e3effe"].CGColor;
                registerBtn.layer.borderWidth = 1.0f;
                [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                registerBtn.titleLabel.font = kFont18;
                [registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
                [registerBtn addTarget:self action:@selector(clickRegisterBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                //注册协议
                UIButton *protocalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [cell.contentView addSubview:protocalBtn];
                [protocalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.offset(0);
                    make.top.offset(0);
                    make.width.offset(kScreenWidth);
                    make.height.offset(30);
                }];
                [protocalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [protocalBtn setTitle:@"注册即表示同意《康庄学车注册协议》" forState:UIControlStateNormal];
                protocalBtn.titleLabel.font = Font14;
                [protocalBtn addTarget:self action:@selector(clickProtocalBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
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

- (void)clickBackBtn:(UIButton *)backBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickProtocalBtn:(UIButton *)protocalBtn
{
    NSString *registerProtocal = @"https://www.kangzhuangxueche.com/index.php/wap/agreement";
    webVC = [[LLWebViewController alloc] initWithUrl:[NSURL URLWithString:registerProtocal] title:@"注册协议" rightImgName:nil];
    [self presentViewController:webVC animated:YES completion:nil];
    [webVC.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(kTopBarTotalHeight, 0, 0, 0));
    }];
    
    UIImageView *imageView = [UIImageView new];
    [webVC.view addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"Layer-5"];
    [webVC.view sendSubviewToBack:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //set nav
    UIView *navBgView = [UIView new];
    [webVC.view addSubview:navBgView];
    [navBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(64);
    }];
//    navBgView.backgroundColor = kAppThemeColor;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navBgView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.centerY.offset(10);
        make.width.height.offset(25);
    }];
    [backBtn setImage:[UIImage imageNamed:@"iconfont-loginback"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickRegisterProtocalBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLbl = [UILabel new];
    titleLbl.text = @"康庄学车注册协议";
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.font = [UIFont boldSystemFontOfSize:18];
    [navBgView addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.offset(10);
        make.centerX.offset(0);
    }];
}

- (void)clickRegisterProtocalBackBtn:(UIButton *)backBtn
{
    [webVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickRegisterBtn:(UIButton *)registerBtn
{
    if (!phoneStr || !captchaStr || !setPswStr || !confirmPswStr || [phoneStr isEqualToString:@""]||[captchaStr isEqualToString:@""]||[setPswStr isEqualToString:@""]||[confirmPswStr isEqualToString:@""])
    {
        [LLUtils showErrorHudWithStatus:@"请输入完整信息后再注册"];
        return;
    }
    [NetworkEngine sendAsynPostRequestRelativeAdd:@"/user/register" paraNameArr:@[@"phone",@"time",@"code",@"pwd",@"confirmPwd",@"deviceInfo",@"pushID"] paraValueArr:@[phoneStr,kTimeStamp,captchaStr,setPswStr,confirmPswStr,kDeviceInfo,kUUID] completeBlock:^(BOOL isSuccess, id jsonObj) {
        NSLog(@"jsonObj == > %@",jsonObj);
        if (isSuccess) {
            if([jsonObj[@"code"] intValue] == 1)
            {
                //注册成功
                [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                //注册失败
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
        }
    }];
    
}

//- (void)keyboardShow:(NSNotification *)notify
//{
//    [UIView animateWithDuration:0.25 animations:^{
//        bg_TableView.contentOffset = CGPointMake(0, 125*kHeightScale);
//    }];
//}

#pragma mark - LoginRegisterCellDelegate

- (void)LoginRegisterCell:(LoginRegisterCell *)cell clickCaptchBtn:(UIButton *)captchBtn;
{
    if (isEmptyStr(phoneStr)) {
        [LLUtils showErrorHudWithStatus:@"请输入手机号码"];
        return;
    }
    [cell startCountdown]; //开始倒计时
  [NetworkEngine sendAsynGetRequestRelativeAdd:@"user/getVerificationCode" paraNameArr:@[@"phone",@"time"] paraValueArr:@[phoneStr,kTimeStamp] completeBlock:^(BOOL isSuccess, id jsonObj) {
       NSLog(@"jsonObj ==> %@",jsonObj);
      if (isSuccess) {
          if (isEqualValue(jsonObj[@"info"][@"result"], 1)) {
              //已注册
              [cell stopCountdown]; //停止倒计时
              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您的号码已注册，请登录" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
              [alertView show];
          }
      }
   }];
}

- (void)LoginRegisterCell:(LoginRegisterCell *)cell textFieldDidEditingChanged:(UITextField *)textField;
{
    switch (cell.indexPath.row) {
        case 0:
        {
            phoneStr = textField.text;
        }
            break;
        case 1:
        {
            captchaStr = textField.text;
        }
            break;
        case 2:
        {
            setPswStr = textField.text;
        }
            break;
        case 3:
        {
            confirmPswStr = textField.text;
        }
            break;
            
        default:
            break;
    }
}


@end
