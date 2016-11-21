//
//  AppointInfoCell.m
//  Coach
//
//  Created by LL on 16/8/9.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "AppointInfoCell.h"

@implementation AppointInfoCell
#pragma mark - Setup

- (void)setUI
{
    [super setUI];
    
    _infoLbl = [UILabel new];
    [self.bgView addSubview:_infoLbl];
    
    _flagImgView  = [UIImageView new];
    [self.bgView addSubview:_flagImgView];
}

- (void)setContraints
{
    [super setContraints];
    
    [_infoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kLeftLblLeftOffset);
        make.top.offset(10*kHeightScale);
        make.bottom.offset(-10*kHeightScale);
        make.width.offset(175*kWidthScale);
    }];
    
    WeakObj(_infoLbl)
    WeakObj(_flagImgView)
    [_flagImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_infoLblWeak.mas_right);
        make.right.offset(-15);
        make.top.offset(20);
        make.height.equalTo(_flagImgViewWeak.mas_width).multipliedBy(0.7);
//        make.bottom.offset(-25);
    }];
}

- (void)setAttributes
{
    [super setAttributes];
    
    _infoLbl.numberOfLines = 0;
}

@end
