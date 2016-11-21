//
//  PToderFirstTableCell.m
//  学员端
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PToderFirstTableCell.h"


@implementation PToderFirstTableCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createaUI];
    }
    return self;
}

- (void)createaUI
{
    UILabel * orderLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-90)/2-9, 12, 90, 16)];
    orderLabel.text = @"订单信息";
    orderLabel.textColor = [UIColor colorWithHexString:@"#4c4c4c"];
    orderLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:orderLabel];
  
    
    
    
    NSMutableAttributedString * arrString = [[NSMutableAttributedString alloc] initWithString:@"订单编号:" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    [arrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"887887887" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2f82ff"],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
    
    UILabel * orederNubmerLab = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-110)/2-9, CGRectGetMaxY(orderLabel.frame)+10, 150, 9)];
    orederNubmerLab.attributedText = arrString;
    [self.contentView addSubview:orederNubmerLab];

    
    
    UILabel * coachLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, CGRectGetMaxY(orederNubmerLab.frame)+30, 80, 15)];
    NSMutableAttributedString * attStr = nil;
    attStr = [[NSMutableAttributedString alloc]initWithString:@"教练:" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"张小开" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
    coachLabel.attributedText = attStr;
    [self.contentView addSubview:coachLabel];
    
    UIButton * coachBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(coachLabel.frame)+5, CGRectGetMinY(coachLabel.frame), 50, 15)];
    [coachBtn setTitle:@"五年驾龄" forState:UIControlStateNormal];
    [coachBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    coachBtn.backgroundColor = [UIColor colorWithHexString:@"#feb235"];
    coachBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    coachBtn.layer.cornerRadius = 3;
    coachBtn.clipsToBounds = YES;
    [self.contentView addSubview:coachBtn];
    
    UILabel * carsLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, CGRectGetMaxY(coachLabel.frame)+16, 150, 15)];
    NSMutableAttributedString * carsStr = nil;
    carsStr = [[NSMutableAttributedString alloc]initWithString:@"车辆:" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    [carsStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"捷达" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
    carsLabel.attributedText = carsStr;
    [self.contentView addSubview:carsLabel];
    
    UILabel * subjectsLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, CGRectGetMaxY(carsLabel.frame)+16, 150, 15)];
    NSMutableAttributedString * subjectsStr = nil;
    subjectsStr = [[NSMutableAttributedString alloc]initWithString:@"科目:" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    [subjectsStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"科目二" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
    subjectsLabel.attributedText = subjectsStr;
//    subjectsLabel.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:subjectsLabel];
    
//    _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, CGRectGetMaxY(subjectsLabel.frame)+16, kScreenWidth-60, 15)];
    _addressLabel = [[UILabel alloc] init];
    NSMutableAttributedString * addressStr = nil;
    addressStr = [[NSMutableAttributedString alloc]initWithString:@"地址:" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    [addressStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"合肥市经开区莲花路与芙蓉路交口" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
    _addressLabel.attributedText = addressStr;
    _addressLabel.numberOfLines = 0;
    [self.contentView addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(26);
        make.top.equalTo(subjectsLabel.mas_bottom).offset(16);
        make.width.offset(kScreenWidth - 60);
    }];
    
}
-(CGSize)sizeThatFits:(CGSize)size
{
    

    CGSize  addressLabSize = [_addressLabel.text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(kScreenWidth-60, 15)];
    
    return CGSizeMake(size.width, 12+16+10+9+30+15+16+12+16+15+16+addressLabSize.height);

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
