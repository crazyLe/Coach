//
//  AppointDetailVC.m
//  Coach
//
//  Created by LL on 16/8/9.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "AppointFooterCell.h"
#import "AppointTotalCell.h"
#import "AppointTimeCell.h"
#import "AppointInfoCell.h"
#import "AppointHeaderCell.h"
#import "AppointDetailVC.h"

@interface AppointDetailVC ()

@end

@implementation AppointDetailVC
{
    NSDictionary *detailInfoDic;
}

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self setNavigation];
    [self setUI];
    [self appointDetailRequest:self.infoDic[@"id"]]; //请求详情数据
}

#pragma mark - Setup

- (void)setNavigation
{
    [self setTitleText:@"详情" textColor:nil];
}

- (void)setUI
{
    [self setBg_TableView];
}

- (void)setBg_TableView
{
    [self setBg_TableViewWithConstraints:nil];
    [self registerClassWithClassNameArr:@[@"AppointHeaderCell",@"AppointInfoCell",@"AppointTimeCell",@"AppointTotalCell",@"AppointFooterCell"] cellIdentifier:nil];
}

#pragma mark - UITableViewDelegate && UITableViewDateSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 18;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 2;
        }
            break;
        case 1:
        {
            NSArray *timeArr = detailInfoDic[@"times"];
            return timeArr.count;
        }
            break;
        case 2:
        {
            return 3;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==0) {
                return 70*kHeightScale;
            }
            else
            {
                return 135*kHeightScale;
            }
        }
            break;
        case 1:
        {
            return 35*kHeightScale;
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    return 45*kHeightScale;
                }
                    break;
                case 1:
                {
                    return 55*kHeightScale;
                }
                    break;
                case 2:
                {
                    return 100*kHeightScale;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==0) {
                AppointHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppointHeaderCell"];
                cell.titleLbl.text = @"订单信息";
                NSMutableAttributedString *numAtt = [NSMutableAttributedString attributeStringWithText:@"订单编码：" attributes:@[[UIColor colorWithHexString:@"666666"],kFont12]];
                [numAtt appendText:kHandleEmptyStr(self.infoDic[@"id"]) withAttributesArr:@[kAppThemeColor,kFont12]];
                cell.numLbl.attributedText = numAtt;
                return cell;
            }
            else
            {
                AppointInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppointInfoCell"];
                NSArray *leftTextArr = @[@"考场：",@"车辆：",@"教练：",@"科目："];
//                NSArray *rightTextArr = @[@"合肥南岗考场",@"捷达",@"不提供",@"科目二"];
                NSArray *rightTextArr = @[kHandleEmptyStr(detailInfoDic[@"place"]),kHandleEmptyStr(detailInfoDic[@"carType"]),kNickName,kHandleEmptyStr(detailInfoDic[@"subject"]),];
                NSMutableAttributedString *infoAtt = [NSMutableAttributedString attributeStringWithText:nil attributes:nil];
                for (int i = 0; i < 4; i++) {
                    [infoAtt appendText:leftTextArr[i] withAttributesArr:@[kGrayHex99,kFont13]];
                    [infoAtt appendText:rightTextArr[i] withAttributesArr:@[kGrayHex66,kFont13]];
                    if (i != 3) {
                        [infoAtt appendBreakLineWithInterval:8*kWidthScale];
                    }
                }
                cell.infoLbl.attributedText = infoAtt;
                
//                NSString *stateImgName = nil;
//                switch ([detailInfoDic[@"state"] intValue]) {
//                    case 0:
//                    {
//                        //未处理
//                        stateImgName = @"考场未处理";
//                    }
//                        break;
//                    case 1:
//                    {
//                        //接受
//                        stateImgName = @"考场已接受";
//                    }
//                        break;
//                    case 2:
//                    {
//                        //拒绝
//                        stateImgName = @"考场拒绝章子";
//                    }
//                        break;
//                        
//                    default:
//                        break;
//                }
//                cell.flagImgView.image = [UIImage imageNamed:stateImgName];
                
                return cell;
            }
        }
            break;
        case 1:
        {
            AppointTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppointTimeCell"];
            cell.titleLbl.text = indexPath.row==0 ? @"时间:" : @"";
//            cell.timeLbl.text = @"2016-06-30 09:00~10:00";
//            cell.priceLbl.text = @"¥50";
            NSDictionary *timeDic = detailInfoDic[@"times"][indexPath.row];
            cell.timeLbl.text = timeDic[@"time"];
            cell.priceLbl.text = isNull(timeDic[@"price"])?@"":[NSString stringWithFormat:@"¥%@",timeDic[@"price"]];
            return cell;
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    AppointTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppointTotalCell"];
                    cell.totalLbl.text = @"总计:";
                    NSDictionary *timesTotalDic = detailInfoDic[@"timesTotal"];
                    cell.timeLbl.text = [NSString stringWithFormat:@"%@小时",timesTotalDic[@"timelength"]];
                    cell.priceLbl.text = isNull(timesTotalDic[@"totalprice"])?@"":[NSString stringWithFormat:@"¥ %@",timesTotalDic[@"totalprice"]];
                    return cell;
                }
                    break;
                case 1:
                {
                    AppointSuperCell *cell = [[AppointSuperCell alloc] init];
                    UILabel *contentLbl = [UILabel new];
                    [cell.bgView addSubview:contentLbl];
                    [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.offset(kLeftLblLeftOffset);
                        make.top.bottom.offset(0);
                        make.right.offset(-kLeftLblLeftOffset);
                    }];
                    contentLbl.textColor = [UIColor colorWithHexString:@"f96162"];
                    
                    NSString *reasonStr = nil;
                    switch ([detailInfoDic[@"state"] intValue]) {
                        case 0:
                        {
                            //未处理
                            reasonStr = @"";
                        }
                            break;
                        case 1:
                        {
                            //接受
                            reasonStr = @"考场接受";
                        }
                            break;
                        case 2:
                        {
                            //拒绝
                            if (!isEmptyStr(detailInfoDic[@"reason"])) {
                                reasonStr = [NSString stringWithFormat:@"原因：%@",detailInfoDic[@"reason"]];
                            }
                        }
                            break;
                            
                        default:
                            break;
                    }
                    contentLbl.text = reasonStr;
                    contentLbl.font = kFont13;
                    return cell;
                }
                    break;
                case 2:
                {
                    AppointFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppointFooterCell"];
//                    NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithText:@"赚豆已退还账户" attributes:@[kAppThemeColor,kFont13]];
//                    [attStr appendBreakLineWithInterval:8*kWidthScale];
//                    [attStr appendText:@"考场已接受\t\t\t\t已消费" withAttributesArr:@[[UIColor colorWithHexString:@"fd802d"],kFont13]];
                     NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithText:[detailInfoDic[@"state"] intValue]==2?@"赚豆已退还账户":[detailInfoDic[@"state"] intValue]==1?@"考场已接受\t\t\t\t已消费":@"" attributes:[detailInfoDic[@"state"] intValue]==2?@[kAppThemeColor,kFont13]:[detailInfoDic[@"state"] intValue]==1?@[[UIColor colorWithHexString:@"fd802d"],kFont13]:nil];
                    cell.contentLbl.attributedText = attStr;
                    return cell;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)appointDetailRequest:(NSString *)apppintId
{
    NSString *relativeAdd = @"/member/appointmentDetail";
    NSDictionary *paraDic = @{@"uid":kUid,@"deviceInfo":kDeviceInfo,@"time":kTimeStamp,@"sign":kSignWithIdentify(relativeAdd),@"appointmentId":apppintId};
    [NetworkEngine postRequestWithRelativeAdd:relativeAdd paraDic:paraDic completeBlock:^(BOOL isSuccess, id jsonObj) {
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
