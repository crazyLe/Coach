//
//  OrderInfomationCell.m
//  Coach
//
//  Created by gaobin on 16/7/30.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "OrderInfomationCell.h"

@implementation OrderInfomationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    _driveYearLab.layer.cornerRadius = 4;
    _driveYearLab.clipsToBounds = YES;
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
