//
//  MyStudentVC.m
//  Coach
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "AddStudentVC.h"
#import "EditInfoVC.h"
#import "LLPopoverView.h"
#import "SegmentedView.h"
#import "LLMyStudentCell.h"
#import "MyStudentVC.h"

@interface MyStudentVC () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@end

@implementation MyStudentVC
{
    UIView *segmentedBgView;
    UISegmentedControl *segmentedControl;
    
//    NSMutableArray *selectIndexArr;
    
    NSString *telPhoneStr;
}

- (id)init
{
    if (self = [super init]) {
//        selectIndexArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    [self setUI];
    
    //触发网络请求
    [self segmentedControlChangedValue:segmentedControl];
}

#pragma mark - Setup

- (void)setNavigation
{
    [self setTitleText: @"我的学员" textColor:nil];
    [self setLeftText:nil textColor:nil ImgPath:@"Navigation_Return"];
    if (_isShowRightBtn) {
        [self setRightText:nil textColor:nil ImgPath:@"Navigation_Add"];
    }
}

- (void)setUI
{
    [self setSegmentedView];
    WeakObj(segmentedBgView)
    [self setBg_TableViewWithConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(segmentedBgViewWeak.mas_bottom);
        make.left.bottom.right.offset(0);
    }];
    [self registerClassWithClassNameArr:@[@"LLMyStudentCell"]  cellIdentifier:nil];
}

- (void)setSegmentedView
{
    segmentedBgView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopBarTotalHeight, kScreenWidth, 50)];
//    segmentedBgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:segmentedBgView];
    
    segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"正在学",@"已毕业",@"暂停"]];
    [segmentedBgView addSubview:segmentedControl];
    segmentedControl.frame = CGRectMake(12.5f, 10, kScreenWidth-12.5f*2, 30);
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:kGrayHex33,NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"ffffff" ],NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateSelected];
    segmentedControl.tintColor = [UIColor colorWithHexString:@"2e82ff"];
    segmentedControl.selectedSegmentIndex = 0;
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
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LLMyStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLMyStudentCell"];
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:isEmptyStr(self.contentArr[indexPath.row][@"sFace"])?@"":self.contentArr[indexPath.row][@"sFace"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"iconfont-defaultheadimage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            [cell.headBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-defaultheadimage"] forState:UIControlStateNormal];
        }
    }];
    cell.nameLbl.text = self.contentArr[indexPath.row][@"sName"];
//    [cell.headBtn setImage:[UIImage imageNamed:@"myStudents_avator"] forState:UIControlStateNormal];
    NSString *subjectStr = nil;
    switch ([self.contentArr[indexPath.row][@"subject"] intValue]) {
        case 1:
            subjectStr = @"科目一";
            break;
        case 2:
            subjectStr = @"科目二";
            break;
        case 3:
            subjectStr = @"科目三";
            break;
        case 4:
            subjectStr = @"科目四";
            break;
            
        default:
            subjectStr = @"科目一";
            break;
    }
    NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithImg:[UIImage imageNamed:@"MyStudent_Subject"] bounds:CGRectMake(0, -3, 15, 15)];
    [attStr appendText:subjectStr withAttributesArr:@[kGrayHex88,@(12)]];
    [cell.stageLbl setAttributedText:attStr];
    [cell.phoneBtn setImage:[UIImage imageNamed:@"MyStudent_Phone"] forState:UIControlStateNormal];
//    [cell.notifyBtn setTitle:indexPath.row < 2 ?@"已邀请":@"邀请" forState:UIControlStateNormal];
    [cell.settingBtn setImage:[UIImage imageNamed:@"MyStudent_Setting"] forState:UIControlStateNormal];
    [cell.notifyBtn setTitle:@"邀请" forState:UIControlStateNormal];
    [cell.notifyBtn setTitle:@"已邀请" forState:UIControlStateSelected];
    if (isEqualValue(self.contentArr[indexPath.row][@"isMember"], 1)) {
        
        cell.lineView.backgroundColor = kLineWhiteColor;
        [cell.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.offset(-10);
        }];
    }
    else
    {
        cell.lineView.backgroundColor = kLineGrayColor;
        [cell.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
        }];
    }
    
