//
//  EarnExtraSecondCell.m
//  Coach
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EarnExtraSecondCell.h"

@implementation EarnExtraSecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_firstSujectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,10.0 , 0.0, 0)];
    [_secondSubjectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10.0, 0.0, 0)];
    
}
- (IBAction)clickFirstSubjectBtn:(id)sender
{
    [_firstSujectBtn setImage:[UIImage imageNamed:@"earn_orangeCheck.png"] forState:UIControlStateNormal];
    [_secondSubjectBtn setImage:[UIImage imageNamed:@"earn_grayCheck.png"] forState:UIControlStateNormal];
    if (_delagate && [_delagate respondsToSelector:@selector(EarnExtraSecondCellSubjectBtn:)]) {
        [_delagate EarnExtraSecondCellSubjectBtn:@"科目二"];
    }
}
- (IBAction)clickSecondSubjectBtn:(id)sender
{
    [_firstSujectBtn setImage:[UIImage imageNamed:@"earn_grayCheck.png"] forState:UIControlStateNormal];
    [_secondSubjectBtn setImage:[UIImage imageNamed:@"earn_orangeCheck.png"] forState:UIControlStateNormal];
    if (_delagate && [_delagate respondsToSelector:@selector(EarnExtraSecondCellSubjectBtn:)]) {
        [_delagate EarnExtraSecondCellSubjectBtn:@"科目三"];
    }
}

- (void)setModel:(EarnAppointModel *)model
{
    _model = model;
    if ([_model.subjectId isEqualToString:@"1"]) {
        [_firstSujectBtn setImage:[UIImage imageNamed:@"earn_orangeCheck.png"] forState:UIControlStateNormal];
        [_secondSubjectBtn setImage:[UIImage imageNamed:@"earn_grayCheck.png"] forState:UIControlStateNormal];
    }else if ([_model.subjectId isEqualToString:@"2"]){
        [_firstSujectBtn setImage:[UIImage imageNamed:@"earn_grayCheck.png"] forState:UIControlStateNormal];
        [_secondSubjectBtn setImage:[UIImage imageNamed:@"earn_orangeCheck.png"] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
