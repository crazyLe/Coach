//
//  ImgTextFieldCell.h
//  Coach
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImgTextFieldCell;

@protocol ImgTextFieldCellDelegate <NSObject>

- (void)ImgTextFieldCell:(ImgTextFieldCell *)cell clickAccessoryBtn:(UIButton *)accessoryBtn;

- (void)ImgTextFieldCell:(ImgTextFieldCell *)cell textFieldDidEditingChanged:(UITextField *)textField;

- (void)ImgTextFieldCell:(ImgTextFieldCell *)cell textFieldDidEndEditing:(UITextField *)textField;

@end

@interface ImgTextFieldCell : SuperTableViewCell

@property (nonatomic,strong)UILabel *leftLbl;

@property (nonatomic,strong)UITextField *textField;

@property (nonatomic,strong)UIView *lineView;

@property (nonatomic,strong)UIButton *accessoryBtn; //右侧小配件

@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,assign)id delegate;

@end
