//
//  AccountSecurityVC.h
//  Coach
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "SuperViewController.h"

typedef void(^ChangeSuccessBlock)(void);

@interface AccountSecurityVC : SuperViewController

@property (nonatomic,copy) ChangeSuccessBlock successBlock;

@end
