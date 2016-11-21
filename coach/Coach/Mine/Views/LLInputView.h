//
//  LLInputView.h
//  Coach
//
//  Created by apple on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLInputView;

@protocol LLInputViewDelegate <NSObject>

- (void)LLInputView:(LLInputView *)view textFieldEditChanged:(UITextField *)textField;

@end

@interface LLInputView : UIView 

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UILabel *titleLbl,*unitLbl;

@property (nonatomic,strong) UITextField *textField;

@property (nonatomic,strong) UIButton *accessoryBtn;

@property (nonatomic,assign) id delegate;

@end
