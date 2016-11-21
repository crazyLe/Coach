//
//  EarnExtraFourthCell.m
//  Coach
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EarnExtraFourthCell.h"

@implementation EarnExtraFourthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_personNumTF addTarget:self action:@selector(personNumTFChange) forControlEvents:UIControlEventEditingChanged];
    // Initialization code
}

- (void)setModel:(EarnAppointModel *)model
{
    _model = model;
    if([_infoStr isEqualToString:@"人数"]){
        _personNumTF.text = _model.studentMax;
    }else if ([_infoStr isEqualToString:@"价格"]){
        _personNumTF.text = _model.money;
    }
    
}

- (void)personNumTFChange
{
    if (_delegate && [_delegate respondsToSelector:@selector(EarnExtraFourthCellPersonNumTF:withTextfield:)]) {
        [_delegate EarnExtraFourthCellPersonNumTF:_infoStr withTextfield:_personNumTF];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
