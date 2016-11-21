//
//  LLWithdrawDesCell.m
//  学员端
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLWithdrawDesCell.h"

@implementation LLWithdrawDesCell

#pragma mark - Setup

- (void)setUI
{
    [super setUI];
    
    _titleLbl = [UILabel new];
    [self.contentView addSubview:_titleLbl];
    
    _contentLbl = [UILabel new];
    [self.contentView addSubview:_contentLbl];
    
    _lineView = [UIView new];
    [self.contentView addSubview:_lineView];
}

- (void)setContraints
{
    [super setContraints];
    
    WeakObj(_titleLbl)
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kWidthScale);
        make.top.offset(0);
        make.height.offset(40*kHeightScale);
        make.right.offset(-20*kWidthScale);
    }];
    
    [_contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleLblWeak);
        make.top.equalTo(_titleLblWeak.mas_bottom);
        make.bottom.offset(-15*kHeightScale);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLblWeak.mas_bottom);
        make.left.right.offset(0);
        make.height.offset(kLineWidth);
    }];
}

- (void)setAttributes
{
    [super setAttributes];
    
    _titleLbl.textColor = [UIColor colorWithHexString:@"9c9c9c"];
    _titleLbl.font = [UIFont boldSystemFontOfSize:14*kWidthScale];
    
    _contentLbl.textColor = [UIColor colorWithHexString:@"c8c8c8"];
    _contentLbl.numberOfLines = 0;
    _contentLbl.font = kFont14;
    
    _lineView.backgroundColor = kLineColor;
}

@end
