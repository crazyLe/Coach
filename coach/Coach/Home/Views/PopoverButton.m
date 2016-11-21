//
//  PopoverButton.m
//  Coach
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "PopoverButton.h"

@implementation PopoverButton

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithHexString:@"0X999999"];
    }
    else
    {
        self.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    }
}

@end
