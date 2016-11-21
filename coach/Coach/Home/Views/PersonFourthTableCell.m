//
//  PersonFourthTableCell.m
//  学员端
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PersonFourthTableCell.h"
#import "NSMutableAttributedString+LLExtension.h"

#define hSpacingNum 17.0

@interface  PersonFourthTableCell()<UITextViewDelegate>

@end

@implementation PersonFourthTableCell

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
    UILabel * firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, hSpacingNum, 40, 15)];
    firstLabel.text = @"赚豆:";
    firstLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    firstLabel.font = [UIFont systemFontOfSize:15.0];
    //    firstLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:firstLabel];
    
    
    //    UILabel * secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(26+36, hSpacingNum, 122, 15)];
    //    secondLabel.text = @"1000";
    //    secondLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    //    secondLabel.font = [UIFont systemFontOfSize:15.0];
    ////    secondLabel.backgroundColor = [UIColor orangeColor];
    //    [self.contentView addSubview:secondLabel];
    
    _secondTextView = [[UITextView alloc]initWithFrame:CGRectMake(26+36, hSpacingNum-9, 122, 34)];
//    _secondField.text = @"10000";
//    _secondField.textColor = [UIColor colorWithHexString:@"666666"];
//    _secondField.font = [UIFont systemFontOfSize:15.0];
    _secondTextView.contentInset = UIEdgeInsetsZero;
    _secondTextView.textContainerInset = UIEdgeInsetsMake(7, 0, 0, 0);
    _secondTextView.layer.borderWidth = 0.5f;
    _secondTextView.layer.borderColor = [UIColor colorWithHexString:@"c8c8c8"].CGColor;
    _secondTextView.layer.cornerRadius = 2.0f;
    _secondTextView.clipsToBounds = YES;
    _secondTextView.textAlignment = NSTextAlignmentCenter;
    _secondTextView.delegate = self;
    _secondTextView.keyboardType = UIKeyboardTypeNumberPad;
    _secondTextView.attributedText = [self getAttrStringWithZhuanDouNum:@"10000"];
    [self.contentView addSubview:_secondTextView];
    
    UILabel * thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(26+36+122+5, hSpacingNum, 60, 14)];
    thirdLabel.text = @"抵1000元";
    thirdLabel.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    thirdLabel.font = [UIFont systemFontOfSize:13.0];
    //    thirdLabel.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:thirdLabel];
    
    UILabel * fourthLabel = [[UILabel alloc]initWithFrame:CGRectMake(26+36, CGRectGetMaxY(_secondTextView.frame)+8, 230, 15)];
    fourthLabel.text = @"共1000赚豆，最多可抵1000元";
    fourthLabel.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    fourthLabel.font = [UIFont systemFontOfSize:15.0];
    //    fourthLabel.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:fourthLabel];
    

    
}


-(void)textViewDidChange:(UITextView *)textView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(personFourthCellsecondField)]) {
        [self.delegate personFourthCellsecondField];
    }
}
-(NSMutableAttributedString *)getAttrStringWithZhuanDouNum:(NSString *)num
{
    
    NSMutableAttributedString * secondStr = [[NSMutableAttributedString alloc]initWithString:num attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    NSTextAttachment *attachment=[[NSTextAttachment alloc] initWithData:nil ofType:nil];
    UIImage *img=[UIImage imageNamed:@"iconfont-earnbean"];
    attachment.image=img;
    attachment.bounds=CGRectMake(10, -5, 20, 20);
    NSAttributedString *atr2 = [NSMutableAttributedString attributedStringWithAttachment:attachment];
    [secondStr appendAttributedString:atr2];
    
    return secondStr;
    
}

@end
