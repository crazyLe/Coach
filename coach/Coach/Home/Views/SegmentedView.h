//
//  SegmentedView.h
//  Coach
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <HMSegmentedControl.h>

#import <UIKit/UIKit.h>

@class SegmentedView;

@protocol SegmentedViewDelegate <NSObject>

- (void)SegmentedView:(SegmentedView *)view segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl;

@end

@interface SegmentedView : UIView

@property (nonatomic,strong)HMSegmentedControl *segmentedControl;

@property (nonatomic,assign)id delegate;

- (id)initWithFrame:(CGRect)frame withSectionTitles:(NSArray *)titleArr;

@end
