//
//  EditTableViewCell.h
//  Coach
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardCoachModel.h"

@class EditTableViewCell;

@protocol EditTableViewCellDelegate <NSObject>

- (void)EditTableViewCell:(EditTableViewCell *)cell textFieldDidChanged:(UITextField *)textField;

@end

@interface EditTableViewCell : UITableViewCell

//+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UITextField *contentLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *accessoryImageView;
@property (nonatomic, strong) UILabel * lineLabel;

@property (nonatomic, strong) CardCoachModel * coachModel;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UILabel *unitLbl;

@property (nonatomic,assign) id delegate;

@end
