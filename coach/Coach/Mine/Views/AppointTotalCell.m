//
//  AppointTotalCell.m
//  Coach
//
//  Created by LL on 16/8/9.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "AppointTotalCell.h"

@implementation AppointTotalCell

#pragma mark - Setup

- (void)setUI
{
    [super setUI];
    
    _totalLbl = [UILabel new];
    [self.bgView addSubview:_totalLbl];
    
    _timeLbl = [UILabel new];
    [self.bgView addSubview:_timeLbl];
    
    _priceLbl = [UILabel new];
    [self.bgView addSubview:_priceLbl];
}

- (void)setContraints
{
    [super setContraints];
    
    [_totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kLeftLblLeftOffset+40*kWidthScale+5);
        make.top.offset(5);
        make.bottom.offset(-5);
        make.width.offset(40*kWidthScale);
    }];
    
    WeakObj(_totalLbl)
    [_priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-25*kWidthScale);
        make.width.offset(70*kWidthScale);
        make.centerY.height.equalTo(_totalLblWeak);
    }];
    
    WeakObj(_priceLbl)
    [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_totalLblWeak.mas_right);
        make.right.equalTo(_priceLblWeak.mas_left);
        make.centerY.height.equalTo(_totalLblWeak);
    }];
}

- (void)setAttributes
{
    [super setAttributes];
    
    _totalLbl.textColor = kGrayHex66;
    _totalLbl.font = kFont13;
    
    _timeLbl.textColor = kGrayHex66;
    _timeLbl.font = kFont13;
    _timeLbl.textAlignment = NSTextAlignmentCenter;
    
    _priceLbl.textColor = kAppThemeColor;
    _priceLbl.font = [UIFont boldSystemFontOfSize:13*kWidthScale];
    _priceLbl.textAlignment = NSTextAlignmentRight;
}

@end
