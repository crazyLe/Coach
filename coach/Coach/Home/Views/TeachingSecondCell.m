//
//  TeachingSecondCell.m
//  Coach
//
//  Created by apple on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "TeachingSecondCell.h"

@implementation TeachingSecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
