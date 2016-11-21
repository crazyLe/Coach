//
//  SectionHeaderCell.m
//  Coach
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "SectionHeaderCell.h"

@implementation SectionHeaderCell

- (void)setUI
{
    _sepView = [UIView new];
    [self.contentView addSubview:_sepView];
    
    _titleLbl = [UILabel new];
    [self.contentView addSubview:_titleLbl];
    
    _lineView = [UIView new];
    [self.contentView addSubview:_lineView];
}

- (void)setContraints
{
    WeakObj(_sepView)
    [_sepView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(7);
    }];
    
    [_titleLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sepViewWeak.mas_bottom);
        make.bottom.right.offset(0);
        make.left.offset(15);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.offset(kLineWidth);
    }];
}

- (void)setAttributes
{
    _sepView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];

    _titleLbl.textColor = kBlackTextColor;
    _titleLbl.font = Font16;
    
    _lineView.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
}


@end
