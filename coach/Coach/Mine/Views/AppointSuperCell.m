//
//  AppointSuperCell.m
//  Coach
//
//  Created by LL on 16/8/9.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "AppointSuperCell.h"

@implementation AppointSuperCell

#pragma mark - Setup

- (void)setUI
{
    [super setUI];
    
    _bgView = [UIView new];
    [self.contentView addSubview:_bgView];
    
     _lineView = [UIView new];
    [_bgView addSubview:_lineView];
}

- (void)setContraints
{
    [super setContraints];
    
    CGFloat bgViewOffset = 0;
    if (IS_IPHONE_4_OR_LESS) {
        bgViewOffset = 13;
    }
    else if(IS_IPHONE_5)
    {
        bgViewOffset = 13;
    }
    else if (IS_IPHONE_6)
    {
        bgViewOffset = 14;
    }
    else if(IS_IPHONE_6P)
    {
        bgViewOffset = 15;
    }
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, bgViewOffset, 0, bgViewOffset));
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kLeftLblLeftOffset+5);
        make.bottom.offset(0);
        make.right.offset(-(kLeftLblLeftOffset+5));
        make.height.offset(kLineWidth);
    }];
}

- (void)setAttributes
{
    [super setAttributes];
    
    self.backgroundColor = [UIColor clearColor];
    _bgView.backgroundColor = rgb(253, 254, 255);
    
    _lineView.backgroundColor = kLineWhiteColor;
}

@end
