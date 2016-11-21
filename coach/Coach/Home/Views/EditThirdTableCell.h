//
//  EditThirdTableCell.h
//  Coach
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditThirdTableCell;
@class EditCollectionCell;

@protocol EditThirdTableCellDelegate <NSObject>

- (void)tapEditThirdTableCellContent;

- (void)EditThirdTableCell:(EditThirdTableCell *)cell clickChooseBtnWithCell:(EditCollectionCell *)collectionCell;

@end

@interface EditThirdTableCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView IDstr:(NSString *)str;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *accessoryImageView;
@property (nonatomic, strong) UILabel * topLineLabel;
@property (nonatomic, strong) UILabel * lineLab;

@property (nonatomic, strong) NSArray *dataArray ;

@property (nonatomic, strong) UICollectionView * editCollectionView;

@property (nonatomic, assign) BOOL isCanSelect;
@property (nonatomic, strong) NSMutableArray *selectTagArr;

@property (nonatomic,assign) id<EditThirdTableCellDelegate>delegate;

@end
