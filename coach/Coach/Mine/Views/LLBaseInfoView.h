//
//  LLBaseInfoView.h
//  学员端
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLBaseInfoView;

@protocol LLBaseInfoViewDelegate <NSObject>

@optional

- (void)LLBaseInfoView:(LLBaseInfoView *)view clickHeadBtn:(UIButton *)headBtn;

- (void)LLBaseInfoView:(LLBaseInfoView *)view clickRechargeBtn:(UIButton *)rechargeBtn;

- (void)LLBaseInfoView:(LLBaseInfoView *)view clickWithdrawBtn:(UIButton *)withdrawBtn;

@end

@interface LLBaseInfoView : UIView

@property (nonatomic,strong) UIButton *headBtn,*certificationBtn,*rechargeBtn,*withdrawBtn;

@property (nonatomic,strong) UILabel *nameLbl,*infoLbl,*studentIdLbl,*remainLbl;

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,assign) id delegate;

@end
