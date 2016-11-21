//
//  LLSelectCityViewController.h
//  Coach
//
//  Created by LL on 16/9/21.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLOpenCityModel.h"
#import <UIKit/UIKit.h>

@class LLSelectCityViewController;

@protocol LLSelectCityViewControllerDelegate <NSObject>

- (void)LLSelectCityViewController:(LLSelectCityViewController *)vc didSelectCity:(LLOpenCityModel *)selectCityModel;

@end

@interface LLSelectCityViewController : SuperViewController

@property (nonatomic,strong)LLOpenCityModel *provinceModel; //省model

@property (nonatomic,assign) id delegate;

@end
