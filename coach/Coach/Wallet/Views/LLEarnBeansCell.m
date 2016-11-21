//
//  LLEarnBeansCell.m
//  学员端
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#define kBtnBorderWidth 1.0f
#define kLeftOffset 15

#import "LLEarnBeansCell.h"

@implementation LLEarnBeansCell

- (void)setUI
{
    _bgView = [UIView new];
    [self.contentView addSubview:_bgView];
    
    _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_headBtn];
    
    _nameLbl = [UILabel new];
    [_bgView addSubview:_nameLbl];
    
    _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_rechargeBtn];
    
    _withdrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_withdrawBtn];
    
    _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_recordBtn];
    
    _ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_ruleBtn];
    
    _helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_helpBtn];
}

- (void)setContraints
{
    WeakObj(_headBtn)
    WeakObj(_withdrawBtn)
    WeakObj(_helpBtn)
    WeakObj(_recordBtn)
    WeakObj(_rechargeBtn)
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(9, 0, 0, 0));
    }];
    
    [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(kLeftOffset);
        make.width.height.offset(60);
    }];
    
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headBtnWeak.mas_right).offset(5);
        make.top.height.equalTo(_headBtnWeak);
        make.right.equalTo(_rechargeBtnWeak.mas_left).offset(-10);
    }];
    
    [_withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.width.offset(50);
        make.height.offset(30);
        make.top.equalTo(_headBtnWeak).offset(15);
    }];
    
    [_rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_withdrawBtnWeak.mas_left).offset(-5);
        make.width.top.height.equalTo(_withdrawBtnWeak);
    }];
    
    [_recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(-kBtnBorderWidth);
        make.bottom.offset(0);
        make.width.offset(kScreenWidth/3);
        make.top.equalTo(_headBtnWeak.mas_bottom).offset(12.0f);
    }];
    
    [_helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(_recordBtnWeak);
        make.right.offset(0);
    }];
    
    [_ruleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_recordBtnWeak.mas_right).offset(-kBtnBorderWidth);
        make.right.equalTo(_helpBtnWeak.mas_left).offset(kBtnBorderWidth);
        make.top.height.equalTo(_recordBtnWeak);
    }];
}

- (void)setAttributes
{
    _bgView.backgroundColor = [UIColor whiteColor];
    
    _headBtn.layer.masksToBounds = YES;
    
    _nameLbl.numberOfLines = 0;
    
    [_rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rechargeBtn setBackgroundColor:[UIColor colorWithHexString:@"2878fe"]];
    _rechargeBtn.layer.cornerRadius = 3;
    _rechargeBtn.layer.masksToBounds = YES;
    _rechargeBtn.titleLabel.font = kFont13;
    
    [_withdrawBtn setTitleColor:[UIColor colorWithHexString:@"2878fe"] forState:UIControlStateNormal];
    _withdrawBtn.layer.cornerRadius = 3;
    _withdrawBtn.layer.masksToBounds = YES;
    _withdrawBtn.layer.borderWidth = 1.5f;
    _withdrawBtn.layer.borderColor = [UIColor colorWithHexString:@"2878fe"].CGColor;
    _withdrawBtn.titleLabel.font = _rechargeBtn.titleLabel.font;
    
    int i = 0;
    for (UIButton *btn in @[_recordBtn,_ruleBtn,_helpBtn]) {
        btn.layer.borderColor = kLineWhiteColor.CGColor;
        btn.layer.borderWidth = kBtnBorderWidth;
        [btn setTitleColor:kGrayHex66 forState:UIControlStateNormal];
        btn.titleLabel.font = kFont12;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 13+i++;
    }
    
    [_headBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _headBtn.tag = 10;
    [_rechargeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _rechargeBtn.tag = 11;
    [_withdrawBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _withdrawBtn.tag = 12;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _headBtn.layer.cornerRadius = 60/2;
    _bgView.frame = CGRectMake(0, 9, self.frame.size.width, self.frame.size.height-9);
    [_bgView addBottomBorderWithHeight:kLineWidth andColor:kLineGrayColor];
}

- (void)clickBtn:(UIButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(LLEarnBeansCell:clickBtn:)]) {
        [_delegate LLEarnBeansCell:self clickBtn:btn];
    }
}


@end
