//
//  CoachCarRentPriceCell.m
//  Coach
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 sskz. All rights reserved.
//

#define kSideOffset 10

#import "CoachCarRentPriceCell.h"

@implementation CoachCarRentPriceCell

- (void)setUI
{
    _leftImgView = [UIImageView new];
    [self.contentView addSubview:_leftImgView];
    
    _leftLbl = [UILabel new];
    [self.contentView addSubview:_leftLbl];
    
    _rightLbl = [UILabel new];
    [self.contentView addSubview:_rightLbl];
    
    _lineView = [UIView new];
    [self.contentView addSubview:_lineView];
}

- (void)setContraints
{
    WeakObj(self)
    WeakObj(_leftImgView)
    WeakObj(_leftLbl)
    [_leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kSideOffset);
        make.top.offset(20);
        make.width.height.offset(18);
    }];
    
    [_leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImgViewWeak.mas_right).offset(5);
        make.centerY.equalTo(_leftImgViewWeak);
        make.height.equalTo(selfWeak);
        make.width.offset(40);
    }];
    
    [_rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftLblWeak.mas_right);
        make.right.offset(0);
        make.top.offset(0);
        make.bottom.offset(-1);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.offset(kSideOffset);
        make.right.offset(-kSideOffset);
        make.height.offset(kLineWidth);
    }];
}

- (void)setAttributes
{
    _leftLbl.textColor = [UIColor colorWithHexString:@"0X999999"];
    _leftLbl.font = Font14;
    
    _rightLbl.textColor = [UIColor colorWithHexString:@"0X646464"];
    _rightLbl.font = Font14;
    _rightLbl.numberOfLines = 0;
    
    _lineView.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
}

@end
