//
//  EarnWindfallVC.m
//  Coach
//
//  Created by apple on 16/8/13.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EarnWindfallVC.h"
#import "EarnPublishVC.h"
#import "DealOrderViewController.h"
#import "EarnView.h"
#import "WindfallFirstCell.h"
#import "EarnAppointModel.h"
#import "EarnCalendarModel.h"
#import "WindfallSecondCell.h"
#import "WithfallView.h"

#import "EarnExtraFisrtCell.h"
#import "EarnExtraSecondCell.h"
#import "EarnExtraThirdCell.h"
#import "EarnExtraFourthCell.h"
#import "EarnExtraFifthCell.h"
#import "EarnOneCell.h"

#import "EarnCarListModel.h"
#import "SCDBManager.h"

#define DataBaseArray  @[@"id",@"carId",@"classId",@"end_time_hour",@"money",@"remaining",@"start_time_hour",@"state",@"studentMax",@"subjectId",@"tplId"]

//#import "GrayBackButton.h"

@interface EarnWindfallVC ()<UITableViewDelegate,UITableViewDataSource,WithfallViewDelegate,WindfallFirstCellDelegate,WindfallSecondCellDelegate,EarnExtraThirdCellDelegate,EarnExtraSecondCellDelegate,EarnExtraFifthCellDelegate,EarnExtraFourthCellDelegate,EarnOneCellDelegate>

@property (nonatomic, strong) UITableView * earnTableView;

@property (nonatomic, copy) NSString * appointNum;
@property (nonatomic, strong) NSMutableArray * templatesArray;
@property (nonatomic, strong) NSMutableArray * customArray;
@property (nonatomic, strong) NSMutableArray * calendarArray;
@property (nonatomic, strong)WithfallView * withfallView;

@property (nonatomic, strong) UITableView * addHoursTable;
@property (nonatomic, strong) UIButton *grayBackBtn;
@property (nonatomic, copy)NSString * type;

@property (nonatomic, strong) UITableView * carlistTable;
@property (nonatomic, strong) NSMutableArray * carlistDataArray;
@property (nonatomic, strong) UIButton * chooseCarlistBtn;

@property (nonatomic, assign)NSInteger windfallFirstIndex;
@property (nonatomic, assign)NSInteger windfallSecondIndex;

@property (nonatomic, strong)SCDBManager * manager;

@property (nonatomic, strong)EarnAppointModel * firstTypeModel;

@property (nonatomic, strong)EarnAppointModel * secondTypeModel;

@property (nonatomic, strong)NSMutableDictionary * customDict;

@property (nonatomic, strong) NSMutableArray * fmdbDataArray;

@property (nonatomic, strong) NSMutableArray * fmdbCustomArray;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation EarnWindfallVC

- (UITableView *)carlistTab
{
    if (!_carlistTable) {
        _carlistTable = [[UITableView alloc]initWithFrame:CGRectMake((kScreenWidth-292)/2+75, (kScreenHeight-390)/2+171, 84, 0) style:UITableViewStylePlain];
        _carlistTable.delegate = self;
        _carlistTable.dataSource = self;
    }
    return _carlistTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initWithUI
{
    [super initWithUI];
    
    [self createBackView];
    [self createHeadView];
    [self createFooterView];
    
    _manager = [SCDBManager shareInstance];
    //添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)initWithData
{
    [super initWithData];
    [self requestWithData];
}

- (void)createBackView
{
    self.title = @"赚外快";
    _currentIndex = 0;
    _templatesArray = [NSMutableArray array];
    _calendarArray = [NSMutableArray array];
    _customArray = [NSMutableArray array];
    
    _carlistDataArray = [NSMutableArray array];         //车型数组
    
    _fmdbDataArray = [NSMutableArray array];
    _customDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"0",@"carId",@"1",@"classId",@"",@"firstField",@"",@"secondField",@"",@"thirdField",@"",@"fourthField",@"",@"money",@"",@"remaining",@"1",@"state",@"",@"studentMax",@"1",@"subjectId",@"",@"tplId",nil];
    _fmdbCustomArray = [NSMutableArray array];
    
//    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(30, 5, 40, 20);
//    //    rightBtn.backgroundColor = [UIColor orangeColor];
//    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightBtn setTitle:@"去发布" forState:UIControlStateNormal];
//    rightBtn.titleLabel.font = Font13;
//    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    _earnTableView = [[UITableView alloc]initWithFrame:CGRectMake(0 , 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    _earnTableView.delegate = self;
    _earnTableView.dataSource = self;
    _earnTableView.showsVerticalScrollIndicator = NO;
    _earnTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_earnTableView];
    
    
}

- (void)createHeadView
{
    UIView * headView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 42+7+84+15)];
