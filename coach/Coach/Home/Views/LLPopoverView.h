//
//  LLPopoverView.h
//  Coach
//
//  Created by LL on 16/7/26.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLPopoverView;

@protocol LLPopoverViewDelegate <NSObject>

@optional

- (void)LLPopoverView:(LLPopoverView *)view didSelectItemAtIndex:(NSInteger)index;

- (void)popoverViewWillDismiss:(LLPopoverView *)view;

- (void)popoverViewDidDismiss:(LLPopoverView *)view;

@end

@interface LLPopoverView : UIView <UITableViewDelegate,UITableViewDataSource>

//rect    : 显示的矩形frame
//view    : 添加到哪个view上
//itemArr : item数组，由字符串组成 比如：@[@"Item1",@"Item2"] 
//delegate: 代理      可传nil
//object  : 携带的对象 可传nil
+ (LLPopoverView *)showAtRect:(CGRect)rect inView:(UIView *)view withItemArr:(NSArray *)itemArr delegate:(id)delegate object:(id)obj;

@property (nonatomic,strong) NSArray      *ItemTitleArr;
@property (nonatomic,strong) UIImage      *bgImg;

@property (nonatomic,strong) UIColor      *selectedBgColor;

@property (nonatomic,strong) UIColor      *highlightBgColor;
@property (nonatomic,strong) NSDictionary *highlightTitleAttributes;

@property (nonatomic,strong) UIColor      *normalBgColor;
@property (nonatomic,strong) NSDictionary *normalTitleAttributes;

@property (nonatomic,assign) CGFloat      sectionHeaderHeight;

@property (nonatomic,strong) id object; //携带的对象

@property (nonatomic,strong) NSDictionary *userInfo; //用户信息，可携带对象

@property (nonatomic,assign) id delegate; 

@end
