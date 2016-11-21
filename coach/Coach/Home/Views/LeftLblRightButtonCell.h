//
//  LeftLblRightButtonCell.h
//  Coach
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLButton.h"

#import <UIKit/UIKit.h>

@class LeftLblRightButtonCell;

@protocol LeftLblRightButtonCellDelegate <NSObject>

- (void)LeftLblRightButtonCell:(LeftLblRightButtonCell *)cell clickRightBtn:(LLButton *)rightBtn;

@end

@interface LeftLblRightButtonCell : SuperTableViewCell

@property (nonatomic,strong)UILabel *leftLbl;

@property (nonatomic,strong)LLButton *rightBtn;

@property (nonatomic,strong)UIView *lineView;

@property (nonatomic,assign) id delegate;

@property (nonatomic,strong)NSIndexPath *indexPath;

@end
