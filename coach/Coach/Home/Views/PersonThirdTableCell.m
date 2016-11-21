//
//  PersonThirdTableCell.m
//  学员端
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PersonThirdTableCell.h"

#define hSpacingNum 20.0

@implementation PersonThirdTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return  self;
}

- (void)createUI
{
    UILabel * firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, hSpacingNum, 36, 15)];
    firstLabel.text = @"优惠:";
    firstLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    firstLabel.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:firstLabel];
    
    UIButton * secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    secondBtn.frame = CGRectMake(26+36,hSpacingNum, 42, 15);
    [secondBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-redbackground"] forState:UIControlStateNormal];
    [secondBtn setTitle:@"代金券" forState:UIControlStateNormal];
    [secondBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    secondBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:secondBtn];
    
    
    _thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(26+36+42+6, hSpacingNum, 130, 15)];
    _thirdLabel.text = @"200元学车代金券";
    _thirdLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _thirdLabel.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:_thirdLabel];
    
    UIImageView * fourthImageV = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-50-8, hSpacingNum+3, 12, 8)];
    fourthImageV.image = [UIImage imageNamed:@"iconfont-jiantou(1)123"];
    [self.contentView addSubview:fourthImageV];
}



@end
