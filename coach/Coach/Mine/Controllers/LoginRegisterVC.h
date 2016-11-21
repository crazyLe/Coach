//
//  LoginRegisterVC.h
//  Coach
//
//  Created by LL on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

typedef void(^SuccessBlock)(void);

#import <UIKit/UIKit.h>

@interface LoginRegisterVC : UIViewController

@property (nonatomic,copy) SuccessBlock successBlock;
@end
