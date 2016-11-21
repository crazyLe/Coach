//
//  SendDDJController.h
//  Coach
//
//  Created by 翁昌青 on 16/7/30.
//  Copyright © 2016年 sskz. All rights reserved.
//

typedef enum {
    EditCouponTypeAdd, //新增代金券
    EditCouponTypeEdit //编辑代金券
}EditCouponType;

typedef void(^SuccessBlock)(EditCouponType type);

#import "SuperViewController.h"

@interface SendDDJController : SuperViewController

@property (nonatomic,assign) EditCouponType type;

@property (nonatomic,copy) SuccessBlock successBlock;

@end
