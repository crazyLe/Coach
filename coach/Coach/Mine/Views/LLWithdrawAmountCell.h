//
//  LLWithdrawAmountCell.h
//  学员端
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLWithdrawAmountCell;

@protocol LLWithdrawAmountCellDelegate <NSObject>

- (void)LLWithdrawAmountCell:(LLWithdrawAmountCell *)cell textFieldDidChange:(UITextField *)textField;

@end

@interface LLWithdrawAmountCell : SuperTableViewCell

@property (nonatomic,strong) UILabel *leftLbl;

@property (nonatomic,strong) UITextField *textField;

@property (nonatomic,strong) UIImageView *accessoryImgView;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,assign) id delegate;

@end
