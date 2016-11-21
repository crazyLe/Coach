//
//  Autofit_Label_Height.m
//  WanXiaCentury
//
//  Created by Will on 19/8/15.
//  Copyright (c) 2015年 Tousan. All rights reserved.
//

#import "Autofit_Label_Height.h"

@implementation Autofit_Label_Height

- (id)initWithText:(NSString*)text Size:(CGFloat)textSize Frame:(CGRect)frame;
{
    if (self = [super init]) {
        super.text = text;
        self.font = [UIFont systemFontOfSize:textSize];
        self.textAlignment = NSTextAlignmentLeft;
        self.numberOfLines = 0;
        self.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [self sizeThatFits:CGSizeMake(kScreenWidth - 20, MAXFLOAT)];
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height);
        return self;
    }
    return nil;
}
-(id)initWithText:(NSString *)text Size:(CGFloat)textSize Frame:(CGRect)frame oldWidth:(CGFloat)width;
{
    if (self = [super init]) {
        super.text = text;
        self.font = [UIFont systemFontOfSize:textSize];
        self.textAlignment = NSTextAlignmentLeft;
        self.numberOfLines = 0;
        self.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [self sizeThatFits:CGSizeMake(width, MAXFLOAT)];
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height);
        return self;
    }
    return nil;
}

-(id)initWithWidthText:(NSString *)text Size:(CGFloat)textSize Frame:(CGRect)frame oldWidth:(CGFloat)width;
{
    if (self = [super init]) {
        super.text = text;
        self.font = [UIFont systemFontOfSize:textSize];
        //self.textAlignment = NSTextAlignmentLeft;
        self.numberOfLines = 0;
        self.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [self sizeThatFits:CGSizeMake(width, MAXFLOAT)];
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, width, size.height);
        return self;
    }
    return nil;
}

@end
