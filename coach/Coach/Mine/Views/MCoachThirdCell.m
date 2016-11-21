//
//  MCoachThirdCell.m
//  Coach
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "MCoachThirdCell.h"

@implementation MCoachThirdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickUploadBtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickMCoachThirdCellDelegateUploadBtn:WithIndex:)])
    {
        [self.delegate clickMCoachThirdCellDelegateUploadBtn:_uploadBtn WithIndex:_index];
    }
}

@end
