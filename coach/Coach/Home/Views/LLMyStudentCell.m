//
//  LLMyStudentCell.m
//  Coach
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 sskz. All rights reserved.
//

#define kSideOffset 10

#import "LLMyStudentCell.h"

@implementation LLMyStudentCell

#pragma mark - Setup

- (void)setUI
{
    _headBtn = [UIButton  new];
    [self.contentView addSubview:_headBtn];
    
    _nameLbl = [UILabel  new];
    [self.contentView addSubview:_nameLbl];
    
    _stageLbl = [UILabel new];
    [self.contentView addSubview:_stageLbl];
    
    _phoneBtn = [UIButton new];
    [self.contentView addSubview:_phoneBtn] ;
    
    _notifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_notifyBtn];
    
    _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_settingBtn];
    
    _promptLbl = [UILabel new];
    [self.contentView addSubview:_promptLbl];
    
    _lineView = [UIView new];
    [self.contentView addSubview:_lineView];
    
    _topLine = [UIView new];
    [self.contentView addSubview:_topLine];
}

- (void)setContraints
{
    WeakObj(self)
    WeakObj(_headBtn)
    WeakObj(_nameLbl)
    WeakObj(_notifyBtn)
    WeakObj(_phoneBtn)
    WeakObj(_stageLbl)
    
    [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selfWeak.contentView.mas_centerY);
        make.left.offset(kSideOffset);
        make.width.height.equalTo(selfWeak.mas_height).multipliedBy(0.65);
    }];
    
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headBtnWeak.mas_right).offset(10);
        make.width.height.equalTo(_headBtnWeak.mas_width);
        make.centerY.equalTo(_headBtnWeak.mas_centerY);
    }];
    
    [_notifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-kSideOffset);
        make.centerY.equalTo(_headBtnWeak.mas_centerY);
        make.width.offset(49);
        make.height.offset(27);
    }];
    
    [_phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_stageLblWeak.mas_right).offset(10);
        make.width.equalTo(_phoneBtnWeak.mas_height);
        make.centerY.equalTo(_headBtnWeak.mas_centerY);
    }];
    
    [_stageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLblWeak.mas_right);
        make.width.offset(60);
        make.height.centerY.equalTo(_headBtnWeak);
    }];
    
    [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_phoneBtnWeak.mas_right);
        make.right.equalTo(_notifyBtnWeak.mas_left);
        make.centerY.equalTo(_notifyBtnWeak);
        make.height.equalTo(_phoneBtnWeak);
        make.width.equalTo(_phoneBtnWeak.mas_height);
    }];
    
    [_promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLblWeak);
        make.right.equalTo(_notifyBtnWeak);
        make.bottom.offset(0);
        make.height.offset(20);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kSideOffset);
        make.right.offset(-kSideOffset);
        make.bottom.offset(0);
        make.height.offset(kLineWidth);
    }];
    
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(kLineWidth);
    }];
}

- (void)setAttributes
{
    _headBtn.clipsToBounds = YES;
    _headBtn.contentMode = UIViewContentModeScaleAspectFill;
    _headBtn.tag = LLMyStudentCellBtnTagHead;
    [_phoneBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _nameLbl.textColor = kGrayHex66;
    _nameLbl.font = Font15;
    
    _stageLbl.textColor = kGrayHex88;
    _stageLbl.font = Font15;
    
//    _phoneBtn.contentMode = UIViewContentModeCenter;
    [_phoneBtn setTitleColor:kOrangeColor forState:UIControlStateNormal];
    _phoneBtn.tag = LLMyStudentCellBtnTagPhone;
    [_phoneBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_settingBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _settingBtn.tag = LLMyStudentCellBtnTagSetting;
    
    _notifyBtn.titleLabel.font = Font15;
    _notifyBtn.backgroundColor = [UIColor colorWithHexString:@"6cc13d"];
    _notifyBtn.layer.cornerRadius = 3;
    _notifyBtn.layer.masksToBounds = YES;
    [_notifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_notifyBtn setTitleColor:kGrayHex88 forState:UIControlStateSelected];
    [_notifyBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _notifyBtn.tag = LLMyStudentCellBtnTagInvite;
    
    _promptLbl.textColor = kGrayHex88;
    _promptLbl.font = Font12;
    
    _lineView.backgroundColor = kLineWhiteColor;
    _lineView.hidden = YES;
    
    _settingBtn.contentMode = UIViewContentModeScaleAspectFit;
    _phoneBtn.contentMode = UIViewContentModeScaleAspectFit;
    
    _topLine.backgroundColor = kLineGrayColor;
    _topLine.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _headBtn.layer.cornerRadius = _headBtn.frame.size.width/2;
    
    
}

- (void)clickBtn:(UIButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(LLMyStudentCell:clickBtn:)]) {
        [_delegate LLMyStudentCell:self clickBtn:btn];
    }
}

@end
