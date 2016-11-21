//
//  BusinessCardController.m
//  Coach
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLWebViewController.h"
#import <IQKeyboardManager.h>
#import "AccountSecurityVC.h"
#import "MMPickerView.h"
#import "EditCollectionCell.h"
#import "LLAddress.h"
#import "GroundMapController.h"
#import "WMPPopView.h"
#import "BusinessCardController.h"
#import "EditTableViewCell.h"
#import "EditSecondTableCell.h"
#import "EditThirdTableCell.h"
#import "EditFourthTableCell.h"
#import "EditFifthTableCell.h"
#import "UIPlaceHolderTextView.h"

#import "CardCoachModel.h"
#import "CardClassesModel.h"
#import "CardTgaModel.h"
#import "EditFirstTableCell.h"
#import "EditSecondDetailCell.h"
#import "EditThirdDetailCell.h"

#import "DrivingTypeCell.h"
#import "ProvinceModel.h"

@interface BusinessCardController ()<UITableViewDelegate,UITableViewDataSource,EditFifthTableCellDlegate,EditThirdTableCellDelegate,EditTableViewCellDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,EditFirstTableCellDelegate,UITextViewDelegate,UITextFieldDelegate,WMPPopViewDelegate>
{
    NSMutableArray * _messageDataArr;
    NSMutableArray * _imageDataArr;
    NSMutableArray * _dataArr;
    
    NSDictionary * _schoolDic;
    UIView * backView;
    BOOL _isAllowPop;
}
@property (nonatomic ,strong)UITableView * editTableView;

@property (nonatomic, strong) UIButton *grayBackBtn;

@property (nonatomic, strong)CardCoachModel * coachModel;
@property (nonatomic, strong)CardClassesModel * classesModel;
@property (nonatomic, strong)CardTgaModel * tgaModel;

@property (nonatomic, strong)NSMutableArray * classesDataArray;
@property (nonatomic, strong)NSMutableArray * tgaDataArray;

@property (nonatomic, strong)NSMutableArray * canSelectTagArr;

@property (nonatomic, copy) NSString * avatorDataString;
@property (nonatomic, strong) UIImageView * avatorImageV;

@end

@implementation BusinessCardController
{
    cityModel *_cityModel;
    CLLocationCoordinate2D _locationCoordinate;
    
    NSMutableArray *bottomUploadImgArr;
    UIImageView *clickedImgView;
    UIActionSheet *currentActionSheet;
    
    NSString *customTagStr;
    
    UIImage *faceImg;
    
}

