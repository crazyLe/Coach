//
//  EarnExtraFourthCell.h
//  Coach
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EarnAppointModel.h"

@protocol  EarnExtraFourthCellDelegate <NSObject>

- (void)EarnExtraFourthCellPersonNumTF:(NSString *)str withTextfield:(UITextField *)field;

@end

@interface EarnExtraFourthCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITextField *personNumTF;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;

@property (nonatomic, copy) NSString * infoStr;

@property (nonatomic, strong) EarnAppointModel * model;

@property (nonatomic, assign) id delegate;

@end
