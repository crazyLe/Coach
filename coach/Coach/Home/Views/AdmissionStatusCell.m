//
//  AdmissionStatusCell.m
//  Coach
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "AdmissionStatusCell.h"

@implementation AdmissionStatusCell

- (void)setUI
{
    _centerLbl = [UILabel new];
    [self.contentView addSubview:_centerLbl];
}

- (void)setContraints
{
    [_centerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(20, 0, 0, 0));
    }];
}

- (void)setAttributes
{
    _centerLbl.numberOfLines = 0;
    _centerLbl.textAlignment = NSTextAlignmentCenter;
}

@end
