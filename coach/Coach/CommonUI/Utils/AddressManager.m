//
//  AddressManager.m
//  学员端
//
//  Created by zuweizhong  on 16/8/6.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

/*
 (
 {
 hot = 0;
 id = 110101;
 name = "\U4e1c\U57ce\U533a";
 "parent_id" = 110100;
 pinyin = "<null>";
 "short_name" = "\U4e1c\U57ce";
 title = "\U4e1c\U57ce\U533a";
 }
 )
 */

#import "LLAddress.h"
#import "AddressManager.h"
#import "ChineseToPinyin.h"
#import "ProvinceModel.h"
#import "HttpParamManager.h"
#import "HttpsTools.h"

@implementation AddressManager

singletonImplementation(AddressManager)

-(NSMutableArray *)addressArray
{
    if (!_addressArray) {
        _addressArray = [NSMutableArray array];
    }
    return _addressArray;

}

-(void)updateAddressInfo
{
    //加载市
    [LLAddress loadCity];
    //加载省
    [self loadProvince];
    //加载县
    [self loadCountry];
}

-(void)loadCountry
{
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST_ADDR,@"/getAddress"];
    NSString *time = [HttpParamManager getTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/getAddress" time:time];
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    param[@"levelid"] = @(3);
    
    [HttpsTools POST:url parameter:param progress:^(NSProgress *downloadProgress) {
        
    } succeed:^(id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        
        if (code == 1) {
            
            NSArray *arr1 = responseObject[@"info"][@"address"];
            
            if (arr1.count>0) {
                NSDictionary *dic = [arr1 lastObject] ;
                [kUserDefault setObject:dic[@"id"] forKey:@"kCountryArrCount"];
                [kUserDefault synchronize];
                
                SCDBManager *db_manager = [SCDBManager shareInstance];
                
                if ([[kUserDefault objectForKey:cacheCountyDataKey] boolValue]) {
                    [db_manager dropTableWithName:kCountyTableName];
                }
                
                [db_manager createTableWithName:kCountyTableName keyArr:kCountyTableCollumnArr];
                
                [db_manager fastInsertIntoTable:kCountyTableName dicArr:arr1 insertColumnArr:kCountyTableCollumnArr];
                
                [kUserDefault setBool:YES forKey:cacheCountyDataKey]; //记录已经缓存了县数据
                [kUserDefault synchronize];
                
                /*
                //从数据库中读取，验证
                [db_manager getAllObjectsFromTable:kCountyTableName keyArr:kCountyTableCollumnArr completionBlock:^(NSArray *array) {
                    if (array.count>0) {
                        //读到数据
                        [kUserDefault setBool:YES forKey:cacheCountyDataKey]; //记录已经缓存了县数据
                    }
                    else
                    {
                        [kUserDefault setBool:NO forKey:cacheCountyDataKey];
                    }
                }];
                 */
            }
            
        }

    } failure:^(NSError *error) {
        
    }];

}

-(void)loadProvince
{
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST_ADDR,@"/getAddress"];
    NSString *time = [HttpParamManager getTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/getAddress" time:time];
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    param[@"levelid"] = @(1);
    
    [HttpsTools POST:url parameter:param progress:^(NSProgress *downloadProgress) {
        
    } succeed:^(id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 1) {
            
            NSArray *arr1 = responseObject[@"info"][@"address"];
            
            if (arr1.count>0) {
                SCDBManager *db_manager = [SCDBManager shareInstance];
                
                if ([[kUserDefault objectForKey:cacheProvinceDataKey] boolValue]) {
                    [db_manager dropTableWithName:kProvinceTableName];
                }
                
                [db_manager createTableWithName:kProvinceTableName keyArr:kProvinceTableCollumnArr];
                [db_manager fastInsertIntoTable:kProvinceTableName dicArr:arr1 insertColumnArr:kProvinceTableCollumnArr];
                
                [kUserDefault setBool:YES forKey:cacheProvinceDataKey]; //记录已经缓存了省数据
                [kUserDefault synchronize];
                
                /*
                //从数据库中读取，验证
                [db_manager getAllObjectsFromTable:kProvinceTableName keyArr:kProvinceTableCollumnArr completionBlock:^(NSArray *array) {
                    if (array.count>0) {
                        //读到数据
                        [kUserDefault setBool:YES forKey:cacheProvinceDataKey]; //记录已经缓存了省数据
                    }
                    else
                    {
                        [kUserDefault setBool:NO forKey:cacheProvinceDataKey];
                    }
                }];
                 */
                
                [self loadAddress];
            }
            
        }

    } failure:^(NSError *error) {
        
    }];
}

-(void)loadAddress
{
    
    NSData *data = [NSData dataNamed:@"krsys_area.json"];
    
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSArray *cityDicArr = kProvinceDict;
    
    for (NSDictionary *dic in cityDicArr) {
        NSString *idNum = dic[@"id"];
        for (int i = 0; i<dataArray.count; i++) {
            NSString *idNum2 = dataArray[i][@"id"];
            if ([idNum2 isEqualToString:idNum]) {
                ProvinceModel *model = [ProvinceModel mj_objectWithKeyValues:dataArray[i]];
                model.citys = [NSMutableArray array];
                for (int j = 0; j<dataArray.count; j++) {
                    NSDictionary *dict2=dataArray[j];
                    if ([dict2[@"parent_id"] integerValue] == model.idNum) {
                        CityModel *cityModel = [CityModel mj_objectWithKeyValues:dict2];
                        [model.citys addObject:cityModel];
                        cityModel.countrys = [NSMutableArray array];
                        for (int m = 0; m<dataArray.count; m++) {
                            NSDictionary *dict3=dataArray[m];
                            if ([dict3[@"parent_id"] integerValue] == cityModel.idNum) {
                                CountryModel *countryModel = [CountryModel mj_objectWithKeyValues:dict3];
                                [cityModel.countrys addObject:countryModel];
                                
                            }
                            
                        }
                        
                        
                    }
                    
                }
                //将student类型变为NSData类型
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
                
                [self.addressArray addObject:data];
                
            }
            
        }
        
    }
    
    
    [kUserDefault setObject:self.addressArray forKey:@"addressArray"];
    
}

@end
