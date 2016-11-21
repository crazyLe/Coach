//
//  EditInfoVC.h
//  Coach
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "SuperViewController.h"
#import <UIKit/UIKit.h>

typedef enum {
    EditInfoVCTypeAdd = 0,
    EditInfoVCTypeEdit
}EditInfoVCType;

typedef void(^editSuccessBlock)(NSString *nameStr
                               ,NSString *phoneStr
                               ,NSString *subjectStr);

@interface EditInfoVC : SuperViewController

@property (nonatomic,assign) EditInfoVCType type;

@property (nonatomic,copy) editSuccessBlock successBlock;

@end
