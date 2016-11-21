//
//  WFDateCollectCell.h
//  Coach
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EarnCalendarModel.h"

@interface WFDateCollectCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *publishLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong)EarnCalendarModel * calendarModel;

@end
