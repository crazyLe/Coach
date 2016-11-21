//
//  InviteStudentVC.m
//  Coach
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "ExamScheduleCell.h"
#import "InviteStudentVC.h"

@interface InviteStudentVC () <UIAlertViewDelegate>

@end

@implementation InviteStudentVC
{
    NSMutableArray *_isInviteArr; //标识是否已邀请
    
    NSString *telPhoneStr;
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
    [self setNav];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)setNav
{
    [self setTitleText:@"邀请学员" textColor:nil];
    [self setLeftText:nil textColor:nil ImgPath:@"Navigation_Return"];
//    [self setRightText:nil textColor:nil ImgPath:@"Navigation_Add"];
}

- (void)setUI
{
    [self setBg_TableViewWithConstraints:nil];
    [self registerClassWithClassNameArr:@[@"ExamScheduleCell"]  cellIdentifier:nil];
    
    NSString *relativeAdd = @"/recruit/retrieve";
    NSDictionary *paraDic = @{@"uid":kUid,@"typeId":@"1",@"time":kTimeStamp,@"sign":kSignWithIdentify(relativeAdd)};
    [self setNetworkRelativeAdd:relativeAdd paraDic:paraDic pageFiledName:@"pageId" parseDicKeyArr:@[@"info",@"recruit"]];
    [self.bg_TableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
            return self.contentArr.count;
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
        return 60;
    }
    else
    {
        return 70;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *promptLbl = [UILabel new];
        [cell.contentView addSubview:promptLbl];
        promptLbl.backgroundColor = [UIColor colorWithHexString:@"fffbf2"];
        [promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell);
            make.height.equalTo(cell).multipliedBy(0.7);
            make.width.equalTo(cell).multipliedBy(0.8);
        }];
        promptLbl.textColor = [UIColor  colorWithHexString:@"cfc3a8"];
        promptLbl.textAlignment = NSTextAlignmentCenter;
        promptLbl.layer.borderWidth = 1.0f;
        promptLbl.layer.borderColor = [UIColor colorWithHexString:@"e6decc"].CGColor;
        promptLbl.font = Font14;
        promptLbl.text = @"只有使用APP的学员才能被接受邀请哦";
        return cell;
    }
    else
    {
        ExamScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExamScheduleCell"];
        cell.delegate = self;
        cell.indexPath = indexPath;
        
        NSDictionary *dic = self.contentArr[indexPath.row];
        [cell.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:dic[@"face"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"iconfont-defaultheadimage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                [cell.headBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-defaultheadimage"] forState:UIControlStateNormal];
            }
        }];
        cell.nameLbl.text = dic[@"userName"];
        NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithImg:[UIImage imageNamed:@"InviteStudent_Stage"] bounds:CGRectMake(0, -3, 15, 15)];
        
        NSString *subjectStr = nil;
        switch ([dic[@"subject"] intValue]) {
            case 1:
            {
                subjectStr = @" 科目一";
            }
                break;
            case 2:
            {
                subjectStr = @" 科目二";
            }
                break;
            case 3:
            {
                subjectStr = @" 科目三";
            }
                break;
            case 4:
            {
                subjectStr = @" 科目四";
            }
                break;
                
            default:
                subjectStr = @" 科目一";
                break;
        }
        
        [attStr appendText:subjectStr withAttributesArr:@[[UIColor colorWithHexString:@"c8c8c8"],kFont12]];
        cell.stageLbl.attributedText = attStr;
        [cell.phoneBtn setImage:[UIImage imageNamed:@"InviteStudent_Phone"] forState:UIControlStateNormal];
        int  inviteState = [dic[@"yaoqing_state"] intValue];
