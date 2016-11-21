//
//  ExanStudyHourCell.m
//  Coach
//
//  Created by gaobin on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "ExanStudyHourCell.h"

@implementation ExanStudyHourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _bgView.layer.cornerRadius = 10;
    _bgView.clipsToBounds = YES;
    
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:@"128" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2f82ff"],NSFontAttributeName:[UIFont systemFontOfSize:11]}];
    [attString appendAttributedString:[[NSAttributedString alloc]initWithString:@"个空闲时段" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont boldSystemFontOfSize:11]}]];
    _numberFreeLab.attributedText = attString;
    
    
}

@end
