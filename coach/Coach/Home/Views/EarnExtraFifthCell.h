//
//  EarnExtraFifthCell.h
//  Coach
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EarnExtraFifthCellDelegate <NSObject>

- (void)EarnExtraFifthCellOneBtn:(NSString *)str;

@end

@interface EarnExtraFifthCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
//@property (weak, nonatomic) IBOutlet UIButton *twoBtn;

@property (nonatomic, assign)id delegate;

@end
