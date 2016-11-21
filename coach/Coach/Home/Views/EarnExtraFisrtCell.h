//
//  EarnExtraFisrtCell.h
//  Coach
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EarnAppointModel.h"

@interface EarnExtraFisrtCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) EarnAppointModel * model;

@end
