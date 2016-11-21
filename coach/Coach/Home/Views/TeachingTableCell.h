//
//  TeachingTableCell.h
//  Coach
//
//  Created by apple on 16/7/15.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeachArticleModel.h"

@interface TeachingTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *topImagView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;
@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;

@property (weak, nonatomic) IBOutlet UILabel *publishLabel;

@property (nonatomic, strong) TeachArticleModel * articleModel;

@end
