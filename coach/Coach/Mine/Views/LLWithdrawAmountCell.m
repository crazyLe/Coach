//
//  LLWithdrawAmountCell.m
//  学员端
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLWithdrawAmountCell.h"

@implementation LLWithdrawAmountCell

#pragma mark - Setup

- (void)setUI
{
    [super setUI];
    
    _leftLbl = [UILabel new];
    [self.contentView addSubview:_leftLbl];

    _textField = [UITextField new];
    [self.contentView addSubview:_textField];
    
    _accessoryImgView = [UIImageView new];
    [self.contentView addSubview:_accessoryImgView];
}

- (void)setContraints
{
    [super setContraints];
    
    [_leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*kWidthScale);
        make.centerY.offset(0);
        make.height.equalTo(self);
        make.width.offset(80*kWidthScale);
    }];
    
    WeakObj(_leftLbl)
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftLblWeak.mas_right);
        make.centerY.height.equalTo(_leftLblWeak);
        make.right.offset(-15*kWidthScale);
    }];
    
    WeakObj(_textField)
    [_accessoryImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_textFieldWeak);
        make.right.offset(-8*kWidthScale);
        make.width.height.offset(30);
    }];
}

- (void)setAttributes
{
    [super setAttributes];
    
    _leftLbl.textColor = [UIColor colorWithHexString:@"666666"];
    _leftLbl.font = kFont15;
    
    [_textField setValue:[UIColor colorWithHexString:@"c8c8c8"] forKeyPath:@"_placeholderLabel.textColor"];
    [_textField setValue:kFont15 forKeyPath:@"_placeholderLabel.font"];
    _textField.textAlignment = NSTextAlignmentRight;
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _accessoryImgView.contentMode = UIViewContentModeCenter;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(LLWithdrawAmountCell:textFieldDidChange:)]) {
        [_delegate LLWithdrawAmountCell:self textFieldDidChange:textField];
    }
}

@end
