//
//  ExamSendCell.m
//  Coach
//
//  Created by 翁昌青 on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "ExamSendCell.h"

@implementation ExamSendCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _value.delegate = self;
    [_value addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

- (void)textFieldDidChanged:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(ExamSendCell:textFieldDidChanged:)]) {
        [_delegate ExamSendCell:self textFieldDidChanged:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    if (_delegate && [_delegate respondsToSelector:@selector(ExamSendCell:textFieldDidEndEdited:)]) {
        [_delegate ExamSendCell:self textFieldDidEndEdited:textField];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if (_delegate && [_delegate respondsToSelector:@selector(ExamSendCell:textFieldDidBeginEdited:)]) {
        [_delegate ExamSendCell:self textFieldDidBeginEdited:textField];
    }
}

@end
