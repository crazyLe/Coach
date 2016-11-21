//
//  ExamSendCell.h
//  Coach
//
//  Created by 翁昌青 on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExamSendCell;

@protocol ExamSendCellDelegate <NSObject>

- (void)ExamSendCell:(ExamSendCell *)cell textFieldDidChanged:(UITextField *)textField;

- (void)ExamSendCell:(ExamSendCell *)cell textFieldDidEndEdited:(UITextField *)textField;

- (void)ExamSendCell:(ExamSendCell *)cell textFieldDidBeginEdited:(UITextField *)textField;

@end

@interface ExamSendCell : UITableViewCell <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *key;


@property (weak, nonatomic) IBOutlet UITextField *value;
@property (weak, nonatomic) IBOutlet UIImageView *jiantou;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,assign) id delegate;

@end
