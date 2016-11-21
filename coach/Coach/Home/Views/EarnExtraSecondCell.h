//
//  EarnExtraSecondCell.h
//  Coach
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EarnAppointModel.h"

@protocol EarnExtraSecondCellDelegate <NSObject>

- (void)EarnExtraSecondCellSubjectBtn:(NSString *)str;

@end

@interface EarnExtraSecondCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *firstSujectBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondSubjectBtn;

@property (nonatomic, assign) id delagate;

@property (nonatomic, strong)EarnAppointModel * model;

@end