- (id)init
{
    if (self = [super init]) {
        bottomUploadImgArr = [@[[UIImage imageNamed:@"MCoach_click"],[UIImage imageNamed:@"MCoach_click"],[UIImage imageNamed:@"MCoach_click"]] mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initWithUI
{
//    [super initWithUI];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 10, 70, 20);
    //    backBtn.backgroundColor = [UIColor redColor];
    [backBtn setImage:[UIImage imageNamed:@"NavigationBar_Return"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pressBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"编辑微名片";
    _isAllowPop = YES;
    [self createUI];
    //添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)initWithData
{
    [super initWithData];
    _messageDataArr = [[NSMutableArray alloc]initWithObjects:@"真实姓名",@"头像",@"性别",@"手机号",@"所属驾校",@"年龄",@"驾龄",@"教龄",@"已毕业学员",@"平均拿证时间",@"科目二通过率",@"科目三通过率", nil];
    _imageDataArr = [[NSMutableArray alloc]initWithObjects:@"card_name",@"card_avator",@"card_male",@"card_MobilePhone",@"card_BeenDriving",@"card_steeringWheel",@"card_schoolingAge",@"card_students",@"card_time",@"card_secondSub",@"card_ThirdSub",nil];
    _dataArr = [[NSMutableArray alloc]initWithObjects:@"张三",@"",@"男",@"1333456789",@"请选择",@"35岁",@"10年",@"5年",@"300人",@"60天",@"85%",@"90%", nil];
    
    _classesDataArray = [NSMutableArray array];
    _tgaDataArray = [NSMutableArray array];
    _canSelectTagArr = [NSMutableArray array];
    [self requestWithData];
}

- (void)pressBackBtn
{
    if (_isAllowPop == YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(_isAllowPop == NO){
        
    }
    
}

- (void)createUI
{
    _editTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _editTableView.delegate = self;
    _editTableView.dataSource = self;
    _editTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _editTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_editTableView];
    
}

- (void)requestWithData
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"deviceInfo"] = kDeviceInfo;
    param[@"time"] = kTimeStamp;
    param[@"sign"] = kSignWithIdentify(@"/card/retrieve");
    
    [NetworkEngine postRequestWithRelativeAdd:@"/card/retrieve" paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                NSString * jstr = [LLUtils jsonStrWithJSONObject:jsonObj];
                NSString * str = [LLUtils replaceUnicode:jstr];
                
                NSLog(@"%@",str);
                
                self.coachModel = [CardCoachModel mj_objectWithKeyValues:jsonObj[@"info"][@"coach"]];
                
                _cityModel = [[cityModel alloc] init];
                
                _cityModel.cityId = self.coachModel.cityId;
                
                self.classesDataArray = [CardClassesModel mj_objectArrayWithKeyValuesArray:jsonObj[@"info"][@"classes"]];
                
                //所属驾校
                _schoolDic = jsonObj[@"info"][@"school"];
                for (NSDictionary * dic in _schoolDic[@"list"]) {
                    if ([dic[@"id"] isEqualToString:_schoolDic[@"selected"]]) {
                        _coachModel.selectedSchool = dic[@"name_other"];
                    }
                }
                
                for (CardClassesModel *classModel in self.classesDataArray) {
                    classModel.classCarId = [classModel.classCar isEqualToString:@"C1"]?@"1":[classModel.classCar isEqualToString:@"C2"]?@"2":@"";
                    classModel.classDateId = [classModel.classDate isEqualToString:@"周一至周五"]?@"12":[classModel.classDate isEqualToString:@"晚上"]?@"2":[classModel.classDate isEqualToString:@"周六至周日"]?@"3":[classModel.classDate isEqualToString:@"周一至周日"]?@"4":@"";
                }
                
//                self.tgaDataArray = [CardTgaModel mj_objectArrayWithKeyValuesArray:jsonObj[@"info"][@"tga"]];
                NSArray *tgaArr = [CardTgaModel mj_objectArrayWithKeyValuesArray:jsonObj[@"info"][@"tga"]];
                for (CardTgaModel *model in tgaArr) {
                    if ([model.state isEqualToString:@"1"]) {
                        //已选
                        [_tgaDataArray addObject:model];
                    }
                    else
                    {
                        //可选
                        [_canSelectTagArr addObject:model];
                    }
                }
                
                bottomUploadImgArr = [@[_coachModel.userPic1,_coachModel.userPic2,_coachModel.userPic3] mutableCopy];
                
                [_editTableView reloadData];
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

#pragma mark -- EditThirdTableCellDelegate
- (void)tapEditThirdTableCellContent
{
//    NSLog(@"点击了第三个cell");
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIButton *grayBackBtn = [[UIButton alloc] init];
    grayBackBtn.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    grayBackBtn.backgroundColor = [UIColor colorWithRed:25/255.0 green: 25/255.0 blue:25/255.0 alpha:0.5];
    //    clearBtn.backgroundColor = [UIColor brownColor];
    [window addSubview:grayBackBtn];
    [grayBackBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.grayBackBtn = grayBackBtn;
    
    backView = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth-291)/2, (kScreenHeight-400)/2, 291, 400)];
//    UIScrollView * backView = [[UIScrollView alloc]initWithFrame:CGRectMake((kScreenWidth-291)/2, (kScreenHeight-400)/2, 291, 400)];
    backView.layer.cornerRadius = 5.0;
    backView.backgroundColor = [UIColor whiteColor];
    [grayBackBtn addSubview:backView];
    backView.tag = 200;
    
    UILabel * chooseLabel = [[UILabel alloc]initWithFrame:CGRectMake((backView.frame.size.width-40)/2, 15, 40, 16)];
//    chooseLabel.backgroundColor = [UIColor orangeColor];
    chooseLabel.text = @"选择";
    chooseLabel.textColor = rgb(35, 105, 255);
    chooseLabel.font = Font18;
    [backView addSubview:chooseLabel];
    
    UIButton * cancelBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(backView.frame.size.width-15-16, 15, 16, 16);
//    cancelBtn.backgroundColor = [UIColor redColor];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"card_cancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:cancelBtn];
    
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(chooseLabel.frame)+14, backView.frame.size.width, 1)];
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"#b7d6ff"];
    [backView addSubview:lineLabel];
    
    EditThirdTableCell * cell = [EditThirdTableCell cellWithTableView:_editTableView IDstr:@"AddNewTag"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.messageLabel.hidden = YES;
    //        cell.iconView.image = [UIImage imageNamed:@"card_label"];
    cell.contentLabel.hidden = YES;
    cell.iconView.hidden = YES;
    cell.accessoryImageView.hidden = YES;
    cell.dataArray = _canSelectTagArr;
    cell.editCollectionView.scrollEnabled = YES;
    cell.lineLab.hidden = YES;
    cell.topLineLabel.hidden = YES;
    cell.isCanSelect = YES;
    cell.tag = 2016;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) cell.editCollectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake((291-40)/3, 49);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
//    layout.minimumLineSpacing = 10;
//    layout.minimumInteritemSpacing = 10;
    [backView addSubview:cell];
    
    UIPlaceHolderTextView * textView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(16, 266, 259, 60)];
    textView.placeholder = @"没有合适的词汇，自定义输入";
    textView.layer.borderWidth = 1.0;
    textView.layer.cornerRadius = 3.0f;
    textView.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    textView.font = [UIFont systemFontOfSize:13];
    [backView addSubview:textView];
    textView.delegate = self;
    
    UIButton * ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ensureBtn.frame = CGRectMake((backView.frame.size.width-105)/2, 17+CGRectGetMaxY(textView.frame), 105, 38);
    ensureBtn.layer.cornerRadius = 19.0;
    ensureBtn.titleLabel.font = Font15;
    ensureBtn.backgroundColor = [UIColor colorWithHexString:@"2e83ff"];
    [ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [ensureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ensureBtn addTarget:self action:@selector(pressEnsureBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:ensureBtn];
    

    [cell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel.mas_bottom).offset(10);
        make.bottom.equalTo(textView.mas_top).offset(-10);
        make.left.offset(10);
        make.right.offset(-10);
//        make.left.offset(0);
//        make.right.offset(0);
    }];
    
    [cell.editCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [LLUtils showSpringBackAnimationView:backView];  //回弹动画弹出
    grayBackBtn.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        grayBackBtn.alpha = 1;
    }];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView;
{
    customTagStr = textView.text;
}

