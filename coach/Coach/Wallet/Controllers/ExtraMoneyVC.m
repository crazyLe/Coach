//
//  ExtraMoneyVC.m
//  Coach
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "CYLTableViewPlaceHolder.h"
#import "LLExtraMoneyCell.h"
#import "ExtraMoneyVC.h"

@interface ExtraMoneyVC ()

@end

@implementation ExtraMoneyVC
{
    NSMutableArray *_dataSourceArr;
}

- (id)init
{
    if (self = [super init]) {
        _dataSourceArr = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array],[NSMutableArray array], nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self setNavigation];
    [self setUI];
    [self requestAllData];
}

#pragma mark - Setup

- (void)setNavigation
{
    [self setTitleText: _type == ExtraMoneyVCTypeAdmissionEarn ? @"招生收入":_type == ExtraMoneyVCTypeExtraMoney?@"外快收入":@"查询账单" textColor:nil];
    [self setLeftText:nil textColor:nil ImgPath:@"Navigation_Return"];
//    [self setRightText:nil textColor:nil ImgPath:@"Navigation_Add"];
}

- (void)setUI
{
    [self setBg_TableViewWithConstraints:nil];
//    self.bg_TableView.sectionHeaderHeight = 37.0f;
    self.bg_TableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self.bg_TableView setSeparatorColor:[UIColor colorWithHexString:@"f0f0f0"]];
    [self.bg_TableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.bg_TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self registerClassWithClassNameArr:@[@"LLExtraMoneyCell"] cellIdentifier:nil];
}

#pragma mark - UITableViewDelegate && UITableViewDateSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ((NSArray *)_dataSourceArr[section]).count?37.0f:0.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)_dataSourceArr[section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 37.0f)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(18*kWidthScale, 0, kScreenWidth-18*kWidthScale, 37.0f)];
    [bgView addSubview:titleLbl];
    titleLbl.text = section==0?@"本月":[LLUtils previousMonthWithProviceMonthIndex:section==1?1:2 dateFormat:@"MM月"];
    titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
    titleLbl.font = kFont18;
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LLExtraMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLExtraMoneyCell"];
    NSDictionary *dic = _dataSourceArr[indexPath.section][indexPath.row];
    NSArray *timeArr = [dic[@"timeStr"] componentsSeparatedByString:@" "];
    if (timeArr.count>1) {
        cell.dateLbl.text = timeArr.count>0?timeArr[0]:@"";
        cell.timeLbl.text = timeArr.count>1?timeArr[1]:@"";
    }
    else
    {
        if (timeArr.count>0) {
            NSString *dataStr = timeArr[0];
            if (dataStr.length>2) {
                cell.dateLbl.text = [dataStr substringToIndex:2];
                cell.timeLbl.text = [dataStr substringFromIndex:2];
            }
        }
    }
    NSString *headImgUrl = dic[@"face"];
    [cell.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:kHandleEmptyStr(headImgUrl)] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"iconfont-defaultheadimage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            [cell.headBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-defaultheadimage"] forState:UIControlStateNormal];
        }
    }]; 
//    cell.beansNumLbl.text = [NSString stringWithFormat:@"+%@赚豆",isNull(dic[@"beans"])?@"":dic[@"beans"]];
    if(_type == ExtraMoneyVCTypeQueryBill){
        cell.beansNumLbl.text = [NSString stringWithFormat:@"%@",dic[@"total"]];
    }else{
        cell.beansNumLbl.text = [NSString stringWithFormat:@"+%@元",isNull(dic[@"beans"])?@"":dic[@"beans"]];
    }
    cell.classLbl.text = dic[_type==ExtraMoneyVCTypeAdmissionEarn?@"className":_type==ExtraMoneyVCTypeExtraMoney?@"typeName":@"className"];
    return cell;
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)requestAllData
{
    NSString *formatStr = @"yyyy-MM";
    NSString *nowMonthStr = [LLUtils dateStrWithDate:[NSDate date] dateFormat:formatStr];
    NSString *previousMonthStr = [LLUtils previousMonthWithProviceMonthIndex:1 dateFormat:formatStr];
    NSString *lastMonthStr = [LLUtils previousMonthWithProviceMonthIndex:2 dateFormat:formatStr];
    NSArray *monthArr = @[nowMonthStr,previousMonthStr,lastMonthStr];
    for (int i = 0; i < monthArr.count; i++) {
        [self getIncomeRequestWithSearchMonth:monthArr[i] index:i];
    }
}

- (void)getIncomeRequestWithSearchMonth:(NSString *)month index:(NSInteger)index
{
    NSString *relativeAdd = _type==ExtraMoneyVCTypeAdmissionEarn?@"/Mypurse/enrollment":_type == ExtraMoneyVCTypeExtraMoney?@"/Mypurse/income":@"/Mypurse/billist";
    NSMutableDictionary *paraDic =[ @{@"uid":kUid,@"time":kTimeStamp,@"sign":kSignWithIdentify(relativeAdd),@"deviceInfo":kDeviceInfo} mutableCopy];
    [paraDic setObject:month forKey:@"searchMonth"];
    [NetworkEngine postRequestWithRelativeAdd:relativeAdd paraDic:paraDic completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if (isEqualValue(jsonObj[@"code"], 1)) {
                //成功
                _dataSourceArr[index] = isNull(jsonObj[@"info"][@"order"])?[NSMutableArray array]:jsonObj[@"info"][@"order"];
                [self.bg_TableView cyl_reloadData];
            }
            else
            {
                [self.bg_TableView cyl_reloadData];
            }
        }
        else
        {
            
        }
    }];
}

#pragma mark - CYLTableViewPlaceHolderDelegate

- (UIView *)makePlaceHolderView;
{
    UIView *bgView = [UIView new];
    
    UILabel *promptLbl = [UILabel new];
    [bgView addSubview:promptLbl];
    NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithImg:[UIImage imageNamed:@"CoachCarRent_Cry"] bounds:CGRectMake(0, 0, 100, 100)];
    [attStr appendBreakLineWithInterval:20];
    [attStr appendText:@"暂无数据" withAttributesArr:@[rgb(249, 117, 43)]];
//    [attStr appendBreakLineWithInterval:3];
//    [attStr appendText:@"可出租的教练车资源" withAttributesArr:@[rgb(249, 117, 43)]];
    promptLbl.attributedText = attStr;
    promptLbl.textAlignment = NSTextAlignmentCenter;
    promptLbl.numberOfLines = 0;
    
//    UIButton *goPublicbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [bgView addSubview:goPublicbtn];
//    [goPublicbtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(bgView.mas_centerY);
//        make.centerX.equalTo(promptLbl);
//        make.width.offset(0.8*kScreenWidth);
//        make.height.offset(40);
//    }];
//    goPublicbtn.layer.cornerRadius = 20;
//    goPublicbtn.layer.masksToBounds = YES;
//    [goPublicbtn setBackgroundColor:kAppThemeColor];
//    [goPublicbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [goPublicbtn setTitle:segmentedControl.selectedSegmentIndex==1?@"去发布":@"刷新" forState:UIControlStateNormal];
//    [goPublicbtn addTarget:self action:@selector(clickGoPublicBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(-self.view.bounds.size.height/4);
    }];
    
    return bgView;
}

- (BOOL)enableScrollWhenPlaceHolderViewShowing;
{
    return YES;
}


@end
