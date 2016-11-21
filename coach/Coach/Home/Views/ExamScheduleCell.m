//
//  ExamScheduleCell.m
//  Coach
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "UIView+DrawDashLine.h"
#import "ExamScheduleCell.h"

@implementation ExamScheduleCell


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
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-kSideOffset*2, kLineWidth)];
    [self.contentView addSubview:_lineView];
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
        make.width.offset(60);
        make.height.offset(27);
    }];
    
    [_phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_notifyBtnWeak.mas_left).offset(-30);
        make.height.equalTo(_notifyBtnWeak.mas_height);
//        make.width.equalTo(_headBtnWeak.mas_width);
        make.width.equalTo(_stageLblWeak);
        make.centerY.equalTo(_headBtnWeak.mas_centerY);
    }];
    
    [_stageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLblWeak.mas_right);
        make.right.equalTo(_phoneBtnWeak.mas_left);
        make.height.centerY.equalTo(_headBtnWeak);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kSideOffset);
        make.right.offset(-kSideOffset);
        make.bottom.offset(0);
        make.height.offset(kLineWidth);
    }];
}

- (void)setAttributes
{
    _headBtn.clipsToBounds = YES;
    _headBtn.contentMode = UIViewContentModeScaleAspectFill;
    [_headBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _headBtn.tag = 10;
    
    _nameLbl.textColor = [UIColor colorWithHexString:@"0X646464"];
    _nameLbl.font = Font15;
    
    _stageLbl.textColor = [UIColor colorWithHexString:@"0Xc8c8c8"];
    _stageLbl.font = Font15;
    
    _phoneBtn.contentMode = UIViewContentModeCenter;
    [_phoneBtn setTitleColor:kOrangeColor forState:UIControlStateNormal];
    [_phoneBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _phoneBtn.tag = 11;
    
    _notifyBtn.titleLabel.font = Font15;
    _notifyBtn.layer.cornerRadius = 3;
    _notifyBtn.layer.masksToBounds = YES;
    [_notifyBtn  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_notifyBtn setTitleColor:[UIColor colorWithHexString:@"c8c8c8"] forState:UIControlStateSelected];
    [_notifyBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _notifyBtn.tag = 12;
    
    _lineView.hidden = YES;
    _lineView.backgroundColor = kLineWhiteColor;
//    [_lineView drawDashLineWithLineLength:3 lineSpacing:3 lineColor:kLineWhiteColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _headBtn.layer.cornerRadius = _headBtn.frame.size.width/2;
}

- (void)clickBtn:(UIButton *)btn
{
    switch (btn.tag) {
        case 10:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(ExamScheduleCell:clickHeadBtn:)]) {
                [_delegate ExamScheduleCell:self clickHeadBtn:btn];
            }
        }
            break;
        case 11:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(ExamScheduleCell:clickPhoneBtn:)]) {
                [_delegate ExamScheduleCell:self clickPhoneBtn:btn];
            }
        }
            break;
        case 12:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(ExamScheduleCell:clickNotifyBtn:)]) {
                [_delegate ExamScheduleCell:self clickNotifyBtn:btn];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
