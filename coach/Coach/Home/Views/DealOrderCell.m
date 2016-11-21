//
//  DealOrderCell.m
//  Coach
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "DealOrderCell.h"
#import "DOBookCell.h"

@interface DealOrderCell ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * _timeListArray;

}

@end

@implementation DealOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _timeListArray = [NSMutableArray array];
    
    _topView.layer.borderColor = rgb(176, 196, 244).CGColor;
    _topView.layer.borderWidth = 1;
    
    _acceptBtn.layer.borderWidth = 1;
    _acceptBtn.layer.borderColor = rgb(37, 106, 252).CGColor;
    _acceptBtn.tag = 10;
    _refuseBtn.layer.borderWidth = 1;
    _refuseBtn.layer.borderColor = rgb(215, 64, 70).CGColor;
    _refuseBtn.tag = 20;
    _EarningsLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    _bookTable.delegate = self;
    _bookTable.dataSource = self;
    _bookTable.scrollEnabled = NO;
    _bookTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bookTable.showsVerticalScrollIndicator = NO;
    
    
}

- (void)setModel:(DealOrderModel *)model
{
    _model = model;
    
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString1 = [dateFormat1 stringFromDate:[NSDate dateWithTimeIntervalSince1970:[_model.addtime doubleValue]]];
    
    _orderTimeLabel.text = [NSString stringWithFormat:@"订单时间:（%@）",dateString1];
    _nameLabel.text = model.title;
    _EarningsLabel.text = [NSString stringWithFormat:@"收益:¥%@",_model.money];
    
    if ([_model.state isEqualToString:@"1"]) {
        _refuseBtnHeight.constant = 0;
        _refuseBtn.hidden = YES;
        _acceptBtn.hidden = YES;
    }else{
        _refuseBtnHeight.constant = 30;
        _acceptBtn.hidden = NO;
        _refuseBtn.hidden = NO;
    }
    
    _timeListArray = [_model.timeList mutableCopy];
    [_bookTable reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return _model.timeList.count;
    return _timeListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 22;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string = @"cell";
    DOBookCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DOBookCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString1 = [dateFormat1 stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[_timeListArray[indexPath.row] objectForKey:@"start_time"] doubleValue]]];
    
//    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
//    [dateFormat2 setDateFormat:@"hh:mm"];
//    NSString * dateString2 = [dateFormat2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[_timeListArray[indexPath.row] objectForKey:@"end_time"] doubleValue]]];
    
    NSLog(@"---%@---",dateString1);
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%@-%@",dateString1,[_timeListArray[indexPath.row] objectForKey:@"desc"]];
    cell.personLabel.text = [_timeListArray[indexPath.row] objectForKey:@"time_length"];
//    cell.timeLabel.backgroundColor = [UIColor blueColor];
    
//    cell.personLabel.text = 
//    cell.backgroundColor = [UIColor cyanColor];
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickAcceptBtn:(id)sender
{
    
    [_acceptBtn setBackgroundColor:[UIColor colorWithHexString:@"#2e83ff"]];
    [_acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString1 = [dateFormat1 stringFromDate:[NSDate dateWithTimeIntervalSince1970:[_model.addtime doubleValue]]];
    
    if (_delegate && [_delegate respondsToSelector:@selector(DealOrderCellClickBtn:withIdStr:withTimeStr:)]) {
        [_delegate DealOrderCellClickBtn:sender withIdStr:_model.idStr withTimeStr:dateString1];
    }
    
}
- (IBAction)clickRefuseBtn:(id)sender
{
    [_refuseBtn setBackgroundColor:[UIColor colorWithHexString:@"#f96262"]];
    [_refuseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString1 = [dateFormat1 stringFromDate:[NSDate dateWithTimeIntervalSince1970:[_model.addtime doubleValue]]];
    
    if (_delegate && [_delegate respondsToSelector:@selector(DealOrderCellClickBtn:withIdStr:withTimeStr:)]) {
        [_delegate DealOrderCellClickBtn:sender withIdStr:_model.idStr withTimeStr:dateString1];
    }
}



@end
