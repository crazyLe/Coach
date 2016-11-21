//
//  TSkillsView.h
//  Coach
//
//  Created by apple on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TSkillsViewDelegate <NSObject>

/**
 *  选中
 */
- (void)tSkillsViewDidSelectedIndex:(NSInteger)index ;

@end

@interface TSkillsView : UIView

@property (nonatomic,  weak) id<TSkillsViewDelegate>delegate ;

@property (nonatomic, strong) NSArray *dataArray ;

@end
