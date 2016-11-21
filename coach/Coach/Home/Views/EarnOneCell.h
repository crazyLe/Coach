//
//  EarnOneCell.h
//  Coach
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EarnOneCellDelegate <NSObject>

- (void)EarnOneCellTF:(UITextField *)textField;

@end

@interface EarnOneCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *firstTF;
@property (weak, nonatomic) IBOutlet UITextField *secondTF;
@property (weak, nonatomic) IBOutlet UITextField *thirdTF;
@property (weak, nonatomic) IBOutlet UITextField *fourthTF;

@property (nonatomic, strong) id delegate;

@end
