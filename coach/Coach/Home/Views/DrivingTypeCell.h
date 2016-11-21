//
//  DrivingTypeCell.h
//  KZXC_Headmaster
//
//  Created by 翁昌青 on 16/7/15.
//  Copyright © 2016年 cqingw. All rights reserved.
//


#import <UIKit/UIKit.h>
@class DrivingTypeCell;
typedef void(^cancleBlock)(id sender);
typedef void(^succeedBlock)(DrivingTypeCell *sender);
typedef void (^updateFrame)(UITextField *sender);
typedef void (^resetFrame)();

typedef void(^deleteType)();

@interface DrivingTypeCell : UITableViewCell <UITextFieldDelegate>
//{
//    int lastFirIndex;
//    int lastSecIndex;
//}
@property(assign,nonatomic)int lastFirIndex;
@property(assign,nonatomic)int lastSecIndex;
@property (weak, nonatomic) IBOutlet UITextField *DrivingClassName;

@property (weak, nonatomic) IBOutlet UIButton *C1;

@property (weak, nonatomic) IBOutlet UIButton *C2;

@property (weak, nonatomic) IBOutlet UIButton *C3;

@property (weak, nonatomic) IBOutlet UIButton *B1;

@property (weak, nonatomic) IBOutlet UIButton *B2;
@property (weak, nonatomic) IBOutlet UIButton *A1;
@property (weak, nonatomic) IBOutlet UIButton *A2;

@property (weak, nonatomic) IBOutlet UIButton *A3;


@property (weak, nonatomic) IBOutlet UITextField *DrivingPrice;


@property (weak, nonatomic) IBOutlet UITextField *OtherDrivingTime;

@property(copy,nonatomic)cancleBlock cancle;
@property(copy,nonatomic)succeedBlock succeed;
@property(copy,nonatomic)updateFrame update;
@property(copy,nonatomic)resetFrame reset;

@property(copy,nonatomic)deleteType deleteself;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@property (weak, nonatomic) IBOutlet UIButton *timeBtn1;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn2;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn3;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn4;

@end
