//
//  PersonSettingVC.m
//  Coach
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "AccountSecurityVC.h"
#import "MMPickerView.h"
#import <EXPhotoViewer.h>
#import "LLInputCell.h"
#import "LLPersonSettingCell.h"
#import "PersonSettingVC.h"

@interface PersonSettingVC () <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation PersonSettingVC
{
    NSArray *LeftLblTextArr;
    NSMutableArray *rightLblTextArr;
    
    NSDictionary *infoDic;
    
    NSString *nickNameStr;
    NSString *addressStr;
    NSString *phoneStr;
    NSString *ageStr;
    NSString *sexStr;
    NSString *introduceStr;
}

- (id)init
{
    if (self = [super init]) {
        LeftLblTextArr = @[@"昵称",@"头像",@"地址",@"手机号",@"年龄",@"性别"];
//        rightLblTextArr = @[@"张小开",@"",@"安徽省  合肥市  瑶海区",@"13956076188",@"25",@"男"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self setNavigation];
    [self setUI];
    [self requestDataWithIsUpdateUI:YES];
}

#pragma mark - Setup

- (void)setNavigation
{
    [self setTitleText: @"个人设置" textColor:nil];
    [self setLeftText:nil textColor:nil ImgPath:@"Navigation_Return"];
    [self setRightText:@"保存" textColor:nil ImgPath:nil];
}

- (void)setUI
{
    [self setBg_TableViewWithConstraints:nil];
    [self registerClassWithClassNameArr:@[@"LLPersonSettingCell",@"LLInputCell"] cellIdentifier:nil];
    self.bg_TableView.sectionHeaderHeight = 15.0f;
}

- (void)commonInit
{
    rightLblTextArr = [@[isEmptyStr(infoDic[@"nickName"])?@"":infoDic[@"nickName"]
                         ,@""
                         ,isEmptyStr(infoDic[@"address"])?@"":infoDic[@"address"]
                         ,isEmptyStr(infoDic[@"phone"])?@"":infoDic[@"phone"]
                         ,isNull(infoDic[@"age"])?@"":infoDic[@"age"]
                         ,isNull(infoDic[@"sex"])?@"":[infoDic[@"sex"] intValue]==0?@"女":@"男"
                         ,isEmptyStr(infoDic[@"introduce"])?@"":infoDic[@"introduce"]
                         ] mutableCopy];
}

#pragma mark - UITableViewDelegate && UITableViewDateSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 6;
    }
    else
    {
        return 1;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 50.0f;
    }
    else
    {
        return 110.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        LLPersonSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLPersonSettingCell"];
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.leftLbl.text = LeftLblTextArr[indexPath.row];
        cell.rightTF.text = numToStr(rightLblTextArr[indexPath.row]);
        cell.accessoryImgView.image = [UIImage imageNamed:@"iconfont-jiantou"];
        if (indexPath.row == 1)
        {
//            [cell.headBtn setImage:[UIImage imageNamed:@"iconfont-touxiang(1)"] forState:UIControlStateNormal];
            [cell.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:isEmptyStr(infoDic[@"face"])?@"":infoDic[@"face"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"iconfont-defaultheadimage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error) {
                    [cell.headBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-defaultheadimage"] forState:UIControlStateNormal];
                }
            }];
            cell.rightTF.userInteractionEnabled = NO;
            cell.headBtn.userInteractionEnabled = NO;
            cell.rightTF.text = @"";
        }
        else
        {
            cell.rightTF.userInteractionEnabled = YES;
            cell.headBtn.userInteractionEnabled = NO;
        }
        
        if (indexPath.row==5||indexPath.row==3) {
            //性别 , 手机号
            cell.rightTF.userInteractionEnabled = NO;
        }
        
        if (indexPath.row==4) {
            cell.rightTF.keyboardType = UIKeyboardTypeNumberPad;
        }
       
        cell.lineView.hidden = indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1;
        return cell;
    }
    else
    {
        LLInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLInputCell"];
        cell.textView.placeholder = @"自我介绍";
        cell.textView.text = [rightLblTextArr lastObject];
        cell.maxInputNum = 120;
        cell.delegate = self;
        [cell refreshPromptLbl];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        actionSheet.tag = 1000;
        [actionSheet showInView:self.view];
    }
    else if (indexPath.row==5)
    {
        //选择性别
        
        NSArray *arr = @[@"男",@"女"];
        
        LLPersonSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [MMPickerView showPickerViewInView:self.view
                               withStrings:arr
                               withOptions:@{MMbackgroundColor: [UIColor whiteColor],
                                             MMtextColor: [UIColor blackColor],
                                             MMtoolbarColor: [UIColor whiteColor],
                                             MMbuttonColor: [UIColor blueColor],
                                             MMfont: [UIFont systemFontOfSize:18],
                                             MMvalueY: @3,
                                             MMselectedObject:isEmptyStr(cell.rightTF.text)?arr[0]:cell.rightTF.text,
                                             }
                                completion:^(NSString *selectedString) {
                                    //                                    NSLog(@"selectStr==>%@",selectedString);
//                                    rightTextArr[indexPath.row] = selectedString;
//                                    cell.textField.text = selectedString;
                                    rightLblTextArr[indexPath.row]=selectedString;
                                    [tableView reloadRow:5 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
                                }];
    }
    else if ((indexPath.section==0)&&(indexPath.row==3))
    {
        //账号安全
        AccountSecurityVC * vc = [[AccountSecurityVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - Overwrite

- (void)clickRightBtn:(UIButton *)rightBtn
{
    [self.view endEditing:YES];
    //保存
    [self changePersonSettingRequest];
}

#pragma mark - LLPersonSettingCellDelegate 

- (void)LLPersonSettingCell:(LLPersonSettingCell *)cell textFieldDidChange:(UITextField *)textField;
{
//    switch (cell.indexPath.row) {
//        case 0:
//        {
//            nickNameStr = textField.text;
//        }
//            break;
//        case 2:
//        {
//            addressStr = textField.text;
//        }
//            break;
//        case 3:
//        {
//            phoneStr = textField.text;
//        }
//            break;
//        case 4:
//        {
//            ageStr = textField.text;
//        }
//            break;
//        case 5:
//        {
//            sexStr = textField.text;
//        }
//            break;
//            
//        default:
//            break;
//    }
    rightLblTextArr[cell.indexPath.row] = textField.text;
}

- (void)LLPersonSettingCell:(LLPersonSettingCell *)cell clickHeadBtn:(UIButton *)headBtn;
{
    UIImageView *aImgView = [[UIImageView alloc] init];
    [self.view addSubview:aImgView];
    [EXPhotoViewer showImageFrom:headBtn.imageView];
}

#pragma mark - LLInputCellDelegate

- (void)LLInputCell:(LLInputCell *)cell textViewDidChange:(UITextView *)textView;
{
//    introduceStr = textView.text;
    rightLblTextArr[6] = textView.text;
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
    [self updateHeadRequestWithImage:editedImage];
}

#pragma mark - Network

//获取个人设置请求
- (void)requestDataWithIsUpdateUI:(BOOL)isUpdateUI
{
    [NetworkEngine sendAsynPostRequestRelativeAdd:@"/member/info" paraNameArr:@[@"uid",@"time",@"deviceInfo",@"sign"] paraValueArr:@[kUid,kTimeStamp,kDeviceInfo,kSignWithIdentify(@"/member/info")] completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                infoDic = jsonObj[@"info"];
                if (isUpdateUI) {
                    [self updateUI];
                }
                else
                {
                    [self.bg_TableView reloadData];
                }
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

//修改个人设置请求
- (void)changePersonSettingRequest
{
    NSMutableDictionary *paraDic = [@{@"uid":kUid,@"time":kTimeStamp,@"sign":kSignWithIdentify(@"/member/update")} mutableCopy];
    if (!isEmptyStr(rightLblTextArr[0])) {
        [paraDic setObject:rightLblTextArr[0] forKey:@"nickName"];
    }
    if (!isEmptyStr(rightLblTextArr[2])) {
        [paraDic setObject:rightLblTextArr[2] forKey:@"address"];
    }
    if (!isEmptyStr(numToStr(rightLblTextArr[4]))) {
        [paraDic setObject:rightLblTextArr[4] forKey:@"age"];
    }
    if (!isEmptyStr(rightLblTextArr[5])) {
        [paraDic setObject:[rightLblTextArr[5] rangeOfString:@"男"].location != NSNotFound ?@"1":@"0" forKey:@"sex"];
    }
    if (!isEmptyStr(rightLblTextArr[6])) {
        [paraDic setObject:rightLblTextArr[6] forKey:@"introduce"];
    }
    [NetworkEngine postRequestWithRelativeAdd:@"/member/update" paraDic:paraDic completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
//                infoDic = jsonObj[@"info"];
//                [self updateUI];
                [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
                if (self.settingSuccessBlock) {
                    self.settingSuccessBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
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

//刷新UI
- (void)updateUI
{
    rightLblTextArr = [@[isEmptyStr(infoDic[@"nickName"])?@"":infoDic[@"nickName"]
                        ,@""
                        ,isEmptyStr(infoDic[@"address"])?@"":infoDic[@"address"]
                        ,isEmptyStr(infoDic[@"phone"])?@"":infoDic[@"phone"]
                        ,isNull(infoDic[@"age"])?@"":infoDic[@"age"]
                        ,isNull(infoDic[@"sex"])?@"":[infoDic[@"sex"] intValue]==0?@"女":@"男"
                        ,isEmptyStr(infoDic[@"introduce"])?@"":infoDic[@"introduce"]
                        ] mutableCopy];
    [self.bg_TableView reloadData];
}

- (void)updateHeadRequestWithImage:(UIImage *)image
{
    NSData *imageData = [LLUtils dataWithImage:image];
    if (isNull(imageData)) {
        return;
    }
    [LLUtils showTextAndProgressHud:@"上传头像中..."];
    NSDictionary *paraDic = @{@"uid":kUid,@"time":kTimeStamp,@"sign":kSignWithIdentify(@"/userPics"),@"deviceInfo":kDeviceInfo};
    [NetworkEngine UploadFileWithRelativeAdd:@"/userPics" param:paraDic serviceName:@"pics" fileName:@"0.png" mimeType:@"image/jpeg" fileData:imageData finish:^(NSData *data) {
        NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (isEqualValue(jsonObj[@"code"], 1)) {
            //成功
            [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
            [self requestDataWithIsUpdateUI:NO]; //重新获取服务器数据
            if (self.settingSuccessBlock) {
                self.settingSuccessBlock();
            }
        }
        else
        {
            //失败
            [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
        }
    } failed:^(NSError *error) {
        NSLog(@"error-==>error");
        [LLUtils dismiss];
    }];
}

@end
