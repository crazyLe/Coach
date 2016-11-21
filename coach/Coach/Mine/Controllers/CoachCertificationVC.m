//
//  CoachCertificationVC.m
//  Coach
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "CoachCertificationVC.h"
#import "MCoachFirstCell.h"
#import "MCoachSecondCell.h"
#import "MCoachThirdCell.h"

#import "AFHTTPSessionManager.h"

@interface CoachCertificationVC ()<UITableViewDelegate,UITableViewDataSource,MCoachThirdCellDelegate,UIActionSheetDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MCoachSecondCellDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UITableView * coachTable;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic, strong)UIButton * picIdBtn;

@property (nonatomic, strong)UIButton * picCoachBtn;

@end

@implementation CoachCertificationVC
{
    BOOL isChangedImage[2];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initWithUI
{
    [super initWithUI];
    self.title = @"重新认证";
    self.view.backgroundColor = rgb(236, 236, 236);
    
    _coachTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _coachTable.delegate = self;
    _coachTable.dataSource = self;
    _coachTable.showsVerticalScrollIndicator = NO;
    _coachTable.backgroundColor = rgb(236, 236, 236);
    _coachTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_coachTable];
    
    UIView * downView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 235)];
//    downView.backgroundColor = [UIColor orangeColor];
    _coachTable.tableFooterView = downView;
    
    UIView * grayView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 122)];
    grayView.backgroundColor = rgb(236, 236, 236);
    [downView addSubview:grayView];
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(46, 37, kScreenWidth-46*2, 44);
    submitBtn.backgroundColor = [UIColor colorWithHexString:@"#2e83ff"];
    submitBtn.layer.cornerRadius = 22.0;
    [submitBtn setTitle:@"提交认证" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(pressSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:submitBtn];
    
    UIView * remindView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(grayView.frame), kScreenWidth, 112)];
    remindView.backgroundColor = [UIColor whiteColor];
    [downView addSubview:remindView];
    
    UILabel * remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 14, 80, 14)];
    remindLabel.text = @"认证须知:";
    remindLabel.textColor = rgb(135, 135, 135);
    remindLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
//    remindLabel.backgroundColor = [UIColor blueColor];
    [remindView addSubview:remindLabel];
    
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(remindLabel.frame)+12, kScreenWidth, 1)];
    lineLabel.backgroundColor = rgb(236, 237, 236);
    [remindView addSubview:lineLabel];
    
    NSArray * arr = @[@"认证提交必须真实有效",@"提交成功后将会在1个工作日内审核"];
    for (int i=0; i<2; i++) {
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(18, CGRectGetMaxY(lineLabel.frame)+15+18*i, 7, 7)];
        imageV.backgroundColor = rgb(135, 135, 135);
        imageV.layer.cornerRadius = 4.0;
        imageV.layer.masksToBounds = YES;
        [remindView addSubview:imageV];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+8, CGRectGetMaxY(lineLabel.frame)+11+19*i, kScreenWidth-34, 15)];
//        label.backgroundColor = [UIColor magentaColor];
        label.text = arr[i];
        label.textColor = rgb(82, 82, 82);
        label.font = Font14;
        [remindView addSubview:label];
    }
    
}

- (void)initWithData
{
    [super initWithData];
//    NSData *_decodedImageData   = [[NSData alloc]initWithBase64Encoding:_coachModel.coachPic];
//    UIImage *_decodedImage  = [UIImage imageWithData:_decodedImageData];
//    _coachModel.coachImage = _decodedImage;
}

