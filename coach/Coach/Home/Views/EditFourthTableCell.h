//
//  EditFourthTableCell.h
//  Coach
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditFourthTableCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView IDstr:(NSString *)str;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *accessoryImageView;

@end
