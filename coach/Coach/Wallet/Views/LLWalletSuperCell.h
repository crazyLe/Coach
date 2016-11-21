//
//  LLWalletSuperCell.h
//  学员端
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLButton.h"
#import <UIKit/UIKit.h>

@interface LLWalletSuperCell : SuperTableViewCell

@property (nonatomic,strong) UIView *bgView,*leftView;

@property (nonatomic,strong) UILabel *titleLbl;

@property (nonatomic,strong) LLButton *rightBtn;

@end
