//
//  Autofit_Label.m
//  CentralChinaMerchant
//
//  Created by user on 15/4/25.
//  Copyright (c) 2015年 tousan. All rights reserved.
//

#define CustomLabelWidth(text, font) \
[(text) boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:(font)} context:nil].size.width
#define CustomLabelHeight(text, font) \
[(text) boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:(font)} context:nil].size.height

#import "Autofit_Label.h"
#import "Header.h"

@implementation Autofit_Label

- (id)initWithText:(NSString*)text Size:(CGFloat)textSize Frame:(CGRect)frame;
{
    self = [super init];
    if (self)
    {
        super.text = text;
        self.font = [UIFont systemFontOfSize:textSize];
        self.textAlignment = NSTextAlignmentCenter;
        CGFloat labelWidth = CustomLabelWidth(self.text, self.font);
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, labelWidth+5*Scale, frame.size.height);
    }
    return self;
}

- (id)initWithAttributeText:(NSString *)text Size:(CGFloat)textSize Frame:(CGRect)frame
{
    self = [super init];
    if (self)
    {
        _attText = [[NSMutableAttributedString alloc]initWithString:text];
        [_attText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:textSize] range:NSMakeRange(0, _attText.length)];
        [_attText addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, _attText.length)];
        self.attributedText = _attText;
        self.textAlignment = NSTextAlignmentCenter;
        CGFloat labelWidth = CustomLabelWidth(text, self.font);
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, labelWidth+5*Scale, frame.size.height);
    }
    return self;
}

- (void)setText:(NSString *)text;
{
    super.text = text;
    CGFloat labelWidth = CustomLabelWidth(self.text, self.font);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, labelWidth+5*Scale, self.frame.size.height);
}

@end
