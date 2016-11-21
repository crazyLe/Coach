//
//  DateCell.m
//  wills
//
//  Created by ai_ios on 16/4/18.
//  Copyright © 2016年 ai_ios. All rights reserved.
//

#import "DateCell.h"

@interface DateCell (){
    
    UILabel *_weekLabel;
    UILabel *_dateLabel;
}

@end


@implementation DateCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}


- (void)initView
{
    _weekLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height/2, self.bounds.size.width, self.bounds.size.height/2)];
    _weekLabel.textAlignment = NSTextAlignmentCenter;
    _weekLabel.font = [UIFont systemFontOfSize:14];
    _weekLabel.text = @"7月19日";
    [self addSubview:_weekLabel];
    
    _dateLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height/2)];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.font = [UIFont systemFontOfSize:12];
    _dateLabel.text = @"今天";
    [self addSubview:_dateLabel];
    
}
- (void)setTextTintColor:(UIColor *)textTintColor
{
    _textTintColor = textTintColor;
    _weekLabel.textColor = _textTintColor ;
    _dateLabel.textColor = _textTintColor ;
}

- (void)setWeek:(NSString *)week
{
    _week = week ;
    _weekLabel.text = _week ;
}
- (void)setDate:(NSString *)date
{
    _date = date ;
    _dateLabel.text = _date ;
}

@end