- (void)pressSubmitBtn:(UIButton *)sender
{
//    NSLog(@"提交认证");
    if ([_coachModel.trueName isEqualToString:@""] || _coachModel.trueName == nil) {
        [self.hudManager showErrorSVHudWithTitle:@"请填写真实姓名" hideAfterDelay:1.0];
        return;
    }
    if ([_coachModel.IDNum isEqualToString:@""] || _coachModel.IDNum == nil) {
        [self.hudManager showErrorSVHudWithTitle:@"请填写身份证号码" hideAfterDelay:1.0];
        return;
    }
    if (_coachModel.idImage == nil) {
        [self.hudManager showErrorSVHudWithTitle:@"请选择身份证照片" hideAfterDelay:1.0];
        return;
    }
    if (_coachModel.coachPic == nil) {
        [self.hudManager showErrorSVHudWithTitle:@"请选择教练资格证照片" hideAfterDelay:1.0];
        return;
    }
    
    
    [self.hudManager showNormalStateSVHUDWithTitle:@"正在提交..."];
    NSString * url = [NSString stringWithFormat:@"%@%@",HOST_ADDR,@"/userAuth/add"];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = kTimeStamp;
    param[@"sign"] = kSignWithIdentify(@"/userAuth/add");
    param[@"trueName"] = _coachModel.trueName;
    param[@"IDNum"] = _coachModel.IDNum;
    param[@"coachNum"] = _coachModel.coachNum;
    NSData *data1 = UIImageJPEGRepresentation(_coachModel.idImage, 0.5);
//    NSData * data2 = UIImageJPEGRepresentation(_coachModel.coachImage, 0.5);
    NSData * data2 = nil;
    if (isChangedImage[1]) {
        data2 = UIImageJPEGRepresentation(_coachModel.coachImage, 0.5);
    }else{
        data2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:_coachModel.coachPic]];
    }
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPSessionManager *session =  [AFHTTPSessionManager manager];
    session.requestSerializer.timeoutInterval = 30;
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    [session POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data1 name:@"IDPic" fileName:@"IDPic.png" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:data2 name:@"coachPic" fileName:@"coachPic.png" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.hudManager dismissSVHud];
//        NSLog(@"~%@~",responseObject);
        NSLog(@"~%@~",responseObject[@"msg"]);
        if ([responseObject[@"code"] integerValue] == 1) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提交成功" message:@"我们会在1个工作日内审核认证,请留意系统消息。" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            [self.hudManager showErrorSVHudWithTitle:responseObject[@"msg"] hideAfterDelay:1.0f];
        }
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.hudManager showErrorSVHudWithTitle:@"保存失败" hideAfterDelay:1.0f];
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.refresh(@"new");
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        return 85;
//    }else if(indexPath.section == 1){
//        return 48;
//    }else if (indexPath.section == 2  || indexPath.section == 3){
//        return 223;
//    }
//    return 0;
    if (indexPath.row == 0) {
        return 105;
    }else if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3){
        return 48;
    }else{
        return 233;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
////    return 4;
//    return 5;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString * string = @"cellone";
        MCoachFirstCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MCoachFirstCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.phoneLabel.text = kPhone;
        cell.nameLabel.text = _coachModel.trueName;
        [cell.avatorImageView sd_setImageWithURL:[NSURL URLWithString:kFace] placeholderImage:[UIImage imageNamed:@"MCoach_Avator"]];
        if (_coachModel.state == nil || [_coachModel.state isEqualToString:@"-1"] || [_coachModel.state isEqualToString:@"2"]) {
            cell.idImageV.image = [UIImage imageNamed:@"MCoach_grayImage"];
        }else if([_coachModel.state isEqualToString:@"0"]){
            cell.idImageV.image = [UIImage imageNamed:@"MCoach_review"];
        }else{
            cell.idImageV.image = [UIImage imageNamed:@"MCoach_markImage"];
        }
        return cell;
    }else if (indexPath.row == 1){
        
        static NSString * string = @"celltwo";
        MCoachSecondCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MCoachSecondCell" owner:self options:nil]lastObject];
        }
        cell.nameLabel.text = @"真实姓名";
        cell.contentTF.text =  _coachModel.trueName;
        cell.contentTF.keyboardType = UIKeyboardTypeDefault;
        cell.contentTF.borderStyle = UITextBorderStyleNone;
        
        cell.index = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
        
    }else if (indexPath.row == 2){
        
        static NSString * string = @"celltwo";
        MCoachSecondCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MCoachSecondCell" owner:self options:nil]lastObject];
        }
        cell.nameLabel.text = @"身份证号";
        cell.contentTF.borderStyle = UITextBorderStyleNone;
        cell.contentTF.keyboardType = UIKeyboardTypeASCIICapable;
        cell.contentTF.text = _coachModel.IDNum;
        cell.index = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }else if (indexPath.row == 3){
        static NSString * string = @"cellThree";
        MCoachSecondCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MCoachSecondCell" owner:self options:nil]lastObject];
        }
        cell.nameLabel.text = @"资格证编号";
        cell.contentTF.keyboardType = UIKeyboardTypeNumberPad;
        cell.contentTF.borderStyle = UITextBorderStyleNone;
        cell.contentTF.text = _coachModel.coachNum;
        cell.index = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }else if (indexPath.row == 4){
        
        static NSString * string = @"cellthree";
        MCoachThirdCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MCoachThirdCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameLabel.text = @"手持身份证照片";
        cell.delegate = self;
        cell.index = indexPath.row;
        if (isChangedImage[0]) {
            [cell.uploadBtn setImage:_coachModel.idImage forState:UIControlStateNormal];
        }
        else
        {
//            [cell.uploadBtn sd_setImageWithURL:[NSURL URLWithString:_coachModel.IDPic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"MCoach_click"]];
            [cell.uploadBtn setImage:[UIImage imageNamed:@"MCoach_click"] forState:UIControlStateNormal];
        }
        
        return cell;
        
    }else if (indexPath.row == 5){
        static NSString * string = @"cellthree";
        MCoachThirdCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MCoachThirdCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameLabel.text = @"教练资格证照照片";
        cell.delegate = self;
        cell.index = indexPath.row;
        if (isChangedImage[1]) {
            [cell.uploadBtn setImage:_coachModel.coachImage forState:UIControlStateNormal];
        }
        else
        {
           [cell.uploadBtn sd_setImageWithURL:[NSURL URLWithString:_coachModel.coachPic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"MCoach_click"]];
        }
        
        return cell;
    }
    return nil;
}

