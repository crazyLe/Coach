//
//  UIView+Animations.m
//  Coach
//
//  Created by apple on 16/7/15.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "UIView+Animations.h"

@implementation UIView (Animations)

- (void)ScaleFromSmallToBig
{
    CABasicAnimation * animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation2.fromValue = [NSNumber numberWithDouble:0];
    
    animation2.toValue = [NSNumber numberWithDouble:1];
    
    animation2.duration= 0.4f;
    
    animation2.autoreverses= NO;
    
    animation2.repeatCount= 1;
    
    [self.layer addAnimation:animation2 forKey:nil];
}

@end
