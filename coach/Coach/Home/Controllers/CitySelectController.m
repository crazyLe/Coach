//
//  CitySelectController.m
//  学员端
//
//  Created by zuweizhong  on 16/8/1.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLAddress.h"
#import "CitySelectController.h"
#import "BAddressPickerController.h"
@interface CitySelectController ()<BAddressPickerDelegate,BAddressPickerDataSource>

@end

@implementation CitySelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitleText:@"城市选择" textColor:nil];
    
    BAddressPickerController *addressPickerController = [[BAddressPickerController alloc] initWithFrame:self.view.frame];
    addressPickerController.dataSource = self;
    addressPickerController.delegate = self;
    [self addChildViewController:addressPickerController];
    [self.view addSubview:addressPickerController.view];
    
}
-(void)clickLeftBtn:(UIButton *)leftBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark - BAddressController Delegate

- (NSArray*)arrayOfHotCitiesInAddressPicker:(BAddressPickerController *)addressPicker{
//    return @[@"北京",@"上海",@"深圳",@"杭州",@"广州",@"武汉",@"天津",@"重庆",@"成都",@"苏州"];
    return @[];
}

- (void)addressPicker:(BAddressPickerController *)addressPicker didSelectedCity:(NSString *)city
{
    NSLog(@"选择---------%@",city);
    [LLAddress getCityId:city completeBlock:^(BOOL isSuccess, NSString *areaName, NSString *areaID) {
        if (isSuccess) {
            NSLog(@"2222=====>countyID : %@\n 2222==>countyName : %@",areaID,areaName);
            [kUserDefault setObject:areaName forKey:@"CoachAreaName"]; //全称
            [kUserDefault setObject:areaID forKey:@"CoachAreaID"];     //地区ID
        }
    }];
    [kUserDefault  setObject:city forKey:@"CoachAreaShortName"];  //简称
    if (self.didSelectCityBlock) {
        self.didSelectCityBlock(city);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)beginSearch:(UISearchBar *)searchBar{
- (void)addressBeginFind:(UISearchBar*)searchBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

//- (void)endSearch:(UISearchBar *)searchBar{
- (void)addressEndFind:(UISearchBar*)searchBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


@end
