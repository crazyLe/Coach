//
//  EditRentInfoVC.m
//  Coach
//
//  Created by LL on 16/8/12.
//  Copyright © 2016年 sskz. All rights reserved.
//

#define kSubjectIdIndex 7

#define kCarTypeIndex 4

#import "LLInputCell.h"
#import "ExamQuotaReleaseModel.h"
#import "OSAddressPickerView.h"
#import <IQKeyboardManager.h>
#import "MMPickerView.h"
#import "LeftLblRightButtonCell.h"
#import "ShowPromptCell.h"
#import "OneCenterBtnCell.h"
#import "SectionHeaderCell.h"
#import "LeftLblRightTFCell.h"
#import "EditRentInfoVC.h"
#import "AddImageCell.h"

@interface EditRentInfoVC () <UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) OSAddressPickerView * pickerview;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) ExamQuotaReleaseModel * examQuotaRelease;

@end

@implementation EditRentInfoVC
{
    NSArray *numOfRowsInSectionArr;
    NSArray *heightForRowAtIndexArr;
 
    NSArray *leftTextArr1;
    NSArray *rightTextArr1;
    NSArray *sectionImgArr1;
    
    NSArray *leftTextArr2;
    NSArray *rightTextArr2;
    NSArray *sectionImgArr2;
    
    NSMutableArray *rightInputArr;
    NSArray *subjectArr;
    NSArray *inputArrIndexArr;
    NSMutableArray *uploadImageArr;
    
    UIButton *clickedUploadBtn;  //指向用户点击的上传图像按钮
    
    NSMutableArray *carListArr;
}

