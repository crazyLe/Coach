//
//  EditFirstTableCell.m
//  Coach
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EditFirstTableCell.h"

@implementation EditFirstTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _avatorImageView.userInteractionEnabled = YES;
    _avatorImageView.clipsToBounds = YES;
    _avatorImageView.layer.cornerRadius = _avatorImageView.frame.size.width/2;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(justTap:)];
    [_avatorImageView addGestureRecognizer:tap];
    
}

- (void)justTap:(UITapGestureRecognizer *)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(EditFirstTableCell:imageView:)])
    {
        [_delegate EditFirstTableCell:self imageView:_avatorImageView];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
