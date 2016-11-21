//
//  MCoachSecondCell.m
//  Coach
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "MCoachSecondCell.h"

@implementation MCoachSecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _contentTF.borderStyle = UITextBorderStyleNone;
    _contentTF.textAlignment = UITextAlignmentRight;
    [_contentTF addTarget:self action:@selector(contentTF:) forControlEvents:UIControlEventEditingChanged];

    
}

- (void)contentTF:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(MCoachSecondCellContentTF:withIndex:)]) {
        [_delegate MCoachSecondCellContentTF:_contentTF withIndex:_index];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
