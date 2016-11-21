//
//  SystemExtraMsgCell.h
//  Coach
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MsgModel;
@class SystemExtraMsgCell;
@protocol SystemExtraMsgCellDelegate <NSObject>

- (void)SystemExtraMsgCell:(SystemExtraMsgCell *)cell tagStr:(NSString *)tag student_idStr:(NSString *)student_idStr;

@end

@interface SystemExtraMsgCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;

@property (strong,nonatomic) MsgModel *model;

@property (nonatomic, copy) NSString * student_idStr;

@property (nonatomic, assign) id <SystemExtraMsgCellDelegate>delegate;

@end
