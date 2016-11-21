//
//  EditInfoVC.m
//  Coach
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLPopoverView.h"
#import "OneCenterBtnCell.h"
#import "ImgTextFieldCell.h"
#import "EditInfoVC.h"

@interface EditInfoVC () <OneCenterBtnCellDelegate,UIAlertViewDelegate>

@end

@implementation EditInfoVC
{
    NSArray *imgNameArr;
    NSArray *leftLblTextArr;
    NSArray *placeHolderArr;
    
    NSString *nameStr;
    NSString *phoneStr;
    NSString *subjectStr;
}

- (id)init
{
    if (self = [super init]) {
        imgNameArr = @[@"wode",@"iconfont-editstudentphone",@"iconfont-editstudentsubject"];
        leftLblTextArr = @[@"  姓名：",@"  手机号码：",@"  科目："];
        placeHolderArr = @[@"输入学员姓名",@"输入学员手机号",@"选择学员所学科目"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self prepareData];
    [self setNav];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)setNav
{
    [self setTitleText:@"编辑学员信息" textColor:nil];
    [self setLeftText:nil textColor:nil ImgPath:@"Navigation_Return"];
    [self setRightText:@"保存" textColor:nil ImgPath:nil];
}

- (void)setUI
{
    [self setBg_TableViewWithConstraints:nil];
    [self registerClassWithClassNameArr:@[@"ImgTextFieldCell",@"OneCenterBtnCell"]  cellIdentifier:nil];
    self.bg_TableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
}

- (void)prepareData
{
    if (_type == EditInfoVCTypeEdit) {
        nameStr = self.infoDic[@"sName"];
        phoneStr = self.infoDic[@"phone"];
        int subjectInt = [self.infoDic[@"subject"] intValue];
        subjectStr = subjectInt==1?@"科目一":subjectInt==2?@"科目二":subjectInt==3?@"科目三":@"科目四";
    }
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        ImgTextFieldCell *imgTextCell = [tableView dequeueReusableCellWithIdentifier:@"ImgTextFieldCell"];
        imgTextCell.delegate = self;
        imgTextCell.indexPath = indexPath;
        NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithImg:[UIImage imageNamed:imgNameArr[indexPath.row]] bounds:CGRectMake(0, -3, 17, 17)];
        [attStr appendText:leftLblTextArr[indexPath.row] withAttributesArr:@[[UIColor colorWithHexString:@"333333"],kFont15]];
        [imgTextCell.leftLbl setAttributedText:attStr];
        imgTextCell.textField.attributedPlaceholder = [NSMutableAttributedString attributeStringWithText: placeHolderArr[indexPath.row] attributes:@[kGrayHex88,kFont15]];
        if (indexPath.row==2) {
            [imgTextCell.accessoryBtn setImage:[UIImage imageNamed:@"iconfont-editstudentselect"] forState:UIControlStateNormal];
            [imgTextCell.accessoryBtn setImage:[UIImage imageNamed:@"iconfont-editstudentselected"] forState:UIControlStateSelected];
            imgTextCell.textField.userInteractionEnabled = NO;
        }
        else
        {
            [imgTextCell.accessoryBtn removeFromSuperview] , imgTextCell.accessoryBtn = nil;
             imgTextCell.textField.userInteractionEnabled = YES;
        }
        if (indexPath.row==1) {
            imgTextCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        else if (indexPath.row==0)
        {
            imgTextCell.textField.keyboardType = UIKeyboardTypeDefault;
        }
        imgTextCell.textField.text = indexPath.row==0?nameStr:indexPath.row==1?phoneStr:subjectStr;
        return imgTextCell;
    }
    else
    {
//        OneCenterBtnCell *centerBtnCell = [tableView dequeueReusableCellWithIdentifier:@"OneCenterBtnCell"];
//        [centerBtnCell.centerBtn setTitle:@"保存" forState:UIControlStateNormal];
//        centerBtnCell.delegate = self;
//        return centerBtnCell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)clickEnterMyStudentBtn
{
    
}

#pragma mark - OneCenterBtnCellDelegate 

- (void)centerBtnCell:(OneCenterBtnCell *)cell clickCenterBtn:(UIButton *)centerBtn
{
    
}

#pragma mark -ImgTextFieldCellDelegate

- (void)ImgTextFieldCell:(ImgTextFieldCell *)cell clickAccessoryBtn:(UIButton *)accessoryBtn
{
    accessoryBtn.selected = YES;
    CGFloat popViewWidth = 85.0f;
    CGRect originRect = CGRectMake(accessoryBtn.frame.origin.x+accessoryBtn.frame.size.width-popViewWidth+9.0f
                                   , accessoryBtn.frame.origin.y+accessoryBtn.frame.size.height+5.0f, popViewWidth, 150);
    CGRect targetRect = [cell.contentView convertRect:originRect toView:self.view];
    [LLPopoverView showAtRect:targetRect inView:self.view withItemArr:@[@"科目一",@"科目二",@"科目三",@"科目四"] delegate:self object:nil];
}

- (void)ImgTextFieldCell:(ImgTextFieldCell *)cell textFieldDidEditingChanged:(UITextField *)textField;
{
    if ((cell.indexPath.row==1)&&(textField.text.length>=11)) {
        cell.textField.text = [cell.textField.text substringToIndex:11];
    }
    
    switch (cell.indexPath.row) {
        case 0:
        {
            nameStr = textField.text;
        }
            break;
        case 1:
        {
            phoneStr = textField.text;
        }
            break;
        case 2:
        {
            subjectStr = textField.text;
        }
            break;
        default:
            break;
    }
}

- (void)ImgTextFieldCell:(ImgTextFieldCell *)cell textFieldDidEndEditing:(UITextField *)textField;
{
    [self ImgTextFieldCell:cell textFieldDidEditingChanged:textField];
}

#pragma mark - LLPopoverViewDelegate 

- (void)LLPopoverView:(LLPopoverView *)view didSelectItemAtIndex:(NSInteger)index;
{
    ImgTextFieldCell *imgTextCell = [self.bg_TableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    imgTextCell.textField.text = view.ItemTitleArr[index];
    subjectStr = view.ItemTitleArr[index];
}

- (void)popoverViewWillDismiss:(LLPopoverView *)view;
{
    ImgTextFieldCell *imgTextCell = [self.bg_TableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    imgTextCell.accessoryBtn.selected = NO;
}

#pragma mark - Overwrite

- (void)clickRightBtn:(UIButton *)rightBtn
{
    //保存
    //添加学员
    [self.view endEditing:YES];
    
    [self addNewStudentRequest];
}

#pragma mark - Network

- (void)addNewStudentRequest
{
    NSString *promptStr = nil;
    if (isEmptyStr(nameStr))
    {
        promptStr = @"请输入学员姓名";
    }
    else if (isEmptyStr(phoneStr)) {
        //电话为空
        promptStr = @"请输入学员电话号码";
    }
    else if(isEmptyStr(subjectStr) || [subjectStr isEqualToString:@"选择学员所学科目"])
    {
        promptStr = @"请选择或输入学员科目";
    }
//    else if (![phoneStr isTelephone]) {
//        promptStr = @"请输入正确格式的手机号码";
//    }
    
    if (promptStr) {
        [LLUtils showErrorHudWithStatus:promptStr];
        return;
    }
    
    NSInteger subjectInt = 0;
    if ([subjectStr rangeOfString:@"科目一"].location != NSNotFound) {
        subjectInt = 1;
    }
    else if ([subjectStr rangeOfString:@"科目二"].location != NSNotFound)
    {
        subjectInt = 2;
    }
    else if ([subjectStr rangeOfString:@"科目三"].location != NSNotFound)
    {
        subjectInt = 3;
    }
    else if ([subjectStr rangeOfString:@"科目四"].location != NSNotFound)
    {
        subjectInt = 4;
    }
    else
    {
        subjectInt = 1; //默认
    }
    
    if (_type == EditInfoVCTypeEdit) {
        //编辑学员信息
        [NetworkEngine sendAsynPostRequestRelativeAdd:@"/myStudent/config" paraNameArr:@[@"uid",@"time",@"phone",@"sign",@"sName",@"subjectId"] paraValueArr:@[kUid,kTimeStamp,phoneStr,kSignWithIdentify(@"/myStudent/config"),nameStr,[NSString stringWithFormat:@"%ld",subjectInt]] completeBlock:^(BOOL isSuccess, id jsonObj) {
            if (isSuccess) {
                
                if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                    //请求成功
                    [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
                    [self.navigationController popViewControllerAnimated:YES];
                    if (_successBlock) {
                        _successBlock(nameStr,phoneStr,[NSString stringWithFormat:@"%ld",subjectInt]);
                    }
                }
                else if([jsonObj[@"code"] isEqualToNumber:@(2)])
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
    else
    {
        //添加新学员
        NSString *jsonStr = [LLUtils jsonStrWithJSONObject:@[@[isEmptyStr(phoneStr)?@"":phoneStr
                                                               ,isEmptyStr(nameStr)?@"":nameStr
                                                               ,[NSString stringWithFormat:@"%ld",subjectInt]
                                                               ]]];
        [NetworkEngine sendAsynPostRequestRelativeAdd:@"/myStudent/create" paraNameArr:@[@"uid",@"time",@"student",@"sign"] paraValueArr:@[kUid,kTimeStamp,jsonStr,kSignWithIdentify(@"/myStudent/create")] completeBlock:^(BOOL isSuccess, id jsonObj) {
            if (isSuccess) {
                if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                    //请求成功
                    nameStr = @"";
                    subjectStr = @"";
                    phoneStr = @"";
                    [self.bg_TableView reloadData];
                    [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
                }
                else if([jsonObj[@"code"] isEqualToNumber:@(2)])
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
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10) {
        [self showLoginRegisterWithLoginSuccessBlock:nil];
    }
}

@end
