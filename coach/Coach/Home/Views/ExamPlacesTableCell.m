//
//  ExamPlacesTableCell.m
//  Coach
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "ExamPlacesTableCell.h"

@implementation ExamPlacesTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.contentView.backgroundColor = RGBCOLOR(244, 243, 244);
    
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(18, 7, kScreenWidth-18*2, 92)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5.0;
    [self.contentView addSubview:backView];
    
    _conentLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 14, 230*kScreenWidth/375.0, 45)];
    _conentLabel.text = @"学员排队考试等待时间过长，10名员考试转让，望可快速报名参加考试，限合肥本地。";
    _conentLabel.numberOfLines = 0;
    _conentLabel.textColor = [UIColor colorWithHexString:@"#646464"];
    _conentLabel.font = Font12;
//    _conentLabel.backgroundColor = [UIColor brownColor];
    [backView addSubview:_conentLabel];
    
    _firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(_conentLabel.frame)+10, 59, 15)];
    _firstLabel.text = @"安徽合肥";
    _firstLabel.textColor = [UIColor whiteColor];
    _firstLabel.font = Font12;
    _firstLabel.textAlignment = NSTextAlignmentCenter;
    _firstLabel.layer.masksToBounds = YES;
    _firstLabel.layer.cornerRadius = 8.0;
//    _firstLabel.backgroundColor = [UIColor brownColor];
    _firstLabel.backgroundColor = RGBCOLOR(158, 209, 255);
    [backView addSubview:_firstLabel];
    
    _secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_firstLabel.frame)+5, CGRectGetMaxY(_conentLabel.frame)+10, 59, 15)];
    _secondLabel.text = @"10人";
    _secondLabel.textColor = [UIColor whiteColor];
    _secondLabel.font = Font12;
    _secondLabel.textAlignment = NSTextAlignmentCenter;
    _secondLabel.layer.masksToBounds = YES;
    _secondLabel.layer.cornerRadius = 8.0;
//    _secondLabel.backgroundColor = [UIColor brownColor];
    _secondLabel.backgroundColor = RGBCOLOR(158, 209, 255);
    [backView addSubview:_secondLabel];
    
    _thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_secondLabel.frame)+5, CGRectGetMaxY(_conentLabel.frame)+10, 59, 15)];
    _thirdLabel.text = @"限本地";
    _thirdLabel.textColor = [UIColor whiteColor];
    _thirdLabel.font = Font12;
    _thirdLabel.textAlignment = NSTextAlignmentCenter;
    _thirdLabel.layer.masksToBounds = YES;
    _thirdLabel.layer.cornerRadius = 8.0;
//    _thirdLabel.backgroundColor = [UIColor brownColor];
    _thirdLabel.backgroundColor = RGBCOLOR(158, 209, 255);
    [backView addSubview:_thirdLabel];
    
    _placesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _placesBtn.frame = CGRectMake(backView.frame.size.width-45-29, 23, 45, 45);
//    _placesBtn.backgroundColor = [UIColor magentaColor];
    [_placesBtn setImage:[UIImage imageNamed:@"eaxm_placesImage"] forState:UIControlStateNormal];
    [backView addSubview:_placesBtn];
    
//    _topRightImage = [[UIImageView alloc]initWithFrame:CGRectMake(backView.frame.size.width-30, 0, 30, 30)];
////    _topRightImage.backgroundColor = [UIColor orangeColor];
//    _topRightImage.image = [UIImage imageNamed:@"exam_hot"];
//    [backView addSubview:_topRightImage];
    
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