//    headView.backgroundColor = [UIColor redColor];
    _earnTableView.tableHeaderView = headView;
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 42)];
    topView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopView)];
    [topView addGestureRecognizer:tap];
    [headView addSubview:topView];
    
    UILabel * infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 13, 90, 16)];
    infoLabel.text = @"未处理的预约";
    infoLabel.textColor = rgb(81, 81, 81);
    infoLabel.font = Font15;
    [topView addSubview:infoLabel];
    
    UILabel * redLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-32-27, 12.5, 27, 17)];
    redLabel.backgroundColor = [UIColor colorWithHexString:@"#ff5d5d"];
//    redLabel.text = @"15";
    redLabel.text = _appointNum;
    redLabel.tag = 1;
    redLabel.layer.cornerRadius = 8.5;
    redLabel.layer.masksToBounds = YES;
    redLabel.textAlignment = NSTextAlignmentCenter;
    redLabel.textColor = [UIColor whiteColor];
    redLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    [topView addSubview:redLabel];
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-21, 13, 12, 16)];
    imageV.image = [UIImage imageNamed:@"card_arrow"];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [topView addSubview:imageV];
    
    
    
    //上面的选择
//    EarnView * earnView = [[EarnView alloc]initWithFrame:CGRectMake(0, 42+7, kScreenWidth, 72)];
//    earnView.backgroundColor = [UIColor whiteColor];
//    [headView addSubview:earnView];
    _withfallView = [[WithfallView alloc]initWithFrame:CGRectMake(0, 42+7, kScreenWidth, 85)];
    _withfallView.backgroundColor = [UIColor whiteColor];
    _withfallView.delegate = self;
    [headView addSubview:_withfallView];
}

- (void)createFooterView
{
    UIView * footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10+40+197+30)];
    footerView.backgroundColor = [UIColor whiteColor];
    _earnTableView.tableFooterView = footerView;
    
    UIButton * bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake((kScreenWidth-151)/2, 10, 151, 40);
    bottomBtn.backgroundColor = kAppThemeColor;
    [bottomBtn setTitle:@"自定义时段" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = Font13;
    bottomBtn.layer.cornerRadius = 20.0;
    [bottomBtn addTarget:self action:@selector(pressBottomBtn) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:bottomBtn];
    
//    UILabel * lineGrayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bottomBtn.frame)+20, kScreenWidth, 10)];
//    lineGrayLabel.backgroundColor = kBackgroundColor;
//    [footerView addSubview:lineGrayLabel];
    
    UIView * lineGrayView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bottomBtn.frame)+20, kScreenWidth, 80)];
    lineGrayView.backgroundColor = kBackgroundColor;
    [footerView addSubview:lineGrayView];
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(40, 20, kScreenWidth-80, 40);
    submitBtn.backgroundColor = kAppThemeColor;
    [submitBtn setTitle:@"一键发布" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = Font13;
    submitBtn.layer.cornerRadius = 20.0;
    [submitBtn addTarget:self action:@selector(pressSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    [lineGrayView addSubview:submitBtn];
    
    
    UILabel * firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, CGRectGetMaxY(lineGrayView.frame)+13, kScreenWidth, 15)];
    firstLabel.text = @"温馨提示：";
    firstLabel.textColor = rgb(136, 136, 136);
    firstLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [footerView
     addSubview:firstLabel];
    
    UIImageView * circleImageV = [[UIImageView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(firstLabel.frame)+23+5, 7, 7)];
    circleImageV.backgroundColor = rgb(134, 134, 134);
    circleImageV.layer.cornerRadius = 3.5;
    [footerView addSubview:circleImageV];
    
    UILabel * secondLabel = [[UILabel alloc]init];
    //    secondLabel.backgroundColor = [UIColor redColor];
    secondLabel.text = @"当自定义时段与系统推荐时段冲突时将以自定义时段为准。例：推荐时段为07:00-09:00和08:00-09:00，若自定义设置为07:30-08:30，则推荐时段会自动取消。";
    secondLabel.font = Font15;
    secondLabel.numberOfLines = 0;
    CGFloat contentH = [self sizeWithText:secondLabel.text font:Font15 maxSize:CGSizeMake(footerView.frame.size.width-50, CGFLOAT_MAX)].height;
    secondLabel.frame = CGRectMake(CGRectGetMaxX(circleImageV.frame)+8, CGRectGetMaxY(firstLabel.frame)+22, footerView.frame.size.width-50, contentH);
    secondLabel.textColor = rgb(83, 83, 83);
    [footerView addSubview:secondLabel];
}

