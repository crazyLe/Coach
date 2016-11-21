//
//  LeftLblRightTFCell.m
//  Coach
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 sskz. All rights reserved.
//

#define kLeftLblLeftOffset 10
#define kRightTFRightOffset 10

#import "LeftLblRightTFCell.h"

@implementation LeftLblRightTFCell

- (void)setUI
{
    _leftLbl = [UILabel new];
    [self.contentView addSubview:_leftLbl];
    
    _rightTF = [UITextField new];
    [self.contentView addSubview:_rightTF];
    
    _lineView = [UIView new];
    [self.contentView addSubview:_lineView];
    
    _accessoryImgView = [UIImageView new];
    [self.contentView addSubview:_accessoryImgView];
}

- (void)setContraints
{
    WeakObj(self)
    WeakObj(_leftLbl)
    WeakObj(_rightTF)
    WeakObj(_accessoryImgView)
    [_leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kLeftLblLeftOffset);
        make.top.bottom.offset(0);
        make.width.equalTo(selfWeak.mas_width).multipliedBy(0.4);
    }];
    
    [_rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftLblWeak.mas_right);
        make.top.bottom.offset(0);
        make.right.equalTo(_accessoryImgViewWeak.mas_left);
    }];
    
    [_accessoryImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-kRightTFRightOffset);
        make.centerY.equalTo(_rightTFWeak);
        make.width.height.offset(15);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(0.5f);
    }];
}

- (void)setAttributes
{
    _leftLbl.font = Font15;
    _leftLbl.textColor = [UIColor colorWithHexString:@"0X999999"];
    
    [_rightTF setValue:_leftLbl.textColor forKeyPath:@"_placeholderLabel.textColor"];
    [_rightTF setValue:_leftLbl.font forKeyPath:@"_placeholderLabel.font"];
    
    _rightTF.textColor = [UIColor colorWithHexString:@"0X646464"];
    _rightTF.font = _leftLbl.font;
    _rightTF.textAlignment = NSTextAlignmentRight;
    [_rightTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _rightTF.delegate = self;
    
    _lineView.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(LeftLblRightTFCell:textFieldDidChange:)]) {
        [_delegate LeftLblRightTFCell:self textFieldDidChange:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    if (_delegate && [_delegate respondsToSelector:@selector(LeftLblRightTFCell:textFieldDidEndEditing:)]) {
        [_delegate LeftLblRightTFCell:self textFieldDidEndEditing:textField];
    }
}

@end
