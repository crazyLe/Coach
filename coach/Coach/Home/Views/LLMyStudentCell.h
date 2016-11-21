//
//  LLMyStudentCell.h
//  Coach
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LLMyStudentCellBtnTagHead = 1,
    LLMyStudentCellBtnTagPhone,
    LLMyStudentCellBtnTagSetting,
    LLMyStudentCellBtnTagInvite
}LLMyStudentCellBtnTag;

@class LLMyStudentCell;

@protocol LLMyStudentCellDelegate <NSObject>

@optional

- (void)LLMyStudentCell:(LLMyStudentCell *)cell clickBtn:(UIButton *)btn;

@end

@interface LLMyStudentCell : SuperTableViewCell 

@property (nonatomic,strong) UIButton    *headBtn;

@property (nonatomic,strong) UILabel     *nameLbl;

@property (nonatomic,strong) UILabel     *stageLbl;

@property (nonatomic,strong) UIButton    *phoneBtn;

@property (nonatomic,strong) UIButton    *settingBtn;

@property (nonatomic,strong) UIButton    *notifyBtn;

@property (nonatomic,strong) UILabel     *promptLbl;

@property (nonatomic,strong) UIView      *lineView;

@property (nonatomic,strong) UIView      *topLine; //参考

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,assign) id delegate;

@end
