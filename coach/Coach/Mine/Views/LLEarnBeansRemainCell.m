//
//  LLEarnBeansRemainCell.m
//  学员端
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLEarnBeansRemainCell.h"

@implementation LLEarnBeansRemainCell

#pragma mark - Setup

- (void)setUI
{
    [super setUI];
    
    _leftLbl = [UILabel new];
    [self.contentView addSubview:_leftLbl];
    
    _rightLbl = [UILabel new];
    [self.contentView addSubview:_rightLbl];
}

- (void)setContraints
{
    [super setContraints];
    
    WeakObj(_leftLbl)
    [_leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*kWidthScale);
        make.centerY.offset(0);
        make.width.offset(95*kWidthScale);
        make.height.offset(25*kHeightScale);
    }];
    
    [_rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftLblWeak.mas_right);
        make.height.centerY.equalTo(_leftLblWeak);
        make.right.offset(-15);
    }];
}

- (void)setAttributes
{
    [super setAttributes];
    
    _leftLbl.textColor = [UIColor colorWithHexString:@"666666"];
    _leftLbl.font = kFont15;
    
    _rightLbl.textColor = [UIColor colorWithHexString:@"5cb6ff"];
    _rightLbl.font = kFont16;
    _rightLbl.textAlignment = NSTextAlignmentRight;
}

@end
