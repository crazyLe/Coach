//
//  LLRechargeCell.h
//  Coach
//
//  Created by apple on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLInputView.h"
#import <UIKit/UIKit.h>

@class LLRechargeCell;

@protocol LLRechargeCellDelegate <NSObject>

- (void)LLRechargeCell:(LLRechargeCell *)cell moneyTextFieldDidChanged:(UITextField *)textField;

- (void)LLRechargeCell:(LLRechargeCell *)cell earnBeansTextFieldDidChanged:(UITextField *)textField;

- (void)LLRechargeCell:(LLRechargeCell *)cell clickRechargeBtn:(UIButton *)rechargeBtn;

@end

@interface LLRechargeCell : SuperTableViewCell

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIImageView *bgImgView;

@property (nonatomic,strong) UILabel *beansRemainLbl,*desLbl;

@property (nonatomic,strong) UIButton *rechargeBtn;

@property (nonatomic,strong) LLInputView *amountInputView,*rechargeBeansNumView;

@property (nonatomic,assign) id delegate;

@end
