//
//  CoachProveModel.h
//  Coach
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoachProveModel : NSObject

@property (nonatomic, copy)NSString * trueName;

@property (nonatomic, copy)NSString * IDNum;

@property (nonatomic, copy)NSString * IDPic;

@property (nonatomic, strong)UIImage *idImage;

@property (nonatomic, strong)UIImage *coachImage;

@property (nonatomic,copy) NSString * state;

@property (nonatomic, copy)NSString * coachNum;

@property (nonatomic, copy)NSString * coachPic;

@end
