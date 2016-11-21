//
//  EarnExtraOneCell.h
//  Coach
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EarnExtraOneCell;

@protocol EarnExtraOneCellDelegate <NSObject>

@optional

- (void)EarnExtraOneCell:(EarnExtraOneCell *)cell clicBtn:(UIButton *)btn;

@end

@interface EarnExtraOneCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;


@property (nonatomic,assign) id <EarnExtraOneCellDelegate> delegate;

@end
