//
//  LLBaseInfoView.m
//  学员端
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLBaseInfoView.h"

@implementation LLBaseInfoView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
        [self setConstraints];
        [self setAttributes];
    }
    return self;
}

- (void)setUI
{
    _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_headBtn];
    
    _certificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_certificationBtn];
    
    _nameLbl = [UILabel new];
    [self addSubview:_nameLbl];
    
//    _infoLbl = [UILabel new];
//    [self addSubview:_infoLbl];
    
    _bgView  = [UIView new];
    [self addSubview:_bgView];
    
    _studentIdLbl = [UILabel new];
    [self addSubview:_studentIdLbl];
    
    _remainLbl = [UILabel new];
    [_bgView addSubview:_remainLbl];
    
    _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_rechargeBtn];
    
    _withdrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_withdrawBtn];
}

- (void)setConstraints
{
    WeakObj(_headBtn)
    WeakObj(_nameLbl)
    WeakObj(_withdrawBtn)
    WeakObj(_rechargeBtn)
    [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-87.5*kHeightScale);
        make.left.offset(15*kWidthScale);
        make.width.height.offset(68*kHeightScale);
    }];
    
    [_certificationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headBtnWeak);
        make.top.equalTo(_headBtnWeak.mas_bottom).offset(-8.5*kHeightScale);
        make.height.offset(17*kHeightScale);
        make.width.equalTo(_headBtnWeak).multipliedBy(1.1f);
    }];
    
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headBtnWeak.mas_right).offset(23);
        make.bottom.equalTo(_headBtnWeak.mas_centerY);
        make.width.offset(kScreenWidth*0.5);
        make.height.offset(20*kHeightScale);
    }];
    
//    [_infoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(_headBtnWeak);
//        make.top.equalTo(_nameLblWeak.mas_bottom).offset(4*kHeightScale);
//        make.width.equalTo(_nameLblWeak);
//        make.height.equalTo(_nameLblWeak).multipliedBy(0.6);
//    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.offset(47*kHeightScale);
    }];
    
    [_studentIdLbl  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(_nameLblWeak);
        make.top.equalTo(_nameLblWeak.mas_bottom).offset(5*kHeightScale);
        make.right.offset(-10);
    }];
    
    [_withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.height.offset(29*kHeightScale);
        make.centerY.offset(0);
        make.width.offset(55*kWidthScale);
    }];
    
    [_rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_withdrawBtnWeak.mas_left).offset(-21*kWidthScale);
        make.width.height.centerY.equalTo(_withdrawBtnWeak);
    }];
    
    [_remainLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*kWidthScale);
        make.top.bottom.offset(0);
        make.right.equalTo(_rechargeBtnWeak.mas_left).offset(-10*kWidthScale);
    }];
}

- (void)setAttributes
{
    _headBtn.layer.masksToBounds = YES;
    _headBtn.layer.borderWidth = 1.0f;
    _headBtn.layer.borderColor = [UIColor colorWithHexString:@"ffffff" alpha:0.8f].CGColor;
    _headBtn.tag = 10;
    [_headBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_certificationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _certificationBtn.titleLabel.font = kFont12;
    
    _nameLbl.textAlignment = NSTextAlignmentLeft;
    _nameLbl.font = [UIFont boldSystemFontOfSize:18];
    
//    _infoLbl.textColor = [UIColor colorWithHexString:@"ffffff" alpha:0.5f];
//    _infoLbl.font = kFont10;
//    _infoLbl.textAlignment = NSTextAlignmentCenter;
    
    _bgView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.3f];
    
    _studentIdLbl.alpha = 0.8f;
    
    _rechargeBtn.titleLabel.font = kFont12;
    [_rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rechargeBtn setBackgroundColor:[UIColor colorWithHexString:@"2e83ff"]];
    _rechargeBtn.layer.cornerRadius = 4.0f*kWidthScale;
    _rechargeBtn.layer.masksToBounds = YES;
    _rechargeBtn.tag = 20;
    [_rechargeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _withdrawBtn.titleLabel.font = _rechargeBtn.titleLabel.font;
    [_withdrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _withdrawBtn.layer.cornerRadius = _rechargeBtn.layer.cornerRadius;
    _withdrawBtn.layer.masksToBounds = _rechargeBtn.layer.masksToBounds;
    _withdrawBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _withdrawBtn.layer.borderWidth = 1.0f;
    _withdrawBtn.tag = 30;
    [_withdrawBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _headBtn.layer.cornerRadius = 68*kHeightScale/2;
}

- (void)clickBtn:(UIButton *)btn
{
    switch (btn.tag) {
        case 10:
        {
            //头像
            if (_delegate && [_delegate respondsToSelector:@selector(LLBaseInfoView:clickHeadBtn:)]) {
                [_delegate LLBaseInfoView:self clickHeadBtn:btn];
            }
        }
            break;
        case 20:
        {
            //充值
            if (_delegate && [_delegate respondsToSelector:@selector(LLBaseInfoView:clickRechargeBtn:)]) {
                [_delegate LLBaseInfoView:self clickRechargeBtn:btn];
            }
        }
            break;
        case 30:
        {
            //提现
            if (_delegate && [_delegate respondsToSelector:@selector(LLBaseInfoView:clickWithdrawBtn:)]) {
                [_delegate LLBaseInfoView:self clickWithdrawBtn:btn];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
