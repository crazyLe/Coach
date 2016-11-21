//
//  LLGuideViewController.h
//  Coach
//
//  Created by LL on 16/8/26.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickEntryBlock)(UIButton *entryBtn);

@interface LLGuideViewController : UIViewController

//引导图片名称数组
//imgNameArr : 图片数组
//title      : 进入按钮标题
- (id)initWithImgNameArr:(NSArray *)imgNameArr entryBtnTitle:(NSString *)title entryBtnBlock:(ClickEntryBlock)block;

@end
