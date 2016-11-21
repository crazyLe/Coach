//
//  LLCouponView.m
//  Coach
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLCouponView.h"

@implementation LLCouponView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
        [self setContraints];
        [self setAttributes];
    }
    return self;
}

#pragma mark - Setup

- (void)setUI
{
    _couponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_couponBtn];
    
    _leftLbl = [UILabel new];
    [_couponBtn addSubview:_leftLbl];
    
    _rightLbl = [UILabel new];
    [_couponBtn addSubview:_rightLbl];
    
    _lineView = [UIView new];
    [self addSubview:_lineView];
}

- (void)setContraints
{
    WeakObj(_couponBtn)
    [_couponBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(10);
        make.bottom.offset(-10);
        make.right.offset(-5);
    }];
    
    [_leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(8*kWidthScale);
        make.top.offset(10);
        make.bottom.offset(-5);
        make.width.equalTo(_couponBtnWeak).multipliedBy(0.54);
    }];
    
    [_rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-5);
        make.top.offset(15);
        make.bottom.offset(-5);
        make.width.equalTo(_couponBtnWeak).multipliedBy(0.4);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(kLineWidth);
    }];
}

- (void)setAttributes
{
    _couponBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_couponBtn addTarget:self action:@selector(clickCouponBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _leftLbl.numberOfLines = 0;
    
    _rightLbl.numberOfLines = 0;
    _rightLbl.textAlignment = NSTextAlignmentRight;
    
    _lineView.backgroundColor = kLineWhiteColor;
}

- (void)clickCouponBtn:(UIButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(LLCouponView:clickCouponBtn:)]) {
        [_delegate LLCouponView:self clickCouponBtn:btn];
    }
}

@end