- (id)init
{
    if (self = [super init]) {
        numOfRowsInSectionArr = @[@(4),@(1),@(4),@(1),@(5),@(1),@(1),@(1),@(1),@(1)];
        heightForRowAtIndexArr = @[@(50),@(60),@(50),@(60),@(50),@(65),@(60),@(100),@(20*2+(kScreenWidth-4*20)/3),@(70)];
        
        leftTextArr1 = @[@[@"发布者",@"联系电话",@"地址",@"详细地址"]
                         ,@[@" 车辆信息"]
                         ,@[@"车型",@"数量(辆)",@"车龄(年)",@"里程(万公里)"]
                         ,@[@" 价格设置"],@[@"按天计费(元/天)",@"按周计费(元/周)",@"按月计费(元/月)",@"按季计费(元/季)",@"按年计费(元/年)"]
                         ,@[@"费用可按天、周、月、季（三个月）、年五种方式计费，可多选设置。"]
                         ,@[@"备注"],@[@""]
                         ,@[@"保存并发布"]];
        
        rightTextArr1 = @[@[@"请先进行实名认证",@"请输入手机号",@"请选择地址",@"请输入详细地址"]
                          ,@[@""]
                          ,@[@"选择车型",@"提供多少辆车",@"请输入车龄",@"请输入里程数"]
                          ,@[@"价格设置"],@[@"请输入按天计费价格",@"请输入按周计费价格",@"请输入按月计费价格",@"请输入按季计费价格",@"请输入按年计费价格"]
                          ,@[@"费用可按天、周、月、季（三个月）、年五种方式计费，可多选设置。"]
                          ,@[@"备注"],@[@""]
                          ,@[@"保存并发布"]];
        sectionImgArr1 = @[@"CoachCarRent_Car",@"",@"CoachCarRent_Price",@"",@"",@""];
        
        leftTextArr2 = @[@[@"发布者",@"联系电话",@"地址",@"详细地址"]
                         ,@[@" 场地信息"]
                         ,@[@"面积(亩)",@"车库(个)",@"容量(辆)",@"科目"]
                         ,@[@" 价格设置"],@[@"按天计费(元/天)",@"按周计费(元/周)",@"按月计费(元/月)",@"按季计费(元/季)",@"按年计费(元/年)"]
                         ,@[@"费用可按天、周、月、季（三个月）、年五种方式计费，可多选设置。"]
                         ,@[@"备注"],@[@""]
                         ,@[@"保存并发布"]];
        
        rightTextArr2 = @[@[@"请先进行实名认证",@"请输入您的手机号",@"请选择地址",@"请输入详细地址"]
                          ,@[@""]
                          ,@[@"请输入场地面积",@"场地设多少车库",@"最大可容纳多少辆车",@"请选择科目"]
                          ,@[@"价格设置"],@[@"请输入按天计费价格",@"请输入按周计费价格",@"请输入按月计费价格",@"请输入按季计费价格",@"请输入按年计费价格"]
                          ,@[@"费用可按天、周、月、季（三个月）、年五种方式计费，可多选设置。"]
                          ,@[@"备注"],@[@""]
                          ,@[@"保存并发布"]];
        sectionImgArr2 = @[@"iconfont-carrentarea",@"",@"iconfont-carrentnotepad",@"",@"",@""];
        
        subjectArr = @[@"科目二场地",@"科目三场地"];
        
        inputArrIndexArr = @[@[@(0),@(1),@(2),@(3)],@[],@[@(4),@(5),@(6),@(7)],@[],@[@(8),@(9),@(10),@(11),@(12)],@[],@[],@[@(13)]];
        
        rightInputArr = [@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""] mutableCopy];  //保存用户输入与选择
        
        uploadImageArr = [@[@"",@"",@""] mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
    [self setNavigation];
    [self setUI];
    [self requestData];
}

#pragma mark - CommonInit

- (void)commonInit
{
    _examQuotaRelease = [[ExamQuotaReleaseModel alloc]init];
    
    if (self.infoDic[@"id"]) {
        //编辑
        NSArray *keyArr = nil;
        if (_type == RentViewControllerTypeCoachCarRent) {
            keyArr = @[@"trueName",@"tel",@"",@"address",@"carType",@"carNum",@"carAge",@"carKm",@"priceDay",@"priceWeek",@"priceMonth",@"priceQuarter",@"priceYear"];
        }
        else
        {
            keyArr = @[@"trueName",@"tel",@"",@"address",@"size",@"garageNum",@"carMax",@"subjectId",@"priceDay",@"priceWeek",@"priceMonth",@"priceQuarter",@"priceYear"];
        }
        for (int i = 0; i < keyArr.count; i++) {
            NSString *key = keyArr[i];
            NSString *value = self.infoDic[key];
            if ([key isEqualToString:@"subjectId"]) {
                int subjectId =  [value intValue];
                [rightInputArr replaceObjectAtIndex:i withObject:subjectId==2?subjectArr[0]:subjectId==3?subjectArr[1]:@"选择场地"];
            }
            else
            {
                [rightInputArr replaceObjectAtIndex:i withObject:kHandleEmptyStr(value)];
            }
        }
        
        NSArray *picArr = self.infoDic[@"pic"];
        if ([picArr isKindOfClass:[NSDictionary class]] && (picArr.count>=3)) {
            NSArray *picNameArr = @[@"pic1",@"pic2",@"pic3"];
            for (int i = 0; i < uploadImageArr.count; i++) {
                NSString *urlStr = self.infoDic[@"pic"][picNameArr[i]];
                if (!isEmptyStr(urlStr)) {
                    uploadImageArr[i] = urlStr;
                }
            }
        }
        
        if (isEmptyStr(rightInputArr[0])) {
            rightInputArr[0] = kRealName;
        }
        else if (isEmptyStr(rightInputArr[1]))
        {
            rightInputArr[1] = kPhone;
        }
        
        //初始化地区
        _examQuotaRelease.provinceId = self.infoDic[@"provinceId"];
        _examQuotaRelease.cityId = self.infoDic[@"cityId"];
        _examQuotaRelease.areaId = self.infoDic[@"areaId"];
        
        //初始化备注信息
        if (!isEmptyStr(self.infoDic[@"other"])) {
            rightInputArr[[inputArrIndexArr[7][0] intValue]] = self.infoDic[@"other"];
        }
    }
    else
    {
        //添加
        rightInputArr[0] = kRealName;
        rightInputArr[1] = kPhone;
        
    }
}

#pragma mark - Setup

- (void)setNavigation
{
    [self setTitleText:_isEditInfo?@"编辑出租信息":@"新增出租信息" textColor:nil];
}

- (void)setUI
{
    [self setTableView];
}

- (void)setTableView
{
    [self setBg_TableViewWithConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(kTopBarTotalHeight, 0, 0, 0));
    }];
    [self registerClassWithClassNameArr:@[@"LeftLblRightTFCell",@"SectionHeaderCell",@"OneCenterBtnCell",@"ShowPromptCell",@"LeftLblRightButtonCell",@"AddImageCell",@"LLInputCell"]  cellIdentifier:nil];
    self.bg_TableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    //     NSDictionary *dic = @{@"uid":kUid,@"time":kTimeStamp,@"deviceInfo":kDeviceInfo,@"sign":kSignWithIdentify(@"/carHire"),@"cityId":kCityID,@"address":kAddress};
    //    [self setNetworkRelativeAdd:@"/carHire" paraDic:dic pageFiledName:@"pageId" parseDicKeyArr:@[@"info",@"carList"]];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 15;
    }
    else
    {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [numOfRowsInSectionArr[section] longValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [heightForRowAtIndexArr[indexPath.section] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((_type==RentViewControllerTypeCoachCarRent) && (indexPath.section == 2) && (indexPath.row == 0))
    {
        //选择车型
        LeftLblRightTFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftLblRightTFCell"];
        cell.leftLbl.text = leftTextArr1[indexPath.section][indexPath.row];
        [cell.accessoryImgView setImage:[UIImage imageNamed:@"MCoach_rightArrow"]];
        cell.accessoryImgView.contentMode = UIViewContentModeCenter;
        cell.rightTF.text = kHandleEmptyStr(rightInputArr[kCarTypeIndex]);
        cell.rightTF.placeholder = @"选择车型";
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.rightTF.userInteractionEnabled = NO;
        return cell;
    }
    else if((_type==RentViewControllerTypePlaceRent) && (indexPath.section == 2) && (indexPath.row == 3))
    {
        //选择场地
        LeftLblRightTFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftLblRightTFCell"];
        cell.leftLbl.text = leftTextArr2[indexPath.section][indexPath.row];
        [cell.accessoryImgView setImage:[UIImage imageNamed:@"MCoach_rightArrow"]];
        cell.accessoryImgView.contentMode = UIViewContentModeCenter;
        cell.rightTF.text = kHandleEmptyStr(rightInputArr[kSubjectIdIndex]);
        cell.rightTF.placeholder = @"选择场地";
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.rightTF.userInteractionEnabled = NO;
        return cell;
    }
//    else if ((_type==RentViewControllerTypeCoachCarRent) && (indexPath.section == 2) && (indexPath.row == 3))
//    {
//        //选择科目
//        LeftLblRightButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftLblRightButtonCell"];
//        cell.leftLbl.text = leftTextArr1[indexPath.section][indexPath.row];
//        [cell.rightBtn setImage:[UIImage imageNamed:@"AddExam_Arrow"] forState:UIControlStateNormal];
//        [cell.rightBtn setTitle:isEmptyStr(rightInputArr[kSubjectIdIndex])?@"选择场地":rightInputArr[kSubjectIdIndex] forState:UIControlStateNormal];
//        cell.delegate = self;
//        cell.indexPath = indexPath;
//        return cell;
//    }
    
    BOOL isLeftLblRightTF = indexPath.section == 0
    || indexPath.section == 2
    || indexPath.section == 4;
    if (isLeftLblRightTF)
    {
        LeftLblRightTFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftLblRightTFCell"];
        cell.delegate = self;
        cell.indexPath = indexPath;
        
        cell.accessoryImgView.image = [UIImage imageNamed:@"MCoach_rightArrow"];
        
        cell.accessoryImgView.contentMode = UIViewContentModeCenter;
        
        cell.leftLbl.text = _type == RentViewControllerTypeCoachCarRent ? leftTextArr1[indexPath.section][indexPath.row] : leftTextArr2[indexPath.section][indexPath.row];
        
        cell.rightTF.placeholder = _type == RentViewControllerTypeCoachCarRent ? rightTextArr1[indexPath.section][indexPath.row] : rightTextArr2[indexPath.section][indexPath.row];
        
        //防止cell重用导致显示混乱
        if (_type == RentViewControllerTypeCoachCarRent) {
            if (((indexPath.section==2)&&(indexPath.row==1||indexPath.row==2||indexPath.row==3)) || (indexPath.section==4)) {
                cell.rightTF.text = [NSString stringWithFormat:@"%ld",[rightInputArr[[inputArrIndexArr[cell.indexPath.section][cell.indexPath.row] intValue]] longValue]];
                if ([cell.rightTF.text isEqualToString:@"0"]) {
                    cell.rightTF.text = @"";
                }
            }
            else
            {
                cell.rightTF.text = rightInputArr[[inputArrIndexArr[cell.indexPath.section][cell.indexPath.row] intValue]];
            }
        }
        else
        {
            if (((indexPath.section==2)&&(indexPath.row<3)) || (indexPath.section==4)) {
                cell.rightTF.text = [NSString stringWithFormat:@"%ld",[rightInputArr[[inputArrIndexArr[cell.indexPath.section][cell.indexPath.row] intValue]] longValue]];
                if ([cell.rightTF.text isEqualToString:@"0"]) {
                    cell.rightTF.text = @"";
                }
            }
            else
            {
                cell.rightTF.text = rightInputArr[[inputArrIndexArr[cell.indexPath.section][cell.indexPath.row] intValue]];
            }
        }

        
        //        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        //            cell.lineView.hidden = YES;
        //        }
        //        else
        //        {
        //            cell.lineView.hidden = NO;
        //        }
        //        if (indexPath.section == 4) {
        //            cell.lineView.hidden = NO;
        //        }
        
        if (((indexPath.section==0)&&(indexPath.row==1)) || (indexPath.section==4 )) {
            cell.rightTF.keyboardType = UIKeyboardTypeNumberPad;
        }
        else
        {
            if (indexPath.section==2) {
                cell.rightTF.keyboardType = UIKeyboardTypeNumberPad;
            }
            else
            {
                cell.rightTF.keyboardType = UIKeyboardTypeDefault;
            }
        }
        
        if ((indexPath.section==0)&&(indexPath.row==0))
        {
            cell.rightTF.userInteractionEnabled = NO;
        }
        else
        {
            cell.rightTF.userInteractionEnabled = YES;
        }
        
        if ((indexPath.section==0)&&(indexPath.row==2)) {
            
            cell.rightTF.userInteractionEnabled = NO;
            NSArray * provinceArr = kProvinceDict;
            NSString * provinceStr = nil;
            for (NSDictionary * dic in provinceArr) {
                if ([dic[@"id"] isEqualToString:_examQuotaRelease.provinceId]) {
                    provinceStr = dic[@"title"];
                }
            }
            NSArray *cityArr = kCityDict;
            NSString * cityStr = nil;
            for (NSDictionary *dic in cityArr) {
                if ([dic[@"id"] isEqualToString:_examQuotaRelease.cityId]) {
                    cityStr = dic[@"title"];
                }
            }
            NSArray * countryArr = kCountryDict;
            NSString * countryStr = nil;
            for (NSDictionary * dict in countryArr) {
                if ([dict[@"id"] isEqualToString:_examQuotaRelease.areaId]) {
                    countryStr = dict[@"title"];
                }
            }
            
            if (isEmptyStr(provinceStr)&&isEmptyStr(cityStr)&&isEmptyStr(countryStr)) {
                cell.rightTF.text = @"";
            }
            else
            {
                if (isEmptyStr(provinceStr)) {
                    provinceStr = @"";
                }
                
                if (isEmptyStr(cityStr)) {
                    cityStr = @"";
                }
                
                if (isEmptyStr(countryStr)) {
                    countryStr = @"";
                }
                
                if (!_isEditInfo && _isSelected) {
                    
                    cell.rightTF.text = [NSString stringWithFormat:@"%@ %@ %@",provinceStr,cityStr,countryStr];
                }if (_isEditInfo) {
                    cell.rightTF.text = [NSString stringWithFormat:@"%@ %@ %@",provinceStr,cityStr,countryStr];
                }
            }
            
        }
        
        return cell;
    }
    else
    {
        if (indexPath.section == 1 || indexPath.section == 3 || indexPath.section == 6) {
            SectionHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionHeaderCell"];
            cell.sepView.hidden = YES;
            cell.backgroundColor = [UIColor clearColor];
            UIImage *img = [UIImage imageNamed:_type == RentViewControllerTypeCoachCarRent ? sectionImgArr1[indexPath.section-1] :  sectionImgArr2[indexPath.section-1]];
            NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithImg:img bounds:CGRectMake(0, -1, img.size.width, img.size.height)];
            [attStr appendText:_type == RentViewControllerTypeCoachCarRent ? leftTextArr1[indexPath.section][indexPath.row] : leftTextArr2[indexPath.section][indexPath.row] withAttributesArr:@[[UIColor colorWithHexString:@"2e84fb"]]];
            cell.titleLbl.attributedText = attStr;
            [cell.titleLbl mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.right.offset(-10);
            }];
            //            [cell.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            //                make.left.offset(10);
            //                make.right.offset(-10);
            //            }];
            //            [cell.sepView mas_updateConstraints:^(MASConstraintMaker *make) {
            //                make.height.offset(10);
            //            }];
            return cell;
        }
        else if(indexPath.section == 5)
        {
            //            ShowPromptCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowPromptCell"];
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            //            cell.contentLbl.textAlignment = NSTextAlignmentLeft;
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.numberOfLines = 0;
            NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithImg:[UIImage imageNamed:@"iconfont-tishi(1)"] bounds:CGRectMake(0, 0, 10, 10)];
            [attStr appendText:@"温馨提示：" withAttributesArr:@[[UIColor colorWithHexString:@"c8c8c8"],[UIFont boldSystemFontOfSize:12*kWidthScale]]];
            [attStr appendText:leftTextArr1[indexPath.section][indexPath.row] withAttributesArr:@[[UIColor colorWithHexString:@"c8c8c8"],kFont12]];
            cell.textLabel.attributedText = attStr;
            return cell;
        }
        else if(indexPath.section == 7)
        {
            LLInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLInputCell"];
            cell.textView.placeholder = @"请输入备注信息";
            cell.textView.text = rightInputArr[[inputArrIndexArr[indexPath.section][indexPath.row] intValue]];
            cell.textView.font = Font15;
            cell.maxInputNum = 120;
            cell.delegate = self;
            [cell.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(5, 10, 5, 10));
            }];
            [cell refreshPromptLbl];
            return cell;
        }
        else if(indexPath.section == 8)
        {
            AddImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddImageCell"];
            cell.delegate = self;
            for (int i = 0; i < cell.btnArr.count; i++) {
                UIButton *btn = cell.btnArr[i];
                if ([uploadImageArr[i] isKindOfClass:[UIImage class]]) {
                    [btn setImage:uploadImageArr[i] forState:UIControlStateNormal];
                }
                else if ([uploadImageArr[i] isKindOfClass:[NSString class]])
                {
                    [btn sd_setImageWithURL:[NSURL URLWithString:kHandleEmptyStr(uploadImageArr[i])] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"MCoach_click"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (error) {
                            [btn setImage:[UIImage imageNamed:@"MCoach_click"] forState:UIControlStateNormal];
                        }
                    }];
                }
                else
                {
                    [btn setImage:[UIImage imageNamed:@"MCoach_click"] forState:UIControlStateNormal];
                }
            }
            return cell;
        }
        else if(indexPath.section == 9)
        {
            OneCenterBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OneCenterBtnCell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.delegate = self;
            [cell.centerBtn setTitle:@"保存并发布" forState:UIControlStateNormal];
            [cell.centerBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.offset(45*kWidthScale);
                make.right.offset(-45*kWidthScale);
            }];
            return cell;
        }
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                
            }
                break;
                
            default:
                break;
        }
    }
    
