//
//  WindfallSecondCell.h
//  Coach
//
//  Created by apple on 16/8/13.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  WindfallSecondCellDelegate <NSObject>

- (void)windfallSecondCell:(UITableViewCell *)cell withIndex:(NSInteger)index withState:(NSString *)state;

@end

@interface WindfallSecondCell : UITableViewCell

@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic, assign)id delegate;

//@property (nonatomic, assign)NSInteger index;

@end
