//
//  TinyClassesModel.h
//  KZXC_Headmaster
//
//  Created by gaobin on 16/8/13.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TinyClassesModel : NSObject
//驾照类型
@property (nonatomic, copy) NSString * classCar;
//日期
@property (nonatomic, copy) NSString * classDate;
//班级id
@property (nonatomic, copy) NSString * classId;
//学费
@property (nonatomic, copy) NSString * classMoney;
//班级名称
@property (nonatomic, copy) NSString * className;


@property(nonatomic,copy)NSString * otherTime;


@end
