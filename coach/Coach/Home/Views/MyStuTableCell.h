//
//  MyStuTableCell.h
//  Coach
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyStuTableCellDelegate <NSObject>

- (void)phoneBtnClick:(NSInteger)index;
- (void)optionsBtnClick:(NSInteger) index;
- (void)invitationBtnClick:(NSInteger) index;

@end

@interface MyStuTableCell : UITableViewCell

@property (nonatomic, strong)UIImageView * imageV;

@property (nonatomic, strong)UILabel * nameLabel;

@property (nonatomic, strong)UILabel * unUseLabel;

@property (nonatomic, strong)UILabel * subjectsLabel;

@property (nonatomic, strong)UIButton * phoneBtn;

@property (nonatomic, strong)UIButton * optionsBtn;

@property (nonatomic, strong)UIButton * invitationBtn;

@property (nonatomic,assign) id<MyStuTableCellDelegate>delegate;

@property (nonatomic, assign) NSInteger index;

@end