- (void)requestWithData
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"deviceInfo"] = kDeviceInfo;
    param[@"time"] = kTimeStamp;
    param[@"date"] = [LLUtils dateStrWithTimeStamp:kTimeStamp dateFormat:@"yyyy-MM-dd"];
    param[@"sign"] = kSignWithIdentify(@"/appointment");
    
    [NetworkEngine postRequestWithRelativeAdd:@"/appointment" paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                
                //请求成功
                NSString * jstr = [LLUtils jsonStrWithJSONObject:jsonObj];
                NSString * str = [LLUtils replaceUnicode:jstr];
                NSLog(@"%@",str);
                
                _appointNum = jsonObj[@"info"][@"appointmentNum"];
                self.templatesArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:jsonObj[@"info"][@"templates"]];
                self.calendarArray = [EarnCalendarModel mj_objectArrayWithKeyValuesArray:jsonObj[@"info"][@"calendar"]];
                self.customArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:jsonObj[@"info"][@"custom"]];
                
                UILabel * label = [self.view viewWithTag:1];
                label.text = [NSString stringWithFormat:@"%@",_appointNum];
                _withfallView.dataArray = _calendarArray;
                [_earnTableView reloadData];
                
                
                if (!_windfallFirstIndex) {
                    [_manager dropTableWithName:@"templates0"];
                }
                
                //创建数据表格0
                [_manager createTableWithName:@"templates0" keyArr:DataBaseArray];
                
                for (int i=0; i<_templatesArray.count; i++) {
                    
                    EarnAppointModel * model = _templatesArray[i];
                    [_manager insertIntoTable:@"templates0" Values:intToStr(i),model.carId,model.classId,model.end_time_hour,model.money,model.remaining,model.start_time_hour,model.state,model.studentMax,model.subjectId,model.tplId,nil];
                }
                
                [_manager dropTableWithName:@"templates1"];
                
                //创建数据表格1
                [_manager createTableWithName:@"templates1" keyArr:DataBaseArray];
                for (int j = 0; j<_customArray.count; j++) {
                    EarnAppointModel * model = _customArray[j];
                    [_manager insertIntoTable:@"templates1" Values:intToStr(j),model.carId,model.classId,model.end_time_hour,model.money,model.remaining,model.start_time_hour,model.state,model.studentMax,model.subjectId,model.tplId,nil];
                }
                
//                [_manager dropTableWithName:@"templates1"];
                
                //                for (EarnAppointModel * model in _templatesArray) {
                ////                    NSLog(@"%@",model.carId);
                //                    [_manager insertIntoTable:@"templates0" Values:model.classId,model.end_time_hour,model.money,model.start_time_hour,model.state,model.studentMax,model.style,model.subjectId,model.tplId,nil];
                //                }
                
//                NSLog(@"~~%@~~",[_manager getAllObjectsFromTable:@"templates" KeyArr:@[@"carId",@"classId",@"end_time_hour",@"money",@"start_time_hour",@"state",@"studentMax",@"style",@"subjectId",@"tplId"]]);

            }else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                
                //需要登录
                [LLUtils showAlertWithTitle:jsonObj[@"msg"] message:nil delegate:self tag:10 type:AlertViewTypeOnlyConfirm];
            }
            else
            {
                
                //失败
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
        }
    }];
}


//去发布
//- (void)rightBtnAction
//{
//    EarnPublishVC * vc = [[EarnPublishVC alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}

//点击预约处理
- (void)tapTopView
{
    DealOrderViewController * dealOrderVC = [[DealOrderViewController alloc]init];
    [self.navigationController pushViewController:dealOrderVC animated:YES];
}

//点击底部自定义时段
- (void)pressBottomBtn
{
    _type = @"3";
//    [self createAddHoursTableViewWithType:@"3"];
}

#pragma mark -- WithfallViewDelegate                              //点击顶部时间选择
- (void)withfallViewDidSelectedIndex:(NSInteger)index
{
    _currentIndex = index;
}

