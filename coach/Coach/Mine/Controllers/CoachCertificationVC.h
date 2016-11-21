//
//  CoachCertificationVC.h
//  Coach
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "SuperViewController.h"

#import "CoachProveModel.h"
typedef void (^RefreshBlock)(NSString *type);

@interface CoachCertificationVC : SuperViewController

@property (nonatomic, copy)RefreshBlock refresh;

@property (nonatomic, strong) CoachProveModel * coachModel;

@end