- (void)cancelBtnClick
{
//    [self.grayBackBtn removeFromSuperview];
    
    customTagStr = @""; //清空之前输入的自定义标签
    
    UIView *backView = [self.grayBackBtn viewWithTag:200];
    
    [LLUtils showDismissAnimationWithAlphaView:self.grayBackBtn scaleView:backView didDismissBlock:nil];
}

- (void)pressBtn:(UIButton *)sender
{
    UIButton * btn = sender;
    sender.selected =! sender.selected;
    if (sender.selected == NO) {
        [btn setBackgroundColor:[UIColor colorWithHexString:@"d4d4d4"]];
        NSLog(@"未点");
    }else if (sender.selected == YES){
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#55b0fe"]];
        NSLog(@"点了");
    }
   
}

//点击弹框出来确定按钮
- (void)pressEnsureBtn:(UIButton *)btn
{
    EditThirdTableCell * cell = [btn.superview viewWithTag:2016];
    [_tgaDataArray addObjectsFromArray:cell.selectTagArr];
    [_canSelectTagArr removeObjectsInArray:cell.selectTagArr];
    if (!isEmptyStr(customTagStr)) {
        CardTgaModel *model = [[CardTgaModel alloc] init];
        model.tgaId = @"2016";
        model.tgaName = customTagStr;
        model.state = @"0"; //标识别可选标签
        [_tgaDataArray addObject:model];
    }
    [_editTableView reloadSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
    [self cancelBtnClick];
}

#pragma mark -- EditFifthTableCellDlegate     保存按钮
- (void)clickEditFifthTableCellSaveBtn
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否保存已设置的信息" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==2016) {
        if (buttonIndex==1) {
            CardTgaModel *model = objc_getAssociatedObject(alertView, @"tgaModel");
            [_tgaDataArray removeObject:model];
            [_canSelectTagArr addObject:model];
            [_editTableView reloadSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    else
    {
        if(buttonIndex == 1)
        {
//            [self submitData];
            [self editMicroCardRequest]; //ti
        }
    }
}


#pragma mark - TableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 57;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 50;
        }else{
            return 40;
        }
    }else if (indexPath.section == 2){
//        return 168+13+11;
//        if (indexPath.row == 0) {
//            return 57+11;
//        }else{
//            return 49;
//        }
        return 57+11+49*(ceilf(_tgaDataArray.count/3.0));
    }else if(indexPath.section == 3){
        return 57+11;
    }else if (indexPath.section == 4){
        return 281;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _messageDataArr.count;
    }else if(section == 1){
        return _classesDataArray.count+1;
    }else if(section == 2){
//        return ceilf(_tgaDataArray.count/3.0)+1;
        return 1;
    }else{
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if(indexPath.row == 1){
            
            static NSString * string = @"cellone";
            EditFirstTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"EditFirstTableCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.messageLabel.text = _messageDataArr[indexPath.row];
            if (faceImg) {
                [cell.avatorImageView setImage:faceImg];
            }
            else
            {
                [cell.avatorImageView sd_setImageWithURL:[NSURL URLWithString:_coachModel.face] placeholderImage:[UIImage imageNamed:@"card_avatorImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error) {
                        cell.avatorImageView.image = [UIImage imageNamed:@"card_avatorImage.png"];
                    }
                }];
            }
            cell.delegate = self;
            return cell;
        }else{
            NSString *CellIdentifier = @"EditTableViewCell";
            EditTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            if (!cell) {
                
                cell = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                        
                                         reuseIdentifier:CellIdentifier];
            }
            cell.messageLabel.text = _messageDataArr[indexPath.row];
