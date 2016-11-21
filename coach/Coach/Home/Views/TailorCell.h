//
//  TailorCell.h
//  KZXC_Headmaster
//
//  Created by 翁昌青 on 16/7/15.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TailorCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *showKey;
@property (weak, nonatomic) IBOutlet UITextField *showValue;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;

@end
