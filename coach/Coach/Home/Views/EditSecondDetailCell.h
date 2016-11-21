//
//  EditSecondDetailCell.h
//  Coach
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardClassesModel.h"

@class EditSecondDetailCell;

@protocol EditSecondDetailCellDelegate <NSObject>

- (void)EditSecondDetailCell:(EditSecondDetailCell *)cell clickFifthLbl:(UILabel *)lbl;

@end

@interface EditSecondDetailCell : UITableViewCell

@property (nonatomic, strong) UILabel * firstLabel;
@property (nonatomic, strong) UILabel * secondLabel;
@property (nonatomic, strong) UILabel * thirdLabel;
@property (nonatomic, strong) UILabel * fourthLabel;
@property (nonatomic, strong) UILabel * fifthLabel;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong)CardClassesModel * classModel;

@property (nonatomic, assign) id delegate;

@end
