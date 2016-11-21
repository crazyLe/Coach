//
//  LoginRegisterCell.h
//  Coach
//
//  Created by LL on 16/8/3.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginRegisterCell;

@protocol LoginRegisterCellDelegate <NSObject>

@optional

- (void)LoginRegisterCell:(LoginRegisterCell *)cell clickCaptchBtn:(UIButton *)captchBtn;

- (void)LoginRegisterCell:(LoginRegisterCell *)cell textFieldDidEditingChanged:(UITextField *)textField;

- (BOOL)LoginRegisterCell:(LoginRegisterCell *)cell textFieldShouldReturn:(UITextField *)textField;

@end

@interface LoginRegisterCell : SuperTableViewCell   <UITextFieldDelegate>

@property (nonatomic,strong)UIView *bgView;

@property (nonatomic,strong)UIImageView *iconImgView;

@property (nonatomic,strong)UITextField *textField;

@property (nonatomic,strong)UIView *lineView;

@property (nonatomic,strong)UIButton *captchaBtn;

@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,assign)NSInteger timerTotalSecond;    //定时总时间

@property (nonatomic,assign)CGFloat   timerInterval; //定时器时间间隔

@property (nonatomic,copy)  NSString *captchaBtnTitle;

@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,assign)id delegate;

//开始倒计时
- (void)startCountdown;

//停止倒计时
- (void)stopCountdown;

@end
