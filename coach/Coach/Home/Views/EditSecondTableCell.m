//
//  EditSecondTableCell.m
//  Coach
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EditSecondTableCell.h"

#define HCoachWidth kScreenWidth/375.0

@implementation EditSecondTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView IDstr:(NSString *)str{
    
    NSString *ID = str;
    EditSecondTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[EditSecondTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUI];
        
    }
    return self;
}

- (void)createUI
{
//    CGFloat padding = 5;
    
    UILabel * topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 11)];
    topLabel.backgroundColor = rgb(239, 238, 239);
    [self.contentView addSubview:topLabel];
    
//    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 11+padding +5, 24, 24)];
//    _iconView.userInteractionEnabled = YES;
//    _iconView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.contentView addSubview:_iconView];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 21, 100, 15)];
    _messageLabel.font = Font14;
    _messageLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_messageLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-120, 21, 120-24-10, 15)];
    _contentLabel.font = Font14;;
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:_contentLabel];
    
    _accessoryImageView = [[UIImageView alloc] init];
    _accessoryImageView.frame = CGRectMake(kScreenWidth - 24, 21, 12, 15);
    _accessoryImageView.image = [UIImage imageNamed:@"card_arrow"];
    _accessoryImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_accessoryImageView];
    
//    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.contentView addSubview:_rightBtn];
//    _rightBtn.frame = CGRectMake(CGRectGetMinX(_contentLabel.frame), CGRectGetMinY(_contentLabel.frame), _contentLabel.frame.size.width+_accessoryImageView.frame.size.width+15, _contentLabel.frame.size.height);
//    [_rightBtn  addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    
//    NSArray * arr1 = @[@"普通班",@"周末班",@"夜间班"];
//    NSArray * arrBackColor1 = @[@"2e82ff",@"#fd8b33",@"#f96162"];
//    NSArray * arr2 = @[@"C1",@"C1",@"C1"];
//    NSArray * arr3 = @[@"周一至周日",@"周六至周日",@"周一至周日"];
//    NSArray * arr4 = @[@"¥3500",@"¥3500",@"¥3500"];
//    NSArray * arr5 = @[@"修改",@"修改",@"修改"];
//    for (int i=0; i<3; i++) {
//        UILabel * firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(25*HCoachWidth, CGRectGetMaxY(_messageLabel.frame)+26+44*i, 46, 13)];
//        firstLabel.text = arr1[i];
//        firstLabel.font = Font15;
//        firstLabel.textColor = [UIColor colorWithHexString:arrBackColor1[i]];
////        firstLabel.backgroundColor = [UIColor redColor];
//        [self.contentView addSubview:firstLabel];
//        
//        UILabel * secondLabel = [[UILabel alloc]initWithFrame:CGRectMake((46+25+18)*HCoachWidth, CGRectGetMaxY(_messageLabel.frame)+26+44*i, 18, 13)];
//        secondLabel.text = arr2[i];
//        secondLabel.font = Font15;
////        secondLabel.backgroundColor = [UIColor brownColor];
//        secondLabel.textColor = [UIColor colorWithHexString:@"#666666"];
////        secondLabel.backgroundColor = [UIColor orangeColor];
//        [self.contentView addSubview:secondLabel];
//        
//        UILabel * thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake((46+18+25+18+28)*HCoachWidth, CGRectGetMaxY(_messageLabel.frame)+26+44*i, 75, 13)];
//        thirdLabel.text = arr3[i];
//        thirdLabel.font = Font15;
////        thirdLabel.backgroundColor = [UIColor yellowColor];
//        thirdLabel.textColor = [UIColor colorWithHexString:@"#666666"];
//        [self.contentView addSubview:thirdLabel];
//        
//        UILabel * fourthLabel = [[UILabel alloc]initWithFrame:CGRectMake((46+18+75+25+18+28+24)*HCoachWidth, CGRectGetMaxY(_messageLabel.frame)+26+44*i, 45, 13)];
//        fourthLabel.text = arr4[i];
//        fourthLabel.font = BoldFontWithSize(15);
////        fourthLabel.backgroundColor = [UIColor greenColor];
//        fourthLabel.textColor = [UIColor colorWithHexString:@"#4c4c4c"];
//        [self.contentView addSubview:fourthLabel];
//        
//        UILabel * fifthLabel = [[UILabel alloc]initWithFrame:CGRectMake((46+18+75+45+18+28+25+24+28)*HCoachWidth, CGRectGetMaxY(_messageLabel.frame)+26+44*i, 40, 15)];
//        fifthLabel.text = arr5[i];
//        fifthLabel.textAlignment = NSTextAlignmentCenter;
//        fifthLabel.font = Font15;
//        fifthLabel.layer.cornerRadius = 3.0;
//        fifthLabel.layer.masksToBounds = YES;
////        fifthLabel.backgroundColor = [UIColor blueColor];
//        fifthLabel.backgroundColor = [UIColor colorWithHexString:@"#c8c8c8"];
//        fifthLabel.textColor = [UIColor whiteColor];
//        [self.contentView addSubview:fifthLabel];
//        
//    }
    
//    UILabel * downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-11, kScreenWidth, 11)];
//    downLabel.backgroundColor = rgb(239, 238, 239);
//    [self.contentView addSubview:downLabel];
    
}

//- (void)clickRightBtn:(UIButton *)rightBtn
//{
//    if (_delegate && [_delegate respondsToSelector:@selector(EditSecondTableCell:clickRightBtn:)]) {
//        [_delegate EditSecondTableCell:self clickRightBtn:rightBtn];
//    }
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-11, kScreenWidth, 11)];
//    lineLabel.backgroundColor = rgb(239, 238, 239);
//    [self.contentView addSubview:lineLabel];
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
