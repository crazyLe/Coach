//
//  ShowColNameCell.m
//  Coach
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 sskz. All rights reserved.
//

#define kSideOffset 30

#import "UIView+DrawDashLine.h"
#import "ShowColNameCell.h"

@implementation ShowColNameCell

- (void)setUI
{
    _nameLbl = [UILabel new];
    [self.contentView addSubview:_nameLbl];
    
    _statusLbl = [UILabel new];
    [self.contentView addSubview:_statusLbl];
    
    _totolNumLbl = [UILabel new];
    [self.contentView addSubview:_totolNumLbl];
    
    _setLbl = [UILabel new];
    [self.contentView addSubview:_setLbl];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(15*kWidthScale, 59, kScreenWidth-2*15*kWidthScale, kLineWidth)];
    [self.contentView addSubview:_lineView];
}

- (void)setContraints
{
    WeakObj(self)
    WeakObj(_nameLbl)
    WeakObj(_setLbl)
    WeakObj(_statusLbl)
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kSideOffset+20);
        make.centerY.equalTo(selfWeak.mas_centerY);
        make.width.offset(50*kWidthScale);
        make.height.equalTo(selfWeak);
    }];
    
    [_statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLblWeak.mas_right).offset(5);
        make.centerY.equalTo(_nameLblWeak);
        make.width.offset(60*kWidthScale);
        make.height.equalTo(_nameLblWeak);
    }];
    
    [_setLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(selfWeak).offset(-kSideOffset);
        make.centerY.equalTo(_nameLblWeak);
        make.width.offset(50*kWidthScale);
        make.height.equalTo(_nameLblWeak);
    }];
    
    [_totolNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_statusLblWeak.mas_right);
        make.right.equalTo(_setLblWeak.mas_left);
        make.centerY.height.equalTo(_nameLblWeak);
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
    _nameLbl.textColor = [UIColor colorWithHexString:@"0X646464"];
    _nameLbl.font = [UIFont boldSystemFontOfSize:15*kWidthScale];
    
    _statusLbl.textColor = [UIColor colorWithHexString:@"0X646464"];
    _statusLbl.font = [UIFont boldSystemFontOfSize:15*kWidthScale];
    _statusLbl.textAlignment = NSTextAlignmentRight;
    
    _setLbl.textColor = [UIColor colorWithHexString:@"0X646464"];
    _setLbl.font = [UIFont boldSystemFontOfSize:15*kWidthScale];
    _setLbl.textAlignment = NSTextAlignmentCenter;
    
    _totolNumLbl.textColor = [UIColor colorWithHexString:@"0X646464"];
    _totolNumLbl.font = [UIFont boldSystemFontOfSize:15*kWidthScale];
    _totolNumLbl.textAlignment = NSTextAlignmentRight;
    
    _lineView.backgroundColor = kLineWhiteColor;
//    [_lineView drawDashLineWithLineLength:3 lineSpacing:3 lineColor:kLineColor];
}

@end
