//
//  LLPersonSettingCell.h
//  Coach
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLPersonSettingCell;

@protocol LLPersonSettingCellDelegate <NSObject>

- (void)LLPersonSettingCell:(LLPersonSettingCell *)cell textFieldDidChange:(UITextField *)textField;

- (void)LLPersonSettingCell:(LLPersonSettingCell *)cell clickHeadBtn:(UIButton *)headBtn;

@end

@interface LLPersonSettingCell : SuperTableViewCell

@property (nonatomic,strong) UILabel *leftLbl;

@property (nonatomic,strong) UITextField *rightTF;

@property (nonatomic,strong) UIImageView *accessoryImgView;

@property (nonatomic,strong) UIButton *headBtn;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,assign) id delegate;

@end
