//
//  LLInputView.m
//  Coach
//
//  Created by apple on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLInputView.h"

@implementation LLInputView

- (id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self setUI];
        [self setConstraints];
        [self setAttributes];
    }
    return self;
}

- (void)setUI
{
    _bgView = [UIView new];
    [self addSubview:_bgView];
    
    _titleLbl = [UILabel new];
    [_bgView addSubview:_titleLbl];
    
    _textField = [UITextField new];
    [_bgView addSubview:_textField];
    
    _accessoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_accessoryBtn];
    
    _unitLbl = [UILabel new];
    [_bgView addSubview:_unitLbl];
}

- (void)setConstraints
{
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    WeakObj(_bgView)
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12*kWidthScale);
        make.width.offset(45*kWidthScale);
        make.centerY.offset(0);
        make.height.equalTo(_bgViewWeak);
    }];
    
    WeakObj(_titleLbl)
    [_unitLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-12*kWidthScale);
        make.centerY.height.equalTo(_titleLblWeak);
        make.width.offset(40);
    }];
    
    WeakObj(_unitLbl)
    [_accessoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_unitLblWeak.mas_left).offset(20);
        make.height.centerY.equalTo(_unitLblWeak);
        make.width.offset(15);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLblWeak.mas_right).offset(-5);
        make.right.equalTo(_unitLblWeak.mas_left);
        make.centerY.height.equalTo(_titleLblWeak);
    }];
}

- (void)setAttributes
{
    _bgView.layer.cornerRadius = 5.0f;
    _bgView.layer.borderColor = [UIColor colorWithHexString:@"f0f0f0"].CGColor;
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.borderWidth = 1.0f;
    
    _titleLbl.textColor = [UIColor colorWithHexString:@"4c4c4c"];
    _titleLbl.font = [UIFont boldSystemFontOfSize:14*kWidthScale];
    
    _textField.textColor = _titleLbl.textColor;
    _textField.font = _titleLbl.font;
    _textField.textAlignment = NSTextAlignmentRight;
    _textField.delegate = self;
    [_textField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    _accessoryBtn.contentMode = UIViewContentModeCenter;
    [_accessoryBtn setImage:[UIImage imageNamed:@"iconfont-meexit"] forState:UIControlStateNormal];
    _accessoryBtn.hidden = YES;
    [_accessoryBtn addTarget:self action:@selector(clickAccessoryBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _unitLbl.textColor = _titleLbl.textColor;
    _unitLbl.font = _titleLbl.font;
    
    _unitLbl.textAlignment = NSTextAlignmentRight;
}

- (void)textFieldEditChanged:(UITextField *)textField
{
    _accessoryBtn.hidden = textField.text.length == 0;
    if (_delegate && [_delegate respondsToSelector:@selector(LLInputView:textFieldEditChanged:)]) {
        [_delegate LLInputView:self textFieldEditChanged:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text isEqualToString:@"0"]&&[string isEqualToString:@"0"]) {
        return NO;
    }
    
    if (([textField.text rangeOfString:@"."].location != NSNotFound) && ([string rangeOfString:@"."].location != NSNotFound)) {
        return NO;
    }
    
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    
//    if ([futureString integerValue]>999999) {
//        return NO;
//    }
    
    NSInteger flag=0;
    const NSInteger limited = 1;  //小数点  限制输入两位
    for (int i = futureString.length-1; i>=0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            
            if (flag > limited) {
                return NO;
            }
            
            break;
        }
        flag++;
    }
    
    return YES;
}

- (void)clickAccessoryBtn:(UIButton *)accessoryBtn
{
    _textField.text = @"";
    [self textFieldEditChanged:_textField];
}

@end
