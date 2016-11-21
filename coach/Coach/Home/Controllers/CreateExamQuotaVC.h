//
//  CreateExamQuotaVC.h
//  KZXC_Headmaster
//
//  Created by gaobin on 16/8/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamQuotaReleaseModel.h"
#import "SuperViewController.h"

@interface CreateExamQuotaVC : SuperViewController

@property (nonatomic, assign) BOOL isNewAdd;

@property (nonatomic, strong) ExamQuotaReleaseModel * examQuotaRelease;

@end
