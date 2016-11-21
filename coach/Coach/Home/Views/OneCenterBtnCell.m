//
//  OneCenterBtnCell.m
//  Coach
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "OneCenterBtnCell.h"

@implementation OneCenterBtnCell

- (void)setUI
{
    _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_centerBtn];
}

- (void)setContraints
{
    WeakObj(self)
    [_centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(selfWeak.contentView);
        make.width.offset(kScreenWidth*0.8);
        make.height.equalTo(selfWeak.contentView.mas_height).multipliedBy(0.6f);
    }];
}

- (void)setAttributes
{
    [_centerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_centerBtn setBackgroundColor:[UIColor colorWithHexString:@"2e83ff"]];
    _centerBtn.layer.cornerRadius = 20;
    _centerBtn.layer.masksToBounds = YES;
    [_centerBtn addTarget:self action:@selector(clickCenterBtn:) forControlEvents:UIControlEventTouchUpInside];
    _centerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
}

- (void)clickCenterBtn:(UIButton *)centerBtn
{
    if (_delegate && [_delegate respondsToSelector:@selector(centerBtnCell:clickCenterBtn:)]) {
        [_delegate centerBtnCell:self clickCenterBtn:centerBtn];
    }
}

@end
