//
//  DealOrderModel.h
//  Coach
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DealOrderModel : NSObject

@property (nonatomic, copy)NSString * addtime;

@property (nonatomic, copy)NSString * idStr;

@property (nonatomic, copy)NSString * money;

@property (nonatomic, copy)NSString * state;

@property (nonatomic, strong)NSArray * timeList;

@property (nonatomic, copy)NSString * title;

@end
