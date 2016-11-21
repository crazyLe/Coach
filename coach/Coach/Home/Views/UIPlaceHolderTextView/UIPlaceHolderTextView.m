//
//  UIPlaceHolderTextView.m
//  quHaoIos
//
//  Created by yexin on 15/11/5.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "UIPlaceHolderTextView.h"

@implementation UIPlaceHolderTextView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    [self addObserver];
}

#pragma mark 注册通知
- (void)addObserver{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:self];
}

#pragma mark 移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark 开始编辑
- (void)textDidBeginEditing:(NSNotification *)notification{
    if ([super.text isEqualToString:_placeholder]) {
        super.text = @"";
        [super setTextColor:[UIColor blackColor]];
    }
}

#pragma mark 结束编辑
- (void)textDidEndEditing:(NSNotification *)notification{
    if (super.text.length == 0) {
        super.text = _placeholder;
        //如果文本框内是原本的提示文字,则显示灰色字体
        [super setTextColor:[UIColor lightGrayColor]];
    }
}

#pragma mark 重写setPlaceholder方法

- (void)setPlaceholder:(NSString *)aplaceholder{
    _placeholder = aplaceholder;
    [self textDidEndEditing:nil];
}

#pragma mark重写getText方法
- (NSString *)text{
    NSString * text = [super text];
    if ([text isEqualToString:_placeholder]) {
        return @"";
    }
    return text;
}

@end