#pragma mark ---MCoachSecondCellDelegate
- (void)MCoachSecondCellContentTF:(UITextField *)contentTF withIndex:(NSInteger)index
{
    switch (index) {
        case 1:
        {
            _coachModel.trueName = contentTF.text;
        }
            break;
        case 2:
        {
            _coachModel.IDNum = contentTF.text;
        }
            break;
        case 3:
        {
            _coachModel.coachNum = contentTF.text;
            
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -- MCoachThirdCellDelegate
- (void)clickMCoachThirdCellDelegateUploadBtn:(UIButton *)uploadBtn WithIndex:(NSInteger)index
{
    switch (index) {
        case 4:
        {
            NSLog(@"手持身份证cell");
            _index = index;
            _picIdBtn = uploadBtn;
            __unsafe_unretained typeof(self) mineself = self;
            UIActionSheet * sheet;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"本机相册", nil];
                //            sheet.tag = 101;
            }else{
                sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本机相册", nil];
            }
            [sheet showInView:mineself.view];
        }
            break;
        case 5:
        {
            NSLog(@"教练资格证照照片cell");
            _index = index;
            _picCoachBtn = uploadBtn;
            __unsafe_unretained typeof(self) mineself = self;
            UIActionSheet * sheet;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"本机相册", nil];
                //            sheet.tag = 101;
            }else{
                sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本机相册", nil];
            }
            [sheet showInView:mineself.view];
        }
            break;
        default:
            break;
    }
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = 0;
    //    if (actionSheet.tag == 101) {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
                
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
                
            case 2:
                return;
                
            default:
                break;
        }
        
    }else{
        if (buttonIndex == 0) {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }else{
            return;
        }
    }
    //    }
    UIImagePickerController * imagePic = [[UIImagePickerController alloc]init];
    imagePic.delegate = self;
    imagePic.allowsEditing = YES;
    imagePic.sourceType = sourceType;
    [self presentViewController:imagePic animated:YES completion:nil];
    

    
}

#pragma mark - 更改头像
//上传头像
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //相册图片点击后调用该方法
    //获取点击图片
    UIImage * img = [info objectForKey:UIImagePickerControllerEditedImage];
    isChangedImage[_index-4] = YES;
    switch (_index) {
        case 4:
        {
            [_picIdBtn setImage:img forState:UIControlStateNormal];
//            NSData *data = UIImageJPEGRepresentation(img, 1.0f);
//            NSString *encodedImageStr = [NSString stringWithFormat:@"%@",data];
//            _coachModel.idPic = encodedImageStr;
            _coachModel.idImage = img;
        }
            break;
        case 5:
        {
            [_picCoachBtn setImage:img forState:UIControlStateNormal];
//            NSData *data = UIImageJPEGRepresentation(img, 1.0f);
//            NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//            _coachModel.coachPic = encodedImageStr;
             _coachModel.coachImage = img;
        }
            break;
        default:
            break;
    }
    //将图片显示在头像按钮上
//    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    //    img = [self cutCenterImage:img size:CGSizeMake(720, 720)];
//    
//    float ratio = 0.1;
//    NSData * imageData = UIImageJPEGRepresentation(img, ratio);//JPGg格式
    
//    _avatorDataString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//    
//    EditFirstTableCell * cell = [_editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//    cell.avatorImageView.image = img;
//    _coachModel.face = _avatorDataString;
    //    [_avatorImageV sd_setImageWithURL:[NSURL URLWithString:_avatorDataString] placeholderImage:[UIImage imageNamed:@"card_avatorImage.png"]];
    //    [_editTableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
