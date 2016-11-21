//
//  LLCarAreaCell.m
//  Coach
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLCarAreaCell.h"

@implementation LLCarAreaCell

- (void)setUI
{
    [super setUI];
    
    _contentLbl = [UILabel new];
    [self.bgView addSubview:_contentLbl];
    
    [_contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    _contentLbl.textColor = kDarkGrayColor;
    _contentLbl.font = kFont13;
    _contentLbl.numberOfLines = 0;
}

@end
