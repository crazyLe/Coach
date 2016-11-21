//
//  LLCustomAlertView.h
//  Coach
//
//  Created by LL on 16/8/9.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <SZTextView.h>
#import <UIKit/UIKit.h>

typedef enum {
    SelectBtnTypeLeftBtn = 10,
    SelectBtnTypeCenterBtn,
    SelectBtnTypeRightBtn
}SelectBtnType;

@class LLCustomAlertView;

@protocol LLCustomAlertViewDelegate <NSObject>

//点击选则按钮
- (void)LLCustomAlertView:(LLCustomAlertView *)view clickSelectBtn:(UIButton *)btn;
//点击底部确认按钮
- (void)LLCustomAlertView:(LLCustomAlertView *)view clickConfirmSelectBtn:(UIButton *)btn;
//点击退出按钮
- (void)LLCustomAlertView:(LLCustomAlertView *)view clickExitSelectBtn:(UIButton *)btn;

//将要消失
- (void)alertViewWillDismiss:(LLCustomAlertView *)alertView;
//已经消失
- (void)alertViewDidDismiss:(LLCustomAlertView *)alertView;

//textField编辑改变回调
- (void)LLCustomAlertView:(LLCustomAlertView *)view textViewDidChange:(SZTextView *)textView;

- (void)LLCustomAlertView:(LLCustomAlertView *)view textViewDidBeginEditing:(SZTextView *)textView;

@end

@interface LLCustomAlertView : UIView <UITextViewDelegate>

+ (LLCustomAlertView *)showWithTitle:(NSString *)title btnTitleArr:(NSArray *)titleArr textFieldPlaceHolder:(NSString *)placeHolder confirmBtnTitle:(NSString *)confimTitle object:(id)obj userInfo:(NSDictionary *)userInfo delegate:(id)delegate;

- (void)dismiss;

@property (nonatomic,strong) UIView *coverView,*bgView,*lineView;

@property (nonatomic,strong) UILabel *titleLbl;

@property (nonatomic,strong) UIButton *exitBtn,*leftSelectBtn,*centerSelectBtn,*rightSelectBtn;

@property (nonatomic,strong) SZTextView *textView;

@property (nonatomic,strong) UIButton *confirmBtn;

@property (nonatomic,strong) NSArray *btnArr;

@property (nonatomic,strong) id object;

@property (nonatomic,strong) NSDictionary *userInfo;

@property (nonatomic,assign) id delegate;

@end
