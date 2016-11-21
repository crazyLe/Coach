//
//  EarnView.m
//  Coach
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EarnView.h"
#import "DayBtnView.h"

@interface EarnView ()

@property(nonatomic,strong)NSDate * currentLeftDate;

@property(nonatomic,strong)NSDate * startDate;

@property(nonatomic,strong)NSMutableArray * itemViewArray;

@end

@implementation EarnView

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
    self.itemViewArray = [NSMutableArray array];
    
    UIButton *leftScrollBtn = [[UIButton alloc]init];
    
    self.leftScrollBtn = leftScrollBtn;
    
    self.leftScrollBtn.backgroundColor = [UIColor colorWithHexString:@"#38424c"];
    
    [self.leftScrollBtn setImage:[UIImage imageNamed:@"earn_leftMark"] forState:UIControlStateNormal];
    
    [self.leftScrollBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:leftScrollBtn];
    
    self.dayBtnArray = [NSMutableArray array];
    
    self.currentLeftDate = [NSDate date];
    
    self.startDate = [NSDate date];
    
    for (int i = 0; i<5; i++) {
        
        DayBtnView *dayBtn = [[[NSBundle mainBundle]loadNibNamed:@"DayBtnView" owner:nil options:nil]lastObject];
        
        dayBtn.tag = 5000+i;
        
        //
        dayBtn.publishLabel.text = @"未发布";
        
        dayBtn.topLabel.text = [self getDateStringByIndex:i];
        
        NSDate *date = [GHDateTools dateByAddingDays:self.currentLeftDate day:i];
        
        dayBtn.bottomLabel.text = [self getWeekDayWithDate:date];
        
        if (date.isToday) {
            dayBtn.bottomLabel.text = @"今天";
        }
        if ([[NSDate compareDate:date] isEqualToString:@"明天"]) {
            dayBtn.bottomLabel.text = @"明天";
        }
        
        [dayBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dayBtnClick:)]];
        
        [self addSubview:dayBtn];
        
        [self.dayBtnArray addObject:dayBtn];
        
        
        
        
    }
    
    UIButton *rightScrollBtn = [[UIButton alloc]init];
    
    self.rightSrcollBtn = rightScrollBtn;
    
    self.rightSrcollBtn.backgroundColor = [UIColor colorWithHexString:@"#38424c"];
    
    [self.rightSrcollBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rightSrcollBtn setImage:[UIImage imageNamed:@"earn_rightMark"] forState:UIControlStateNormal];
    
    [self addSubview:rightScrollBtn];
    
    [self createLayoutSubviews];
}

-(void)createLayoutSubviews
{
    //    [super layoutSubviews];
    
    [self.leftScrollBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(0);
        
        make.top.offset(0);
        
        make.width.equalTo(@34);
        
        make.height.equalTo(@72);
        
    }];
    
    CGFloat itemWidth = (kScreenWidth-34*2)/5;
    
    for (int i = 0; i<self.dayBtnArray.count; i++) {
        
        DayBtnView *btn = self.dayBtnArray[i];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(itemWidth*i+34);
            make.top.equalTo(self.leftScrollBtn.mas_top);
            make.height.equalTo(self.leftScrollBtn.mas_height);
            make.width.equalTo(@(itemWidth));
        }];
        
        
        if (i == 2) {
            
            
            btn.bgImageView.hidden = NO;
            
            btn.publishLabel.textColor = [UIColor whiteColor];
            
            btn.topLabel.textColor = [UIColor whiteColor];
            
            btn.bottomLabel.textColor = [UIColor whiteColor];
            
            btn.topLabel.font = [UIFont systemFontOfSize:15];
            
            btn.bottomLabel.font = [UIFont systemFontOfSize:13];
            
            btn.backgroundColor = [UIColor whiteColor];
            
            btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
            
            btn.bgImageView.image = [UIImage imageNamed:@"earn_publish"];
            
        }else
        {
            
            btn.bgImageView.hidden = YES;
            
        }
        
    }
    
    [self.rightSrcollBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftScrollBtn.mas_top);
        make.right.offset(0);
        make.width.equalTo(@34);
        make.height.equalTo(self.leftScrollBtn.mas_height);
    }];
}


