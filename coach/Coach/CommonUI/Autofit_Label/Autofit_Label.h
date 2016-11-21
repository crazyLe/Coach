//
//  Autofit_Label.h
//  CentralChinaMerchant
//
//  Created by user on 15/4/25.
//  Copyright (c) 2015年 tousan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Autofit_Label : UILabel

@property(nonatomic,strong)NSMutableAttributedString *attText;

- (id)initWithText:(NSString*)text Size:(CGFloat)textSize Frame:(CGRect)frame;
- (id)initWithAttributeText:(NSString *)text Size:(CGFloat)textSize Frame:(CGRect)frame;
- (void)setText:(NSString *)text;

@end
