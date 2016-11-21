//
//  UICollectionView+LLPlaceHolder.h
//  Coach
//
//  Created by LL on 16/8/13.
//  Copyright © 2016年 sskz. All rights reserved.
//

/********** 由CYLTableViePlaceHolder改写 ************/

#import <UIKit/UIKit.h>

@protocol LLCollectionViewPlaceHolderDelegate <NSObject>

@required
/*!
 @brief  make an empty overlay view when the tableView is empty
 @return an empty overlay view
 */
- (UIView *)makePlaceHolderView;

@optional
/*!
 @brief enable tableView scroll when place holder view is showing, it is disabled by default.
 @attention There is no need to return  NO, it will be NO by default
 @return enable tableView scroll, you can only return YES
 */
- (BOOL)enableScrollWhenPlaceHolderViewShowing;

@end

@interface UICollectionView (LLPlaceHolder)

/*!
 @brief just use this method to replace `reloadData` ,and it can help you to add or remove place holder view automatically
 @attention this method has already reload the tableView,so do not reload tableView any more.
 */
- (void)ll_reloadData;

@end