//    if (_type == RentViewControllerTypeCoachCarRent) {
//        //教练车租赁
//        if ((indexPath.section == 2) && (indexPath.row == 0)) {
//            //选择车型
//            
//        }
//    }
    
    [self.view endEditing:YES];
    
    if ((indexPath.section==0)&&(indexPath.row==2)) {
        //选择地址
        
        _isSelected = YES;
        
        _pickerview = [OSAddressPickerView shareInstance];
        
        NSArray *addressArr = kProvinceData;
        
        NSMutableArray *dataArray = [NSMutableArray  array];
        
        for (NSData *data in addressArr) {
            ProvinceModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [dataArray addObject:model];
        }
        _pickerview.dataArray = dataArray;
        
        [_pickerview showBottomView];
        
        [self.view addSubview:_pickerview];
        
        WeakObj(self);
        
        _pickerview.block = ^(ProvinceModel *provinceModel,CityModel *cityModel,CountryModel *districtModel)
        {
            
            selfWeak.examQuotaRelease.provinceId = [NSString stringWithFormat:@"%d",provinceModel.idNum];
            
            selfWeak.examQuotaRelease.cityId = [NSString stringWithFormat:@"%d",cityModel.idNum];
            
            selfWeak.examQuotaRelease.areaId = [NSString stringWithFormat:@"%d",districtModel.idNum];
            
            [selfWeak.bg_TableView reloadData];
            
        };
    }
    else if ((indexPath.section==2)&&(indexPath.row==0)&&(_type==RentViewControllerTypeCoachCarRent))
    {
        //选择车型
        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSDictionary *dic in carListArr) {
            [arr addObject:dic[@"car_name"]];
        }
        
        LeftLblRightTFCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [MMPickerView showPickerViewInView:self.view
                               withStrings:arr
                               withOptions:@{MMbackgroundColor: [UIColor whiteColor],
                                             MMtextColor: [UIColor blackColor],
                                             MMtoolbarColor: [UIColor whiteColor],
                                             MMbuttonColor: [UIColor blueColor],
                                             MMfont: [UIFont systemFontOfSize:18],
                                             MMvalueY: @3,
                                             MMselectedObject:isEmptyStr(rightInputArr[kCarTypeIndex])?arr[0]:cell.rightTF.text,
                                             }
                                completion:^(NSString *selectedString) {
                                    //                                    NSLog(@"selectStr==>%@",selectedString);
                                    rightInputArr[kCarTypeIndex] = selectedString;
                                    cell.rightTF.text = selectedString;
                                }];
    }
    else if ((indexPath.section == 2) && (indexPath.row == 3)&&(_type !=RentViewControllerTypeCoachCarRent))
    {
        //选择科目
        LeftLblRightTFCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [MMPickerView showPickerViewInView:self.view withStrings:subjectArr withOptions:
         @{MMbackgroundColor: [UIColor whiteColor],
           MMtextColor: [UIColor blackColor],
           MMtoolbarColor: [UIColor whiteColor],
           MMbuttonColor: [UIColor blueColor],
           MMfont: [UIFont systemFontOfSize:18],
           MMvalueY: @3,
           MMselectedObject:isEmptyStr(rightInputArr[kSubjectIdIndex])?subjectArr[0]:cell.rightTF.text,
           }
                                completion:^(NSString *selectedString) {
                                    cell.rightTF.text = selectedString;
                                    rightInputArr[kSubjectIdIndex] = selectedString;
                                }];
    }
    else if ((indexPath.section==2)&&(indexPath.row==3)&&(_type==RentViewControllerTypePlaceRent))
    {
        //编辑/新增场地租赁
        LeftLblRightTFCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [MMPickerView showPickerViewInView:self.view withStrings:subjectArr withOptions:
         @{MMbackgroundColor: [UIColor whiteColor],
           MMtextColor: [UIColor blackColor],
           MMtoolbarColor: [UIColor whiteColor],
           MMbuttonColor: [UIColor blueColor],
           MMfont: [UIFont systemFontOfSize:18],
           MMvalueY: @3,
           MMselectedObject:isEmptyStr(rightInputArr[kSubjectIdIndex])?subjectArr[0]:cell.rightTF.text,
           }
                                completion:^(NSString *selectedString) {
                                    cell.rightTF.text = selectedString;
                                    rightInputArr[kSubjectIdIndex] = selectedString;
                                }];
    }
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
}

