//
//  RentViewController.h
//  Coach
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "SuperViewController.h"
#import <UIKit/UIKit.h>

typedef enum {
    RentViewControllerTypeCoachCarRent = 1,
    RentViewControllerTypePlaceRent
}RentViewControllerType;

@interface RentViewController : SuperViewController

@property (nonatomic,assign)RentViewControllerType type;

@end
