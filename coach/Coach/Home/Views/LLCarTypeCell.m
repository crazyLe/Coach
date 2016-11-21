//
//  LLCarTypeCell.m
//  Coach
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLCarTypeCell.h"

@implementation LLCarTypeCell

- (void)setUI
{
    [super setUI];
    
    _lblArr = [[NSMutableArray alloc] init];
    
    __weak UIView *bgViewWeak = self.bgView;
    for (int i = 0; i < 4; i++) {
        UILabel *lbl = [UILabel new];
        [self.bgView addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.offset(i==0||i==2?5:5+btnWidth);
            if (i==0||i==1) {
                make.bottom.equalTo(bgViewWeak.mas_centerY);
                make.top.offset(5);
            }
            else
            {
                make.top.equalTo(bgViewWeak.mas_centerY);
                make.bottom.offset(-5);
            }
            if (i==0||i==2) {
                make.right.equalTo(bgViewWeak.mas_centerX);
                make.left.offset(10);
            }
            else
            {
                make.left.equalTo(bgViewWeak.mas_centerX);
                make.right.offset(-5);
            }
        }];
        [_lblArr addObject:lbl];
    }
}

@end
