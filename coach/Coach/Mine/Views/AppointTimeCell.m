//
//  AppointTimeCell.m
//  Coach
//
//  Created by LL on 16/8/9.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "AppointTimeCell.h"

@implementation AppointTimeCell
#pragma mark - Setup

- (void)setUI
{
    [super setUI];
    
    _titleLbl = [UILabel new];
    [self.bgView addSubview:_titleLbl];
    
    _timeLbl = [UILabel new];
    [self.bgView addSubview:_timeLbl];
    
    _priceLbl = [UILabel new];
    [self.bgView addSubview:_priceLbl];
}

- (void)setContraints
{
    [super setContraints];
    
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kLeftLblLeftOffset);
        make.width.offset(40*kWidthScale);
        make.top.offset(5);
        make.bottom.offset(-5);
    }];
    
    WeakObj(_titleLbl)
    WeakObj(_priceLbl)
    [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLblWeak.mas_right).offset(0);
        make.centerY.height.equalTo(_titleLblWeak);
        make.right.equalTo(_priceLblWeak.mas_left);
    }];
    
    [_priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-25*kWidthScale);
        make.width.offset(60*kWidthScale);
        make.centerY.height.equalTo(_titleLblWeak);
    }];
    
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kLeftLblLeftOffset+40*kWidthScale+5);
        make.right.offset(-25*kWidthScale);
    }];
}

- (void)setAttributes
{
    [super setAttributes];
    
    _titleLbl.textColor = kGrayHex99;
    _titleLbl.font = kFont13;
    
    _timeLbl.textColor = kGrayHex66;
    _timeLbl.font = kFont13;
    
    _priceLbl.textColor = kAppThemeColor;
    _priceLbl.font = kFont13;
    _priceLbl.textAlignment = NSTextAlignmentRight;
}

@end
