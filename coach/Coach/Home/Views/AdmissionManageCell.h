//
//  AdmissionManageCell.h
//  Coach
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdmissionManageCell;

@protocol AdmissionManageCellDelegate <NSObject>

@optional

- (void)AdmissionManageCell:(AdmissionManageCell *)cell clickHeadBtn:(UIButton *)headBtn;

- (void)AdmissionManageCell:(AdmissionManageCell *)cell clickPhoneBtn:(UIButton *)phoneBtn;

- (void)AdmissionManageCell:(AdmissionManageCell *)cell clickSetBtn:(UIButton *)setBtn;

@end

@interface AdmissionManageCell : SuperTableViewCell

@property (nonatomic,strong)UIButton *headBtn,*phoneBtn,*setBtn;

@property (nonatomic,strong)UILabel  *nameLbl,*statusLbl,*totolNumLbl;

@property (nonatomic,strong)UIView *lineView;

@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,weak)  id delegate;

@end
