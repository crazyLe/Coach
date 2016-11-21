//
//  LLCouponView.h
//  Coach
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLCouponView;

@protocol LLCouponViewDelegate <NSObject>

@optional

- (void)LLCouponView:(UIView *)view clickCouponBtn:(UIButton *)couponBtn;

@end

@interface LLCouponView : UIView

@property (nonatomic,strong) UIButton *couponBtn;

@property (nonatomic,strong) UILabel *leftLbl,*rightLbl;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,assign) id delegate;

@end
