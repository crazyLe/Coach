//
//  LLCarAreaPriceCell.m
//  Coach
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLCarAreaPriceCell.h"

@implementation LLCarAreaPriceCell

- (void)setUI
{
    [super setUI];
    
    _lblArr = [[NSMutableArray alloc] init];
    
    _btnArr = [[NSMutableArray alloc] init];
    
    CGFloat lblWidth = 180.0f*kWidthScale;
    CGFloat lblHeight = 20.0f*kHeightScale;
    CGFloat lblLeftOffset = 10.0f;
    CGFloat TopOffset = 10.0f;
    CGFloat VerticalInterval = 5.f;
    for (int i = 0; i < 5; i++) {
        UILabel *lbl = [UILabel new];
        [self.bgView addSubview:lbl];
        lbl.frame = CGRectMake(lblLeftOffset, TopOffset+i*(VerticalInterval+lblHeight), lblWidth, lblHeight);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:btn];
        btn.frame = CGRectMake(lbl.frame.origin.x+lbl.frame.size.width+10, lbl.frame.origin.y, 95, lblHeight);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = kFont13;
        
        [_lblArr addObject:lbl];
        [_btnArr addObject:btn];
    }
}

@end
