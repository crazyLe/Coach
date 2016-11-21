//
//  ExamScheduleCell.h
//  Coach
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 sskz. All rights reserved.
//

#define kSideOffset 10

#import <UIKit/UIKit.h>

@class ExamScheduleCell;

@protocol ExamScheduleCellDelegate <NSObject>

- (void)ExamScheduleCell:(ExamScheduleCell *)cell clickHeadBtn:(UIButton *)headBtn;

- (void)ExamScheduleCell:(ExamScheduleCell *)cell clickPhoneBtn:(UIButton *)phoneBtn;

- (void)ExamScheduleCell:(ExamScheduleCell *)cell clickNotifyBtn:(UIButton *)notifyBtn;

@end

@interface ExamScheduleCell : SuperTableViewCell

@property (nonatomic,strong) UIButton    *headBtn;

@property (nonatomic,strong) UILabel     *nameLbl;

@property (nonatomic,strong) UILabel     *stageLbl;

@property (nonatomic,strong) UIButton    *phoneBtn;

@property (nonatomic,strong) UIButton    *notifyBtn;

@property (nonatomic,strong) UIView      *lineView;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,assign) id delegate;

@end
