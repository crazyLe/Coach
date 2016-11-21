//
//  LLEarnBeansCell.h
//  学员端
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LLEarnBeansCellBtnTypeHeadBtn = 10,
    LLEarnBeansCellBtnTypeRechargeBtn,
    LLEarnBeansCellBtnTypeWithdrawBtn,
    LLEarnBeansCellBtnTypeRecordBtn,
    LLEarnBeansCellBtnTypeRuleBtn,
    LLEarnBeansCellBtnTypeHelpBtn
}LLEarnBeansCellBtnType;

@class LLEarnBeansCell;

@protocol LLEarnBeansCellDelegate <NSObject>

- (void)LLEarnBeansCell:(LLEarnBeansCell *)cell clickBtn:(UIButton *)btn;

@end

@interface LLEarnBeansCell : SuperTableViewCell

@property (nonatomic,strong) UIButton *headBtn,*rechargeBtn,*withdrawBtn,*recordBtn,*ruleBtn,*helpBtn;

@property (nonatomic,strong) UILabel *nameLbl;

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,assign) id delegate;

@end
