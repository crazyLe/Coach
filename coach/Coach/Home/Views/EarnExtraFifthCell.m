//
//  EarnExtraFifthCell.m
//  Coach
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EarnExtraFifthCell.h"

@implementation EarnExtraFifthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_oneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,7.0 , 0.0, 0)];
//    [_twoBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,7.0 , 0.0, 0)];
    
    [_oneBtn addTarget:self action:@selector(clickOneBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickOneBtn:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(EarnExtraFifthCellOneBtn:)])
    {
        sender.selected =! sender.selected;
        if (sender.selected == NO) {
            [sender setImage:[UIImage imageNamed:@"earn_grayRound.png"] forState:UIControlStateNormal];
           [_delegate EarnExtraFifthCellOneBtn:@"NO"];
        }else if (sender.selected == YES){
            [sender setImage:[UIImage imageNamed:@"earn_tickRound"] forState:UIControlStateNormal];
            [_delegate EarnExtraFifthCellOneBtn:@"Yes"];
        }
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
