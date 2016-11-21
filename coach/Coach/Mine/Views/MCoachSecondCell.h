//
//  MCoachSecondCell.h
//  Coach
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCoachSecondCellDelegate <NSObject>

- (void)MCoachSecondCellContentTF:(UITextField *)contentTF withIndex:(NSInteger)index;

@end

@interface MCoachSecondCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet UITextField *contentTF;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) id delegate;

@end