#pragma mark - LeftLblRightTFCellDelegate

- (void)LeftLblRightTFCell:(LeftLblRightTFCell *)cell textFieldDidChange:(UITextField *)textField;
{
   
    rightInputArr[[inputArrIndexArr[cell.indexPath.section][cell.indexPath.row] intValue]] = textField.text;
}

- (void)LeftLblRightTFCell:(LeftLblRightTFCell *)cell textFieldDidEndEditing:(UITextField *)textField;
{
    [self LeftLblRightTFCell:cell textFieldDidChange:textField];
}

#pragma mark - AddImageCellDelegate

- (void)AddImageCell:(AddImageCell *)cell clickBtn:(UIButton *)btn;
{
    clickedUploadBtn = btn;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    actionSheet.tag = 1000;
    [actionSheet showInView:self.view];
}

#pragma mark - LLInputCellDelegate
- (void)LLInputCell:(LLInputCell *)cell textViewDidChange:(UITextView *)textView;
{
    //    introduceStr = textView.text;
    rightInputArr[[inputArrIndexArr[7][0] intValue]] = textView.text;
}

#pragma mark - OneCenterBtnCellDelegate

- (void)centerBtnCell:(OneCenterBtnCell *)cell clickCenterBtn:(UIButton *)centerBtn;
{
    [self editRentInfoRequest];
}

