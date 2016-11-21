//
//  SegmentedView.m
//  Coach
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 sskz. All rights reserved.
//


#import "SegmentedView.h"

@implementation SegmentedView

- (id)initWithFrame:(CGRect)frame withSectionTitles:(NSArray *)titleArr
{
    if (self = [super initWithFrame:frame]) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:titleArr];
        _segmentedControl.frame = CGRectMake(10, 10, 300, 60);
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_segmentedControl];
        //    segmentedControl.backgroundColor = [UIColor redColor];
        [_segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        _segmentedControl.selectionIndicatorColor = [UIColor colorWithHexString:@"0X5cb6ff"];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0X646464"],NSFontAttributeName:[UIFont boldSystemFontOfSize:16]};
        _segmentedControl.selectionIndicatorHeight = 3.0f;
        _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, -25, 0, -50);
        _segmentedControl.borderWidth = 1.0f;
        _segmentedControl.borderColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
        _segmentedControl.borderType = HMSegmentedControlBorderTypeBottom;
    }
    return self;
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl
{
    if (_delegate && [_delegate respondsToSelector:@selector(SegmentedView:segmentedControlChangedValue:)]) {
        [_delegate SegmentedView:self segmentedControlChangedValue:segmentedControl];
    }
}

@end
