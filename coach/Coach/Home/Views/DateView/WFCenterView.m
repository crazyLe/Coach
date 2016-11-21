//
//  WFCenterView.m
//  Pod演示
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WFCenterView.h"

@implementation WFCenterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -1, self.frame.size.width+4, self.frame.size.height+12)];
//    _bgImageView.backgroundColor = [UIColor redColor];
    _bgImageView.image = [UIImage imageNamed:@"earn_publish"];
    [self addSubview:_bgImageView];
    
    _publishLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 8, self.frame.size.width-6, 17)];
    _publishLabel.font = Font14;
    _publishLabel.textAlignment = NSTextAlignmentCenter;
//    _publishLabel.text = @"未发布";
    _publishLabel.textColor = [UIColor whiteColor];
//    _publishLabel.backgroundColor = [UIColor orangeColor];
    [self addSubview:_publishLabel];
    
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, CGRectGetMaxY(_publishLabel.frame)+7, self.frame.size.width-6, 15)];
    _dateLabel.font = Font15;
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
//    _dateLabel.text = @"8-31";
//    _dateLabel.backgroundColor = [UIColor yellowColor];
    [self addSubview:_dateLabel];
    
    _weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(_dateLabel.frame)+7, self.frame.size.width-10, 15)];
    _weekLabel.font = Font15;
    _weekLabel.textAlignment = NSTextAlignmentCenter;
//    _weekLabel.text = @"今天";
    _weekLabel.textColor = [UIColor whiteColor];
//    _weekLabel.backgroundColor = [UIColor blueColor];
    [self addSubview:_weekLabel];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    [self createUI];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




@end
