//
//  LLCarAreaSuperCell.m
//  Coach
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#define kLeftOffset 11

#import "LLCarAreaSuperCell.h"

@implementation LLCarAreaSuperCell

#pragma mark - Setup

- (void)setUI
{
    [super setUI];
    
    _titleLbl = [UILabel new];
    [self.contentView addSubview:_titleLbl];
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kLeftOffset);
        make.top.offset(5);
        make.width.offset(kScreenWidth/2);
        make.height.offset(20);
    }];
    
    WeakObj(_titleLbl)
    _bgView = [UIView new];
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLblWeak);
        make.top.equalTo(_titleLblWeak.mas_bottom).offset(10);
        make.right.offset(-kLeftOffset);
        make.bottom.offset(-5);
    }];
    _bgView.layer.borderWidth = 0.5f;
    _bgView.layer.borderColor = [UIColor colorWithHexString:@"e7e7e7"].CGColor;
}


@end
