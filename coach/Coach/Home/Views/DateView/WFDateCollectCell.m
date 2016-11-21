//
//  WFDateCollectCell.m
//  Coach
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "WFDateCollectCell.h"

@implementation WFDateCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _publishLabel.userInteractionEnabled = YES;
    _dateLabel.userInteractionEnabled = YES;
    _weekLabel.userInteractionEnabled = YES;
}

- (void)setCalendarModel:(EarnCalendarModel *)calendarModel
{
    _calendarModel = calendarModel;
    _dateLabel.text = _calendarModel.date;
    _weekLabel.text = _calendarModel.week;
    if ([_calendarModel.state isEqualToString:@"0"]) {
        _publishLabel.text = @"未发布";
        _publishLabel.textColor = [UIColor colorWithHexString:@"858F94"];
    }else if([_calendarModel.state isEqualToString:@"1"]){
        _publishLabel.text = @"已发布";
        _publishLabel.textColor = [UIColor colorWithHexString:@"ffd85c"];
    }else{
        _publishLabel.text = @"";
    }
    
//    if (_index == 2) {
//        _bgImageView.hidden = NO;
//        
////        _bgView.hidden = YES;
//        
//        _publishLabel.textColor = [UIColor whiteColor];
//        
//        _dateLabel.textColor = [UIColor whiteColor];
//        
//        _weekLabel.textColor = [UIColor whiteColor];
//        
//        _publishLabel.font = [UIFont systemFontOfSize:15];
//        
//        _dateLabel.font = [UIFont systemFontOfSize:13];
//        
//        self.backgroundColor = [UIColor whiteColor];
//        
////        self.transform = CGAffineTransformMakeScale(1.1, 1.1);
////        self.bgImageView.transform = CGAffineTransformMakeScale(1.1, 1.0);
//        
//        _bgImageView.image = [UIImage imageNamed:@"earn_publish"];
//        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
//        
//    }else
//    {
//        
//        _bgImageView.hidden = YES;
////        _bgView.hidden = NO;
//        self.bgView.transform = CGAffineTransformMakeScale(0.9, 1.0);
//        _bgView.backgroundColor = [UIColor whiteColor];
//        
//    }
    
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    
    
}

@end
