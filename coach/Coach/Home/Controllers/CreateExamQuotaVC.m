//
//  CreateExamQuotaVC.m
//  KZXC_Headmaster
//
//  Created by gaobin on 16/8/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "MMPickerView.h"
#import "CreateExamQuotaVC.h"
#import "ExamQuotaReleaseModel.h"
#import "TailorCell.h"
#import "OSAddressPickerView.h"
#import "RemarkCell.h"

#import "HJHttpManager.h"
#import "HttpParamManager.h"
#import "HttpsTools.h"

//合作名额
#define HZMEKeyArray @[@[@"发布者",@"联系电话",@"地址",@"详细地址"],@[@"人数(人)",@"拿证时间要求(天)",@"考试地域要求",@"转让价格(元)"]]
#define HZMEValueArray @[@[@"请先进行实名认证",@"请输入您的手机号码",@"请选择您的地址",@"请输入您的详细地址"],@[@"请输入转让人数",@"请输入拿证时间要求",@"限本市",@"请输入转让价格"]]
#define LeaseHeadImgArrar @[@"section1",@"section2",@"section1",@"section1"]
#define LeaseHeadTitleArray @[@"场地信息",@"价格信息",@"备注",@"上传图片"]
#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height

@interface CreateExamQuotaVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) OSAddressPickerView * pickerview;
@property (nonatomic, assign) BOOL isSelected;

@end

@implementation CreateExamQuotaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"新增名额";
    
    self.view.backgroundColor = rgb(247, 247, 247);
    
    if (_isNewAdd) {
        
        _examQuotaRelease = [[ExamQuotaReleaseModel alloc]init];
    }
    
    [self createUI];
    
}
- (void)createUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = rgb(247, 247, 247);
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"TailorCell" bundle:nil] forCellReuseIdentifier:@"TailorCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"RemarkCell" bundle:nil] forCellReuseIdentifier:@"RemarkCell"];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0 || section == 1) {
        
        return [HZMEKeyArray[section] count];
    }else {
        
        return 1;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        
        static NSString * identifier = @"TailorCell";
        
        TailorCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        if (0 == indexPath.row) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"#ececec"];
            [cell addSubview:line];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSInteger section = [indexPath section];
        
        NSInteger row = [indexPath row];
        
        cell.showKey.text = [HZMEKeyArray[section] objectAtIndex:row];
        
        cell.showValue.placeholder = [HZMEValueArray[section] objectAtIndex:row];
        
        if (((indexPath.section == 0) && (indexPath.row == 2))||((indexPath.section==1)&&(indexPath.row==2))) {
            
            cell.showValue.enabled = NO;
        }else {
            cell.showValue.enabled = YES;
        }
        
        if (indexPath.section == 0) {
            
            cell.showValue.tag = indexPath.row;
        }if (indexPath.section == 1) {
            
            cell.showValue.tag = indexPath.row + 10;
        }
        
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                {
//                    cell.showValue.text = _examQuotaRelease.trueName;
                    if (isEmptyStr(_examQuotaRelease.trueName)) {
                        cell.showValue.text = kRealName;
                        _examQuotaRelease.trueName = kRealName;
                    }else{
                        cell.showValue.text = _examQuotaRelease.trueName;
                    }
                    cell.showValue.userInteractionEnabled = NO;
                }
                    break;
                case 1:
                {
                    if (isEmptyStr(_examQuotaRelease.tel)) {
                        cell.showValue.text = kPhone;
                        _examQuotaRelease.tel = kPhone;
                    }else{
                        cell.showValue.text = _examQuotaRelease.tel;
                    }
                    cell.showValue.keyboardType = UIKeyboardTypePhonePad;
//                    cell.showValue.text = _examQuotaRelease.tel;
                }
                    break;
                case 2:
                {
                    NSArray * provinceArr = kProvinceDict;
                    NSString * provinceStr = nil;
                    for (NSDictionary * dic in provinceArr) {
                        if ([dic[@"id"] isEqualToString:_examQuotaRelease.provinceId]) {
                            provinceStr = dic[@"title"];
                        }
                    }
                    NSArray *cityArr = kCityDict;
                    NSString * cityStr = nil;
                    for (NSDictionary *dic in cityArr) {
                        if ([dic[@"id"] isEqualToString:_examQuotaRelease.cityId]) {
                            cityStr = dic[@"title"];
                        }
                    }
                    NSArray * countryArr = kCountryDict;
                    NSString * countryStr = nil;
                    for (NSDictionary * dict in countryArr) {
                        if ([dict[@"id"] isEqualToString:_examQuotaRelease.areaId]) {
                            countryStr = dict[@"title"];
                        }
                    }
                    
                    if (_isNewAdd && _isSelected) {
                        
                        cell.showValue.text = [NSString stringWithFormat:@"%@ %@ %@",provinceStr,cityStr,countryStr];
                    }if (!_isNewAdd) {
                        cell.showValue.text = [NSString stringWithFormat:@"%@ %@ %@",provinceStr,cityStr,countryStr];
                    }
                    
                }
                    break;
                case 3:
                {
                    cell.showValue.keyboardType = UIKeyboardTypeDefault;
                    cell.showValue.text = _examQuotaRelease.address;
                }
                    break;
                default:
                    break;
            }
        }
        if (indexPath.section == 1) {
            switch (indexPath.row) {
                case 0:
                {
                    cell.showValue.keyboardType = UIKeyboardTypePhonePad;
                    cell.showValue.text = _examQuotaRelease.peopleNum;
                }
                    break;
                case 1:
                {
                    cell.showValue.keyboardType = UIKeyboardTypePhonePad;
                    cell.showValue.text = _examQuotaRelease.holdingTime;
                }
                    break;
                case 2:
                {
                    cell.showValue.text = _examQuotaRelease.region;
                }
                    break;
                case 3:
                {
                    cell.showValue.keyboardType = UIKeyboardTypePhonePad;
                    cell.showValue.text = _examQuotaRelease.price;
                }
                    break;
                    
                default:
                    break;
            }
            
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:cell.showValue];
        
        
        return cell;

        
    }else {
        //备注content
        static NSString * identifier = @"RemarkCell";
        RemarkCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.backgroundColor = rgb(247,247,247);
        cell.myTextView.backgroundColor = [UIColor whiteColor];
        cell.myTextView.text = _examQuotaRelease.content;
        cell.myTextView.delegate = self;
        
        return  cell;
    }
    
}
#pragma mark -- textView的代理方法
- (void)textViewDidChange:(UITextView *)textView {
    
    _examQuotaRelease.content = textView.text;
    
}
- (void)textFieldChanged:(NSNotification *)notification {
    
    UITextField * textField = (UITextField *)[notification object];
    textField.textColor = [UIColor colorWithHexString:@"#333333"];
    
    switch (textField.tag) {
        case 0:
        {
            _examQuotaRelease.trueName = textField.text;

        }
            break;
        case 1:
        {
            _examQuotaRelease.tel = textField.text;
        }
            break;
        case 3:
        {
            _examQuotaRelease.address = textField.text;
        }
            break;
        case 10:
        {
            _examQuotaRelease.peopleNum = textField.text;
        }
            break;
        case 11:
        {
            _examQuotaRelease.holdingTime = textField.text;
        }
            break;
        case 12:
        {
            _examQuotaRelease.region = textField.text;
        }
            break;
        case 13:
        {
            _examQuotaRelease.price = textField.text;
            
        }
            break;
        default:
            break;
    }
    
        
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(15, 19, 12, 12)];
//        img.image = [UIImage imageNamed:@"mehz_head"];
        img.image = [UIImage imageNamed:@"iconfont-icon"];
        [headview addSubview:img];
        
        UILabel *headtitle = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 80, 50)];
        headtitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        headtitle.textColor = [UIColor colorWithHexString:@"#646464"];
        headtitle.text = @"名额信息";
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 49, kWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#ececec"];
        [headview addSubview:line];
        [headview addSubview:headtitle];
        
        return headview;
    }if (section == 2) {
        
        
        UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
        headview.backgroundColor = rgb(247, 247, 247);
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(15, 19, 12, 12)];
//        img.image = [UIImage imageNamed:LeaseHeadImgArrar[section - 1]];
        img.image =  [UIImage imageNamed:@"iconfont-edit-price"];
        [headview addSubview:img];
        
        UILabel *headtitle = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 80, 50)];
        headtitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        headtitle.textColor = [UIColor colorWithHexString:@"#646464"];
