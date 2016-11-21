//
//  EarnOrdinaryCell.m
//  Coach
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EarnOrdinaryCell.h"

@implementation EarnOrdinaryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSubViews];
}

- (void)initSubViews
{
    UILabel * dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,(kScreenWidth-40)/3, 25)];
    dateLabel.text = @"07:00-08:00";
    dateLabel.backgroundColor = [UIColor colorWithHexString:@"5cb6ff"];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = Font11;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:dateLabel];
    
    UILabel * subjectsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(dateLabel.frame)+8, (kScreenWidth-40)/3, 10)];
    subjectsLabel.textColor = RGBCOLOR(81, 173, 255);
    subjectsLabel.text = @"科二";
    subjectsLabel.font = Font10;
    subjectsLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:subjectsLabel];
    
    UILabel * personNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(subjectsLabel.frame)+2, (kScreenWidth-40)/3, 10)];
    personNumLabel.text = @"¥ 50/人";
    personNumLabel.font = Font10;
    personNumLabel.textAlignment = NSTextAlignmentCenter;
    personNumLabel.textColor = RGBCOLOR(81, 173, 255);
    [self.contentView addSubview:personNumLabel];
}
@end
