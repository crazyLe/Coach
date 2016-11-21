//
//  PlaceRentDetailVC.h
//  Coach
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "SuperViewController.h"
#import <UIKit/UIKit.h>

typedef enum {
    RentDetailVCTypeCoachCarDetail = 0,
    RentDetailVCTypePlaceRent
}RentDetailVCType;

@interface CoachCarRentDetailVC : SuperViewController

@property (nonatomic,assign) RentDetailVCType type;

@end
