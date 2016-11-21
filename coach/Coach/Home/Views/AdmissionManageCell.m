//
//  AdmissionManageCell.m
//  Coach
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 sskz. All rights reserved.
//

#define kSideOffset 15

#import "UIView+DrawDashLine.h"
#import "AdmissionManageCell.h"

@implementation AdmissionManageCell

- (void)setUI
{
    _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_headBtn];
    
    _nameLbl = [UILabel new];
    [self.contentView addSubview:_nameLbl];
    
    _statusLbl = [UILabel new];
    [self.contentView addSubview:_statusLbl];
    
    _totolNumLbl = [UILabel new];
    [self.contentView addSubview:_totolNumLbl];
    
    _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_phoneBtn];
    
    _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_setBtn];
    
    _lineView = [UIView new];
    [self.contentView addSubview:_lineView];
}

- (void)setContraints
{
    WeakObj(self)
    WeakObj(_headBtn)
    WeakObj(_nameLbl)
    WeakObj(_statusLbl)
    WeakObj(_setBtn)
    WeakObj(_phoneBtn)
   [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.offset(kSideOffset);
       make.width.height.equalTo(selfWeak.mas_height).multipliedBy(0.6);
       make.centerY.equalTo(selfWeak);
   }];
    
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headBtnWeak.mas_right).offset(10);
        make.centerY.equalTo(_headBtnWeak);
        make.height.equalTo(selfWeak);
        make.width.offset(55*kWidthScale);
    }];
    
    [_statusLbl  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLblWeak.mas_right);
        make.centerY.equalTo(_headBtnWeak);
        make.width.offset(65*kWidthScale);
        make.height.equalTo(_headBtnWeak);
    }];
    
    [_setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-kSideOffset);
        make.width.equalTo(selfWeak.mas_height).multipliedBy(0.45);
        make.height.equalTo(selfWeak);
        make.centerY.equalTo(_headBtnWeak);
    }];
    
    [_phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_setBtnWeak.mas_left).offset(-10*kWidthScale);
        make.width.equalTo(_setBtnWeak);
        make.height.equalTo(selfWeak);
        make.centerY.equalTo(_headBtnWeak);
    }];
    
    [_totolNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_statusLblWeak.mas_right);
        make.centerY.equalTo(_headBtnWeak);
        make.right.equalTo(_phoneBtnWeak.mas_left);
        make.height.equalTo(selfWeak);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(kLineWidth);
    }];
}

- (void)setAttributes
{
    _headBtn.layer.masksToBounds = YES;
    _headBtn.tag = 10;
    [_headBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _nameLbl.textColor = [UIColor colorWithHexString:@"0X646464"];
    _nameLbl.font = [UIFont boldSystemFontOfSize:15*kWidthScale];
    
    _statusLbl.textColor = [UIColor colorWithHexString:@"0Xc8c8c8"];
    _statusLbl.font = [UIFont boldSystemFontOfSize:15*kWidthScale];
    _statusLbl.textAlignment = NSTextAlignmentCenter;
    
    _totolNumLbl.textColor = kOrangeColor;
    _totolNumLbl.font = [UIFont boldSystemFontOfSize:15*kWidthScale];
    _totolNumLbl.textAlignment = NSTextAlignmentCenter;
    
    _phoneBtn.contentMode = UIViewContentModeCenter;
    _phoneBtn.tag = 20;
    [_phoneBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _setBtn.contentMode = UIViewContentModeCenter;
    _setBtn.tag = 30;
    [_setBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];

    _lineView.backgroundColor = kLineWhiteColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _headBtn.layer.cornerRadius = _headBtn.frame.size.width/2;
    
//    [_lineView drawDashLineWithLineLength:3 lineSpacing:3 lineColor:kLineColor];
}

- (void)clickBtn:(UIButton *)button
{
    switch (button.tag) {
        case 10:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(AdmissionManageCell:clickHeadBtn:)]) {
                [_delegate AdmissionManageCell:self clickHeadBtn:button];
            }
        }
            break;
        case 20:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(AdmissionManageCell:clickPhoneBtn:)]) {
                [_delegate AdmissionManageCell:self clickPhoneBtn:button];
            }
        }
            break;
        case 30:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(AdmissionManageCell:clickSetBtn:)]) {
                [_delegate AdmissionManageCell:self clickSetBtn:button];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
