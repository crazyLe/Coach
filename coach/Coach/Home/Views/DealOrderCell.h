//
//  DealOrderCell.h
//  Coach
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealOrderModel.h"

@protocol DealOrderCellDelegate <NSObject>

- (void)DealOrderCellClickBtn:(UIButton *)sender withIdStr:(NSString *)str withTimeStr:(NSString *)time;

@end

@interface DealOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectsLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointLabel;
//@property (weak, nonatomic) IBOutlet UILabel *firstTime;
//@property (weak, nonatomic) IBOutlet UILabel *secondTime;
//@property (weak, nonatomic) IBOutlet UILabel *firstPlacesLabel;
//@property (weak, nonatomic) IBOutlet UILabel *secondPlacesLabel;
@property (weak, nonatomic) IBOutlet UILabel *EarningsLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet UITableView *bookTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refuseBtnHeight;

@property (nonatomic, assign) id delegate;

@property (nonatomic, strong)DealOrderModel * model;

@end
