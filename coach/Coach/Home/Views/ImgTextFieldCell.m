//
//  ImgTextFieldCell.m
//  Coach
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 sskz. All rights reserved.
//

#define kImgLeftOffset 15

#import "ImgTextFieldCell.h"

@implementation ImgTextFieldCell

- (void)setUI
{
    _leftLbl  = [UILabel new];
    [self.contentView addSubview:_leftLbl];
    
    _textField = [[UITextField alloc] init];
    [self.contentView addSubview:_textField];
    
    _lineView = [UIView new];
    [self.contentView addSubview:_lineView];
    
}

- (void)setContraints
{
    WeakObj(self)
    WeakObj(_leftLbl)
    WeakObj(_textField)
    [_leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kImgLeftOffset);
        make.centerY.equalTo(selfWeak.mas_centerY);
        make.width.offset(120);
        make.height.equalTo(selfWeak);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftLblWeak.mas_right);
        make.top.bottom.offset(0);
        make.right.offset(-(kImgLeftOffset+10+60*0.35));
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftLblWeak.mas_left);
        make.top.equalTo(_textFieldWeak.mas_bottom);
        make.right.offset(-kImgLeftOffset);
        make.height.offset(kLineWidth);
    }];
    
}

- (void)setAttributes
{
    [_textField setValue:[UIColor colorWithHexString:@"888888"] forKeyPath:@"_placeholderLabel.textColor"];
    [_textField setValue:Font15 forKeyPath:@"_placeholderLabel.font"];
    _textField.textAlignment = NSTextAlignmentRight;
    [_textField addTarget:self action:@selector(textFieldDidEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    _textField.delegate = self;
    
    _lineView.backgroundColor = kLineWhiteColor;
}

//懒加载
- (UIButton *)accessoryBtn
{
    if (!_accessoryBtn) {
        _accessoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _accessoryBtn.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_accessoryBtn];
        [_accessoryBtn addTarget:self action:@selector(clickAccessoryBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        WeakObj(self)
        [_accessoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-kImgLeftOffset);
            make.centerY.equalTo(selfWeak.mas_centerY);
            make.width.height.equalTo(self.mas_height).multipliedBy(0.35);
        }];
    }
    return _accessoryBtn;
}

- (void)clickAccessoryBtn:(UIButton *)accessoryBtn
{
    if (_delegate && [_delegate respondsToSelector:@selector(ImgTextFieldCell:clickAccessoryBtn:)]) {
        [_delegate ImgTextFieldCell:self clickAccessoryBtn:accessoryBtn];
    }
}

- (void)textFieldDidEditingChanged:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(ImgTextFieldCell:textFieldDidEditingChanged:)]) {
        [_delegate ImgTextFieldCell:self textFieldDidEditingChanged:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    if (_delegate && [_delegate respondsToSelector:@selector(ImgTextFieldCell:textFieldDidEndEditing:)]) {
        [_delegate ImgTextFieldCell:self textFieldDidEndEditing:textField];
    }
}

@end