-(void)dayBtnClick:(UITapGestureRecognizer  *)tap
{
    
    DayBtnView *btn = (DayBtnView *)tap.view;
    
    if ([btn.topLabel.text isEqualToString:@""]) {
        return;
    }
    
    if ([btn.bottomLabel.text isEqualToString:@"今天"]) {
        
        self.currentLeftDate = [GHDateTools dateByAddingDays:_currentLeftDate day:btn.tag-5000-2];
        
        for (int i = 0; i<self.dayBtnArray.count; i++) {
            
            
            
            DayBtnView *dayBtn = self.dayBtnArray[i];
            
            //
            dayBtn.publishLabel.text = @"未发布";
            
            dayBtn.topLabel.text = [self getDateStringByIndex:i];
            
            NSDate *date1 = [GHDateTools dateByAddingDays:self.currentLeftDate day:i];
            
            dayBtn.bottomLabel.text = [self getWeekDayWithDate:date1];
            
            if (date1.isToday) {
                dayBtn.bottomLabel.text = @"今天";
            }
            if ([[NSDate compareDate:date1] isEqualToString:@"明天"]) {
                dayBtn.bottomLabel.text = @"明天";
            }
            
            if (i == 0 || i==1) {
                dayBtn.bottomLabel.text = @"";
                dayBtn.topLabel.text = @"";
                dayBtn.publishLabel.text = @"";
            }
            
            
            
        }
        
        return;
    }
    if ([btn.bottomLabel.text isEqualToString:@"明天"]) {
        
        self.currentLeftDate = [GHDateTools dateByAddingDays:_currentLeftDate day:btn.tag-5000-2];
        
        for (int i = 0; i<self.dayBtnArray.count; i++) {
            
            
            
            DayBtnView *dayBtn = self.dayBtnArray[i];
            
            //
            dayBtn.publishLabel.text = @"未发布";
            
            dayBtn.topLabel.text = [self getDateStringByIndex:i];
            
            NSDate *date1 = [GHDateTools dateByAddingDays:self.currentLeftDate day:i];
            
            dayBtn.bottomLabel.text = [self getWeekDayWithDate:date1];
            
            if (date1.isToday) {
                dayBtn.bottomLabel.text = @"今天";
            }
            if ([[NSDate compareDate:date1] isEqualToString:@"明天"]) {
                dayBtn.bottomLabel.text = @"明天";
            }
            
            if (i == 0) {
                dayBtn.bottomLabel.text = @"";
                dayBtn.topLabel.text = @"";
                dayBtn.publishLabel.text = @"";
            }
            
        }
        
        return;
    }
    self.currentLeftDate = [GHDateTools dateByAddingDays:_currentLeftDate day:btn.tag-5000-2];
    
    for (int i = 0; i<self.dayBtnArray.count; i++) {
        
        DayBtnView *dayBtn = self.dayBtnArray[i];
        
        dayBtn.publishLabel.text = @"未发布";
        
        dayBtn.topLabel.text = [self getDateStringByIndex:i];
        
        NSDate *date1 = [GHDateTools dateByAddingDays:self.currentLeftDate day:i];
        
        dayBtn.bottomLabel.text = [self getWeekDayWithDate:date1];
        
        if (date1.isToday) {
            dayBtn.bottomLabel.text = @"今天";
        }
        if ([[NSDate compareDate:date1] isEqualToString:@"明天"]) {
            dayBtn.bottomLabel.text = @"明天";
        }
        
        
    }
    
}
-(void)leftBtnClick
{
    DayBtnView *dayBtn = self.dayBtnArray[0];
    
    if ([dayBtn.topLabel.text isEqualToString:@""]||dayBtn.topLabel.text == nil ) {
        return;
    }
    
    if ([GHDateTools isDateSameDay:self.currentLeftDate andTwoDate:self.startDate]) {
        return;
    }
    self.currentLeftDate = [GHDateTools dateByAddingDays:self.currentLeftDate day:-1];
    
    for (int i = 0; i<self.dayBtnArray.count; i++) {
        
        DayBtnView *dayBtn = self.dayBtnArray[i];
        
        dayBtn.publishLabel.text = @"未发布";
        
        dayBtn.topLabel.text = [self getDateStringByIndex:i];
        
        NSDate *date = [GHDateTools dateByAddingDays:self.currentLeftDate day:i];
        
        dayBtn.bottomLabel.text = [self getWeekDayWithDate:date];
        
        if (date.isToday) {
            dayBtn.bottomLabel.text = @"今天";
        }
        if ([[NSDate compareDate:date] isEqualToString:@"明天"]) {
            dayBtn.bottomLabel.text = @"明天";
        }
        
        
    }
    
    
    
    
}

