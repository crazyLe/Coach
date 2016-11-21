//
//  MCoachFirstCell.m
//  Coach
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "MCoachFirstCell.h"

@implementation MCoachFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _avatorImageView.layer.cornerRadius = _avatorImageView.layer.width/2;
    _avatorImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