#pragma mark -- WindfallFirstCellDelegate                         //点击模板的item
- (void)windfallFirstCell:(UITableViewCell *)cell withIndex:(NSInteger)index withState:(NSString *)state
{
    _windfallFirstIndex = index;
    _type = @"1";
    if ([state isEqualToString:@"1"] || [state isEqualToString:@"0"]) {
//        [self createAddHoursTableViewWithType:@"1"];
        [_addHoursTable reloadData];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此时间段不能设置" delegate:self cancelButtonTitle:@"朕知道了" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

#pragma mark -- WindfallSecondCellDelegate                //自定义时段
- (void)windfallSecondCell:(UITableViewCell *)cell withIndex:(NSInteger)index withState:(NSString *)state
{
    _windfallSecondIndex = index;
    _type = @"2";
    if ([state isEqualToString:@"1"] || [state isEqualToString:@"0"]) {
//        [self createAddHoursTableViewWithType:@"2"];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此时间段不能设置" delegate:self cancelButtonTitle:@"朕知道了" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}


- (void)createAddHoursTableViewWithType:(NSString *)type withState:(NSString *)state
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIButton *grayBackBtn = [[UIButton alloc] init];
    grayBackBtn.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    grayBackBtn.backgroundColor = [UIColor colorWithRed:25/255.0 green: 25/255.0 blue:25/255.0 alpha:0.5];
    //    clearBtn.backgroundColor = [UIColor brownColor];
    [window addSubview:grayBackBtn];
    [grayBackBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.grayBackBtn = grayBackBtn;
    
    _addHoursTable = [[UITableView alloc]initWithFrame:CGRectMake((kScreenWidth-292)/2, (kScreenHeight-390)/2, 292, 390) style:UITableViewStylePlain];
    _addHoursTable.delegate = self;
    _addHoursTable.dataSource = self;
    _addHoursTable.layer.cornerRadius = 8.0;
    _addHoursTable.scrollEnabled = NO;
    _addHoursTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [grayBackBtn addSubview:_addHoursTable];
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _addHoursTable.frame.size.width, 46)];
    //    topView.backgroundColor = [UIColor redColor];
    _addHoursTable.tableHeaderView = topView;
    
    UILabel * chooseLabel = [[UILabel alloc]initWithFrame:CGRectMake((topView.frame.size.width-80)/2, 15, 80, 16)];
    //    chooseLabel.backgroundColor = [UIColor orangeColor];
    chooseLabel.text = @"添加学时";
    chooseLabel.textColor = rgb(35, 105, 255);
    chooseLabel.font = Font18;
    [topView addSubview:chooseLabel];
    
    UIButton * cancelBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(topView.frame.size.width-15-15, 15, 15, 15);
    //    cancelBtn.backgroundColor = [UIColor redColor];
    cancelBtn.contentMode = UIViewContentModeScaleAspectFit;
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"earn_close"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancelBtn];
    
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(chooseLabel.frame)+14, topView.frame.size.width, 1)];
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"#b7d6ff"];
    [topView addSubview:lineLabel];
    
    UIView * downView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _addHoursTable.frame.size.width, 76)];
    downView.backgroundColor = [UIColor whiteColor];
    _addHoursTable.tableFooterView = downView;
    
    UIButton * saveBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake((_addHoursTable.frame.size.width-105)/2, 10, 105, 37);
    saveBtn.layer.cornerRadius = 18.5;
    saveBtn.titleLabel.font = Font15;
    saveBtn.backgroundColor = [UIColor colorWithHexString:@"#2e83ff"];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(pressSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:saveBtn];
    
    
    //添加下拉框
    [grayBackBtn addSubview:self.carlistTab];
}

- (void)cancelBtnClick
{
    [self.grayBackBtn removeFromSuperview];
}

