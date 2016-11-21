//
//  EditFirstTableCell.h
//  Coach
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditFirstTableCell;

@protocol EditFirstTableCellDelegate <NSObject>

- (void)EditFirstTableCell:(EditFirstTableCell *)cell imageView:(UIImageView *)avatorImageView;

@end

@interface EditFirstTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (nonatomic, assign) id delegate;

@end