#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1000) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //来源:相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    //来源:相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    return;
            }
        }
        else
        {
            if (buttonIndex == 2) {
                return;
            }
            else
            {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    //    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //    self.headImage.image = image;
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (clickedUploadBtn) {
        uploadImageArr[clickedUploadBtn.tag-10] = editedImage;
        [clickedUploadBtn setImage:editedImage forState:UIControlStateNormal];
    }
}

#pragma mark - Network

- (void)editRentInfoRequest
{
    if (isEmptyStr(rightInputArr[0])) {
        [LLUtils showErrorHudWithStatus:@"请先进行实名认证"];
        return;
    }
    
    NSArray *promptArr = nil;
    if (_type == RentViewControllerTypeCoachCarRent) {
        promptArr = @[@"请输入教练名",@"请输入手机号",@"请选择地址",@"请输入详细地址",@"请选择车型",@"请输入提供车辆数",@"请输入车龄",@"请输入里程数",@"请输入按天计费数",@"请输入按周计费数",@"请输入按月计费数",@"请输入按季计费数",@"请输入按年计费数"];
    }
    else
    {
        promptArr = @[@"请输入驾校名",@"请输入手机号",@"请选择地址",@"请输入详细地址",@"请输入场地面积",@"请输入多少车库",@"请输入多大可容纳多少车",@"请选择场地",@"请输入按天计费数",@"请输入按周计费数",@"请输入按月计费数",@"请输入按季计费数",@"请输入按年计费数"];
    }
    
    for (int i = 0; i < promptArr.count ; i++) {
        NSString *str = rightInputArr[i];
        if (i==2) {
            //检测用户有没有选择地址
            if (isEmptyStr(_examQuotaRelease.provinceId)||isEmptyStr(_examQuotaRelease.cityId)||isEmptyStr(_examQuotaRelease.areaId)) {
                [LLUtils showErrorHudWithStatus:promptArr[i]];
                return;
            }
            continue;
        }
        if (isEmptyStr(str)) {
            [LLUtils showErrorHudWithStatus:promptArr[i]];
            return;
        }
    }
    
    NSString *relativeAdd = _type == RentViewControllerTypeCoachCarRent ? @"/myCarHire/cu": @"/myVenue/cu";
    NSMutableDictionary *paraDic = [@{@"uid":kUid,@"time":kTimeStamp,@"sign":kSignWithIdentify(relativeAdd),@"carHireId":_isEditInfo?kHandleEmptyStr(self.infoDic[@"id"]):@"0",@"cityId":kCityID} mutableCopy];
    NSArray *paraNameArr = nil;
    if (_type == RentViewControllerTypeCoachCarRent) {
        //教练车
        paraNameArr = @[@"trueName",@"tel",@"",@"address",@"carTyle",@"carNum",@"carAge",@"carKm",@"priceDay",@"priceWeek",@"priceMonth",@"priceQuarter",@"priceYear"];
    }
    else
    {
        //场地
        rightInputArr[kSubjectIdIndex] = [rightInputArr[kSubjectIdIndex] isEqualToString:subjectArr[0]]?@"2":@"3";
        paraNameArr = @[@"trueName",@"tel",@"",@"address",@"size",@"garageNum",@"carMax",@"subjectId",@"priceDay",@"priceWeek",@"priceMonth",@"priceQuarter",@"priceYear"];
    }
    
    for (int i = 0; i < paraNameArr.count; i++) {
        if (i==2) {
            continue;
        }
        if ((i==kCarTypeIndex)&&(_type==RentViewControllerTypeCoachCarRent)) {
            //设置carType参数
            for (NSDictionary *carDic in carListArr) {
                if ([carDic[@"car_name"] isEqualToString:rightInputArr[i]]) {
                    [paraDic setObject:carDic[@"id"] forKey:paraNameArr[i]];
                    break;
                }
            }
        }
        else
        {
            [paraDic setObject:rightInputArr[i] forKey:paraNameArr[i]];
        }
    }
    
    //组织地址参数
    [paraDic setObject: _examQuotaRelease.provinceId forKey:@"provinceId"];;
    [paraDic setObject:_examQuotaRelease.cityId forKey:@"cityId"];
    [paraDic setObject:_examQuotaRelease.areaId forKey:@"areaId"];
    
    //拼接备注信息
    if (!isEmptyStr(rightInputArr[[inputArrIndexArr[7][0] intValue]])) {
        [paraDic setObject:rightInputArr[[inputArrIndexArr[7][0] intValue]] forKey:@"other"];
    }
    
    //拼接图片参数
    NSArray *picParaNameArr = @[@"pic1",@"pic2",@"pic3"];
//    for (int i = 0; i < uploadImageArr.count; i++) {
//        if (![uploadImageArr[i] isEqual:[UIImage imageNamed:@"MCoach_click"]]) {
//            [paraDic setObject:uploadImageArr[i] forKey:picParaNameArr[i]];
//        }
//    }
    
    NSMutableArray *serviceNameArr = [NSMutableArray array];
    NSMutableArray *fileNameArr = [NSMutableArray array];
    NSMutableArray *fileDataArr = [NSMutableArray array];
    for (int i = 0; i < uploadImageArr.count; i++) {
        if ([uploadImageArr[i] isKindOfClass:[UIImage class]]) {
            UIImage *img = uploadImageArr[i];
            NSData * data = [LLUtils dataWithImage:img];
            [fileDataArr addObject:data];
            [serviceNameArr addObject:picParaNameArr[i]];
            [fileNameArr addObject:@"0.png"];
        }
        else if (([uploadImageArr[i] isKindOfClass:[NSString class]]) && (!isEmptyStr(uploadImageArr[i])))
        {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:uploadImageArr[i]]];
            if (isNull(data)) {
                continue;
            }
            [fileDataArr addObject:data];
            [serviceNameArr addObject:picParaNameArr[i]];
            [fileNameArr addObject:@"0.png"];
        }
    }
    
    //show HUD
    [LLUtils showTextAndProgressHud:@"请求中..."];
    
    WeakObj(self)
    [NetworkEngine UploadFileWithUrl:[HOST_ADDR stringByAppendingString:relativeAdd] param:paraDic serviceNameArr:serviceNameArr fileNameArr:fileNameArr mimeType:@"image/jpeg" fileDataArr:fileDataArr finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1)
        {
            //成功
//            if (selfWeak.isEditInfo) {
//                selfWeak.needRefreshBlock(selfWeak.indexPath);  //回调到列表页 刷新列表页数据
//            }
            if (self.needRefreshBlock) {
                self.needRefreshBlock(selfWeak.indexPath);
            }
            [selfWeak.navigationController popViewControllerAnimated:YES];
            [LLUtils showSuccessHudWithStatus:msg];
        }
        else
        {
            [LLUtils showErrorHudWithStatus:msg];
        }
        
    } failed:^(NSError *error) {
        [LLUtils showErrorHudWithStatus:@"请求异常，请稍后重试"];
    }];
    
    
//    [NetworkEngine postRequestWithRelativeAdd:relativeAdd paraDic:paraDic completeBlock:^(BOOL isSuccess, id jsonObj) {
//        if (isSuccess) {
//            if (isEqualValue(jsonObj[@"code"], 1)) {
//                //成功
//                [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
//            }
//            else
//            {
//                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
//            }
//        }
//        else
//        {
//            [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
//        }
//    }];
}

- (void)requestData
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"deviceInfo"] = kDeviceInfo;
    param[@"time"] = kTimeStamp;
    param[@"sign"] = kSignWithIdentify(@"/Car/carlist");
    
    [NetworkEngine postRequestWithRelativeAdd:@"/Car/carlist" paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                
                //请求成功
                NSString * jstr = [LLUtils jsonStrWithJSONObject:jsonObj];
                NSString * str = [LLUtils replaceUnicode:jstr];
                NSLog(@"%@",str);
                
               carListArr = jsonObj[@"info"][@"CarList"];
                
            }else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                
                //需要登录
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
            else
            {
                
                //失败
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
        }
    }];
}

@end
