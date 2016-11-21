//
//  LLAdmissionAlertView.h
//  Coach
//
//  Created by LL on 16/8/15.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAdmissionAlertView;

@protocol LLAdmissionAlertViewDelegate <NSObject,UITextFieldDelegate>

//点击充值按钮
- (void)LLAdmissionAlertView:(LLAdmissionAlertView *)view clickRechargeBtn:(UIButton *)btn;
//点击底部确认按钮
- (void)LLAdmissionAlertView:(LLAdmissionAlertView *)view clickConfirmSelectBtn:(UIButton *)btn;
//点击退出按钮
- (void)LLAdmissionAlertView:(LLAdmissionAlertView *)view clickExitSelectBtn:(UIButton *)btn;

//将要消失
- (void)alertViewWillDismiss:(LLAdmissionAlertView *)alertView;
//已经消失
- (void)alertViewDidDismiss:(LLAdmissionAlertView *)alertView;

//textField编辑改变回调
- (void)LLAdmissionAlertView:(LLAdmissionAlertView *)view textFieldDidChange:(UITextField *)textField;

- (void)LLAdmissionAlertView:(LLAdmissionAlertView *)view textFieldDidEndEditing:(UITextField *)textField;

@end

@interface LLAdmissionAlertView : UIView

+ (LLAdmissionAlertView *)showWithTitle:(NSString *)title textFieldPlaceHolder:(NSString *)placeHolder confirmBtnTitle:(NSString *)confimTitle rechargeBtnTitle:(NSString *)rechargeTitle beansUnit:(NSString *)unit beansRemain:(NSMutableAttributedString *)beansRemainAtt object:(id)obj userInfo:(NSDictionary *)userInfo delegate:(id)delegate;

- (void)dismiss;

@property (nonatomic,strong) UIView *coverView,*bgView,*lineView;

@property (nonatomic,strong) UILabel *titleLbl,*unitLbl,*beansRemainLbl;

@property (nonatomic,strong) UIButton *exitBtn;

@property (nonatomic,strong) UIButton *confirmBtn,*rechargeBtn;

@property (nonatomic,strong) UITextField *textField;

@property (nonatomic,strong) id object;

@property (nonatomic,strong) NSDictionary *userInfo;

@property (nonatomic,assign) id delegate;

@end
