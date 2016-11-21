//
//  AddressBookCell.m
//  Coach
//
//  Created by gaobin on 16/8/1.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "AddressBookCell.h"

@implementation AddressBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _subjectBgView.layer.cornerRadius = 5;
    _subjectBgView.clipsToBounds = YES;
    _subjectBgView.backgroundColor = kTableBgColor;
    [_subjectBtn addTarget:self action:@selector(subjectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _subjectTrailing.constant = (kScreenWidth-10-15-10-110-40)/2;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectSubject:)];
    [self.subjectBgView addGestureRecognizer:tap];
    
}
- (void)subjectBtnClick {
    
    
    
    
}
- (void)layoutSubviews {
    

    
}

- (void)selectSubject:(UITapGestureRecognizer *)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(AddressBookCell:clickSubjectBgView:)]) {
        [_delegate AddressBookCell:self clickSubjectBgView:tap.view];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
