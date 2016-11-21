//
//  AppointListTableCell.h
//  Coach
//
//  Created by LL on 16/8/9.
//  Copyright © 2016年 sskz. All rights reserved.
//

@class AppointListTableCell;

@protocol AppointListTableCellDelegate <NSObject>

- (void)AppointListTableCell:(AppointListTableCell *)cell clickCancelBtn:(UIButton *)cancelBtn;

@end

#import <UIKit/UIKit.h>

@interface AppointListTableCell : SuperTableViewCell

@property (nonatomic,strong) UIView *bgView,*topBgView;

@property (nonatomic,strong) UILabel *numLbl,*infoLbl,*timeLbl,*priceLbl,*statusLbl;

@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,assign) id delegate;

@end
