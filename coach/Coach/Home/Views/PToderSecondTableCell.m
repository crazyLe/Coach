//
//  PToderSecondTableCell.m
//  学员端
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PToderSecondTableCell.h"

#define hSpacingNum 17.0

@implementation PToderSecondTableCell
{
    NSMutableArray * _dataArray;
    
    
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _dataArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
        [self createaUI];
    }
    return self;
}

- (void)createaUI
{
    UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, hSpacingNum, 36, 15)];
    timeLabel.text = @"时间:";
    timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    timeLabel.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:timeLabel];
    
    
    for (int i = 0; i < _dataArray.count; i++) {
        
        UIView * firstView = [[UIView alloc]initWithFrame:CGRectMake(26+36, 5+ 38 * i, kScreenWidth-80-16, 38)];
        [self.contentView addSubview:firstView];
        
        UILabel * firstLabel = [[UILabel alloc] init];
        firstLabel.text = @"2016-06-30 09:00~10:00";
        firstLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        firstLabel.font = [UIFont systemFontOfSize:14];
        [firstView addSubview:firstLabel];
        [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(firstView);
            make.left.offset(0);
        }];

        UIButton * arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [arrowBtn setImage:[UIImage imageNamed:@"iconfont-jiantou(1)123"] forState:UIControlStateNormal];
        [firstView addSubview:arrowBtn];
        [arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.centerY.equalTo(firstView);
        }];

        UILabel * priceLab = [[UILabel alloc] init];
        priceLab.text = @"¥50";
        priceLab.textColor = [UIColor colorWithHexString:@"#2f82ff"];
        priceLab.font = [UIFont systemFontOfSize:14];
        [firstView addSubview:priceLab];
        [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(firstView);
            make.right.equalTo(arrowBtn.mas_right).offset(-10);
        }];
        
        UIImageView * firstLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, firstView.frame.size.height-LINE_HEIGHT, firstView.frame.size.width-20, LINE_HEIGHT)];
        firstLine.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        [firstView addSubview:firstLine];
        
        
        
    }
    
    
    
    UIView * thirdView = [[UIView alloc]initWithFrame:CGRectMake(26+36, 38 * _dataArray.count, kScreenWidth-80-16, 38)];
    [self.contentView addSubview:thirdView];
    
    UILabel * thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, thirdView.frame.size.width-26, 15)];
    NSMutableAttributedString * thirdStr = nil;
    thirdStr = [[NSMutableAttributedString alloc]initWithString:@"总计：           2小时           " attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    thirdLabel.attributedText = thirdStr;
    [thirdView addSubview:thirdLabel];
    
    UILabel * totolPriceLab = [[UILabel alloc] init];
    totolPriceLab.text = @"¥250";
    totolPriceLab.textColor = [UIColor colorWithHexString:@"2f82ff"];
    totolPriceLab.font = [UIFont systemFontOfSize:14];
    [thirdView addSubview:totolPriceLab];
    [totolPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(thirdView);
        make.right.offset(-25);
    }];
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
