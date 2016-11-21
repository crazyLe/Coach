//
//  AppointListVC.m
//  Coach
//
//  Created by LL on 16/8/8.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "CYLTableViewPlaceHolder.h"

#import "LLCustomAlertView.h"
#import "AppointDetailVC.h"
#import "AppointListTableCell.h"
#import "AppointListVC.h"

@interface AppointListVC ()

@end

@implementation AppointListVC
{
    LLCustomAlertView *customAlertView;
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
}

#pragma mark - Setup

- (void)setNavigation
{
    [self setTitleText:@"预约列表" textColor:nil];
}

- (void)setUI
{
    [self setBg_TableView];
}

- (void)setBg_TableView
{
    [self setBg_TableViewWithConstraints:nil];
    [self registerClassWithClassNameArr:@[@"AppointListTableCell"] cellIdentifier:nil];
    [self setNetworkRelativeAdd:@"/member/appointmentOrder" paraDic:@{@"uid":kUid,@"deviceInfo":kDeviceInfo,@"time":kTimeStamp,@"sign":kSignWithIdentify(@"/member/appointmentOrder")} pageFiledName:@"pageId" parseDicKeyArr:@[@"info",@"order"]];
    [self.bg_TableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate && UITableViewDateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppointListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppointListTableCell"];
    cell.delegate = self;
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *dic = self.contentArr[indexPath.row];
    NSMutableAttributedString *numAtt = [NSMutableAttributedString attributeStringWithText:@"订单编号：" attributes:@[[UIColor colorWithHexString:@"888888"],kFont13]];
    [numAtt appendText:kHandleEmptyStr(dic[@"id"]) withAttributesArr:@[kAppThemeColor,kFont13]];
    cell.numLbl.attributedText = numAtt;
    
    [cell.cancelBtn setTitle:isEqualValue(dic[@"state"], 1)?@"取消该预约":@"" forState:UIControlStateNormal];
    
    NSMutableAttributedString *infoAtt = [NSMutableAttributedString attributeStringWithText:[NSString stringWithFormat:@"订单信息：%@",dic[@"title"]] attributes:@[[UIColor colorWithHexString:@"666666"],kFont13]];
    [infoAtt appendBreakLineWithInterval:10];
    NSArray *timeArr = dic[@"timeList"];
    for (int i = 0 ; i < timeArr.count ; i++) {
        NSString *timeStr = timeArr[i];
        [infoAtt appendText:timeStr withAttributesArr:@[[UIColor colorWithHexString:@"888888"],kFont12]];
        if (i!=timeArr.count-1) {
            [infoAtt appendBreakLineWithInterval:3.0f];
        }
    }
    cell.infoLbl.attributedText  = infoAtt;
    
    NSMutableAttributedString *timeAtt = [NSMutableAttributedString attributeStringWithImg:[UIImage imageNamed:@"iconfont-shijian"] bounds:CGRectMake(0, -1.5, 13, 13)];
    
    [timeAtt appendText:[NSString stringWithFormat:@" %@",[LLUtils dateStrWithDate:[NSDate dateWithTimeIntervalSince1970:[dic[@"addtime"] longLongValue]<0?[LLUtils timestampsWithDate:[NSDate date]]:[dic[@"addtime"] longLongValue]] dateFormat:@"yyyy-MM-dd hh:mm"]] withAttributesArr:@[[UIColor colorWithHexString:@"999999"],kFont12]];
    cell.timeLbl.attributedText = timeAtt;
    
    cell.priceLbl.text = [NSString stringWithFormat:@"¥%@",dic[@"money"]];
    
    cell.statusLbl.text = isEqualValue(dic[@"state"], 1)?@"已接受":isEqualValue(dic[@"state"], 2)?@"已拒绝":@"未处理";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppointDetailVC *appointDetailVC = [[AppointDetailVC alloc] init];
    appointDetailVC.infoDic = self.contentArr[indexPath.row];
    [self.navigationController pushViewController:appointDetailVC animated:YES];
}

#pragma mark -

- (void)contentArrDidRefresh:(NSArray *)newArr
{
    if (newArr.count==0) {
        [self.bg_TableView cyl_reloadData];
    }
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

#pragma mark - AppointListTableCellDelegate

- (void)AppointListTableCell:(AppointListTableCell *)cell clickCancelBtn:(UIButton *)cancelBtn;
{
  customAlertView = [LLCustomAlertView showWithTitle:nil btnTitleArr:nil textFieldPlaceHolder:nil confirmBtnTitle:nil object:cell userInfo:nil delegate:self];
    
//    [LLUtils showAlertWithTitle:@"aaa" message:nil delegate:nil tag:nil type:AlertViewTypeOnlyYes];
}

#pragma mark - LLCustomAlertViewDelegate

//点击选则按钮
- (void)LLCustomAlertView:(LLCustomAlertView *)view clickSelectBtn:(UIButton *)btn;
{
    
}

//点击底部确认按钮
- (void)LLCustomAlertView:(LLCustomAlertView *)view clickConfirmSelectBtn:(UIButton *)btn;
{
    UIButton *selectBtn;
    NSString *reasonStr;
    for (UIButton *btn in view.btnArr) {
        if (btn.selected) {
            selectBtn = btn;
            break;
        }
    }
    if (selectBtn.tag==12) {
        //其他原因
        reasonStr = view.textView.text;
    }
    else
    {
        reasonStr = selectBtn.titleLabel.text;
    }
    
    if (isEmptyStr(reasonStr)) {
        [LLUtils showErrorHudWithStatus:@"请选择或输入取消原因"];
        return;
    }
    
    AppointListTableCell *cell = view.object;
    NSDictionary *dic = self.contentArr[cell.indexPath.row];
    NSString *appointid = dic[@"id"];
    
    NSDictionary *paraDic = @{@"uid":kUid,@"appointmentId":appointid,@"reason":reasonStr,@"time":kTimeStamp,@"sign":kSignWithIdentify(@"/member/appointmentOrderupdate")};
    [self cancelAppointRequestWithParaDic:paraDic indexPath:cell.indexPath];
}

//点击退出按钮
- (void)LLCustomAlertView:(LLCustomAlertView *)view clickExitSelectBtn:(UIButton *)btn;
{
    
}

//textField编辑改变回调
- (void)LLCustomAlertView:(LLCustomAlertView *)view textViewDidChange:(SZTextView *)textView;
{
    
}

#pragma mark - Network

- (void)cancelAppointRequestWithParaDic:(NSDictionary *)paraDic indexPath:(NSIndexPath *)indexPath
{
    WeakObj(self)
    NSString *relativeAdd = @"/member/appointmentOrderupdate";
    [NetworkEngine postRequestWithRelativeAdd:relativeAdd paraDic:paraDic completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if (isEqualValue(jsonObj[@"code"], 1)) {
                //成功
                [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
                if (selfWeak.contentArr.count>indexPath.row) {
                    [selfWeak.contentArr removeObjectAtIndex:indexPath.row];
                    [selfWeak.bg_TableView deleteRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationBottom];
                }
            }
            else
            {
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
        }
        else
        {
            [LLUtils showErrorHudWithStatus:@"服务器异常"];
        }
        [customAlertView dismiss];
    }];
}

@end
