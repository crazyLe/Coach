//
//  LoginRegisterCell.m
//  Coach
//
//  Created by LL on 16/8/3.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LoginRegisterCell.h"

@implementation LoginRegisterCell
{
    NSInteger _lastSecond;
}

- (void)setUI
{
    _bgView = [UIView new];
    [self.contentView addSubview:_bgView];
    
    _iconImgView = [UIImageView new];
    [_bgView addSubview:_iconImgView];
    
    _textField = [UITextField new];
    [_bgView addSubview:_textField];
    
    _lineView = [UIView new];
    [_bgView addSubview:_lineView];
    
    _captchaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_captchaBtn];
}

- (void)setContraints
{
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 30*kWidthScale, 0, 30*kWidthScale));
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(1.f);
    }];
    
    [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kWidthScale);
        make.bottom.offset(-7.5f);
        make.width.offset(20);
        make.height.offset(20);
    }];
    
    WeakObj(_iconImgView)
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImgViewWeak.mas_right).offset(10*kWidthScale);
        make.centerY.equalTo(_iconImgViewWeak);
        make.right.offset(-10*kWidthScale);
        make.height.offset(25);
    }];

    [_captchaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_iconImgViewWeak);
        make.right.offset(-10*kWidthScale);
        make.width.offset(170/2*kWidthScale);
        make.height.offset(37/2*kHeightScale);
    }];
}

- (void)setAttributes
{
    _lineView.backgroundColor = [UIColor whiteColor];
    
//    [_textField setValue:[UIColor colorWithHexString:@"919ea7"] forKeyPath:@"_placeholderLabel.textColor"];
//    [_textField setValue:kFont14 forKeyPath:@"_placeholderLabel.font"];
    _textField.textColor = [UIColor colorWithHexString:@"919ea7"];
    [_textField addTarget:self action:@selector(textFieldDidEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    _textField.delegate = self;
    
    //验证码
    [_captchaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_captchaBtn setTitleColor:[UIColor colorWithHexString:@"f96162"] forState:UIControlStateNormal];
    _captchaBtn.layer.borderWidth = 0.5f;
    _captchaBtn.layer.borderColor = [UIColor colorWithHexString:@"f96162"].CGColor;
    _captchaBtn.layer.masksToBounds = YES;
    _captchaBtn.layer.cornerRadius = 3.0f;
    [_captchaBtn addTarget:self action:@selector(clickCaptchaBtn:) forControlEvents:UIControlEventTouchUpInside];
    _captchaBtn.hidden = YES;
    _captchaBtn.tag = 100;
    _captchaBtn.titleLabel.font = kFont12;
    
    //设置定时初始值
    _timerInterval = 1.0f;
    _timerTotalSecond = 60;
    _captchaBtnTitle = @"获取验证码";
}

- (void)clickCaptchaBtn:(UIButton *)captchaBtn
{
    if (_delegate && [_delegate respondsToSelector:@selector(LoginRegisterCell:clickCaptchBtn:)]) {
        [_delegate LoginRegisterCell:self clickCaptchBtn:captchaBtn];
    }
}

//开始倒计时
- (void)startCountdown
{
    _captchaBtn.userInteractionEnabled = NO;
    _lastSecond = _timerTotalSecond;
    
    [_captchaBtn setTitle:[NSString stringWithFormat:@"%lds",_lastSecond] forState:UIControlStateNormal];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_timerInterval target:self selector:@selector(tiemrHandle:) userInfo:nil repeats:YES];
}

//停止倒计时
- (void)stopCountdown
{
    //重置按钮title
    [_captchaBtn setTitle:_captchaBtnTitle forState:UIControlStateNormal];
    //设置按钮可以交互
    _captchaBtn.userInteractionEnabled = YES;
    //废弃定时器，并指针置空
    [_timer invalidate] , _timer = nil;
}

- (void)tiemrHandle:(NSTimer *)timer
{
    if (_lastSecond==0) {
        [timer invalidate];
        _captchaBtn.userInteractionEnabled = YES;
        [_captchaBtn setTitle:_captchaBtnTitle forState:UIControlStateNormal];
        return ;
    }
    [_captchaBtn setTitle:[NSString stringWithFormat:@"%lds",--_lastSecond] forState:UIControlStateNormal];
}

- (void)textFieldDidEditingChanged:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(LoginRegisterCell:textFieldDidEditingChanged:)]) {
        [_delegate LoginRegisterCell:self textFieldDidEditingChanged:textField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if (_delegate && [_delegate respondsToSelector:@selector(LoginRegisterCell:textFieldShouldReturn:)]) {
       return  [_delegate LoginRegisterCell:self textFieldShouldReturn:textField];
    }
    else
    {
        return YES;
    }
}

@end
