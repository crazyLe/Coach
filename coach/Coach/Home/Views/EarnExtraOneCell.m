//
//  EarnExtraOneCell.m
//  Coach
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EarnExtraOneCell.h"

@interface EarnExtraOneCell ()<UITextFieldDelegate>

@end

@implementation EarnExtraOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    [_startTimeBtn setTitle:@"开始时间" forState:UIControlStateNormal];
    _startTimeBtn.titleLabel.font = Font14;
    _startTimeBtn.tag = 100;
    _startTimeBtn.clipsToBounds = YES;
    _startTimeBtn.layer.cornerRadius = 3.0;
    _startTimeBtn.layer.borderWidth = 1;
    _startTimeBtn.layer.borderColor = rgb(223, 224, 224).CGColor;
//    [_startTimeBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [_startTimeBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    
//    [_endTimeBtn setTitle:@"结束时间" forState:UIControlStateNormal];
    _endTimeBtn.clipsToBounds = YES;
    _endTimeBtn.layer.cornerRadius = 2.0;
    _endTimeBtn.layer.borderWidth = 1;
    _endTimeBtn.layer.borderColor = rgb(223, 224, 224).CGColor;
    _endTimeBtn.titleLabel.font = Font14;
    _endTimeBtn.tag = 200;
//    [_endTimeBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [_endTimeBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)pressBtn:(UIButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(EarnExtraOneCell:clicBtn:)]) {
        [_delegate EarnExtraOneCell:self clicBtn:btn];
    }
}


@end