//弹框的保存按钮
- (void)pressSaveBtn
{
    if ([_type isEqualToString:@"1"]) {
        
        _firstTypeModel.state = @"1";
        
        NSDictionary * firstDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                                    @(_windfallFirstIndex),@"id",
                                    _firstTypeModel.carId,@"carId",
                                    _firstTypeModel.classId,@"classId",
                               _firstTypeModel.end_time_hour,@"end_time_hour",
                                    _firstTypeModel.money,@"money",
                            _firstTypeModel.start_time_hour,@"start_time_hour",
                                    _firstTypeModel.state,@"state",
                                    _firstTypeModel.studentMax,@"studentMax",
                                    _firstTypeModel.subjectId,@"subjectId",
                                    _firstTypeModel.tplId,@"tplId"
                                    ,nil];
        
//        [_manager updateTable:@"templates0" setDic:firstDict WhereItsKey:@"id" IsValue:@(_windfallFirstIndex)];
        
//        [_manager updateTable:@"templates0" SetTargetKey:@"money" WithValue:_firstTypeModel.money WhereItsKey:@"id" IsValue:@(_windfallFirstIndex)];
        [_manager updateTable:@"templates0" TargetKeys:DataBaseArray TargetValues:@[integerToStr(_windfallFirstIndex),                                                                                               _firstTypeModel.carId,_firstTypeModel.classId,_firstTypeModel.end_time_hour,_firstTypeModel.money,_firstTypeModel.remaining,_firstTypeModel.start_time_hour,_firstTypeModel.state,_firstTypeModel.studentMax,_firstTypeModel.subjectId,_firstTypeModel.tplId] WhereItsKey:@"id" IsValue:integerToStr(_windfallFirstIndex)];
        
        NSLog(@"++%@++",firstDict);
        
        NSLog(@"~~%@~~",[_manager getAllObjectsFromTable:@"templates0" KeyArr:DataBaseArray]);
        
//        _fmdbDataArray = [[_manager getAllObjectsFromTable:@"templates0" KeyArr:@[@"id",@"carId",@"classId",@"end_time_hour",@"money",@"start_time_hour",@"state",@"studentMax",@"style",@"subjectId",@"tplId"]] mutableCopy];
        
        _fmdbDataArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getAllObjectsFromTable:@"templates0" KeyArr:DataBaseArray]];
        
    }else if ([_type isEqualToString:@"2"]){
        
    }else if ([_type isEqualToString:@"3"]){
        
        NSLog(@"**%@**",_customDict);
        
        _fmdbDataArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getAllObjectsFromTable:@"templates0" KeyArr:DataBaseArray]];
        
        NSString * startTimeStr = [NSString stringWithFormat:@"%@:%@",[_customDict objectForKey:@"firstField"],[_customDict objectForKey:@"secondField"]];
        NSString * endTimeStr = [NSString stringWithFormat:@"%@:%@",[_customDict objectForKey:@"thirdField"],[_customDict objectForKey:@"fourthField"]];
        
        EarnCalendarModel * calendarModel = _calendarArray[_currentIndex];
 
        NSString * str1 = [NSString stringWithFormat:@"%@-%@ %@:%@",calendarModel.year,calendarModel.date,[_customDict objectForKey:@"firstField"],[_customDict objectForKey:@"secondField"]];
        NSString * startStamp = [NSString stringWithFormat:@"%lld",[LLUtils timestampsWithDateStr:str1 dateFormat:[NSString stringWithFormat:@"yyyy-MM-dd hh:mm"]]];
        
        NSString * str2 = [NSString stringWithFormat:@"%@-%@ %@:%@",calendarModel.year,calendarModel.date,[_customDict objectForKey:@"thirdField"],[_customDict objectForKey:@"fourthField"]];
        NSString * endStamp = [NSString stringWithFormat:@"%lld",[LLUtils timestampsWithDateStr:str2 dateFormat:[NSString stringWithFormat:@"yyyy-MM-dd hh:mm"]]];
        
         NSLog(@"%@ , %@",endStamp,startStamp);
        for (int i=0; i<_fmdbDataArray.count; i++)
        {
            EarnAppointModel * model = _fmdbDataArray[i];
            if ([model.state isEqualToString:@"1"]) {
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"HH:mm"];
                NSString *dateString1 = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.start_time_hour doubleValue]]];
                
                NSString * dateString2 = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.end_time_hour doubleValue]]];
                
                int i = [self compareDate:dateString1 withDate:startTimeStr];
                int j = [self compareDate:startTimeStr withDate:dateString2];
                int k = [self compareDate:dateString1 withDate:endTimeStr];
                int m = [self compareDate:endTimeStr withDate:dateString2];
                
                NSLog(@"%d-%d-%d-%d",i,j,k,m);
                
                NSLog(@"车型：%@",[ _customDict objectForKey:@"carId"]);
                
                if (j == -1 || k == -1) {
//                    [_manager insertIntoTable:@"templates1" Values:integerToStr(i+_customArray.count),@"1",[_customDict objectForKey:@"classId"],endTimeStr,[_customDict objectForKey:@"money"],[_customDict objectForKey:@"remaining"],startTimeStr,[_customDict objectForKey:@"state"],[_customDict objectForKey:@"studentMax"],[_customDict objectForKey:@"subjectId"],[_customDict objectForKey:@"tplId"],nil];
//                _fmdbCustomArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getAllObjectsFromTable:@"templates1" KeyArr:DataBaseArray]];
                }else{
                    [_manager updateTable:@"templates0" SetTargetKey:@"state" WithValue:@"2" WhereItsKey:@"id" IsValue:intToStr(i)];
                }
            }
        }
        [_manager insertIntoTable:@"templates1" Values:integerToStr(_customArray.count),@"1",[_customDict objectForKey:@"classId"],endStamp,[_customDict objectForKey:@"money"],[_customDict objectForKey:@"remaining"],startStamp,[_customDict objectForKey:@"state"],[_customDict objectForKey:@"studentMax"],[_customDict objectForKey:@"subjectId"],[_customDict objectForKey:@"tplId"],nil];
        NSLog(@"%@ , %@",endStamp,startStamp);
//        @[@"id",@"carId",@"classId",@"end_time_hour",@"money",@"remaining",@"start_time_hour",@"state",@"studentMax",@"subjectId",@"tplId"]
//        [_manager insertIntoTable:@"templates1" Values:@"2",@"2",@"1",@"45545",@"212",@"12",@"123",@"1",@"20",@"1",@"0",nil];
        _fmdbCustomArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getAllObjectsFromTable:@"templates1" KeyArr:DataBaseArray]];
        
        
    }
    
    [self.grayBackBtn removeFromSuperview];
    [_earnTableView reloadData];
}

