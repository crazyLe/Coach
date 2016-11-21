//
//  AppointListTableCell.m
//  Coach
//
//  Created by LL on 16/8/9.
//  Copyright © 2016年 sskz. All rights reserved.
//

#define kBgViewLeftOffset 10
#define kTopViewHeight 43

#import "AppointListTableCell.h"

@implementation AppointListTableCell

- (void)setUI
{
    _bgView = [UIView new];
    [self.contentView addSubview:_bgView];
    
    _topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-kBgViewLeftOffset*2, kTopViewHeight)];
    [_bgView addSubview:_topBgView];
    
    _numLbl = [UILabel new];
    [_topBgView addSubview:_numLbl];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_topBgView addSubview:_cancelBtn];
    
    _infoLbl = [UILabel new];
    [_bgView addSubview:_infoLbl];
    
    _timeLbl = [UILabel new];
    [_bgView addSubview:_timeLbl];
    
    _priceLbl = [UILabel new];
    [_bgView addSubview:_priceLbl];
    
    _statusLbl = [UILabel new];
    [_bgView addSubview:_statusLbl];
}

- (void)setContraints
{
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(5, kBgViewLeftOffset, 5, kBgViewLeftOffset));
    }];
    
    [_topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(kTopViewHeight);
    }];
    
    [_numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(14);
        make.right.offset(-100*kWidthScale);
    }];
    
    WeakObj(_numLbl)
    WeakObj(_timeLbl)
    [_infoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_numLblWeak);
        make.top.equalTo(_topBgView.mas_bottom).offset(10);
        make.right.offset(0);
        make.bottom.equalTo(_timeLblWeak.mas_top);
    }];
    
    [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_numLblWeak);
        make.bottom.offset(-5);
        make.width.offset(120*kWidthScale);
        make.height.offset(25);
    }];
    
    WeakObj(_statusLbl)
    [_statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(_timeLblWeak);
        make.right.offset(-15*kWidthScale);
        make.width.offset(55*kWidthScale);
    }];
    
    [_priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLblWeak.mas_right).offset(10);
        make.centerY.equalTo(_timeLblWeak);
        make.height.equalTo(_timeLblWeak);
        make.right.equalTo(_statusLblWeak.mas_left).offset(-19*kWidthScale);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(16);
        make.top.bottom.offset(0);
        make.left.equalTo(_numLblWeak.mas_right);
    }];
}

- (void)setAttributes
{
    _bgView.backgroundColor = [UIColor whiteColor];
    _topBgView.backgroundColor = [UIColor colorWithHexString:@"e6f1fe"];
    
    [_cancelBtn setTitleColor:kAppThemeColor forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13*kWidthScale];
    [_cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _infoLbl.numberOfLines = 0;
    
    _priceLbl.textColor = [UIColor colorWithHexString:@"fda800"];
    _priceLbl.font = [UIFont boldSystemFontOfSize:13*kWidthScale];
    _priceLbl.textAlignment = NSTextAlignmentRight;
    
    _statusLbl.textColor = [UIColor  colorWithHexString:@"333333"];
    _statusLbl.font = kFont13;
    
    [_topBgView addTopBorderWithHeight:kLineWidth andColor:[UIColor colorWithHexString:@"bdd0f4"]];
    [_topBgView addBottomBorderWithHeight:kLineWidth andColor:[UIColor colorWithHexString:@"bdd0f4"]];
}

- (void)clickCancelBtn:(UIButton *)cancelBtn
{
    if (_delegate && [_delegate respondsToSelector:@selector(AppointListTableCell:clickCancelBtn:)]) {
        [_delegate AppointListTableCell:self clickCancelBtn:cancelBtn];
    }
}

@end
