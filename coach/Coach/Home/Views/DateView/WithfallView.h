//
//  WithfallView.h
//  Coach
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WithfallView;

@protocol WithfallViewDelegate <NSObject>

- (void)WithfallView:(WithfallView *)view collectionViewScrollBeginOrEnd:(BOOL)isEnd;


/**
 *  选中星期几
 */
- (void)withfallViewDidSelectedIndex:(NSInteger)index ;

@end

@interface WithfallView : UIView

@property(nonatomic,strong)UIButton * leftScrollBtn;
@property(nonatomic,strong)UIButton * rightSrcollBtn;

@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,  weak) id<WithfallViewDelegate>delegate;

@end
