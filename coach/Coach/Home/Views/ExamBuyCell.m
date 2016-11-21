//
//  ExamBuyCell.m
//  Coach
//
//  Created by 翁昌青 on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "ExamBuyCell.h"

@implementation ExamBuyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    self.num.layer.cornerRadius = 5;
    self.num.layer.borderWidth = 1;
    self.num.layer.borderColor = [UIColor colorWithHexString:@"#ffcb6f"].CGColor;
    
    self.placescale.layer.cornerRadius = 5;
    self.placescale.layer.borderWidth = 1;
    self.placescale.layer.borderColor = [UIColor colorWithHexString:@"#ff9998"].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
