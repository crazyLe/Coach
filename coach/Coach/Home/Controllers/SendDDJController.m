//
//  SendDDJController.m
//  Coach
//
//  Created by 翁昌青 on 16/7/30.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLDatePicker.h"
#import "SendDDJController.h"
#import "ExamSendCell.h"

@interface SendDDJController ()
@property(strong,nonatomic)NSArray *keyArr;
@property(strong,nonatomic)NSArray *valueArr;
@property(weak,nonatomic)UITableView *exitDDJTable;
@end

@implementation SendDDJController
{
    NSString *titleStr;
    NSString *moneyStr;
    NSDate *startDate;
    NSDate *endDate;
}

- (id)init
{
    if (self = [super init]) {

    }
    return self;
}

- (NSArray *)keyArr
{
    if (!_keyArr) {
        _keyArr = [NSArray arrayWithObjects:@[@"标题",@"金额",@"开始时间",@"结束时间"], nil];
    }
    return _keyArr;
}

- (NSArray *)valueArr
{
    if (!_valueArr) {
        _valueArr = [NSArray arrayWithObjects:@[@"例：开学报名优惠",@"请输入代金券金额",@"03/10／2014",@"03/10／2014"], nil];
    }
    return _valueArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self commonInit];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
    [self setLeftText:nil textColor:nil ImgPath:@"Navigation_Return"];
    
    self.title = _type==EditCouponTypeEdit?@"编辑代金劵":@"新增代金券";
    
    [self setupEditTabel];
}

- (void)commonInit
{
    NSDate *nowDate = [LLUtils setHourMinSecToZero:[NSDate date]];
    NSDate *tomorrowDate = [LLUtils setHourMinSecToZero:[NSDate dateWithTimeIntervalSinceNow:24*3600]];
    if (_type == EditCouponTypeEdit) {
        //编辑
        titleStr = self.infoDic[@"title"];
        moneyStr = self.infoDic[@"money"];
        startDate = [LLUtils dateWithTimeStamp:self.infoDic[@"startTime"]];
        endDate = [LLUtils dateWithTimeStamp:self.infoDic[@"endTime"]];
        
        if (isNull(startDate)) {
            startDate = nowDate;
        }
        if (isNull(endDate)) {
            endDate = tomorrowDate;
        }
    }
    else
    {
        //新增
        startDate = nowDate;
        endDate = tomorrowDate;
    }
}

- (void)setupEditTabel
{
    UITableView *buy = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopBarTotalHeight-25, kScreenWidth , kScreenHeight) style:UITableViewStyleGrouped];
    buy.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    buy.separatorStyle = UITableViewCellSeparatorStyleNone;
    buy.tag = 101;
    
    buy.dataSource = self;
    buy.delegate = self;
    
    [self.view addSubview:buy];
//    [buy mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
    
    self.exitDDJTable = buy;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
        
        
    static NSString *send = @"sendcellID";
    ExamSendCell *cell = [tableView dequeueReusableCellWithIdentifier:send];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ExamSendCell" owner:nil options:nil]firstObject];
    }
    
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.key.text = [self.keyArr[section] objectAtIndex:row];
    
//    NSString *value = [self.valueArr[section] objectAtIndex:row];
    
//    cell.value.text = value;
    
    
    if (row > 1) {
        cell.jiantou.image = [UIImage imageNamed:@"iconfont-rili(1)"];
        cell.value.userInteractionEnabled = NO;
        if (_type == EditCouponTypeAdd) {
            cell.value.text = [LLUtils dateStrWithDate:row==2?[NSDate date]:[NSDate dateWithTimeIntervalSinceNow:24*3600] dateFormat:@"MM/dd/yyyy"];
        }
        else
        {
            //编辑
            cell.value.text = [LLUtils dateStrWithDate:row==2?startDate:endDate dateFormat:@"MM/dd/yyyy"];
        }
        
    }
    else
    {
//        cell.value.attributedPlaceholder = [NSMutableAttributedString attributeStringWithText:row==0?@"例：开学报名优惠":@"200元" attributes:@[kGrayHex33,kFont12]];
        cell.value.placeholder = row==0?@"例：开学报名优惠":@"请输入代金券金额";
        cell.value.userInteractionEnabled = _type==EditCouponTypeEdit?NO:YES;
        if (_type == EditCouponTypeAdd) {
            //新增
            
        }
        else
        {
            //编辑
        }
        NSArray *valueArr = @[kHandleEmptyStr(titleStr),kHandleEmptyStr(moneyStr)];
        cell.value.text = valueArr[row];
    }
    
    if (row == 1) {
        cell.value.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    if (0 == section) {
        return 50;
    }
    return 160;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 200;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
        UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 105)];
        foot.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
        UILabel *tips = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 140)/2, 50, 140, 20)];
        tips.textAlignment = NSTextAlignmentCenter;
        tips.font = Font15;
        tips.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
        tips.text = @"仅限对本校报名使用";
        
        [foot addSubview:tips];
    
        UIButton *keep = [[UIButton alloc]init];
        keep.backgroundColor = [UIColor colorWithHexString:@"#2e83ff"];
        keep.layer.cornerRadius = 22.5;
        [keep setTitle:@"确认发布" forState:UIControlStateNormal];
        [keep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [keep addTarget:self action:@selector(outClick) forControlEvents:UIControlEventTouchUpInside];
        [foot addSubview:keep];
        [keep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tips.mas_bottom).offset(15);
            make.left.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth - 40, 45));
        }];
    
        return foot;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.row>1) {
        //弹出日期选择器
        ExamSendCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *dateStr = cell.value.text;
        NSDate *date = [LLUtils dateWithDateStr:dateStr dateFormat:@"MM/dd/yyyy"];
        [LLDatePicker showWithDate:date minimumDate:(_type==EditCouponTypeEdit)&&(indexPath.row==3)?endDate:nil maximumDate:nil datePickerMode:UIDatePickerModeDate delegate:self object:[tableView cellForRowAtIndexPath:indexPath]];
    }
}

