//
//  LeftLblRightTFCell.h
//  Coach
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeftLblRightTFCell;

@protocol LeftLblRightTFCellDelegate <NSObject,UITextFieldDelegate>

- (void)LeftLblRightTFCell:(LeftLblRightTFCell *)cell textFieldDidChange:(UITextField *)textField;

- (void)LeftLblRightTFCell:(LeftLblRightTFCell *)cell textFieldDidEndEditing:(UITextField *)textField;

@end

@interface LeftLblRightTFCell : SuperTableViewCell

@property (nonatomic,strong)UILabel *leftLbl;

@property (nonatomic,strong)UITextField *rightTF;

@property (nonatomic,strong)UIImageView *accessoryImgView;

@property (nonatomic,strong)UIView *lineView;

@property (nonatomic,assign) id delegate;

@property (nonatomic,strong) NSIndexPath *indexPath;

@end
