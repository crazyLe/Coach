//
//  ExtraMoneyVC.h
//  Coach
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "SuperViewController.h"
#import <UIKit/UIKit.h>

typedef enum {
    ExtraMoneyVCTypeAdmissionEarn = 1,
    ExtraMoneyVCTypeExtraMoney,
    ExtraMoneyVCTypeQueryBill
}ExtraMoneyVCType;

@interface ExtraMoneyVC : SuperViewController

@property (nonatomic,assign) ExtraMoneyVCType type;

@end
