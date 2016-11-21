//
//  LLInputCell.h
//  Coach
//
//  Created by apple on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <SZTextView.h>
#import <UIKit/UIKit.h>

@class LLInputCell;

@protocol LLInputCellDelegate <NSObject>

- (void)LLInputCell:(LLInputCell *)cell textViewDidBeginEditing:(UITextView *)textView;

- (void)LLInputCell:(LLInputCell *)cell textViewDidEndEditing:(UITextView *)textView;

- (void)LLInputCell:(LLInputCell *)cell textViewDidChange:(UITextView *)textView;

@end

@interface LLInputCell : SuperTableViewCell <UITextViewDelegate>

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) SZTextView *textView;

@property (nonatomic,strong) UILabel *promptLbl;    

@property (nonatomic,assign) NSInteger maxInputNum; //最大输入数

@property (nonatomic,assign) id delegate;

- (void)refreshPromptLbl;

@end
