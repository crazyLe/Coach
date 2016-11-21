//
//  UICollectionView+LLPlaceHolder.m
//  Coach
//
//  Created by LL on 16/8/13.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "UICollectionView+LLPlaceHolder.h"
#import <objc/runtime.h>

@interface UICollectionView ()

@property (nonatomic, assign) BOOL scrollWasEnabled;
@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation UICollectionView (LLPlaceHolder)

- (BOOL)scrollWasEnabled {
    NSNumber *scrollWasEnabledObject = objc_getAssociatedObject(self, @selector(scrollWasEnabled));
    return [scrollWasEnabledObject boolValue];
}

- (void)setScrollWasEnabled:(BOOL)scrollWasEnabled {
    NSNumber *scrollWasEnabledObject = [NSNumber numberWithBool:scrollWasEnabled];
    objc_setAssociatedObject(self, @selector(scrollWasEnabled), scrollWasEnabledObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)placeHolderView {
    return objc_getAssociatedObject(self, @selector(placeHolderView));
}

- (void)setPlaceHolderView:(UIView *)placeHolderView {
    objc_setAssociatedObject(self, @selector(placeHolderView), placeHolderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)ll_reloadData {
    [self reloadData];
    [self cyl_checkEmpty];
}

- (void)cyl_checkEmpty {
    BOOL isEmpty = YES;
    
    id<UICollectionViewDataSource> src = self.dataSource;
    NSInteger sections = 1;
    if ([src respondsToSelector: @selector(numberOfSectionsInCollectionView:)]) {
        sections = [src numberOfSectionsInCollectionView:self];
    }
    for (int i = 0; i<sections; ++i) {
        NSInteger rows = [src collectionView:self numberOfItemsInSection:i];
        if (rows) {
            isEmpty = NO;
        }
        
    }
    
    if (!isEmpty) {
        self.mj_footer.hidden = NO; //显示footer
    }
    
    if (!isEmpty != !self.placeHolderView) {
        if (isEmpty) {
            self.scrollWasEnabled = self.scrollEnabled;
            BOOL scrollEnabled = NO;
            if ([self respondsToSelector:@selector(enableScrollWhenPlaceHolderViewShowing)]) {
                scrollEnabled = [self performSelector:@selector(enableScrollWhenPlaceHolderViewShowing)];
                if (!scrollEnabled) {
                    NSString *reason = @"There is no need to return  NO for `-enableScrollWhenPlaceHolderViewShowing`, it will be NO by default";
                    @throw [NSException exceptionWithName:NSGenericException
                                                   reason:reason
                                                 userInfo:nil];
                }
            } else if ([self.delegate respondsToSelector:@selector(enableScrollWhenPlaceHolderViewShowing)]) {
                scrollEnabled = [self.delegate performSelector:@selector(enableScrollWhenPlaceHolderViewShowing)];
                if (!scrollEnabled) {
                    NSString *reason = @"There is no need to return  NO for `-enableScrollWhenPlaceHolderViewShowing`, it will be NO by default";
                    @throw [NSException exceptionWithName:NSGenericException
                                                   reason:reason
                                                 userInfo:nil];
                }
            }
            self.scrollEnabled = scrollEnabled;
            
            [self setPlaceHolderView];
            
            [self addSubview:self.placeHolderView];
        } else {
            self.scrollEnabled = self.scrollWasEnabled;
            [self.placeHolderView removeFromSuperview];
            self.placeHolderView = nil;
        }
    } else if (isEmpty) {
        // Make sure it is still above all siblings.
        [self.placeHolderView removeFromSuperview];
        
        [self setPlaceHolderView];
        
        [self addSubview:self.placeHolderView];
    }
}

- (void)setPlaceHolderView
{
    if ([self respondsToSelector:@selector(makePlaceHolderView)]) {
        self.placeHolderView = [self performSelector:@selector(makePlaceHolderView)];
        self.mj_footer.hidden = YES; //隐藏footer
    } else if ( [self.delegate respondsToSelector:@selector(makePlaceHolderView)]) {
        self.placeHolderView = [self.delegate performSelector:@selector(makePlaceHolderView)];
        self.mj_footer.hidden = YES; //隐藏footer
    } else {
        NSString *selectorName = NSStringFromSelector(_cmd);
        NSString *reason = [NSString stringWithFormat:@"You must implement makePlaceHolderView method in your custom tableView or its delegate class if you want to use %@", selectorName];
        @throw [NSException exceptionWithName:NSGenericException
                                       reason:reason
                                     userInfo:nil];
    }
    self.placeHolderView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end