//
//  CitySelectController.h
//  学员端
//
//  Created by zuweizhong  on 16/8/1.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SuperViewController.h"

typedef void(^DidSelectCityBlock)(NSString *city);

@interface CitySelectController : SuperViewController

@property (nonatomic,copy) DidSelectCityBlock didSelectCityBlock;

@end
