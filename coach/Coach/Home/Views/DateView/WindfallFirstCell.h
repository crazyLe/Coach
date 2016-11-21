//
//  WindfallFirstCell.h
//  Coach
//
//  Created by apple on 16/8/13.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  WindfallFirstCellDelegate<NSObject>

- (void)windfallFirstCell:(UITableViewCell *)cell withIndex:(NSInteger)index withState:(NSString *)state;

@end

@interface WindfallFirstCell : UITableViewCell

@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic, assign) id deleagte;

//@property (nonatomic, assign)NSInteger index;

@end
