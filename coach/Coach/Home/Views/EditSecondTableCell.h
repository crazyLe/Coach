//
//  EditSecondTableCell.h
//  Coach
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditSecondTableCell;

//@protocol EditSecondTableCellDelegate <NSObject>
//
//- (void)EditSecondTableCell:(EditSecondTableCell *)cell clickRightBtn:(UIButton *)rightBtn;
//
//@end

@interface EditSecondTableCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView IDstr:(NSString *)str;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *accessoryImageView;

//@property (nonatomic,assign) id delegate;

//@property (nonatomic, strong) UIButton *rightBtn;

@end
