//
//  TSkillsCell.m
//  Coach
//
//  Created by apple on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "TSkillsCell.h"

@interface TSkillsCell (){
    
    UILabel *_weekLabel;
//    UILabel *_dateLabel;
    
}

@end

//static NSInteger _spaceNum = 0;
@implementation TSkillsCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
//    _weekLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height/2, self.bounds.size.width, self.bounds.size.height/2)];
//    _weekLabel.textAlignment = NSTextAlignmentCenter;
//    _weekLabel.font = [UIFont systemFontOfSize:14];
//    _weekLabel.text = @"7月19日";
//    [self addSubview:_weekLabel];
    
    _subjectsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _subjectsBtn.frame = CGRectMake(5, 14, 70, 25);
    _subjectsBtn.backgroundColor = [UIColor whiteColor];
    [_subjectsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_subjectsBtn setTitle:@"全部" forState:UIControlStateNormal];
    _subjectsBtn.titleLabel.font = Font12;
    _subjectsBtn.layer.cornerRadius = 25.0/2;
    _subjectsBtn.userInteractionEnabled = NO;
    [self addSubview:_subjectsBtn];
    
}

//- (void)setTextTintColor:(UIColor *)textTintColor
//{
//    _textTintColor = textTintColor;
//    _weekLabel.textColor = _textTintColor ;
////    _dateLabel.textColor = _textTintColor ;
//}

- (void)setSubjectStr:(NSString *)subjectStr
{
    _subjectStr = subjectStr;
    [_subjectsBtn setTitle:subjectStr forState:UIControlStateNormal];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
