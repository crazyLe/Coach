//
//  EarnOneCell.m
//  Coach
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EarnOneCell.h"

@implementation EarnOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _firstTF.tag = 10;
    _secondTF.tag = 20;
    _thirdTF.tag = 30;
    _fourthTF.tag = 40;
    
    [_firstTF addTarget:self action:@selector(TFChange:) forControlEvents:UIControlEventEditingChanged];
    [_secondTF addTarget:self action:@selector(TFChange:) forControlEvents:UIControlEventEditingChanged];
    [_thirdTF addTarget:self action:@selector(TFChange:) forControlEvents:UIControlEventEditingChanged];
    [_fourthTF addTarget:self action:@selector(TFChange:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)TFChange:(UITextField *)field
{
    if (_delegate && [_delegate respondsToSelector:@selector(EarnOneCellTF:)]) {
        [_delegate EarnOneCellTF:field];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