//        headtitle.text = @"备注";
        headtitle.text = @"转让说明";
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 49, kWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#ececec"];
        [headview addSubview:line];
        
        [headview addSubview:headtitle];
        
        return headview;
    }
    
    return nil;

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 2) {
        
        UIView * bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor clearColor];
        
        UIButton *keep = [[UIButton alloc]initWithFrame:CGRectMake(20, 30, kWidth- 40, ButtonH)];
        [keep setTitle:@"保存并发布" forState:UIControlStateNormal];
        [keep setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
        keep.layer.cornerRadius = ButtonH/2;
        keep.backgroundColor = CommonButtonBGColor;
        [keep addTarget:self action:@selector(keepClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:keep];
        
        return bgView;
        
    }
    return nil;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (1 == section || 2 == section) {
        return 50;
    }
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0 || section == 1) {
        
        return CGFLOAT_MIN;
    }else {
        
        return 120;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 || indexPath.section == 1) {
        
        return 50;
    }else {
        
        return 110;
    }

}
#pragma mark -- 保存并发布考试名额请求
- (void)keepClick
{
    
    if (isEmptyStr(_examQuotaRelease.provinceId) || isEmptyStr(_examQuotaRelease.cityId) || isEmptyStr(_examQuotaRelease.areaId)) {
        [LLUtils showErrorHudWithStatus:@"请选择您的地址"];
        return;
    }
    
    if (isEmptyStr(_examQuotaRelease.address)) {
        [LLUtils showErrorHudWithStatus:@"请输入您的详细地址"];
        return;
    }
    
    if (isEmptyStr(_examQuotaRelease.peopleNum)) {
        [LLUtils showErrorHudWithStatus:@"请输入转让人数"];
        return;
    }
    
    if (isEmptyStr(_examQuotaRelease.holdingTime)) {
        [LLUtils showErrorHudWithStatus:@"请输入拿证时间要求"];
        return;
    }
    
    if (isEmptyStr(_examQuotaRelease.region)) {
        [LLUtils showErrorHudWithStatus:@"请输入地域要求"];
        return;
    }
    
    if (isEmptyStr(_examQuotaRelease.price)) {
        [LLUtils showErrorHudWithStatus:@"请输入转让价格"];
        return;
    }
    
    NSString * url = [NSString stringWithFormat:@"%@%@",HOST_ADDR,@"/examinationQuota/create"];
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * timeString = kTimeStamp;
    paramDict[@"time"] = timeString;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/examinationQuota/create" time:timeString];
    //选填的参数
    paramDict[@"trueName"] = _examQuotaRelease.trueName;
    paramDict[@"tel"] = _examQuotaRelease.tel;
    paramDict[@"provinceId"] = _examQuotaRelease.provinceId;
    paramDict[@"cityId"] = _examQuotaRelease.cityId;
    paramDict[@"areaId"] = _examQuotaRelease.areaId;
    paramDict[@"address"] = _examQuotaRelease.address;
    paramDict[@"peopleNum"] = _examQuotaRelease.peopleNum;
    paramDict[@"holdingTime"] = _examQuotaRelease.holdingTime;
    paramDict[@"region"] = _examQuotaRelease.region;
    paramDict[@"content"] = _examQuotaRelease.content;
    paramDict[@"price"] = _examQuotaRelease.price;
    
    if (isEmptyStr(_examQuotaRelease.trueName)) {
        [LLUtils showErrorHudWithStatus:@"请先进行实名认证"];
        return;
    }
    
    if (_isNewAdd) {
        paramDict[@"examinaId"] = @"0";
    }else {
        paramDict[@"examinaId"] = self.examQuotaRelease.idStr;
    }

    [HttpsTools POST:url parameter:paramDict progress:^(NSProgress *downloadProgress) {
    } succeed:^(id responseObject) {

        NSLog(@"发布或修改我的名额%@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        NSString * msg = responseObject[@"msg"];
        if (code == 1) {
            
            //添加或者编辑成功跳回前一页面,发送通知刷新页面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMyQuota" object:self];
            [LLUtils showSuccessHudWithStatus:@"发布成功"];
            
            
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            
            //失败
            [LLUtils showErrorHudWithStatus:responseObject[@"msg"]];
        }
        
        
    } failure:^(NSError *error) {
        
        //失败
        [LLUtils showErrorHudWithStatus:@"发布失败"];
        
    }];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.section == 0) && (indexPath.row == 2)) {
        
        [self.view endEditing:YES];
        
        _isSelected = YES;
        
        _pickerview = [OSAddressPickerView shareInstance];
        
        NSArray *addressArr = kProvinceData;
        
        NSMutableArray *dataArray = [NSMutableArray  array];
        
        for (NSData *data in addressArr) {
            ProvinceModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [dataArray addObject:model];
        }
        _pickerview.dataArray = dataArray;
        
        [_pickerview showBottomView];
        
        [self.view addSubview:_pickerview];
        
        WeakObj(self);
        
        _pickerview.block = ^(ProvinceModel *provinceModel,CityModel *cityModel,CountryModel *districtModel)
        {
            
            selfWeak.examQuotaRelease.provinceId = [NSString stringWithFormat:@"%d",provinceModel.idNum];
            
            selfWeak.examQuotaRelease.cityId = [NSString stringWithFormat:@"%d",cityModel.idNum];
            
            selfWeak.examQuotaRelease.areaId = [NSString stringWithFormat:@"%d",districtModel.idNum];
            
            [selfWeak.tableView reloadData];
            
        };

    }
    else if ((indexPath.section==1)&&(indexPath.row==2))
    {
        [self.view endEditing:YES];
        
        //考试地域要求
        NSArray *regionArr = @[@"限本省",@"限本市",@"不限"];
        
        WeakObj(self)
        
        [MMPickerView showPickerViewInView:self.view withStrings:regionArr withOptions:
         @{MMbackgroundColor: [UIColor whiteColor],
           MMtextColor: [UIColor blackColor],
           MMtoolbarColor: [UIColor whiteColor],
           MMbuttonColor: [UIColor blueColor],
           MMfont: [UIFont systemFontOfSize:18],
           MMvalueY: @3,
           MMselectedObject:isEmptyStr(_examQuotaRelease.region)?regionArr[0]:_examQuotaRelease.region,
           }
                                completion:^(NSString *selectedString) {
                                    _examQuotaRelease.region = selectedString;
                                    [selfWeak.tableView reloadRow:2 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
                                }];
    }
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