-(void)rightBtnClick
{
    
    DayBtnView *btn = self.dayBtnArray[2];
    
    if ([btn.bottomLabel.text isEqualToString:@"今天"]) {
        
        self.currentLeftDate = [GHDateTools dateByAddingDays:self.currentLeftDate day:1];
        
        for (int i = 0; i<self.dayBtnArray.count; i++) {
            
            DayBtnView *dayBtn = self.dayBtnArray[i];
            
            dayBtn.publishLabel.text = @"未发布";
            
            dayBtn.topLabel.text = [self getDateStringByIndex:i];
            
            NSDate *date1 = [GHDateTools dateByAddingDays:self.currentLeftDate day:i];
            
            dayBtn.bottomLabel.text = [self getWeekDayWithDate:date1];
            
            if (date1.isToday) {
                dayBtn.bottomLabel.text = @"今天";
            }
            if ([[NSDate compareDate:date1] isEqualToString:@"明天"]) {
                dayBtn.bottomLabel.text = @"明天";
            }
            
            if (i == 0) {
                dayBtn.bottomLabel.text = @"";
                dayBtn.topLabel.text = @"";
                dayBtn.publishLabel.text = @"";
            }
            
            
            
        }
        
        return;
    }
    
    self.currentLeftDate = [GHDateTools dateByAddingDays:self.currentLeftDate day:1];
    
    for (int i = 0; i<self.dayBtnArray.count; i++) {
        
        DayBtnView *dayBtn = self.dayBtnArray[i];
        
        dayBtn.publishLabel.text = @"未发布";
        
        dayBtn.topLabel.text = [self getDateStringByIndex:i];
        
        NSDate *date = [GHDateTools dateByAddingDays:self.currentLeftDate day:i];
        
        dayBtn.bottomLabel.text = [self getWeekDayWithDate:date];
        
        if (date.isToday) {
            dayBtn.bottomLabel.text = @"今天";
        }
        if ([[NSDate compareDate:date] isEqualToString:@"明天"]) {
            dayBtn.bottomLabel.text = @"明天";
        }
        
        
    }
    
    
}
-(NSString *)getWeekDayWithDate:(NSDate *)date
{
    if ([GHDateTools isMonday:date]) {
        return @"周一";
    }
    else if([GHDateTools isTuesday:date])
    {
        
        return @"周二";
        
    }
    else if([GHDateTools isWednesday:date])
    {
        
        return @"周三";
        
    }
    else if([GHDateTools isThursday:date])
    {
        
        return @"周四";
        
    }
    else if([GHDateTools isFriday:date])
    {
        
        return @"周五";
        
    }
    else if([GHDateTools isSaturday:date])
    {
        
        return @"周六";
        
    }
    else if([GHDateTools isSunday:date])
    {
        
        return @"周日";
        
    }
    
    return nil;
    
}
-(NSString *)getDateStringByIndex:(int)index
{
    
    NSDate *date = [GHDateTools dateByAddingDays:self.currentLeftDate day:index];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    
    df.dateFormat = @"MM-dd";
    
    return [df stringFromDate:date];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
