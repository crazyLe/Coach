//
//  WFCustomCollectCell.m
//  Coach
//
//  Created by apple on 16/8/13.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "WFCustomCollectCell.h"

@interface WFCustomCollectCell()

{
    UILabel * dateLabel;
    UILabel * subjectsLabel;
    UILabel * personNumLabel;
}
@end


@implementation WFCustomCollectCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor] ;
        [self initSubviews];
    }
    return self ;
}

- (void)initSubviews
{
    self.layer.cornerRadius = 5.0;
    self.layer.borderWidth = 1;
    self.clipsToBounds = YES;
    
    dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,(kScreenWidth-40)/3, 25)];
    //    dateLabel.text = @"07:00-08:00";
    
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = Font12;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:dateLabel];
    
    subjectsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(dateLabel.frame)+8, (kScreenWidth-40)/3, 10)];
    subjectsLabel.textColor = RGBCOLOR(81, 173, 255);
    //    subjectsLabel.text = @"科二";
    subjectsLabel.font = Font12;
    subjectsLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:subjectsLabel];
    
    personNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(subjectsLabel.frame)+2, (kScreenWidth-40)/3, 10)];
    //    personNumLabel.text = @"¥ 50/人";
    personNumLabel.font = Font12;
    personNumLabel.textAlignment = NSTextAlignmentCenter;
    personNumLabel.textColor = RGBCOLOR(81, 173, 255);
    [self.contentView addSubview:personNumLabel];
}

- (void)setAppointModel:(EarnAppointModel *)appointModel
{
    _appointModel = appointModel;
    
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"HH:mm"];
    NSString *dateString1 = [dateFormat1 stringFromDate:[NSDate dateWithTimeIntervalSince1970:[appointModel.start_time_hour doubleValue]]];
    
    NSString * dateString2 = [dateFormat1 stringFromDate:[NSDate dateWithTimeIntervalSince1970:[appointModel.end_time_hour doubleValue]]];
    
    dateLabel.text = [NSString stringWithFormat:@"%@-%@",dateString1,dateString2];
    
    if([appointModel.state isEqualToString:@"0"]){
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc]init];
        [att appendText:@"设置" withAttributesArr:@[kAppThemeColor,Font12,@(NSMutableAttributedStringExtensionTypeUnderline)]];
        personNumLabel.attributedText = att;
        dateLabel.backgroundColor = [UIColor colorWithHexString:@"b0b4b8"];
        self.layer.borderColor = [[UIColor colorWithHexString:@"#b0b4b8"] CGColor];
        subjectsLabel.text = @"";
        subjectsLabel.text = @"";
    }else if([appointModel.state isEqualToString:@"1"]){
        if ([appointModel.subjectId isEqualToString:@"1"]) {
            subjectsLabel.text = @"科二";
        }else if([appointModel.subjectId isEqualToString:@"2"])
        {
            subjectsLabel.text = @"科三";
        }
        subjectsLabel.textColor = RGBCOLOR(81, 173, 255);
        personNumLabel.text = [NSString stringWithFormat:@"%@元/人",appointModel.money];
        personNumLabel.textColor = RGBCOLOR(81, 173, 255);
        dateLabel.backgroundColor = [UIColor colorWithHexString:@"569bfd"];
        self.layer.borderColor = [[UIColor colorWithHexString:@"#569bfd"] CGColor];
        
    }else if ([appointModel.state isEqualToString:@"2"]){
        if ([appointModel.subjectId isEqualToString:@"1"]) {
            subjectsLabel.text = @"科二";
        }else if([appointModel.subjectId isEqualToString:@"2"])
        {
            subjectsLabel.text = @"科三";
        }
        subjectsLabel.textColor = [UIColor colorWithHexString:@"#b0b4b8"];
        personNumLabel.text = [NSString stringWithFormat:@"%@元/人",appointModel.money];
        personNumLabel.textColor = [UIColor colorWithHexString:@"#b0b4b8"];
        dateLabel.backgroundColor = [UIColor colorWithHexString:@"b0b4b8"];
        self.layer.borderColor = [[UIColor colorWithHexString:@"#b0b4b8"] CGColor];
    }else if ([appointModel.state isEqualToString:@"3"]){
        if ([appointModel.subjectId isEqualToString:@"1"]) {
            subjectsLabel.text = @"科二";
        }else if([appointModel.subjectId isEqualToString:@"2"])
        {
            subjectsLabel.text = @"科三";
        }
        subjectsLabel.textColor = [UIColor colorWithHexString:@"#b0b4b8"];
        personNumLabel.text = [NSString stringWithFormat:@"%@元/人",appointModel.studentMax];
        personNumLabel.textColor = [UIColor colorWithHexString:@"#b0b4b8"];
        dateLabel.backgroundColor = [UIColor colorWithHexString:@"b0b4b8"];
        self.layer.borderColor = [[UIColor colorWithHexString:@"#b0b4b8"] CGColor];
    }
}



@end
