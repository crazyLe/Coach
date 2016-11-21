//
//  LLWalletCell.m
//  Coach
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLWalletCell.h"

@implementation LLWalletCell

#pragma mark - Setup

- (void)setUI
{
    [super setUI];
    
    _detailBtn = [LLButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_detailBtn];
    
    _orderNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_orderNumBtn];
    
    _earnBeansNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_earnBeansNumBtn];
}

- (void)setContraints
{
    [super setContraints];
    
    __weak UILabel *titleLblWeak = self.titleLbl;
    WeakObj(_orderNumBtn)
    [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.height.offset(45*kHeightScale);
        make.width.offset(90*kWidthScale);
        make.centerY.equalTo(titleLblWeak);
    }];
    
    [_orderNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.top.equalTo(titleLblWeak.mas_bottom);
        make.width.offset(kScreenWidth/2);
    }];
    
    [_earnBeansNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderNumBtnWeak.mas_right);
        make.right.offset(0);
        make.top.bottom.equalTo(_orderNumBtnWeak);
    }];
}

- (void)setAttributes
{
    [super setAttributes];
    
    [_detailBtn setTitleColor:[UIColor colorWithHexString:@"c8c8c8"] forState:UIControlStateNormal];
    _detailBtn.titleLabel.font = kFont12;
    
    _orderNumBtn.frame = CGRectMake(0, 0, kScreenWidth/2, 66);
    _earnBeansNumBtn.frame = _orderNumBtn.frame;
    [_orderNumBtn addTopBorderWithHeight:kLineWidth color:kLineWhiteColor leftOffset:15.0f rightOffset:0.0f andTopOffset:0.0f];
    [_orderNumBtn addRightBorderWithWidth:kLineWidth color:kLineWhiteColor rightOffset:0 topOffset:5.0 andBottomOffset:5.0f];
    [_earnBeansNumBtn addTopBorderWithHeight:kLineWidth andColor:kLineWhiteColor];
    
    [_detailBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _detailBtn.tag = 10;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_detailBtn layoutButtonWithEdgeInsetsStyle:LLButtonStyleTextLeft imageTitleSpace:9.0f*kWidthScale];
}

- (void)clickBtn:(UIButton *)btn
{
    if (btn.tag == 10) {
        if (_delegate && [_delegate respondsToSelector:@selector(LLWalletCell:clickDetailBtn:)]) {
            [_delegate LLWalletCell:self clickDetailBtn:btn];
        }
    }
}

@end
