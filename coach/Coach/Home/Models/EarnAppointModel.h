//
//  EarnAppointModel.h
//  Coach
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EarnAppointModel : NSObject

@property (nonatomic, copy)NSString * carId;

@property (nonatomic, copy)NSString * classId;

@property (nonatomic, copy)NSString * end_time_hour;

@property (nonatomic, copy)NSString * money;

@property (nonatomic, copy)NSString *remaining;

@property (nonatomic, copy)NSString * start_time_hour;

@property (nonatomic, copy)NSString * state;

@property (nonatomic, copy)NSString * studentMax;

@property (nonatomic, copy)NSString * subjectId;

@property (nonatomic, copy)NSString * tplId;

@end
