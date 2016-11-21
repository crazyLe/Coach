//
//  LLWalletCell.h
//  Coach
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLButton.h"
#import "LLWalletSuperCell.h"
#import <UIKit/UIKit.h>

@class LLWalletCell;

@protocol LLWalletCell <NSObject>

- (void)LLWalletCell:(LLWalletCell *)cell clickDetailBtn:(UIButton *)detailBtn;

@end

@interface LLWalletCell : LLWalletSuperCell

@property (nonatomic,strong) LLButton *detailBtn;

@property (nonatomic,strong) UIButton *orderNumBtn,*earnBeansNumBtn;

@property (nonatomic,assign) id delegate;

@property (nonatomic,strong) NSIndexPath *indexPath;

@end