//            cell.iconView.image = [UIImage imageNamed:_imageDataArr[indexPath.row]];
            //        cell.contentLabel.text = _dataArr[indexPath.row];
            cell.index = indexPath.row;
            cell.coachModel = _coachModel;
            cell.delegate = self;
            cell.tag = indexPath.row+100;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 9+1) {
                cell.lineLabel.hidden = YES;
            }
            cell.contentLabel.delegate = self;
            if (indexPath.row==0) {
                cell.contentLabel.keyboardType =  UIKeyboardTypeDefault;
                cell.contentLabel.userInteractionEnabled = YES;
            }
            else if(indexPath.row==2 || indexPath.row == 4)
            {
                cell.contentLabel.userInteractionEnabled = NO;
            }
            else
            {
                cell.contentLabel.keyboardType = UIKeyboardTypeNumberPad;
                cell.contentLabel.userInteractionEnabled = YES;
            }
            
            if (indexPath.row==0 || indexPath.row==2 || indexPath.row==3 ||indexPath.row == 4) {
                cell.contentLabel.frame = CGRectMake(kScreenWidth-150, 21, 150-24-10, 15);
            }
            else
            {
                cell.contentLabel.frame = CGRectMake(kScreenWidth-150-15, 21, 150-24-10, 15);
            }
            
            if (indexPath.row==3) {
                cell.unitLbl.userInteractionEnabled = NO;
                cell.contentLabel.userInteractionEnabled = NO;
            }
            else
            {
                cell.unitLbl.userInteractionEnabled = YES;
            }
            
            return cell;
        }
        
    }else if (indexPath.section == 1){
        if (indexPath.row ==0) {
            EditSecondTableCell * cell = [EditSecondTableCell cellWithTableView:tableView IDstr:@"EditSecondCell"];
            cell.messageLabel.text = @"班型";
            //        cell.iconView.image = [UIImage imageNamed:@"card_category"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentLabel.text = @"添加";
//            cell.delegate = self;
            return cell;
        }else{
            static NSString * string = @"cellTwo";
            EditSecondDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"EditSecondDetailCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.classModel = _classesDataArray[indexPath.row-1];
            cell.index = indexPath.row-1;
            cell.delegate = self;
            return cell;
        }
        
    }else if (indexPath.section == 2){
        EditThirdTableCell * cell = [EditThirdTableCell cellWithTableView:tableView IDstr:@"EditThirdTableCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.messageLabel.text = @"标签";
        //        cell.iconView.image = [UIImage imageNamed:@"card_label"];
        cell.contentLabel.text = @"选择";
        cell.dataArray = _tgaDataArray;
        [cell.editCollectionView reloadData];
        return cell;
        
    }else if (indexPath.section == 3){
        EditFourthTableCell * cell = [EditFourthTableCell cellWithTableView:tableView IDstr:@"EditFourthTableCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.messageLabel.text = @"场地";
        //        cell.iconView.image = [UIImage imageNamed:@"card_road"];
        //        cell.contentLabel.text = @"合肥新亚驾校";
        cell.contentLabel.text = _coachModel.addressName;
        return cell;
    }else if (indexPath.section == 4){
        EditFifthTableCell * cell = [EditFifthTableCell cellWithTableView:tableView IDstr:@"EditFifthTableCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.messageLabel.text = @"学员留念";
//        NSArray * arr = @[_coachModel.userPic1,_coachModel.userPic2,_coachModel.userPic3];
        
//        [cell.photoImageArr addObjectsFromArray:arr];
        for (int i = 0; i < bottomUploadImgArr.count; i++) {
            UIImageView *imgView = cell.photoImageArr[i];
            if ([bottomUploadImgArr[i] isKindOfClass:[UIImage class]]) {
                imgView.image = bottomUploadImgArr[i];
            }
            else if([bottomUploadImgArr[i] isKindOfClass:[NSString class]])
            {
                [imgView sd_setImageWithURL:[NSURL URLWithString:bottomUploadImgArr[i]] placeholderImage:[UIImage imageNamed:@"MCoach_click"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error) {
                        imgView.image = [UIImage imageNamed:@"MCoach_click"];
                    }
                }];
            }
        }

        NSArray * arr = @[isNull(_coachModel.userPic1)?@"":_coachModel.userPic1,isNull(_coachModel.userPic2)?@"":_coachModel.userPic2,isNull(_coachModel.userPic3)?@"":_coachModel.userPic3];

        [cell.photoImageArr addObjectsFromArray:arr];

    //        cell.iconView.image = [UIImage imageNamed:@"card_photo"];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ((indexPath.section==1)&&(indexPath.row==0)) {
        WMPPopView *pop = [WMPPopView PopViewWithTable];
        pop.delegate = self;
        pop.row = -1;
//        DrivingTypeCell* cell = [pop.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [pop showTable];
    }
    else if(indexPath.section==3)
    {
        GroundMapController *map = [[GroundMapController alloc]init];
        map.delegate = self;
        [self.navigationController pushViewController:map animated:YES];
    }
    else if ((indexPath.section==0)&&(indexPath.row==2))
    {
        //选择性别
        
        NSArray *arr = @[@"男",@"女"];
        
        EditTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [MMPickerView showPickerViewInView:self.view
                               withStrings:arr
                               withOptions:@{MMbackgroundColor: [UIColor whiteColor],
                                             MMtextColor: [UIColor blackColor],
                                             MMtoolbarColor: [UIColor whiteColor],
                                             MMbuttonColor: [UIColor blueColor],
                                             MMfont: [UIFont systemFontOfSize:18],
                                             MMvalueY: @3,
                                             MMselectedObject:isEmptyStr(cell.contentLabel.text)?arr[0]:cell.contentLabel.text,
                                             }
                                completion:^(NSString *selectedString) {
                                    //                                    NSLog(@"selectStr==>%@",selectedString);
                                    //                                    rightTextArr[indexPath.row] = selectedString;
                                    //                                    cell.textField.text = selectedString;
                                    if ([selectedString rangeOfString:@"男"].location != NSNotFound)
                                    {
                                        _coachModel.sex = @"1";
                                    }else{
                                        _coachModel.sex = @"0";
                                    }
                                    
                                    [tableView reloadRow:2 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
                                }];
    }
    else if ((indexPath.section==0)&&(indexPath.row==3))
    {
        //账号安全
        AccountSecurityVC * vc = [[AccountSecurityVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ((indexPath.section==0)&&(indexPath.row==4)){
        //选择性别
        
        NSMutableArray * arr = [[NSMutableArray alloc]init];

        for (NSDictionary * dic in _schoolDic[@"list"]) {
                [arr addObject:dic[@"name_other"]];
        }
        
        EditTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [MMPickerView showPickerViewInView:self.view
                               withStrings:arr
                               withOptions:@{MMbackgroundColor: [UIColor whiteColor],
                                             MMtextColor: [UIColor blackColor],
                                             MMtoolbarColor: [UIColor whiteColor],
                                             MMbuttonColor: [UIColor blueColor],
                                             MMfont: [UIFont systemFontOfSize:18],
                                             MMvalueY: @3,
                                             MMselectedObject:isEmptyStr(cell.contentLabel.text)?arr[0]:cell.contentLabel.text,
                                             }
                                completion:^(NSString *selectedString) {
                                    
                                    _coachModel.selectedSchool = selectedString;
                                    [tableView reloadRow:4 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
                                }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - GroundMapControllerDelegate

- (void)getCityModel:(cityModel *)city andWeizhi:(CLLocationCoordinate2D)loc;
{
    _cityModel = city;
    _locationCoordinate = loc;
    _coachModel.addressName = city.name;
    [_editTableView reloadData];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:loc.latitude longitude:loc.longitude];
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             NSLog(@"\n name:%@\n  country:%@\n postalCode:%@\n ISOcountryCode:%@\n ocean:%@\n inlandWater:%@\n locality:%@\n subLocality:%@\n administrativeArea:%@\n subAdministrativeArea:%@\n thoroughfare:%@\n subThoroughfare:%@\n",
                   placemark.name,
                   placemark.country,
                   placemark.postalCode,
                   placemark.ISOcountryCode,
                   placemark.ocean,
                   placemark.inlandWater,
                   placemark.administrativeArea,
                   placemark.subAdministrativeArea,
                   placemark.locality,
                   placemark.subLocality,
                   placemark.thoroughfare,
                   placemark.subThoroughfare
                   
                   );
             
             _cityModel.name = placemark.locality;
             
             //获取省份
             NSString * provinceStr = placemark.administrativeArea;
             //获取城市
//             _cityStr = placemark.locality;
             
             NSArray *addressArr = kProvinceData;
             NSMutableArray * dataArr = [NSMutableArray  array];
             for (NSData *data in addressArr) {
                 ProvinceModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                 [dataArr addObject:model];
             }
             
             for (ProvinceModel * provinceModel in dataArr) {
                 if ([provinceStr isEqualToString:provinceModel.name]) {
                     
                     _coachModel.provinceId = [NSString stringWithFormat:@"%d",provinceModel.idNum] ;
//                     _provinceModel = provinceModel;
                     
                     break;
                 }
                 
             }
         }
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];

    
}

- (void)EditFifthTableCell:(EditFifthTableCell *)cell clickPhotoImg:(UIImageView *)photoImgView;
{
    clickedImgView = photoImgView;
    
    UIActionSheet * actionSheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传学员留念" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"本机相册", nil];
        //            sheet.tag = 101;
    }else{
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本机相册", nil];
    }
    actionSheet.tag = 1000;
    [actionSheet showInView:self.view];
    currentActionSheet = actionSheet;
}

#pragma mark --EditFirstTableCellDelegate

- (void)EditFirstTableCell:(EditFirstTableCell *)cell imageView:(UIImageView *)avatorImageView
{
    [self.view endEditing:YES];
    _avatorImageV = avatorImageView;
    
    __unsafe_unretained typeof(self) mineself = self;
    UIActionSheet * sheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"本机相册", nil];
        //            sheet.tag = 101;
    }else{
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本机相册", nil];
    }
    [sheet showInView:mineself.view];
    currentActionSheet = sheet;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1000) {
        NSUInteger sourceType = 0;
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
        UIImagePickerController *imagePic = [[UIImagePickerController alloc] init];
        imagePic.delegate = self;
        imagePic.allowsEditing = YES;
        imagePic.sourceType = sourceType;
        [self presentViewController:imagePic animated:YES completion:nil];
    }else{
        NSUInteger sourceType = 0;
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
        UIImagePickerController *imagePic = [[UIImagePickerController alloc] init];
        imagePic.delegate = self;
        imagePic.allowsEditing = YES;
        imagePic.sourceType = sourceType;
        [self presentViewController:imagePic animated:YES completion:nil];
    }
}

#pragma mark - 更改头像
//上传头像
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //相册图片点击后调用该方法
    //获取点击图片
    UIImage * img = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (currentActionSheet.tag == 1000) {
        //点击底部上传图片
        bottomUploadImgArr[clickedImgView.tag-10] = img;
        [_editTableView reloadData];
    }
    else
    {
        //将图片显示在头像按钮上
        img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        faceImg = img;
        
        EditFirstTableCell * cell = [_editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.avatorImageView.image = img;

    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mrak - EditTableViewCellDelegate

- (void)EditTableViewCell:(EditTableViewCell *)cell textFieldDidChanged:(UITextField *)textField
{
    textField.delegate = self;
    switch (cell.index) {
        case 0:
        {
            _coachModel.trueName = cell.contentLabel.text;
        }
            break;
//        case 1:
//        {
//            
//        }
            break;
        case 2:
        {
            if ([cell.contentLabel.text rangeOfString:@"男"].location != NSNotFound)
            {
                _coachModel.sex = @"1";
            }else{
                _coachModel.sex = @"0";
            }
        }
            break;
        case 3:
        {
            _coachModel.phone = cell.contentLabel.text;
        }
            break;
        case 4:
        {
            _coachModel.selectedSchool = cell.contentLabel.text;
        }
        case 5:
        {
            _coachModel.age = cell.contentLabel.text;
        }
            break;
        case 6:
        {
            _coachModel.dage = cell.contentLabel.text;
        }
            break;
        case 7:
        {
            _coachModel.tage = cell.contentLabel.text;
        }
            break;
        case 8:
        {
            _coachModel.students = cell.contentLabel.text;
        }
            break;
        case 9:
        {
            _coachModel.average = cell.contentLabel.text;
        }
            break;
        case 10:
        {
            _coachModel.percent2 = cell.contentLabel.text;
        }
            break;
        case 11:
        {
            _coachModel.percent3 = cell.contentLabel.text;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - EditSecondDetailCellDelegate

- (void)EditSecondDetailCell:(EditSecondDetailCell *)cell clickFifthLbl:(UILabel *)lbl;
{
    WMPPopView *pop = [WMPPopView PopViewWithTable];
    pop.delegate = self;
    pop.row = cell.index;
    pop.classesModel = self.classesDataArray[cell.index];
    [pop showTable];
}

#pragma mark - EditThirdTableCellDelegate

- (void)EditThirdTableCell:(EditThirdTableCell *)cell clickChooseBtnWithCell:(EditCollectionCell *)collectionCell;
{
    if (collectionCell.tgaModel) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否删除此标签" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 2016;
        [alertView show];
        objc_setAssociatedObject(alertView, @"tgaModel", collectionCell.tgaModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

#pragma mark - WMPPopViewDelegate

- (void)WMPPopView:(WMPPopView *)popView surebtnClickedsendName:(NSString *)name andPrice:(NSString *)price andDrvingtype:(NSString *)type andXuetime:(NSString *)time andOthertime:(NSString *)othertime classesModelId:(NSString *)idNum;
{
    NSArray *classDateArr = @[@"周一至周五",@"周一至周日",@"周六至周日",@"晚上"];
    NSArray *classCarArr  = @[@"C1",@"C2"];
    CardClassesModel *classModel = nil;
    if (popView.classesModel) {
        //编辑
        classModel = popView.classesModel;
    }
    else
    {
        //添加
        classModel = [[CardClassesModel alloc] init];
        classModel.classId = @"0"; //新增Id设为0
//        [self.classesDataArray appendObject:classModel];
        [self.classesDataArray insertObject:classModel atIndex:0];
    }
    
    classModel.className = name;
    classModel.classMoney = price;
    classModel.classDateId = !isEmptyStr(othertime)?@"0":time;
    classModel.classCarId = type;
    classModel.classCar = [classModel.classCarId intValue]-1<classCarArr.count?classCarArr[[classModel.classCarId intValue]-1] : @"";
    if (isEmptyStr(othertime)) {
        if ([classModel.classDateId isEqualToString:@"12"]) {
            classModel.classDate = @"周一至周五";
        }
        else
        {
            classModel.classDate = [classModel.classDateId intValue]-1<classDateArr.count?classDateArr[[classModel.classDateId intValue]-1] : @"";
        }
    }
    else
    {
        classModel.classDate = othertime;
    }
    
    [_editTableView reloadData];
}

- (void)editMicroCardRequest
{
    
    if (isEmptyStr(_cityModel.name)) {
        
        if (isEmptyStr(_cityModel.cityId)) {
            [LLUtils showErrorHudWithStatus:@"请选择场地"];
            return;
        }
        else
        {
            [self eidtRequest:_cityModel.cityId];
        }
//         [self eidtRequest:nil];
    }
    else
    {
        [LLAddress getProviceId:_cityModel.name completeBlock:^(BOOL isSuccess, NSString *areaName, NSString *areaID) {
            
            if (isSuccess) {
                [self eidtRequest:areaID];
            }
            else
            {
                [LLUtils dismiss];
            }
            
        }];
    }
}

- (void)eidtRequest:(NSString *)areaID
{
    //显示HUD
    [LLUtils showTextAndProgressHud:@"提交中..."];
    
    _isAllowPop = NO;
    NSString *relativeAdd = @"/card/update";
    
    //拼接tga
    NSMutableArray *tgaArr = [NSMutableArray array];
    for (CardTgaModel *aTga in _tgaDataArray) {
        [tgaArr addObject:aTga.tgaName];
    }
    NSString *tgaStr = [tgaArr componentsJoinedByString:@" || "];
    
    //拼接classes
    NSMutableArray *classesArr = [NSMutableArray array];
    
    for (CardClassesModel *aClass in _classesDataArray) {
        [classesArr addObject:@{@"classId":kHandleEmptyStr(aClass.classId),@"title":kHandleEmptyStr(aClass.className),@"carClass":kHandleEmptyStr(aClass.classCarId),@"date_id":kHandleEmptyStr(aClass.classDateId),@"date":kHandleEmptyStr(aClass.classDate),@"money":isNull(aClass.classMoney)?@"":aClass.classMoney}];
    }
    NSString *classJsonStr = [LLUtils jsonStrWithJSONObject:classesArr];
    
    NSString * schoolId = nil;
    for (NSDictionary * dic in _schoolDic[@"list"]) {
        if ([dic[@"name_other"] isEqualToString:_coachModel.selectedSchool]) {
            schoolId = dic[@"id"];
        }
    }
    
    NSMutableDictionary *paraDic = [@{@"uid":kUid,@"cityId":kCityID,@"time":kTimeStamp,@"sign":kSignWithIdentify(relativeAdd),@"trueName":_coachModel.trueName,@"sex":_coachModel.sex,@"phone":_coachModel.phone,@"age":_coachModel.age,@"dage":_coachModel.dage,@"tage":_coachModel.tage,@"students":_coachModel.students,@"average":_coachModel.average,@"percent2":_coachModel.percent2,@"percent3":_coachModel.percent3,@"address":_coachModel.address,@"addressName":_coachModel.addressName,@"provinceId":_coachModel.provinceId,@"tga":tgaStr,@"classes":classJsonStr} mutableCopy];
    
    if (!isNull(schoolId)) {
        [paraDic setObject:schoolId forKey:@"school"];
    }
    
    if (!isEmptyStr(areaID)) {
        [paraDic setObject:areaID forKey:@"cityId"];
    }
    
    NSMutableArray *serviceNameArr = [NSMutableArray array];
    NSMutableArray *fileNameArr = [NSMutableArray array];
    NSMutableArray *fileDataArr = [NSMutableArray array];
    for (int i = 0; i < bottomUploadImgArr.count; i++) {
        if ([bottomUploadImgArr[i] isKindOfClass:[UIImage class]]) {
            UIImage *img = bottomUploadImgArr[i];
            NSData * data = [LLUtils dataWithImage:img];
            if (isNull(data)) {
                continue;
            }
            [fileDataArr addObject:data];
            [serviceNameArr addObject:i==0?@"userPic1":i==1?@"userPic2":i==2?@"userPic3":@""];
            [fileNameArr addObject:@"0.png"];
        }
        else if (([bottomUploadImgArr[i] isKindOfClass:[NSString class]]) && (!isEmptyStr(bottomUploadImgArr[i])))
        {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:bottomUploadImgArr[i]]];
            if (isNull(data)) {
                continue;
            }
            [fileDataArr addObject:data];
            [serviceNameArr addObject:i==0?@"userPic1":i==1?@"userPic2":i==2?@"userPic3":@""];
            [fileNameArr addObject:@"0.png"];
        }
    }
    
    if (faceImg) {
        //用户修改了头像
        [serviceNameArr addObject:@"face"];
        [fileNameArr addObject:@"0.png"];
        [fileDataArr addObject:[LLUtils dataWithImage:faceImg]];
    }
    
    WeakObj(self)
    
    [NetworkEngine UploadFileWithUrl:[HOST_ADDR stringByAppendingString:relativeAdd] param:paraDic serviceNameArr:serviceNameArr fileNameArr:fileNameArr mimeType:@"image/jpeg" fileDataArr:fileDataArr finish:^(NSData *data) {
        _isAllowPop = YES;
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1)
        {
            //成功
            [LLUtils showSuccessHudWithStatus:msg];
            [selfWeak.webVC.webView reload];
            [selfWeak.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [LLUtils showErrorHudWithStatus:msg];
        }
        
    } failed:^(NSError *error) {
        _isAllowPop = YES;
        [LLUtils showErrorHudWithStatus:@"请求异常，请稍后重试"];
    }];
    
}

//删除
-(void)deleteselfrow:(NSInteger)row
{
    
    [self.classesDataArray removeObjectAtIndex:row];

    [_editTableView reloadData];

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

#pragma mark -键盘的通知
/**
 *  键盘即将显示
 */
-(void)kbWillShow:(NSNotification *)noti
{
    CGFloat kbHeight = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    backView.frame = CGRectMake((kScreenWidth-291)/2, (kScreenHeight-400)/2-kbHeight+130, 291, 400);
    
}

/**
 *  键盘即将隐藏
 */
-(void)kbWillHide:(NSNotification *)noti
{
    backView.frame = CGRectMake((kScreenWidth-291)/2, (kScreenHeight-400)/2, 291, 400);
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
