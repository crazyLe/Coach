//
//  EditCollectionCell.h
//  Coach
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTgaModel.h"

@class EditCollectionCell;

@protocol EditCollectionCellDelegate <NSObject>

- (void)EditCollectionCell:(EditCollectionCell *)cell clickChooseBtn:(UIButton *)chooseBtn;

@end

@interface EditCollectionCell : UICollectionViewCell

@property (nonatomic, strong)CardTgaModel * tgaModel;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, strong) UIButton * chooseBtn;

@property (nonatomic, assign) id delegate;

@end
