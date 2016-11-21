//
//  PlaceRentDetailVC.m
//  Coach
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLCarTypeCell.h"
#import "LLCarAreaPriceCell.h"
#import "LLCarAreaCell.h"
#import <SDCycleScrollView.h>
#import "CoachCarRentDetailVC.h"

@interface CoachCarRentDetailVC ()

@end

@implementation CoachCarRentDetailVC
{
    NSArray *leftImgNameArr1;
    NSArray *leftLblTextArr1;
    
    NSArray *leftImgNameArr2;
    NSArray *leftLblTextArr2;
    
    NSArray *leftImgNameArr;
    NSArray *leftLblTextArr;
    
    NSDictionary *detailInfoDic;
}

- (id)init
{
    if (self = [super init]) {
        leftImgNameArr1 = @[@"CoachCarRent_Publisher",@"iconfont-money",@"CoachCarRent_Car",@"iconfont-weizhi",@"iconfont-beizhu"];
        leftLblTextArr1 = @[@" 发布者:",@" 价格:",@" 车型:",@" 地址:",@" 备注说明:"];
        
        leftImgNameArr2 = @[@"CoachCarRent_Publisher",@"iconfont-money",@"iconfont-carrentarea",@"iconfont-weizhi",@"iconfont-beizhu"];
        leftLblTextArr2 = @[@" 发布者:",@" 价格:",@" 场地介绍:",@" 地址:",@" 备注说明:"];
        
        leftImgNameArr = @[leftImgNameArr1,leftImgNameArr2];
        leftLblTextArr = @[leftLblTextArr1,leftLblTextArr2];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self setNav];
    [self setUI];
    [self getDetailInfoRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)setNav
{
    [self setTitleText:_type==RentDetailVCTypeCoachCarDetail?@"教练车租赁":@"训练场租赁" textColor:nil];
    [self setLeftText:nil textColor:nil ImgPath:@"Navigation_Return"];
//    [self setRightText:nil textColor:nil ImgPath:@"InviteStudent_RightBarBtnImg"];
}

- (void)setUI
{
    [self setBg_TableViewWithConstraints:nil];
    [self registerClassWithClassNameArr:@[@"LLCarAreaCell",@"LLCarAreaPriceCell",@"LLCarTypeCell"]  cellIdentifier:nil];
}

// banner
- (void)setAlbumWithSuperView:(UIView *)superView
{
//    NSArray *imagesURLStrings = _type == RentDetailVCTypeCoachCarDetail ? @[
//                                @"图层-82"
//                                ] : @[@"图层-3"];
    NSMutableArray *imagesURLStrings =  [NSMutableArray array];
    NSDictionary *picDic = detailInfoDic[@"pic"];
    if (picDic.count) {
        for (NSString *key in picDic) {
            if (!isEmptyStr(picDic[key])) {
                [imagesURLStrings addObject:picDic[key]];
            }
        }
    }
    
    if (!imagesURLStrings.count) {
        imagesURLStrings = [@[@"iconfont-defaultbanner"] mutableCopy];
    }
//    if (_type == RentDetailVCTypeCoachCarDetail) {
//        imagesURLStrings =   @[isEmptyStr(detailInfoDic[@"pic"])?@"iconfont-defaultbanner":detailInfoDic[@"pic"]];
//    }
//    else
//    {
//        imagesURLStrings =   @[isEmptyStr(detailInfoDic[@"pic"])?@"iconfont-defaultbanner":detailInfoDic[@"pic"]];
//    }
   
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 320, kScreenWidth, 180)imageURLStringsGroup:imagesURLStrings]; // 模拟网络延时情景
//    cycleScrollView.pageControlAliment =SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.delegate = self;
    //    cycleScrollView.titlesGroup = titles;
    //    cycleScrollView.dotColor = [UIColor yellowColor]; // 自定义分页控件小圆标颜色
        cycleScrollView.placeholderImage = [UIImage imageNamed:@"iconfont-defaultbanner"];
    [superView addSubview:cycleScrollView];
    cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return 1;
        }
            break;
        case 2:
        {
            return 5;
        }
            break;
        case 3:
        {
            return 1;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return kScreenWidth/2;
    }
    else if (indexPath.section==1)
    {
        return 15.0f;
    }
    else if(indexPath.section==2)
    {
        switch (indexPath.row) {
            case 0:
                return 80;
                break;
            case 1:
                return 200;
                break;
            case 2:
                return 100;
                break;
            case 3:
                return 90;
                break;
            case 4:
                return 110;
                break;
                
            default:
                break;
        }
    }
    else
    {
        return 80;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setAlbumWithSuperView:cell.contentView];
        return cell;
    }
    else if (indexPath.section == 1)
    {
        UITableViewCell *cell = [UITableViewCell new];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else if(indexPath.section == 2)
    {
        LLCarAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLCarAreaCell"];
        UIImage *img = [UIImage imageNamed:leftImgNameArr[_type][indexPath.row]];
        NSMutableAttributedString *titleAtt = [NSMutableAttributedString attributeStringWithImg:img bounds:CGRectMake(0, -3, img.size.width, img.size.height)];
        [titleAtt appendText:leftLblTextArr[_type][indexPath.row] withAttributesArr:@[kAppThemeColor,kFont13]];
        cell.titleLbl.attributedText = titleAtt;
        
        switch (indexPath.row) {
            case 0:
            {
                NSMutableAttributedString *contentAtt = [NSMutableAttributedString attributeStringWithText:@"本资源由 " attributes:@[kLightGreyColor,kFont13]];
                [contentAtt appendText:detailInfoDic[@"trueName"] withAttributesArr:@[kDarkGrayColor,kFont13]];
                [contentAtt appendText:@" 发布" withAttributesArr:@[kLightGreyColor,kFont13]];
                 cell.contentLbl.attributedText = contentAtt;
            }
                break;
            case 1:
            {
                LLCarAreaPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLCarAreaPriceCell"];
                NSMutableAttributedString *titleAtt = [NSMutableAttributedString attributeStringWithImg:[UIImage imageNamed:leftImgNameArr[_type][indexPath.row]] bounds:CGRectMake(0, -3, 17, 16)];
                [titleAtt appendText:leftLblTextArr[_type][indexPath.row] withAttributesArr:@[kAppThemeColor,kFont13]];
                cell.titleLbl.attributedText = titleAtt;
                
                NSArray *leftTextArr = @[@"按天",@"按周",@"按月",@"按季",@"按年"];
                NSArray *centerTextArr = @[
                                [NSString stringWithFormat:@"   %@元/天"
                                 ,isEmptyStr(detailInfoDic[@"priceDay"])?@"":detailInfoDic[@"priceDay"]]
                                ,[NSString stringWithFormat:@"   %@元/周"
                                  ,isEmptyStr(detailInfoDic[@"priceWeek"])?@"":detailInfoDic[@"priceWeek"]]
                                ,[NSString stringWithFormat:@"   %@元/月"
                                  ,isEmptyStr(detailInfoDic[@"priceMonth"])?@"":detailInfoDic[@"priceMonth"]]
                                ,[NSString stringWithFormat:@"   %@元/季"
                                  ,isEmptyStr(detailInfoDic[@"priceQuarter"])?@"":detailInfoDic[@"priceQuarter"]]
                                ,[NSString stringWithFormat:@"   %@元/年"
                                  ,isEmptyStr(detailInfoDic[@"priceYear"])?@"":detailInfoDic[@"priceYear"]]
                                           ];
                
                //计算节省金额
                NSInteger weakCutPrice = [detailInfoDic[@"priceDay"] integerValue]*7-[detailInfoDic[@"priceWeek"] integerValue];
                
                NSInteger monthCutPrice = [detailInfoDic[@"priceWeek"] integerValue]*4-[detailInfoDic[@"priceMonth"] integerValue];
                NSInteger quarterCutPrice = [detailInfoDic[@"priceMonth"] integerValue]*3-[detailInfoDic[@"priceQuarter"] integerValue];
                NSInteger yearCutPrice = [detailInfoDic[@"priceQuarter"] integerValue]*4-[detailInfoDic[@"priceYear"] integerValue];
                
                if (weakCutPrice<0) {
                    weakCutPrice = 0;
                }
                if (monthCutPrice<0) {
                    monthCutPrice = 0;
                }
                if (quarterCutPrice<0) {
                    quarterCutPrice = 0;
                }
                if (yearCutPrice<0) {
                    yearCutPrice = 0;
                }
                
                NSArray *rightTextArr = @[@"",[NSString stringWithFormat:@"省%ld元",weakCutPrice],[NSString stringWithFormat:@"省%ld元",monthCutPrice],[NSString stringWithFormat:@"省%ld元",quarterCutPrice],[NSString stringWithFormat:@"省%ld元",yearCutPrice]];
                for (int i = 0; i < cell.lblArr.count; i++) {
                    UILabel *lbl = cell.lblArr[i];
                    NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithText:leftTextArr[i] attributes:@[kLightGreyColor,kFont13]];
                    [attStr appendText:centerTextArr[i] withAttributesArr:@[kDarkGrayColor,kFont13]];
                    lbl.attributedText = attStr;
                    
                    UIButton *btn = cell.btnArr[i];
                    if (i != 0) {
                        [btn setBackgroundImage:[UIImage imageNamed:@"iconfont-carrentredbg"] forState:UIControlStateNormal];
                        [btn setTitle:rightTextArr[i] forState:UIControlStateNormal];
                    }
                }
                return cell;
            }
                break;
            case 2:
            {
                LLCarTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLCarTypeCell"];
                NSMutableAttributedString *titleAtt = [NSMutableAttributedString attributeStringWithImg:[UIImage imageNamed:leftImgNameArr[_type][indexPath.row]] bounds:CGRectMake(0, -3, 17, 16)];
                [titleAtt appendText:leftLblTextArr[_type][indexPath.row] withAttributesArr:@[kAppThemeColor,kFont13]];
                cell.titleLbl.attributedText = titleAtt;
                NSArray *leftTextArr1 = @[@"车型：",@"车龄：",@"里程：",@""];
                
                NSArray *rightTextArr1 = @[kHandleEmptyStr(detailInfoDic[@"carType"]),[NSString stringWithFormat:@"%@年",kHandleEmptyStr(detailInfoDic[@"carAge"])],[NSString stringWithFormat:@"%@万公里",kHandleEmptyStr(detailInfoDic[@"carKm"])],@""];
                
                NSString *subject = nil;
                switch ([detailInfoDic[@"subjectId"] intValue]) {
                    case 1:
                    {
                        subject = @"科目一";
                    }
                        break;
                    case 2:
                    {
                        subject = @"科目二";
                    }
                        break;
                    case 3:
                    {
                        subject = @"科目三";
                    }
                        break;
                    case 4:
                    {
                        subject = @"科目四";
                    }
                        break;
                        
                    default:
                        subject = @"科目一";
                        break;
                }
                NSArray *leftTextArr2 = @[@"面积：",@"车库：",@"容量：",@"用途："];
                NSArray *rightTextArr2 = @[
                                [NSString stringWithFormat:@"%@亩",kHandleEmptyStr(detailInfoDic[@"size"])]
                                ,[NSString stringWithFormat:@"%@个",kHandleEmptyStr(detailInfoDic[@"garageNum"])]
                                ,[NSString stringWithFormat:@"%@辆车",kHandleEmptyStr(detailInfoDic[@"carMax"])]
                                ,subject
                                ];
                NSArray *leftTextArr = @[leftTextArr1,leftTextArr2];
                NSArray *rightTextArr = @[rightTextArr1,rightTextArr2];
                for (int i = 0; i < cell.lblArr.count; i++) {
                    UILabel *lbl = cell.lblArr[i];
                    NSMutableAttributedString *attr = [NSMutableAttributedString attributeStringWithText:leftTextArr[_type][i] attributes:@[kLightGreyColor,kFont13]];
                    [attr appendText:rightTextArr[_type][i] withAttributesArr:@[kDarkGrayColor,kFont13]];
                    lbl.attributedText = attr;
                }
                return cell;
            }
                break;
            case 3: case 4:
            {
                cell.contentLbl.text = indexPath.row==3?kHandleEmptyStr(detailInfoDic[@"address"]):kHandleEmptyStr(detailInfoDic[@"other"]);
            }
                break;
                
            default:
                break;
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cell.contentView addSubview:centerBtn];
        [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(20, 50*kWidthScale, 20, 50*kWidthScale));
        }];
        centerBtn.backgroundColor = kAppThemeColor;
        centerBtn.layer.cornerRadius = 20.0f;
        centerBtn.layer.masksToBounds = YES;
        [centerBtn setImage:[UIImage imageNamed:@"iconfont-dianhua"] forState:UIControlStateNormal];
        [centerBtn setTitle:[detailInfoDic objectForKey:@"tel"] forState:UIControlStateNormal];
        centerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        [centerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [centerBtn addTarget:self action:@selector(pressCenterBtn) forControlEvents:UIControlEventTouchUpInside];
        return cell;

    }
    return [UITableViewCell new];
}