#pragma mark - LLDatePickerDelegate

- (void)LLDatePicker:(LLDatePicker *)view datePickerValueChanged:(UIDatePicker *)datePicker;
{
    ExamSendCell *cell = view.object;
    cell.value.text = [LLUtils dateStrWithDate:datePicker.date dateFormat:@"MM/dd/yyyy"];
    
    NSDate *selectDate = [LLUtils setHourMinSecToZero:datePicker.date];
    
    if (cell.indexPath.row==2) {
        startDate = selectDate;
    }
    else
    {
        endDate   = selectDate;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


- (void)outClick
{
    //点击确认发布
    NSLog(@"=====");
    NSString *promptStr = nil;
    if (isEmptyStr(titleStr)) {
        promptStr = @"请输入代金券标题";
    }
    else if (isEmptyStr(moneyStr))
    {
        promptStr = @"请输入代金券金额";
    }
    else if (isNull(startDate))
    {
        promptStr = @"请选择开始日期";
    }
    else if (isNull(endDate))
    {
        promptStr = @"请选择结束日期";
    }
    if (promptStr) {
        [LLUtils showErrorHudWithStatus:promptStr];
        return;
    }
    
    NSTimeInterval interval = [startDate timeIntervalSinceDate:endDate];
    NSString *startDateStr = [LLUtils dateStrWithDate:startDate dateFormat:@"yyyy/MM/dd"];
    NSString *endDateStr = [LLUtils dateStrWithDate:endDate dateFormat:@"yyyy/MM/dd"];
    if (![startDateStr isEqualToString:endDateStr] && (interval>0)) {
        [LLUtils showErrorHudWithStatus:@"结束时间不能早于开始时间"];
        return;
    }
    
    [self requestData]; //请求
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Network

- (void)requestData
{
    NSLog(@"time==>%@,%@",integerToStr((long)[endDate timeIntervalSince1970]),[LLUtils dateStrWithTimeStamp:integerToStr((long)[endDate timeIntervalSince1970]) dateFormat:@"yyyy-MM-dd HH:mm:ss"]);
    WeakObj(self)
    if (_type == EditCouponTypeAdd) {
        //新增代金券
        [NetworkEngine sendAsynPostRequestRelativeAdd:@"/cashCoupon/create" paraNameArr:@[@"uid",@"title",@"money",@"startTime",@"endTime",@"time",@"sign"] paraValueArr:@[kUid,titleStr,moneyStr,integerToStr((long)[startDate timeIntervalSince1970]),integerToStr((long)[endDate timeIntervalSince1970]),kTimeStamp,kSignWithIdentify(@"/cashCoupon/create")] completeBlock:^(BOOL isSuccess, id jsonObj) {
            if (isSuccess) {
                if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                    //请求成功
                    [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
                    selfWeak.successBlock(_type);
                    [selfWeak.navigationController popViewControllerAnimated:YES];
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
        //编辑代金券
        [NetworkEngine sendAsynPostRequestRelativeAdd:@"/cashCoupon/update" paraNameArr:@[@"uid",@"startTime",@"endTime",@"time",@"sign",@"coupon_id"] paraValueArr:@[kUid,integerToStr((long)[startDate timeIntervalSince1970]),integerToStr((long)[endDate timeIntervalSince1970]),kTimeStamp,kSignWithIdentify(@"/cashCoupon/update"),self.infoDic[@"id"]] completeBlock:^(BOOL isSuccess, id jsonObj) {
            if (isSuccess) {
                if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                    //请求成功
                    [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
                    selfWeak.successBlock(_type);
                    [selfWeak.navigationController popViewControllerAnimated:YES];
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

#pragma mark - ExamSendCellDelegate

- (void)ExamSendCell:(ExamSendCell *)cell textFieldDidChanged:(UITextField *)textField;
{
    if (cell.indexPath.row == 0) {
        //标题
        titleStr = textField.text;
    }
    else if (cell.indexPath.row == 1)
    {
        //金额
        moneyStr = textField.text;
    }
}

- (void)ExamSendCell:(ExamSendCell *)cell textFieldDidEndEdited:(UITextField *)textField;
{
    [self ExamSendCell:cell textFieldDidChanged:textField];
//    textField.attributedPlaceholder = [NSMutableAttributedString attributeStringWithText:cell.indexPath.row==0?@"例：开学报名优惠":@"200元" attributes:@[kGrayHex33,kFont12]];
}

- (void)ExamSendCell:(ExamSendCell *)cell textFieldDidBeginEdited:(UITextField *)textField;
{
//    textField.attributedPlaceholder = [NSMutableAttributedString attributeStringWithText:nil attributes:nil];
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