//一键发布
- (void)pressSubmitBtn
{
//    NSMutableArray *mutArr = [NSMutableArray array];
//    for (int i = 0; i < 3; i++) {
//        [mutArr addObject:@{{@"tplId":"1","startTime":1469577600,"endTime":1469581200,"subjectId":"2","classId":"C1","carId":"1","studentMax":"50","money":"50.00"},{"tplId":"1","startTime":1469581200,"endTime":1469584800,"subjectId":"2","classId":"C1","carId":"1","studentMax":"50","money":"50.00"}}];
//    }
//    NSString *jsonStr = [LLUtils jsonStrWithJSONObject:mutArr];
    
//    NSMutableArray * arr1 = [[_manager getAllValueInTable:@"templates0" KeyArr:DataBaseArray WhereItsKey:@"state" IsValue:@"1"] mutableCopy];
//    NSArray * arr2 = [_manager getAllValueInTable:@"templates1" KeyArr:DataBaseArray WhereItsKey:@"state" IsValue:@"1"];
//    [arr1 addObjectsFromArray:arr2];
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
//    param[@"content"] = [LLUtils jsonStrWithJSONObject:arr1];
    param[@"time"] = kTimeStamp;
    param[@"sign"] = kSignWithIdentify(@"/appointment/create");
    
    [NetworkEngine postRequestWithRelativeAdd:@"/appointment/create" paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                
                //请求成功
                [LLUtils showSuccessHudWithStatus:@"发布成功"];
                
            }else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                
                //需要登录
                [LLUtils showAlertWithTitle:jsonObj[@"msg"] message:nil delegate:self tag:10 type:AlertViewTypeOnlyConfirm];
            }
            else
            {
                
                //失败
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
        }
    }];
}


//选择车型
#pragma mark -- EarnExtraThirdCellDelegate
- (void)EarnExtraThirdCellClickChooseBtn
{
    if (_carlistTable.hidden == YES) {
        _carlistTable.hidden = NO;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"deviceInfo"] = kDeviceInfo;
    param[@"time"] = kTimeStamp;
    param[@"sign"] = kSignWithIdentify(@"/Car/carlist");
    
    [NetworkEngine postRequestWithRelativeAdd:@"/Car/carlist" paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                
                //请求成功
                NSString * jstr = [LLUtils jsonStrWithJSONObject:jsonObj];
                NSString * str = [LLUtils replaceUnicode:jstr];
                NSLog(@"%@",str);
                
                _carlistDataArray = [EarnCarListModel mj_objectArrayWithKeyValuesArray:jsonObj[@"info"][@"CarList"]];
                [_carlistTable reloadData];
                
            }else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                
                //需要登录
                [LLUtils showAlertWithTitle:jsonObj[@"msg"] message:nil delegate:self tag:10 type:AlertViewTypeOnlyConfirm];
            }
            else
            {
                
                //失败
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
        }
    }];

    
//    NSArray * arr = @[@"捷达",@"大众",@"奇瑞",@"江淮"];
//    [_carlistDataArray addObjectsFromArray:arr];
    
    _carlistTable.frame = CGRectMake((kScreenWidth-292)/2+75, (kScreenHeight-390)/2+171-_addHoursTable.contentOffset.y, 84, 90);
//    _carlistTable.frame = CGRectMake((kScreenWidth-292)/2+75, (kScreenHeight-390)/2+171+_carlistTable.contentOffset.y, 84, 120);
    [_carlistTable reloadData];
    
}
//车型       EarnExtraThirdCellDelegate
- (void)EarnExtraThirdCellVehicleTypeBtn:(NSString *)str
{
    if ([str isEqualToString:@"C1"]) {
        NSLog(@"C1");
        if ([_type isEqualToString:@"1"]) {
            _firstTypeModel.classId = @"1";
        }else if ([_type isEqualToString:@"2"]){
            
        }else if ([_type isEqualToString:@"3"]){
            [_customDict setObject:@"1" forKey:@"classId"];
        }
    }else if ([str isEqualToString:@"C2"]){
        NSLog(@"C2");
        if ([_type isEqualToString:@"1"]) {
            _firstTypeModel.classId = @"2";
        }else if ([_type isEqualToString:@"2"]){
            
        }else if ([_type isEqualToString:@"3"]){
            [_customDict setObject:@"2" forKey:@"classId"];
        }
    }
}

