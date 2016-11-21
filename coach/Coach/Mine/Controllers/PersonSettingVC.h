//
//  PersonSettingVC.h
//  Coach
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "SuperViewController.h"
#import <UIKit/UIKit.h>

typedef void(^changePersonInfoSuccess)(void);

@interface PersonSettingVC : SuperViewController    

@property (nonatomic,copy) changePersonInfoSuccess settingSuccessBlock;

@end
