//
//  EditFifthTableCell.h
//  Coach
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditFifthTableCell;

@protocol EditFifthTableCellDlegate <NSObject>

- (void)clickEditFifthTableCellSaveBtn;

- (void)EditFifthTableCell:(EditFifthTableCell *)cell clickPhotoImg:(UIImageView *)photoImgView;

@end

@interface EditFifthTableCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView IDstr:(NSString *)str;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *accessoryImageView;

@property (nonatomic, strong) NSMutableArray * photoImageArr;

@property (nonatomic,assign) id<EditFifthTableCellDlegate>delegate;

@end
