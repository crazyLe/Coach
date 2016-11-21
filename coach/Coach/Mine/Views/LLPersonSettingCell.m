//
//  LLPersonSettingCell.m
//  Coach
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLPersonSettingCell.h"

@implementation LLPersonSettingCell

#pragma mark - Setup

- (void)setUI
{
    [super setUI];
    
    _leftLbl = [UILabel new];
    [self.contentView addSubview:_leftLbl];
    
    _rightTF = [[UITextField alloc] init];
    [self.contentView addSubview:_rightTF];
    
    _accessoryImgView = [UIImageView new];
    [self.contentView addSubview:_accessoryImgView];
    
    _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_headBtn];
    
    _lineView = [UIView new];
    [self.contentView addSubview:_lineView];
}

- (void)setContraints
{
    [super setContraints];
    
    WeakObj(self)
    WeakObj(_accessoryImgView)
    WeakObj(_rightTF)
    [_leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
        make.height.equalTo(selfWeak);
        make.width.offset(60);
    }];
    
    [_accessoryImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.width.height.offset(20);
        make.centerY.offset(0);
    }];
    
    [_rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_accessoryImgViewWeak.mas_left).offset(-7);
        make.left.equalTo(_leftLbl.mas_right);
        make.centerY.offset(0);
        make.height.equalTo(selfWeak);
    }];
    
    [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rightTFWeak);
        make.centerY.offset(0);
        make.width.height.equalTo(selfWeak.mas_height).multipliedBy(0.75f);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.offset(kLineWidth);
    }];
}

- (void)setAttributes
{
    [super setAttributes];
    
    _leftLbl.textColor = [UIColor colorWithHexString:@"666666"];
    _leftLbl.font = kFont15;
    
    _rightTF.textColor = [UIColor colorWithHexString:@"666666"];
    _rightTF.font = _leftLbl.font;
    _rightTF.textAlignment = NSTextAlignmentRight;
    [_rightTF addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    _headBtn.layer.masksToBounds = YES;
    [_headBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _headBtn.layer.cornerRadius = self.frame.size.height*0.75f/2;
    
    _accessoryImgView.contentMode = UIViewContentModeCenter;
    
    _lineView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
}

- (void)textFieldEditingChanged:(UITextField *)textField;
{
    if (_delegate && [_delegate respondsToSelector:@selector(LLPersonSettingCell:textFieldDidChange:)]) {
        [_delegate LLPersonSettingCell:self textFieldDidChange:textField];
    }
}

- (void)clickBtn:(UIButton *)headBtn
{
    if (_delegate && [_delegate respondsToSelector:@selector(LLPersonSettingCell:clickHeadBtn:)]) {
        [_delegate LLPersonSettingCell:self clickHeadBtn:headBtn];
    }
}

@end
