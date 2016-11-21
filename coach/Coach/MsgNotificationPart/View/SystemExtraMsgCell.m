//
//  SystemExtraMsgCell.m
//  Coach
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "SystemExtraMsgCell.h"

@implementation SystemExtraMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    
    _refuseBtn.layer.cornerRadius = 5.0;
    _refuseBtn.layer.borderWidth = 1.0;
    _refuseBtn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    _refuseBtn.backgroundColor = [UIColor whiteColor];
    _refuseBtn.tag = 100;
    [_refuseBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _acceptBtn.layer.cornerRadius = 5.0;
    _acceptBtn.layer.borderWidth = 1.0;
    _acceptBtn.layer.borderColor = [UIColor colorWithHexString:@"#6AC518"].CGColor;
    _acceptBtn.backgroundColor = [UIColor whiteColor];
    _acceptBtn.tag = 200;
    [_acceptBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)pressBtn:(UIButton *)sender
{
//    NSLog(@"++%@++",_student_idStr);
    if (_delegate && [_delegate respondsToSelector:@selector(SystemExtraMsgCell:tagStr:student_idStr:)]) {
        [_delegate SystemExtraMsgCell:self tagStr:[NSString stringWithFormat:@"%ld",(long)sender.tag] student_idStr:_student_idStr];
    }
}

//- (void)setStudent_idStr:(NSString *)student_idStr
//{
//    _student_idStr = student_idStr;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFrame:(CGRect)frame
{
    frame.origin.x = frame.origin.x+12;
    
    frame.size.width = frame.size.width-24;
    
    [super setFrame:frame];
}

@end
