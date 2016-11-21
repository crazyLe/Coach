//
//  AddImageCell.m
//  Coach
//
//  Created by LL on 16/8/13.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "AddImageCell.h"

@implementation AddImageCell

#pragma mark - Setup

- (void)setUI
{
    _btnArr = [NSMutableArray array];
    
    CGFloat btnTopOffset = 10;
    CGFloat btnInterval = 20;
    CGFloat btnWidth = (kScreenWidth-4*btnInterval)/3;
    
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:btn];
        btn.frame = CGRectMake(btnInterval+(btnInterval+btnWidth)*i, btnTopOffset, btnWidth, btnWidth);
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10+i;
        [_btnArr addObject:btn];
    }
    
}

- (void)clickBtn:(UIButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(AddImageCell:clickBtn:)]) {
        [_delegate AddImageCell:self clickBtn:btn];
    }
}


@end
