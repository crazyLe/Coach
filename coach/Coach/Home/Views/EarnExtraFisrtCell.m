//
//  EarnExtraFisrtCell.m
//  Coach
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EarnExtraFisrtCell.h"

@implementation EarnExtraFisrtCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(EarnAppointModel *)model
{
    _model = model;
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"HH:mm"];
    NSString *dateString1 = [dateFormat1 stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.start_time_hour doubleValue]]];
    
    NSString * dateString2 = [dateFormat1 stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.end_time_hour doubleValue]]];
    _timeLabel .text = [NSString stringWithFormat:@"%@~%@",dateString1,dateString2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
