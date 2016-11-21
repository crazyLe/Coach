//
//  WithdrawRecordController.h
//  学员端
//
//  Created by zuweizhong  on 16/8/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

//#import "BaseViewController.h"
#import "SuperViewController.h"

typedef enum {
    WithdrawRecordControllerTypeRecharge = 1, //充值
    WithdrawRecordControllerTypeWithdraw  //提现
}WithdrawRecordControllerType;

@interface WithdrawRecordController : SuperViewController

@property (nonatomic,assign)WithdrawRecordControllerType type; 

@end


@interface WithdrawGroupModel : NSObject

@property(nonatomic,strong)NSMutableArray * withdrawModelArr;

@property(nonatomic,strong)NSString * month;

@end