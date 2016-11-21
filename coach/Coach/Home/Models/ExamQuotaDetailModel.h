//
//  ExamQuotaDetailModel.h
//  KZXC_Headmaster
//
//  Created by gaobin on 16/8/12.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamQuotaDetailModel : NSObject


@property (nonatomic, copy) NSString * trueName;    //发布人
@property (nonatomic, copy) NSString * phone;       //电话
@property (nonatomic, copy) NSString * holdingTime; //时间要求
@property (nonatomic, copy) NSString * adress;      //地址
@property (nonatomic, copy) NSString * content;     //需求描述.....转让说明
@property (nonatomic, copy) NSString * price;       //转让价格
@property (nonatomic, copy) NSString * addtime;     //发布时间戳
@property (nonatomic, copy) NSString * userMax;     //人数
@property (nonatomic, copy) NSString * region;      //地区限制


@end