#pragma mark -- EarnOneCellDelegate
- (void)EarnOneCellTF:(UITextField *)textField
{
    switch (textField.tag) {
        case 10:
        {
            [_customDict setObject:textField.text forKey:@"firstField"];
        }
            break;
        case 20:
        {
            [_customDict setObject:textField.text forKey:@"secondField"];
        }
            break;
        case 30:
        {
            [_customDict setObject:textField.text forKey:@"thirdField"];
        }
            break;
        case 40:
        {
            [_customDict setObject:textField.text forKey:@"fourthField"];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- EarnExtraSecondCellDelegate                  //科目
- (void)EarnExtraSecondCellSubjectBtn:(NSString *)str
{
    if ([str isEqualToString:@"科目二"]) {
        NSLog(@"科目二");
        if ([_type isEqualToString:@"1"]) {
            _firstTypeModel.subjectId = @"1";
        }else if ([_type isEqualToString:@"2"]){
            
        }else if ([_type isEqualToString:@"3"]){
            [_customDict setObject:@"1" forKey:@"subjectId"];
        }
    }else if ([str isEqualToString:@"科目三"]){
        NSLog(@"科目三");
        if ([_type isEqualToString:@"1"]) {
            _firstTypeModel.subjectId = @"2";
        }else if ([_type isEqualToString:@"2"]){
            
        }else if ([_type isEqualToString:@"3"]){
            [_customDict setObject:@"2" forKey:@"subjectId"];
        }
    }
}

#pragma  mark -- EarnExtraFourthCellDelegate                //人数   价格
- (void)EarnExtraFourthCellPersonNumTF:(NSString *)str withTextfield:(UITextField *)field
{
    
    if ([str isEqualToString:@"人数"]) {
        if ([_type isEqualToString:@"1"]) {
            _firstTypeModel.studentMax = field.text;
            
        }else if ([_type isEqualToString:@"2"]){
            
        }else if ([_type isEqualToString:@"3"]){
            [_customDict setObject:field.text forKey:@"studentMax"];
        }
        
    }else if ([str isEqualToString:@"价格"]){
        if ([_type isEqualToString:@"1"]) {
            _firstTypeModel.money = field.text;
            
        }else if ([_type isEqualToString:@"2"]){
            
        }else if ([_type isEqualToString:@"3"]){
            [_customDict setObject:field.text forKey:@"money"];
        }
    }
}


#pragma mark -- EarnExtraFifthCellDelegate                  //同步
-(void)EarnExtraFifthCellOneBtn:(NSString *)str
{
    if ([str isEqualToString:@"Yes"]) {
        NSLog(@"同步");
    }else if ([str isEqualToString:@"NO"]){
        NSLog(@"不同步");
    }
}





#pragma mark -- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _earnTableView) {
        return 2;
    }else if (tableView == _addHoursTable){
        return 1;
    }else if (tableView == _carlistTable){
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _earnTableView) {
        if (indexPath.section == 0) {
            return ceil(_templatesArray.count/3.0)*75+10;
        }else{
            if(_fmdbCustomArray.count){
                return ceil(_fmdbCustomArray.count/3.0)*75+10;
            }else{
                return ceil(_customArray.count/3.0)*75+10;
            }
        }
    }else if(tableView == _addHoursTable){
        if(indexPath.row == 5){
            return 60;
        }else{
            return 44;
        }
    }else if (tableView == _carlistTable){
        return 30.f;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _earnTableView) {
        if (section == 0) {
            return 1;
        }else if (section == 1){
            return 1;
        }
    }else if(tableView == _addHoursTable){
        if ([_type isEqualToString:@"3"]) {
            return 6;
        }else{
            return 5;
        }
    }else if (tableView == _carlistTable){
        return _calendarArray.count;
//        return 4;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _earnTableView) {
        if (section == 1) {
            return 54.5;
        }else{
            return 0.01;
        }
    }else if (tableView == _addHoursTable){
        
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _earnTableView) {
        if(section == 1){
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 54.5)];
            view.backgroundColor = [UIColor whiteColor];
            
            UILabel * seperateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
            seperateLabel.backgroundColor = kBackgroundColor;
            [view addSubview:seperateLabel];
            
            UILabel * customLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(seperateLabel.frame), 200, 44)];
            customLabel.text = @"自定义时段：";
            customLabel.font = Font13;
            //        customLabel.backgroundColor = [UIColor greenColor];
            [view addSubview:customLabel];
            
            UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(customLabel.frame), kScreenWidth, 0.5)];
            lineLabel.backgroundColor = RGBCOLOR(214, 214, 214);
            [view addSubview:lineLabel];
            return view;
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _earnTableView) {
        if (indexPath.section == 0) {
            static NSString * string = @"fallCellOne";            //
            WindfallFirstCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (cell == nil) {
                cell = [[WindfallFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
            cell.deleagte = self;
//            cell.index = indexPath.item;
            if (_windfallFirstIndex) {
                cell.dataArray = _fmdbDataArray;
            }else{
                cell.dataArray = _templatesArray;
            }
            //        cell.backgroundColor = [UIColor orangeColor];
            return cell;
        }else if(indexPath.section == 1){
            static NSString * string = @"fallCellTwo";          //自定义时段cell
            WindfallSecondCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (cell == nil) {
                cell = [[WindfallSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
//            cell.index = indexPath.row;
            cell.delegate = self;
            if (_fmdbCustomArray.count) {
                cell.dataArray = _fmdbCustomArray;
            }else
            {
                cell.dataArray = _customArray;
            }
            
//            if (_windfallFirstIndex) {
//                cell.dataArray = _fmdbDataArray;
//            }else{
//                cell.dataArray = _customArray;
//            }
            //        cell.contentView.backgroundColor = [UIColor greenColor];
            return cell;
        }else{
            static NSString * string = @"fallCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
            return cell;
        }
    }else if (tableView == _addHoursTable){
        EarnAppointModel * model = _templatesArray[_windfallFirstIndex];
        
        if (indexPath.row == 0) {
            
            if ([_type isEqualToString:@"1"]) {
                
                _firstTypeModel = model;                  //存第一个改的数据
                
                static NSString * string = @"extraCellone";         //时段
                EarnExtraFisrtCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"EarnExtraFisrtCell" owner:self options:nil]lastObject];
                }
                
                cell.model = model;
                return cell;
            }else if ([_type isEqualToString:@"2"] || [_type isEqualToString:@"3"]){
                
                                //存自定义的数据
                
                static NSString * string = @"extraCellONE";       //手动输入时段
                EarnOneCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"EarnOneCell" owner:self options:nil]lastObject];
                }
                if ([_type isEqualToString:@"2"]) {
                    _secondTypeModel = model;
                }else if ([_type isEqualToString:@"3"]){
                    cell.firstTF.text = @"";
                    cell.secondTF.text = @"";
                    cell.thirdTF.text = @"";
                    cell.fourthTF.text = @"";
                }
                cell.delegate = self;
                cell.backgroundColor = [UIColor whiteColor];
                return cell;
            }
        }
        else if (indexPath.row == 1){
            
            static NSString * string = @"extraCelltwo";           //科目
            EarnExtraSecondCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"EarnExtraSecondCell" owner:self options:nil]lastObject];
            }
            cell.delagate = self;
            if ([_type isEqualToString:@"1"]) {
                cell.model = model;
            }else{
                
            }
            
            //        cell.backgroundColor = [UIColor cyanColor];
            return cell;
            
        }else if (indexPath.row == 2){
            
            static NSString * string = @"extraCellthree";          //车型
            EarnExtraThirdCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"EarnExtraThirdCell" owner:self options:nil]lastObject];
            }
            cell.delegate = self;
            if ([_type isEqualToString:@"1"]) {
                cell.model = model;
            }else{
                
            }
