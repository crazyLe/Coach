//
//  LoginRegisterVC.m
//  Coach
//
//  Created by LL on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "LoginRegisterVC.h"

@interface LoginRegisterVC ()

@end

@implementation LoginRegisterVC
{
    UIImageView *_bgImgView;
    UIImageView *_iconImgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
    [self setNavigation];
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

- (void)clickBackBtn:(UIButton *)backBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUI
{
    [self setBgImgView];
    [self setIconImgView];
    [self setLoginRegisterBtn];
}

- (void)setBgImgView
{
    _bgImgView = [UIImageView new];
    [self.view addSubview:_bgImgView];
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _bgImgView.image = [UIImage imageNamed:@"Layer-5"];
    _bgImgView.userInteractionEnabled = YES;
}

- (void)setIconImgView
{
    WeakObj(_bgImgView)
    _iconImgView = [UIImageView new];
    [_bgImgView addSubview:_iconImgView];
    [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bgImgViewWeak.mas_centerY).offset(-30);
        make.centerX.offset(0);
    }];
    _iconImgView.image = [UIImage imageNamed:@"iconfont-kzjlicon"];
}

- (void)setLoginRegisterBtn
{
    WeakObj(_iconImgView)
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgImgView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(_iconImgViewWeak.mas_bottom).offset(40*kHeightScale);
        make.height.offset(44*kHeightScale);
        make.width.offset(376/2*kWidthScale);
    }];
    [loginBtn setBackgroundColor:kAppThemeColor];
    loginBtn.layer.cornerRadius = 22.0f*kHeightScale;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = kFont18;
    [loginBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.tag = 10;
    
//    UILabel *orLbl = [UILabel new];
//    [_bgImgView addSubview:orLbl];
//    [orLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(loginBtn.mas_bottom);
//        make.centerX.width.height.equalTo(loginBtn);
//    }];
//    orLbl.textColor = rgb(160, 179, 211);
//    orLbl.font = kFont18;
//    orLbl.text = @"or";
//    orLbl.textAlignment = NSTextAlignmentCenter;
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgImgView addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.height.width.equalTo(loginBtn);
        make.top.equalTo(loginBtn.mas_bottom).offset(44*kHeightScale);
    }];
    registerBtn.layer.cornerRadius = loginBtn.layer.cornerRadius;
    registerBtn.layer.masksToBounds = loginBtn.layer.masksToBounds;
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    registerBtn.layer.borderWidth = 1.0f;
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.tag = 20;
    [registerBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickBtn:(UIButton *)btn
{
    if (btn.tag == 10) {
        //登录
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.delegate = self;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else
    {
        //注册
        RegisterViewController *registerVC = [[RegisterViewController alloc] init];
        [self presentViewController:registerVC animated:YES completion:nil];
    }
}

#pragma mark - LoginViewControllerDelegate

- (void)loginSuccess;
{
    //登录成功
    if (_successBlock) {
        _successBlock();
    }
}

@end
