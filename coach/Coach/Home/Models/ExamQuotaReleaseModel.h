//
//  ExamQuotaReleaseModel.h
//  KZXC_Headmaster
//
//  Created by gaobin on 16/8/12.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamQuotaReleaseModel : NSObject

//考试名额-发布 or 我的考试名额

@property (nonatomic, copy) NSString * idStr;   //名额需求编号
@property (nonatomic, copy) NSString * addtime;
//@property (nonatomic, copy) NSString * adress;


@property (nonatomic, copy) NSString * trueName;
@property (nonatomic, copy) NSString * tel;
@property (nonatomic, copy) NSString * provinceId;
@property (nonatomic, copy) NSString * cityId;
@property (nonatomic, copy) NSString * areaId;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * peopleNum;
@property (nonatomic, copy) NSString * holdingTime;
@property (nonatomic, copy) NSString * region;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * price;



@end
