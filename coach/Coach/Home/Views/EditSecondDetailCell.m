//
//  EditSecondDetailCell.m
//  Coach
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EditSecondDetailCell.h"

@interface EditSecondDetailCell ()


@end

#define spaceNum 13
@implementation EditSecondDetailCell

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        ;
//    }
//    return self;
//}

- (void)createUI{
    
    NSArray * arrBackColor1 = @[@"2e82ff",@"#fd8b33",@"#f96162"];
    
    _firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(25*HCoachWidth, spaceNum, 60, 13)];
//    firstLabel.text = arr1[i];
    _firstLabel.font = Font15;
    _firstLabel.textColor = [UIColor colorWithHexString:arrBackColor1[_index]];
    //        firstLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_firstLabel];
    _firstLabel.textAlignment = NSTextAlignmentLeft;
    
     _secondLabel = [[UILabel alloc]initWithFrame:CGRectMake((60+25+18)*HCoachWidth, spaceNum, 20, 13)];
//    secondLabel.text = arr2[i];
    _secondLabel.font = Font15;
    //        secondLabel.backgroundColor = [UIColor brownColor];
    _secondLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    //        secondLabel.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_secondLabel];
    
    _thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake((46+18+25+20+28)*HCoachWidth, spaceNum, 75, 13)];
//    thirdLabel.text = arr3[i];
    _thirdLabel.font = Font15;
    //        thirdLabel.backgroundColor = [UIColor yellowColor];
    _thirdLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:_thirdLabel];
    
    _fourthLabel = [[UILabel alloc]initWithFrame:CGRectMake((46+18+75+25+18+28+24)*HCoachWidth, spaceNum, 45, 13)];
//    fourthLabel.text = arr4[i];
    _fourthLabel.font = BoldFontWithSize(15);
    //        fourthLabel.backgroundColor = [UIColor greenColor];
    _fourthLabel.textColor = [UIColor colorWithHexString:@"#4c4c4c"];
    [self.contentView addSubview:_fourthLabel];
    _fourthLabel.textAlignment = NSTextAlignmentLeft;
    
    _fifthLabel = [[UILabel alloc]initWithFrame:CGRectMake((46+18+75+45+18+28+25+24+28)*HCoachWidth,spaceNum, 40, 15)];
//    fifthLabel.text = arr5[i];
    _fifthLabel.textAlignment = NSTextAlignmentCenter;
    _fifthLabel.font = Font15;
    _fifthLabel.layer.cornerRadius = 3.0;
    _fifthLabel.layer.masksToBounds = YES;
    //        fifthLabel.backgroundColor = [UIColor blueColor];
    _fifthLabel.backgroundColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _fifthLabel.textColor = [UIColor whiteColor];
    _fifthLabel.userInteractionEnabled = YES;
    [self.contentView addSubview:_fifthLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFifthLbl:)];
    [_fifthLabel addGestureRecognizer:tap];
}

- (void)setClassModel:(CardClassesModel *)classModel
{
    _classModel = classModel;
    
    _firstLabel.text = classModel.className;
    _secondLabel.text = classModel.classCar;
    _thirdLabel.text = classModel.classDate;
    _fourthLabel.text = [classModel.classMoney intValue]!=0?[NSString stringWithFormat:@"¥%@",classModel.classMoney]:@"";
    _fifthLabel.text = @"修改";
}

- (void)tapFifthLbl:(UITapGestureRecognizer *)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(EditSecondDetailCell:clickFifthLbl:)]) {
        [_delegate EditSecondDetailCell:self clickFifthLbl:tap.view];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createUI];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
