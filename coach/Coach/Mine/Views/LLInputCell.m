//
//  LLInputCell.m
//  Coach
//
//  Created by apple on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLInputCell.h"

@implementation LLInputCell

#pragma mark - Setup

- (void)setUI
{
    [super setUI];
    
    _bgView = [UIView new];
    [self.contentView addSubview:_bgView];
    
    _textView = [SZTextView new];
    [_bgView addSubview:_textView];
    
    _promptLbl = [UILabel new];
    [_bgView addSubview:_promptLbl];
}

- (void)setContraints
{
    [super setContraints];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.bottom.offset(0);
        make.width.offset(60);
        make.height.offset(30);
    }];
}

- (void)setAttributes
{
    [super setAttributes];
    
    _textView.placeholderTextColor = [UIColor colorWithHexString:@"c8c8c8"];
    _textView.font = kFont15;
    _textView.delegate = self;
    
    _promptLbl.textColor = [UIColor colorWithHexString:@"c8c8c8"];
    _promptLbl.font = kFont12;
    _promptLbl.textAlignment = NSTextAlignmentRight;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView;
{
    if (_delegate && [_delegate respondsToSelector:@selector(LLInputCell:textViewDidBeginEditing:)]) {
        [_delegate LLInputCell:self textViewDidBeginEditing:textView];
    }
    [self refreshPromptLbl];
}

- (void)textViewDidEndEditing:(UITextView *)textView;
{
    if (_delegate && [_delegate respondsToSelector:@selector(LLInputCell:textViewDidEndEditing:)]) {
        [_delegate LLInputCell:self textViewDidEndEditing:textView];
    }
    [self refreshPromptLbl];
}

- (void)textViewDidChange:(UITextView *)textView;
{
    if (_textView.text.length > _maxInputNum) {
        _textView.text = [_textView.text substringToIndex:_maxInputNum];
    }
    [self refreshPromptLbl];
    if (_delegate && [_delegate respondsToSelector:@selector(LLInputCell:textViewDidChange:)]) {
        [_delegate LLInputCell:self textViewDidChange:textView];
    }
}

- (void)refreshPromptLbl
{
    _promptLbl.text = [NSString stringWithFormat:@"%ld/%ld",_textView.text.length,_maxInputNum];
}

@end
