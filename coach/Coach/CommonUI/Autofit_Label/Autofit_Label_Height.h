//
//  Autofit_Label_Height.h
//  WanXiaCentury
//
//  Created by Will on 19/8/15.
//  Copyright (c) 2015年 Tousan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@interface Autofit_Label_Height : UILabel

- (id)initWithText:(NSString*)text Size:(CGFloat)textSize Frame:(CGRect)frame;
-(id)initWithText:(NSString *)text Size:(CGFloat)textSize Frame:(CGRect)frame oldWidth:(CGFloat)width;
-(id)initWithWidthText:(NSString *)text Size:(CGFloat)textSize Frame:(CGRect)frame oldWidth:(CGFloat)width;
@end