- (void)pressCenterBtn
{
    if(isEmptyStr([detailInfoDic objectForKey:@"tel"])){
        [LLUtils showErrorHudWithStatus:@"您还未认证,无法获取对方联系方式"];
        return;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", [detailInfoDic objectForKey:@"tel"]]];
    [[UIApplication sharedApplication] openURL:url];
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
}

#pragma mark - Network

//获取租赁详情请求
- (void)getDetailInfoRequest
{
    if (isEmptyStr(self.infoDic[@"id"])) {
        [LLUtils showErrorHudWithStatus:@"服务器异常，请稍后重试"];
        return;
    }
    [NetworkEngine postRequestWithRelativeAdd:_type==RentDetailVCTypeCoachCarDetail?@"/carHire/retrieve":@"/venue/retrieve" paraDic:@{@"uid":kUid,@"deviceInfo":kDeviceInfo,@"time":kTimeStamp,@"sign":kSignWithIdentify(_type==RentDetailVCTypeCoachCarDetail?@"/carHire/retrieve":@"/venue/retrieve"),@"carId":self.infoDic[@"id"]} completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if (isEqualValue(jsonObj[@"code"], 1)) {
                //成功
                detailInfoDic = jsonObj[@"info"];
                [self.bg_TableView reloadData];
            }
            else
            {
                
            }
        }
        else
        {
            
        }
    }];
}

@end