//            if (_chooseCarlistBtn) {
//                cell.chooseBtn.titleLabel.text = _chooseCarlistBtn.titleLabel.text;
//            }else{
//                cell.chooseBtn.titleLabel.text = @"可可";
//            }
            _chooseCarlistBtn = cell.chooseBtn;
            return cell;
            
        }else if(indexPath.row == 3){
            
            static NSString * string = @"extraCellfour";           //人数
            EarnExtraFourthCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"EarnExtraFourthCell" owner:self options:nil]lastObject];
            }
            cell.infoStr = @"人数";
            if ([_type isEqualToString:@"1"]) {
                cell.model = model;
            }else{
                cell.personNumTF.text = @"";
            }
            cell.delegate = self;
//            cell.model = model;
//            cell.personNumTF.text = model.studentMax;
            return cell;
        }else if(indexPath.row == 4){
            
            static NSString * string = @"extraCellfive";           //价格
            EarnExtraFourthCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"EarnExtraFourthCell" owner:self options:nil]lastObject];
            }
            cell.delegate = self;
            cell.infoLabel.text = @"价格:";
            cell.personLabel.text = @"元/人";
            cell.infoStr = @"价格";
            if ([_type isEqualToString:@"1"]) {
                cell.model = model;
            }else{
                cell.personNumTF.text = @"";
            }
//            cell.personNumTF.text = model.money;
//            cell.model = model;
            return cell;
        }else{
//
            static NSString * string = @"extraCellsix";            //同步
            EarnExtraFifthCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"EarnExtraFifthCell" owner:self options:nil]lastObject];
            }
            cell.delegate = self;
            return cell;
        }
    }else if (tableView == _carlistTable){
        static NSString * string = @"cell";                      //车型列表
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }

        cell.textLabel.textColor = [UIColor colorWithHexString:@"#646464"];
        if (_carlistDataArray.count >0) {
            EarnCarListModel * model = _carlistDataArray[indexPath.row];
            cell.textLabel.text = model.car_name;
        }
        
//        cell.textLabel.text = @"什么鬼";
//        cell.backgroundColor = [UIColor cyanColor];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (tableView == _carlistTable) {
        EarnCarListModel * model = _carlistDataArray[indexPath.row];
//        _chooseCarlistBtn.titleLabel.text = _carlistDataArray[indexPath.row];
        [_chooseCarlistBtn setTitle:model.car_name forState:UIControlStateNormal];
        [UIView animateWithDuration:3.0 animations:^{
//            NSLog(@"click了carlistTable");
            [_carlistTable setHidden:YES];
        }];
    }
    
}

#pragma mark -键盘的通知
/**
 *  键盘即将显示
 */
-(void)kbWillShow:(NSNotification *)noti
{
    [UIView animateWithDuration:3.0 animations:^{
        [_carlistTable setHidden:YES];
    }];
}

/**
 *  键盘即将隐藏
 */
-(void)kbWillHide:(NSNotification *)noti
{
//    [_tableView setContentOffset:CGPointMake(0.f, 0.f) animated:YES];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//根据字数计算高度
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

//比较日期的方法
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"yyyy-MM-dd"];
    [df setDateFormat:@"HH:mm"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
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
