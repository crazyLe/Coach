//
//  EditRentInfoVC.h
//  Coach
//
//  Created by LL on 16/8/12.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "RentViewController.h"
#import <UIKit/UIKit.h>

typedef void(^NeedRefreshBlock)(NSIndexPath *needRefreshIndex);

@interface EditRentInfoVC : SuperViewController

@property (nonatomic,assign)RentViewControllerType type;

@property (nonatomic,assign)BOOL isEditInfo; //标识是编辑还是新增 YES：编辑 NO : 新增

@property (nonatomic,copy)NeedRefreshBlock needRefreshBlock;

@property (nonatomic,strong)NSIndexPath *indexPath;  //记录Cell Index

@end