//        if ([_isInviteArr[indexPath.row] isEqualToNumber:@(YES)]) {
        if (inviteState == 5|| inviteState == 6) {
            //未邀请
            cell.notifyBtn.selected = NO;
            cell.notifyBtn.backgroundColor = rgb(97, 185, 54);
            [cell.notifyBtn setTitle:@"邀请" forState:UIControlStateNormal];
            cell.notifyBtn.userInteractionEnabled = YES;
        }
        else if (inviteState==0)
        {
            //已邀请
            cell.notifyBtn.selected = YES;
            cell.notifyBtn.backgroundColor = [UIColor clearColor];
            [cell.notifyBtn setTitle:@"已邀请" forState:UIControlStateNormal];
            cell.notifyBtn.userInteractionEnabled = NO;
        }
        else if (inviteState==1)
        {
            //已接受
            cell.notifyBtn.selected = YES;
            cell.notifyBtn.backgroundColor = [UIColor clearColor];
            [cell.notifyBtn setTitle:@"已接受" forState:UIControlStateNormal];
            cell.notifyBtn.userInteractionEnabled = NO;
        }
        else if (inviteState==2)
        {
            //已经拒绝
            cell.notifyBtn.selected = YES;
            cell.notifyBtn.backgroundColor = [UIColor clearColor];
            [cell.notifyBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
            cell.notifyBtn.userInteractionEnabled = NO;
        }
        else
        {
            //
            
        }
        if (indexPath.row != [tableView numberOfRowsInSection:1]-1) {
             cell.lineView.backgroundColor = kLineWhiteColor;
            [cell.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.offset(kSideOffset);
                make.right.offset(-kSideOffset);
            }];
        }
        else
        {
            //最后一行
            cell.lineView.backgroundColor = kLineGrayColor;
            [cell.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.offset(0);
            }];
        }
        cell.lineView.hidden = NO;
        [cell.phoneBtn mas_updateConstraints:^(MASConstraintMaker *make) {
             make.right.equalTo(cell.notifyBtn.mas_left).offset(-10*kWidthScale);
        }];
        return cell;
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
}

#pragma mark - ExamScheduleCellDelegate

//点击头像
- (void)ExamScheduleCell:(ExamScheduleCell *)cell clickHeadBtn:(UIButton *)headBtn;
{
    
}

//点击电话
- (void)ExamScheduleCell:(ExamScheduleCell *)cell clickPhoneBtn:(UIButton *)phoneBtn;
{
    NSDictionary *dic = self.contentArr[cell.indexPath.row];
    NSString *phoneStr = dic[@"phone"];
    telPhoneStr = phoneStr;
    [LLUtils showAlertWithTitle:kCallPhonePrompt message:phoneStr delegate:self tag:10 type:AlertViewTypeConfirmAndCancel];
}

//邀请
- (void)ExamScheduleCell:(ExamScheduleCell *)cell clickNotifyBtn:(UIButton *)notifyBtn;
{
    //发送邀请网络请求
    NSDictionary *dic = [self.contentArr[cell.indexPath.row] mutableCopy];
    NSString *phoneStr = dic[@"phone"];
    NSDictionary *paraDic = @{@"uid":kUid,@"time":kTimeStamp,@"phone":phoneStr,@"sign":kSignWithIdentify(@"/recruit/create")};
    [self inviteRequestWithParaDic:paraDic atIndexPath:cell.indexPath];
}

#pragma mark - Overwrite

- (void)contentArrDidRefresh:(NSArray *)newArr
{
    _isInviteArr = [NSMutableArray array];
    for (NSDictionary *dic in newArr) {
        [_isInviteArr appendObject:@(NO)];
    }
}

- (void)contentArrDidLoadMoreData:(NSArray *)appendArr
{
    for (NSDictionary *dic in appendArr) {
        [_isInviteArr appendObject:@(NO)];
    }
}

- (void)inviteRequestWithParaDic:(NSDictionary *)paraDic atIndexPath:(NSIndexPath *)indexPath
{
    NSString *relativeAdd = @"/recruit/create";
    [NetworkEngine postRequestWithRelativeAdd:relativeAdd paraDic:paraDic completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if (isEqualValue(jsonObj[@"code"], 1)) {
                //成功
                //刷新UI
//                _isInviteArr[indexPath.row] = @(YES);
                NSMutableDictionary *dic = [self.contentArr[indexPath.row] mutableCopy];
                [dic setObject:@(0) forKey:@"yaoqing_state"];
                self.contentArr[indexPath.row] = dic;
                [self.bg_TableView reloadData];
                [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
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

#pragma mark - 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10) {
        if (buttonIndex==0) {
            [LLUtils callPhoneWithPhone:kHandleEmptyStr(telPhoneStr)];
        }
    }
}

@end
