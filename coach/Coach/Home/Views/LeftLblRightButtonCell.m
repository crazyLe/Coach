//
//  LeftLblRightButtonCell.m
//  Coach
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 sskz. All rights reserved.
//

#define kLeftLblLeftOffset 10
#define kRightBtnRightOffset 0

#import "LeftLblRightButtonCell.h"

@implementation LeftLblRightButtonCell

- (void)setUI
{
    _leftLbl = [UILabel new];
    [self.contentView addSubview:_leftLbl];
    
    _rightBtn = [LLButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_rightBtn];
    
    _lineView = [UIView new];
    [self.contentView addSubview:_lineView];
}

- (void)setContraints
{
    WeakObj(self)
    WeakObj(_leftLbl)
    [_leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kLeftLblLeftOffset);
        make.top.bottom.offset(0);
        make.width.equalTo(selfWeak.mas_width).multipliedBy(0.3);
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_leftLblWeak.mas_right);
        make.width.equalTo(selfWeak).multipliedBy(0.3);
        make.top.bottom.offset(0);
        make.right.offset(-kRightBtnRightOffset);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(kLineWidth);
    }];
}

- (void)setAttributes
{
    _leftLbl.font = Font15;
    _leftLbl.textColor = [UIColor colorWithHexString:@"0X999999"];
    
    [_rightBtn setTitleColor:_leftLbl.textColor forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = _leftLbl.font;
    _rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    _rightBtn.contentMode = UIViewContentModeRight;
    [_rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchDown];

    _lineView.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_rightBtn layoutButtonWithEdgeInsetsStyle:LLButtonStyleTextLeft imageTitleSpace:3];
}

- (void)clickRightBtn:(LLButton *)rightBtn
{
    if (_delegate && [_delegate respondsToSelector:@selector(LeftLblRightButtonCell:clickRightBtn:)]) {
        [_delegate LeftLblRightButtonCell:self clickRightBtn:rightBtn];
    }
}

@end