//    if ([selectIndexArr containsObject:indexPath]) {
//        cell.notifyBtn.selected = YES;
//        cell.notifyBtn.backgroundColor = [UIColor clearColor];
//        cell.notifyBtn.userInteractionEnabled = NO;
//        cell.promptLbl.text = @"";
//    }
//    else
//    {
        if (isEqualValue(self.contentArr[indexPath.row][@"isMember"], 0)) {
            //该学员未注册，可以邀请，显示邀请按钮以及提示语句
            cell.notifyBtn.hidden = NO;
            cell.notifyBtn.selected = [self.contentArr[indexPath.row][@"in_state"] boolValue];
            
            if (cell.notifyBtn.selected) {
                //已邀请
                cell.notifyBtn.backgroundColor = [UIColor clearColor];
                cell.promptLbl.text = @"";
                [cell.notifyBtn setTitleColor:[UIColor colorWithHexString:@"#646464"] forState:UIControlStateSelected];
                cell.notifyBtn.userInteractionEnabled = NO;
            }
            else
            {
                //未邀请
                cell.notifyBtn.backgroundColor = [UIColor colorWithHexString:@"6cc13d"];
                [cell.notifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                cell.promptLbl.text = @"该学员未使用康庄学车";
                cell.notifyBtn.userInteractionEnabled = YES;
            }
        }
        else if(isEqualValue(self.contentArr[indexPath.row][@"isMember"], 1))
        {
            //该学员注册了，隐藏邀请按钮，以及提示语句
            cell.notifyBtn.hidden = YES;
            cell.promptLbl.text = @"";
        }else if (isEqualValue(self.contentArr[indexPath.row][@"isMember"], 2)){
            //该学员已绑定了教练，只显示“已绑定”按钮 不显示提示语句
            cell.notifyBtn.hidden = NO;
            cell.notifyBtn.backgroundColor = [UIColor clearColor];
            cell.notifyBtn.userInteractionEnabled = NO;
            [cell.notifyBtn setTitle:@"已绑定" forState:UIControlStateNormal];
            [cell.notifyBtn setTitleColor:[UIColor colorWithHexString:@"#646464"] forState:UIControlStateNormal];
            cell.promptLbl.text = @"";
        }
//    }
    
    if (indexPath.row == 0) {
        cell.topLine.hidden = NO;
    }
    else
    {
        cell.topLine.hidden = YES;
    }
    cell.lineView.hidden = NO;
    return cell;
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark UISegmentedControl Value Changed

- (void)segmentedControlChangedValue:(UISegmentedControl *)segmentControl
{
    [self.bg_TableView.mj_header endRefreshing];
    NSString *typeId = segmentControl.selectedSegmentIndex==0?@"1":segmentControl.selectedSegmentIndex==1?@"2":@"3";
    
    [self setNetworkRelativeAdd:@"myStudent" paraDic:@{@"uid":kUid,@"time":kTimeStamp,@"typeId":typeId,@"deviceInfo":kDeviceInfo,@"sign":kSignWithIdentify(@"/myStudent")} pageFiledName:@"pageId" parseDicKeyArr:@[@"info",@"student"]];
    
    [self.bg_TableView.mj_header beginRefreshing]; //Enter the refresh status immediately
}

#pragma mark - LLMyStudentCellDelegate

- (void)LLMyStudentCell:(LLMyStudentCell *)cell clickBtn:(UIButton *)btn;
{
    switch (btn.tag) {
        case LLMyStudentCellBtnTagHead:
        {
            //点击头像
            
        }
            break;
        case LLMyStudentCellBtnTagPhone:
        {
            //点击电话
//            [LLUtils callPhoneWithPhone:self.contentArr[cell.indexPath.row][@"phone"]];
            telPhoneStr = self.contentArr[cell.indexPath.row][@"phone"];
            [LLUtils showAlertWithTitle:kCallPhonePrompt message:self.contentArr[cell.indexPath.row][@"phone"] delegate:self tag:10 type:AlertViewTypeConfirmAndCancel];
        }
            break;
        case LLMyStudentCellBtnTagSetting:
        {
            //点击设置
            CGFloat popViewWidth = 85.0f;
            CGSize  btnImgSize = btn.imageView.image.size;
            
            
            LLPopoverView *popoverView = nil;
            if (segmentedControl.selectedSegmentIndex == 0) {
                CGRect originRect = CGRectMake(btn.center.x-popViewWidth/2
                                               , btn.center.y+btnImgSize.height/2+2.0f, popViewWidth, 150);
                CGRect targetRect = [cell.contentView convertRect:originRect toView:self.view];
                popoverView = [LLPopoverView showAtRect:targetRect inView:self.view withItemArr:@[@"毕业",@"暂停",@"编辑",@"删除"] delegate:self object:nil];
            }else if(segmentedControl.selectedSegmentIndex == 1){
                CGRect originRect = CGRectMake(btn.center.x-popViewWidth/2
                                               , btn.center.y+btnImgSize.height/2+2.0f, popViewWidth, 37.5*2);
                CGRect targetRect = [cell.contentView convertRect:originRect toView:self.view];
                popoverView = [LLPopoverView showAtRect:targetRect inView:self.view withItemArr:@[@"编辑",@"删除"] delegate:self object:nil];
            }else if (segmentedControl.selectedSegmentIndex == 2){
                CGRect originRect = CGRectMake(btn.center.x-popViewWidth/2
                                               , btn.center.y+btnImgSize.height/2+2.0f, popViewWidth, 37.5*3);
                CGRect targetRect = [cell.contentView convertRect:originRect toView:self.view];
                popoverView = [LLPopoverView showAtRect:targetRect inView:self.view withItemArr:@[@"编辑",@"恢复",@"删除"] delegate:self object:nil];
            }
            
            popoverView.object = self.contentArr[cell.indexPath.row];
            popoverView.userInfo = @{@"indexPath":cell.indexPath};
            popoverView.bgImg = [UIImage imageNamed:@"PopoverView_ArrowCenter"];
        }
            break;
        case LLMyStudentCellBtnTagInvite:
        {
            //点击邀请
            [self inviteStudentRequestWithPhoneStr:self.contentArr[cell.indexPath.row][@"phone"] indexPath:cell.indexPath];
        }
            break;
            
        default:
            break;
    }
}

//邀请学生请求
- (void)inviteStudentRequestWithPhoneStr:(NSString *)phoneStr indexPath:(NSIndexPath *)indexPath
{
    [LLUtils showOnlyProgressHud];
    NSString *relativeAdd = @"/myStudent/config";
    NSDictionary *paraDic = @{@"uid":kUid,@"time":kTimeStamp,@"phone":phoneStr,@"invited":@"1",@"sign":kSignWithIdentify(relativeAdd)};
    [NetworkEngine postRequestWithRelativeAdd:relativeAdd paraDic:paraDic completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if (isEqualValue(jsonObj[@"code"], 1)) {
                //成功
                [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
//                [selectIndexArr addObject:indexPath]; //将邀请成功的cell索引保存下来
                NSMutableDictionary *dic = [self.contentArr[indexPath.row] mutableCopy];
                [dic setObject:@(YES) forKey:@"in_state"];
                self.contentArr[indexPath.row] = dic;
                [self.bg_TableView reloadData];
            }
            else
            {
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
        }
        else
        {
            [LLUtils showErrorHudWithStatus:@"请求异常，请稍后重试"];
        }
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10) {
        if (buttonIndex==0) {
            //确定拨打
            if (!isEmptyStr(telPhoneStr)) {
                [LLUtils callPhoneWithPhone:telPhoneStr];
            }
        }
    }
}

#pragma mark - LLPopoverViewDelegate

- (void)LLPopoverView:(LLPopoverView *)view didSelectItemAtIndex:(NSInteger)index;
{
    NSMutableDictionary *paraDic = [@{@"uid":kUid,@"time":kTimeStamp,@"phone":isEmptyStr(view.object[@"phone"])?@"":view.object[@"phone"],@"sign":kSignWithIdentify(@"/myStudent/config")} mutableCopy];
    if(segmentedControl.selectedSegmentIndex == 0){
        switch (index) {
            case 0:
            {
                //毕业
                [paraDic setObject:@"2" forKey:@"state"];
            }
                break;
            case 1:
            {
                //暂停
                [paraDic setObject:@"3" forKey:@"state"];
            }
                break;
            case 2:
            {
                //编辑
                WeakObj(self)
                EditInfoVC *editInfoVC = [[EditInfoVC alloc] init];
                editInfoVC.infoDic = view.object;
                editInfoVC.type = EditInfoVCTypeEdit;
                editInfoVC.successBlock = ^(NSString *nameStr ,NSString *phoneStr ,NSString *subjectStr){
                    //                [selfWeak.bg_TableView.mj_header beginRefreshing]; //Enter the refresh status immediately
                    NSMutableDictionary *dic =  [self.contentArr[((NSIndexPath *)view.userInfo[@"indexPath"]).row] mutableCopy];
                    [dic setObject:nameStr forKey:@"sName"];
                    [dic setObject:phoneStr forKey:@"phone"];
                    [dic setObject:subjectStr forKey:@"subject"];
                    self.contentArr[((NSIndexPath *)view.userInfo[@"indexPath"]).row] = dic;
                    [self.bg_TableView reloadData];
                };
                [self.navigationController pushViewController:editInfoVC animated:YES];
                return;
            }
                break;
            case 3:
            {
                //删除
                [paraDic setObject:@"1" forKey:@"del"];
            }
                break;
                
            default:
                break;
        }
    }else if (segmentedControl.selectedSegmentIndex == 1){
        switch (index) {
            case 0:
            {
                //编辑
                EditInfoVC *editInfoVC = [[EditInfoVC alloc] init];
                editInfoVC.infoDic = view.object;
                editInfoVC.type = EditInfoVCTypeEdit;
                editInfoVC.successBlock = ^(NSString *nameStr ,NSString *phoneStr ,NSString *subjectStr){
                    //                [selfWeak.bg_TableView.mj_header beginRefreshing]; //Enter the refresh status immediately
                 /*   NSMutableDictionary *dic =  [self.contentArr[((NSIndexPath *)view.userInfo[@"indexPath"]).row] mutableCopy];
                    [dic setObject:nameStr forKey:@"sName"];
                    [dic setObject:phoneStr forKey:@"phone"];
                    [dic setObject:subjectStr forKey:@"subject"];
                    self.contentArr[((NSIndexPath *)view.userInfo[@"indexPath"]).row] = dic;
                  */
                    [self.contentArr removeObjectAtIndex:((NSIndexPath *)view.userInfo[@"indexPath"]).row];
                    [self.bg_TableView reloadData];
                };
                [self.navigationController pushViewController:editInfoVC animated:YES];
                return;
            }
                break;
            case 1:
            {
                //删除
                [paraDic setObject:@"1" forKey:@"del"];
            }
                break;
                
            default:
                break;
        }
    }else if (segmentedControl.selectedSegmentIndex == 2){
        switch (index) {
            case 0:
            {
                //编辑
                EditInfoVC *editInfoVC = [[EditInfoVC alloc] init];
                editInfoVC.infoDic = view.object;
                editInfoVC.type = EditInfoVCTypeEdit;
                editInfoVC.successBlock = ^(NSString *nameStr ,NSString *phoneStr ,NSString *subjectStr){
                    //                [selfWeak.bg_TableView.mj_header beginRefreshing]; //Enter the refresh status immediately
                    /*
                    NSMutableDictionary *dic =  [self.contentArr[((NSIndexPath *)view.userInfo[@"indexPath"]).row] mutableCopy];
                    [dic setObject:nameStr forKey:@"sName"];
                    [dic setObject:phoneStr forKey:@"phone"];
                    [dic setObject:subjectStr forKey:@"subject"];
                    self.contentArr[((NSIndexPath *)view.userInfo[@"indexPath"]).row] = dic;
                     */
                    [self.contentArr removeObjectAtIndex:((NSIndexPath *)view.userInfo[@"indexPath"]).row];
//                    [self.bg_TableView.mj_header beginRefreshing];
                    [self.bg_TableView reloadData];
                };
                [self.navigationController pushViewController:editInfoVC animated:YES];
                return;
            }
                break;
            case 1:
            {
                //恢复到正在学状态
                [paraDic setObject:@"1" forKey:@"state"];
            }
                break;
            case 2:
            {
                //删除
                [paraDic setObject:@"1" forKey:@"del"];
            }
                break;
                
            default:
                break;
        }
    }
        [self configRequestWithParaDic:paraDic successBlock:^{
        //更新数据源
        //刷新UI
        if (!((segmentedControl.selectedSegmentIndex == 0) && (index==2))) {
            //        if ((index==3)||(index==0)||(index==1)) {
            //删除
            [self.contentArr removeObjectAtIndex:((NSIndexPath *)view.userInfo[@"indexPath"]).row];
            [self.bg_TableView reloadData];
            //        }
        }
    }];
}

- (void)popoverViewWillDismiss:(LLPopoverView *)view;
{
    
}

- (void)popoverViewDidDismiss:(LLPopoverView *)view;
{
    
}

- (void)clickRightBtn:(UIButton *)rightBtn
{
    AddStudentVC *addStudentVC = [[AddStudentVC alloc] init];
    [self.navigationController pushViewController:addStudentVC animated:YES];
}

#pragma mark - Network

- (void)configRequestWithParaDic:(NSDictionary *)paraDic successBlock:(void(^)())successBlock
{
    //我的学员-邀请/编辑/删除
    [NetworkEngine postRequestWithRelativeAdd:@"/myStudent/config" paraDic:paraDic completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
//                [self.bg_TableView.mj_header beginRefreshing];
                successBlock();
                [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
            }
            else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                //需要登录
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
            else
            {
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
        }
    }];
}

@end
