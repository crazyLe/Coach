//
//  QuotaCooperateModel.h
//  KZXC_Headmaster
//
//  Created by gaobin on 16/8/11.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuotaCooperateModel : NSObject

@property (nonatomic, copy) NSString * idStr;   //名额需求编号
@property (nonatomic, copy) NSString * adress;  //地址
@property (nonatomic, copy) NSString * content; //需求描述
@property (nonatomic, copy) NSString * addtime; //时间戳
@property (nonatomic, copy) NSString * userMax; //人数
@property (nonatomic, copy) NSString * region;  //地区限制


@end
