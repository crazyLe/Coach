//
//  EarnExtraThirdCell.h
//  Coach
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLButton.h"
#import <UIKit/UIKit.h>
#import "EarnAppointModel.h"

@protocol  EarnExtraThirdCellDelegate <NSObject>

- (void)EarnExtraThirdCellClickChooseBtn;
- (void)EarnExtraThirdCellVehicleTypeBtn:(NSString *)str;

@end

@interface EarnExtraThirdCell : UITableViewCell
//@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *carTF;
@property (weak, nonatomic) IBOutlet LLButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;

@property (nonatomic,assign) id delegate;

@property (nonatomic, strong) NSMutableArray * carArray;

@property (nonatomic, strong) EarnAppointModel* model;

@end
