//
//  AppointHeaderCell.m
//  Coach
//
//  Created by LL on 16/8/9.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "AppointHeaderCell.h"

@implementation AppointHeaderCell
#pragma mark - Setup

- (void)setUI
{
    [super setUI];
    
    _bgImgView = [UIImageView new];
    [self.contentView addSubview:_bgImgView];
    
    _titleLbl = [UILabel new];
    [self.contentView addSubview:_titleLbl];
    
    _numLbl = [UILabel new];
    [self.contentView addSubview:_numLbl];
}

- (void)setContraints
{
    [super setContraints];
    
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
    }];
    
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(17*kHeightScale);
        make.width.offset(kScreenWidth*0.7);
        make.height.offset(20);
    }];
    
    WeakObj(_titleLbl)
    [_numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.height.equalTo(_titleLblWeak);
        make.top.equalTo(_titleLblWeak.mas_bottom).offset(5);
    }];
}

- (void)setAttributes
{
    [super setAttributes];
    
    self.backgroundColor = [UIColor clearColor];
    _bgImgView.image = [UIImage imageNamed:@"iconfont-appointtopbg"];
    
    _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
    _titleLbl.font = kFont16;
    _titleLbl.textAlignment = NSTextAlignmentCenter;
    
    _numLbl.textAlignment = NSTextAlignmentCenter;
}

@end
