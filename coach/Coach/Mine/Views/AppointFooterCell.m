//
//  AppointFooterCell.m
//  Coach
//
//  Created by LL on 16/8/9.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "AppointFooterCell.h"

@implementation AppointFooterCell

#pragma mark - Setup

- (void)setUI
{
    [super setUI];
    
    _bgImgView = [UIImageView new];
    [self.bgView addSubview:_bgImgView];
    
    _contentLbl = [UILabel new];
    [self.bgView addSubview:_contentLbl];
}

- (void)setContraints
{
    [super setContraints];
    
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, -1));
    }];
    
    [_contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kLeftLblLeftOffset);
        make.top.bottom.offset(0);
        make.right.offset(-kLeftLblLeftOffset);
    }];
}

- (void)setAttributes
{
    [super setAttributes];
 
    self.bgView.backgroundColor = [UIColor clearColor];
    
    _bgImgView.image = [UIImage imageNamed:@"iconfont-appointbottombg"];
    
    _contentLbl.numberOfLines = 0;
    
    [self.lineView removeFromSuperview] , self.lineView = nil;
}

@end
