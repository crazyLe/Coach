//
//  LLRechargeCell.m
//  Coach
//
//  Created by apple on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLRechargeCell.h"

@implementation LLRechargeCell

#pragma mark - Setup

- (void)setUI
{
    [super setUI];
    
    _bgView = [UIView new];
    [self.contentView addSubview:_bgView];
    
    _bgImgView = [UIImageView new];
    [_bgView addSubview:_bgImgView];
    
    _beansRemainLbl = [UILabel new];
    [_bgView addSubview:_beansRemainLbl];
    
    _desLbl = [UILabel new];
    [_bgView addSubview:_desLbl];
    
    _amountInputView = [[LLInputView alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:_amountInputView];
    
    _rechargeBeansNumView = [[LLInputView alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:_rechargeBeansNumView];
    
    _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_rechargeBtn];
}

- (void)setContraints
{
    [super setContraints];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(10*kHeightScale, 10*kWidthScale, 10*kHeightScale, 10*kWidthScale));
    }];
    
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    WeakObj(_bgView)
    [_beansRemainLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(50*kHeightScale);
        make.height.offset(100*kHeightScale);
        make.centerX.offset(0);
        make.width.equalTo(_bgViewWeak);
    }];
    
    WeakObj(_beansRemainLbl)
    [_rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-30*kHeightScale);
        make.centerX.equalTo(_beansRemainLblWeak);
        make.height.offset(43*kHeightScale);
//        make.width.equalTo(_bgViewWeak).multipliedBy(0.75f);
        make.left.offset(25*kWidthScale);
        make.right.offset(-25*kWidthScale);
    }];
    
    WeakObj(_rechargeBtn)
    [_rechargeBeansNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_rechargeBtnWeak.mas_top).offset(-20*kHeightScale);
        make.height.offset(44*kHeightScale);
        make.centerX.equalTo(_beansRemainLblWeak);
        make.width.equalTo(_rechargeBtnWeak);
    }];
    
    WeakObj(_rechargeBeansNumView)
    [_amountInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_rechargeBeansNumViewWeak.mas_top).offset(-10*kHeightScale);
        make.width.height.centerX.equalTo(_rechargeBeansNumViewWeak);
    }];
    
    WeakObj(_amountInputView)
    [_desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_amountInputViewWeak.mas_top).offset(0);
        make.left.equalTo(_amountInputViewWeak).offset(5*kWidthScale);
        make.width.equalTo(_amountInputViewWeak);
        make.height.offset(30*kHeightScale);
    }];
}

- (void)setAttributes
{
    [super setAttributes];
    
    _beansRemainLbl.textAlignment = NSTextAlignmentCenter;
    _beansRemainLbl.numberOfLines = 0;
    
    _rechargeBtn.layer.masksToBounds = YES;
    _rechargeBtn.layer.cornerRadius = 5.0f;
    [_rechargeBtn setBackgroundColor:[UIColor colorWithHexString:@"2e83ff"]];
    [_rechargeBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    _rechargeBtn.titleLabel.font = kFont18;
    [_rechargeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _amountInputView.delegate = self;
    _amountInputView.textField.tag = 10;
    
    _rechargeBeansNumView.delegate = self;
    _rechargeBeansNumView.textField.tag = 20;
}

#pragma mark - LLInputViewDelegate

- (void)LLInputView:(LLInputView *)view textFieldEditChanged:(UITextField *)textField;
{
    if (view.textField.tag == 10) {
        if (_delegate && [_delegate respondsToSelector:@selector(LLRechargeCell:moneyTextFieldDidChanged:)]) {
            [_delegate LLRechargeCell:self moneyTextFieldDidChanged:textField];
        }
    }
    else
    {
        if (_delegate && [_delegate respondsToSelector:@selector(LLRechargeCell:earnBeansTextFieldDidChanged:)]) {
            [_delegate LLRechargeCell:self earnBeansTextFieldDidChanged:textField];
        }
    }
//    _rechargeBeansNumView.textField.text = [NSString stringWithFormat:@"%lld",[_amountInputView.textField.text longLongValue]*10];
}

- (void)clickBtn:(UIButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(LLRechargeCell:clickRechargeBtn:)]) {
        [_delegate LLRechargeCell:self clickRechargeBtn:btn];
    }
}

@end
