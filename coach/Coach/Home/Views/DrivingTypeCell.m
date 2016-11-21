//
//  DrivingTypeCell.m
//  KZXC_Headmaster
//
//  Created by 翁昌青 on 16/7/15.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "DrivingTypeCell.h"

@implementation DrivingTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (IBAction)cancel:(id)sender {
    self.cancle(sender);
}
- (IBAction)sure:(id)sender {
    self.succeed(self);
}
- (IBAction)DrivingClassNameClick:(UIButton *)sender {
    
    NSInteger index = sender.tag;
    
    if (0 != _lastFirIndex) {
        
        UIButton *btn = [self viewWithTag:_lastFirIndex];
        btn.selected = NO;
    }
    sender.selected = YES;
    _lastFirIndex = (int)index;
    
    if (sender == self.C1) {
        _C2.selected = NO;
    }
    
    if (sender == self.C2) {
        _C1.selected = NO;
    }
}

- (IBAction)TimeClick:(UIButton *)sender {
    
    NSInteger index = sender.tag;
    
    if (0 != _lastSecIndex) {
        
        UIButton *btn = [self viewWithTag:_lastSecIndex];
        
        btn.selected = NO;
    }
    
    sender.selected = YES;
    
    _lastSecIndex = (int)index;
    
}

- (IBAction)LearnPriceClick:(id)sender {
//    self.update(sender);
}
- (IBAction)OtherTimeClick:(id)sender {
//    self.update(sender);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
     self.update(textField);
}
- (IBAction)otherTimeTFDidBeginEditing:(id)sender
{
    NSArray *btnArr = @[_timeBtn1,_timeBtn2,_timeBtn3,_timeBtn4];
    for (UIButton *btn in btnArr) {
        btn.selected = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.reset();
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)deleteClass:(id)sender {
    self.deleteself();
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
