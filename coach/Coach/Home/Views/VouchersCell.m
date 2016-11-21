//
//  VouchersCell.m
//  KZXC_Headmaster
//
//  Created by 翁昌青 on 16/7/19.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "VouchersCell.h"

@implementation VouchersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _price.attributedText = [self priceStr:@"¥200"];
    
    NSDictionary *juandict = @{NSObliquenessAttributeName:@0.5};
    
    NSMutableAttributedString *juanAttr = [[NSMutableAttributedString alloc]initWithString:@"优惠劵"];
    [juanAttr addAttributes:juandict range:NSMakeRange(0, [juanAttr length])];
    
    _juan.attributedText = juanAttr;
    
    _time.font = kFont10;
    _content.font = kFont15;
    
    [_send addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];

}

- (NSMutableAttributedString *)priceStr:(NSString *)price
{
    NSMutableAttributedString *priceAttr = [[NSMutableAttributedString alloc]initWithString:price];
    
    [priceAttr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-BoldOblique" size:30] range:NSMakeRange(1, price.length - 1)];
    
    [priceAttr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-BoldOblique" size:15] range:NSMakeRange(0, 1)];
    
    return priceAttr;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)clickBtn:(UIButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(VouchersCell:clickRePublicBtn:)]) {
        [_delegate VouchersCell:self clickRePublicBtn:btn];
    }
}

@end
