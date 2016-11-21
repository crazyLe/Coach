//
//  MEHZCell.h
//  KZXC_Headmaster
//
//  Created by 翁昌青 on 16/7/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamQuotaReleaseModel.h"

typedef void(^pushBlock)(ExamQuotaReleaseModel *examQuotaRelease);

@interface MEHZCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *place;

@property (weak, nonatomic) IBOutlet UILabel *personnum;
@property (weak, nonatomic) IBOutlet UILabel *placestatue;

@property (weak, nonatomic) IBOutlet UILabel *explain;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIButton *own;

@property (copy,nonatomic) pushBlock push;

@property (nonatomic, strong) ExamQuotaReleaseModel * examQuotaRelease;

@end
