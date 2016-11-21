//
//  EarnExtraMoneyController.m
//  Coach
//
//  Created by apple on 16/7/15.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EarnExtraMoneyController.h"
#import "EarnPublishVC.h"
#import "DealOrderViewController.h"
//#import "EarnView.h"
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
//#import "SCDBManager.h"
#import "SCExtraDBManager.h"
#import "EarnExtraOneCell.h"
#import "ZHPickView.h"

#define DataBaseArray  @[@"id",@"dateStr",@"carId",@"classId",@"end_time_hour",@"money",@"remaining",@"start_time_hour",@"state",@"studentMax",@"subjectId",@"tplId"]

#define ExtraDataBaseArray @[@"carId",@"classId",@"money",@"state",@"studentMax",@"subjectId"]
#define AdditionalDataArray @[@"carId",@"classId",@"end_time_hour",@"money",@"start_time_hour",@"studentMax",@"subjectId"]

#define ChartName @"getExtraMoney"

//#import "GrayBackButton.h"

@interface EarnExtraMoneyController ()<UITableViewDelegate,UITableViewDataSource,WithfallViewDelegate,WindfallFirstCellDelegate,WindfallSecondCellDelegate,EarnExtraThirdCellDelegate,EarnExtraSecondCellDelegate,EarnExtraFifthCellDelegate,EarnExtraFourthCellDelegate,EarnOneCellDelegate,EarnExtraOneCellDelegate,UIAlertViewDelegate,ZHPickViewDelegate>

@property (nonatomic, strong) UITableView * earnTableView;

@property (nonatomic, copy) NSString * appointNum;
//@property (nonatomic, strong) NSMutableArray * templatesArray;
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

//@property (nonatomic, strong)SCDBManager * manager;
@property (nonatomic, strong)SCExtraDBManager * manager;

@property (nonatomic, strong)EarnAppointModel * firstTypeModel;

@property (nonatomic, strong)EarnAppointModel * secondTypeModel;

@property (nonatomic, strong)NSMutableDictionary * customDict;

@property (nonatomic, strong)NSMutableDictionary * secondCustomDict;

@property (nonatomic, strong) NSMutableArray * fmdbDataArray;

@property (nonatomic, strong) NSMutableArray * fmdbCustomArray;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSString * currentDate;

@property (nonatomic, strong) NSString * receiveNoti;

@property (nonatomic, strong) UIButton * startTimeBtn;

@property (nonatomic, strong) UIButton * endTimeBtn;

@property (nonatomic, strong) NSString * startTimeText;

@property (nonatomic, strong) NSString * endTimeText;

@property (nonatomic, strong)ZHPickView * fromPickView;
@property (nonatomic, strong) ZHPickView * toPickView;
@property (nonatomic, assign) NSInteger startMin;
@property (nonatomic, assign) NSInteger toMin;


//@property (nonatomic, strong) NSMutableArray * secondFmdbArray;

@end

BOOL _isCanClick = NO;

BOOL _isScrollEnd;

@implementation EarnExtraMoneyController

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
    
//    if (!_windfallFirstIndex) {
        [_manager dropTableWithName:ChartName];
//    }
    
    // Do any additional setup after loading the view.
}

- (void)initWithUI
{
    [super initWithUI];
    
    _isScrollEnd = NO;
    
    [self getCarList];
    
    [self createBackView];
    [self createHeadView];
    [self createFooterView];
    
    _manager = [SCExtraDBManager shareInstance];
    //添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //删除预约
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DealOrderRefuse:) name:@"DealOrderRefuse" object:nil];
    
}

- (void)initWithData
{
    [super initWithData];
    [self requestWithData];
//    [self writeToFmdbDataList];
}

- (void)DealOrderRefuse:(NSNotification *)noti{
    NSDictionary *infoDic = noti.userInfo ;
    _receiveNoti = @"YES";
    [_manager deleteFromTable:ChartName TargetKey:@"dateStr" TargetValue:infoDic[@"time"]];
    if ([_currentDate isEqualToString:infoDic[@"time"]]) {
        [self requestWithData];
    }

}

- (void)getCarList
{
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

- (void)createBackView
{
    self.title = @"赚外快";
    _currentIndex = 0;
//    _templatesArray = [NSMutableArray array];
    _calendarArray = [NSMutableArray array];
    _customArray = [NSMutableArray array];
    
    _carlistDataArray = [NSMutableArray array];         //车型数组
    
    _fmdbDataArray = [NSMutableArray array];

    _customDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"1",@"carId",@"1",@"classId",@"",@"startTF",@"",@"endTF",@"",@"money",@"",@"remaining",@"1",@"state",@"",@"studentMax",@"1",@"subjectId",@"0",@"tplId",nil];
    _secondCustomDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"0",@"carId",@"1",@"classId",@"",@"startTF",@"",@"endTF",@"",@"money",@"",@"remaining",@"1",@"state",@"",@"studentMax",@"1",@"subjectId",@"0",@"tplId",nil];
    _fmdbCustomArray = [NSMutableArray array];
    
    
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
    
    UILabel * infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 13, 100, 16)];
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
    _withfallView = [[WithfallView alloc]initWithFrame:CGRectMake(0, 42+7, kScreenWidth, 85)];
    _withfallView.backgroundColor = [UIColor whiteColor];
    _withfallView.delegate = self;
    [headView addSubview:_withfallView];
}

- (void)createFooterView
{
    UIView * footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10+40+197+80+30)];
    footerView.backgroundColor = [UIColor whiteColor];
    _earnTableView.tableFooterView = footerView;
    
    UIButton * bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake((kScreenWidth-280)/3, 10, 140, 40);
    bottomBtn.backgroundColor = kAppThemeColor;
    [bottomBtn setTitle:@"自定义时段" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = Font13;
    bottomBtn.layer.cornerRadius = 20.0;
    [bottomBtn addTarget:self action:@selector(pressBottomBtn) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:bottomBtn];
    
    UIButton * resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetBtn.frame = CGRectMake((kScreenWidth-280)*2/3+140, 10, 140, 40);
    resetBtn.backgroundColor = kAppThemeColor;
    [resetBtn setTitle:@"重新设置" forState:UIControlStateNormal];
    [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resetBtn.titleLabel.font = Font13;
    resetBtn.layer.cornerRadius = 20.0;
    [resetBtn addTarget:self action:@selector(pressResetBtn) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:resetBtn];
    
    
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

- (void)pressResetBtn
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"重新设置将清空当日未发布的学时，是否重新设置？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alertView.tag = 1010;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1010) {
        if (buttonIndex == 1) {
            NSLog(@"是的");
            [_manager deleteFromTable:ChartName TargetKey:@"dateStr" TargetValue:_currentDate];
            [self requestWithData];
        }
    }
}

#pragma mark -- 加载界面数据请求
- (void)requestWithData
{
    _withfallView.userInteractionEnabled = NO;
    _isCanClick = NO;
    if ([_receiveNoti isEqualToString:@"YES"]) {
        _receiveNoti = @"NO";
    }else{
//        [LLUtils showTextAndProgressHud:@"加载中"];
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"deviceInfo"] = kDeviceInfo;
    param[@"time"] = kTimeStamp;
//
    if (_currentDate) {
        param[@"date"] = _currentDate;
    }else{
        param[@"date"] = [LLUtils dateStrWithTimeStamp:kTimeStamp dateFormat:@"yyyy-MM-dd"];
    }
    
    param[@"sign"] = kSignWithIdentify(@"/appointment");
    
    __block long long requestFlag = _currentIndex;
    
    [NetworkEngine postRequestWithRelativeAdd:@"/appointment" paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
        [LLUtils dismiss];
        if (isSuccess) {
            if (requestFlag != _currentIndex) {
                NSLog(@"双击");
                return ;
            }
            
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                
                //请求成功
                NSString * jstr = [LLUtils jsonStrWithJSONObject:jsonObj];
                NSString * str = [LLUtils replaceUnicode:jstr];
                NSLog(@"%@",str);
                
                _appointNum = jsonObj[@"info"][@"appointmentNum"];
                _fmdbDataArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:jsonObj[@"info"][@"templates"]];
                self.calendarArray = [EarnCalendarModel mj_objectArrayWithKeyValuesArray:jsonObj[@"info"][@"calendar"]];
                self.customArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:jsonObj[@"info"][@"custom"]];
                
                UILabel * label = [self.view viewWithTag:1];
                label.text = [NSString stringWithFormat:@"%@",_appointNum];
                _withfallView.dataArray = [_calendarArray mutableCopy];
//                [_earnTableView reloadSection:[NSIndexPath indexPathForRow:0 inSection:1] withRowAnimation:YES];
//                [_earnTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationFade];
//                [_earnTableView reloadSection:1 withRowAnimation:UITableViewRowAnimationFade];
                [_earnTableView reloadData];
                
                
                
                EarnCalendarModel * calendarModel = _calendarArray[_currentIndex];
                _currentDate = [NSString stringWithFormat:@"%@-%@",calendarModel.year,calendarModel.date];
            
                
                //创建数据表格0
                [_manager createTableWithName:ChartName keyArr:DataBaseArray];
                
                for (int i=0; i<_fmdbDataArray.count; i++) {
                    
//                    EarnAppointModel * model = _templatesArray[i];
                    EarnAppointModel * model = _fmdbDataArray[i];
                    NSString * keyStr = [NSString stringWithFormat:@"%@%@",model.start_time_hour,model.tplId];
                    [_manager insertIntoTable:ChartName Values:keyStr,_currentDate,model.carId,model.classId,model.end_time_hour,model.money,model.remaining,model.start_time_hour,model.state,model.studentMax,model.subjectId,model.tplId,nil];
                }
                
                [kUserDefault setObject:[NSString stringWithFormat:@"%lu",(unsigned long)_fmdbDataArray.count] forKey:@"CoachTemplatesNum"];
                
                for (int i=0; i<_customArray.count; i++) {
                    
                    EarnAppointModel * model = _customArray[i];
                    NSString * keyStr = [NSString stringWithFormat:@"%@%@",model.start_time_hour,model.tplId];
                    [_manager insertIntoTable:ChartName Values:keyStr,_currentDate,model.carId,model.classId,model.end_time_hour,model.money,model.remaining,model.start_time_hour,model.state,model.studentMax,model.subjectId,model.tplId,nil];
                }
                
                _fmdbDataArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getNOCrossAllObjectsFromTable:ChartName KeyArr:DataBaseArray WhereItsNOKey:@"tplId" IsNOValue:@"0" andkey:@"dateStr" value:_currentDate]]];
                
                _fmdbCustomArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getCrossAllObjectsFromTable:ChartName KeyArr:DataBaseArray WhereItsKey:@"tplId" IsValue:@"0" andkey:@"dateStr" value:_currentDate]]];
                
                
            }else if([jsonObj[@"code"] isEqualToNumber:@(2)])
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
        _withfallView.userInteractionEnabled = YES;
        _isCanClick = _isScrollEnd;
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
    [self createAddHoursTableViewWithType:@"3" withState:@"0"];
}

#pragma mark -- WithfallViewDelegate                              //点击顶部时间选择

- (void)WithfallView:(WithfallView *)view collectionViewScrollBeginOrEnd:(BOOL)isEnd
{
    _isScrollEnd = isEnd;
    _isCanClick = _isScrollEnd;
//    NSLog(@"%d-----",_isScrollEnd);
}

- (void)withfallViewDidSelectedIndex:(NSInteger)index
{
    _withfallView.userInteractionEnabled = NO;
    _isCanClick = NO;
    _currentIndex = index;
    EarnCalendarModel * model = _calendarArray[index];
    _currentDate = [NSString stringWithFormat:@"%@-%@",model.year,model.date];
    NSLog(@"日期是~~%@~~",_currentDate);
    _fmdbDataArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getNOCrossAllObjectsFromTable:ChartName KeyArr:DataBaseArray WhereItsNOKey:@"tplId" IsNOValue:@"0" andkey:@"dateStr" value:_currentDate]]];
    
    _fmdbCustomArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getCrossAllObjectsFromTable:ChartName KeyArr:DataBaseArray WhereItsKey:@"tplId" IsValue:@"0" andkey:@"dateStr" value:_currentDate]]];
    if(_fmdbDataArray.count>0){
        [_earnTableView reloadData];
        _withfallView.userInteractionEnabled = YES;
        _isCanClick = _isScrollEnd;
    }else{
        [self requestWithData];
    }
//    _withfallView.userInteractionEnabled = YES;

}

#pragma mark -- WindfallFirstCellDelegate                         //点击模板的item
- (void)windfallFirstCell:(UITableViewCell *)cell withIndex:(NSInteger)index withState:(NSString *)state
{
    if (_isCanClick == YES) {
        _windfallFirstIndex = index;
        _type = @"1";
        if ([state isEqualToString:@"1"] || [state isEqualToString:@"0"]) {
            [self createAddHoursTableViewWithType:@"1" withState:state];
            [_addHoursTable reloadData];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此时间段不能设置" delegate:self cancelButtonTitle:@"朕知道了" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }else{
        
    }
    
}

#pragma mark -- WindfallSecondCellDelegate                //自定义时段cell
- (void)windfallSecondCell:(UITableViewCell *)cell withIndex:(NSInteger)index withState:(NSString *)state
{
    if (_isCanClick == YES) {
        _windfallSecondIndex = index;
        _type = @"2";
        if ([state isEqualToString:@"1"] || [state isEqualToString:@"0"]) {
            EarnAppointModel * model = _fmdbCustomArray[_windfallSecondIndex];
            NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
            [dateFormat1 setDateFormat:@"HH"];
            NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
            [dateFormat2 setDateFormat:@"mm"];
            NSString *dateString1 = [dateFormat1 stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.start_time_hour doubleValue]]];
            NSString *dateString2 = [dateFormat2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.start_time_hour doubleValue]]];
            NSString * dateString3 = [dateFormat1 stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.end_time_hour doubleValue]]];
            NSString *dateString4 = [dateFormat2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.end_time_hour doubleValue]]];
            //        [_secondCustomDict setObject:dateString1 forKey:@"firstField"];
            //        [_secondCustomDict setObject:dateString2 forKey:@"secondField"];
            //        [_secondCustomDict setObject:dateString3 forKey:@"thirdField"];
            //        [_secondCustomDict setObject:dateString4 forKey:@"fourthField"];
            NSDateFormatter *dateFormatStr = [[NSDateFormatter alloc] init];
            [dateFormatStr setDateFormat:@"HH:mm"];
            NSString *dateStringStr1 = [dateFormatStr stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.start_time_hour doubleValue]]];
            NSString *dateStringStr2 = [dateFormatStr stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.end_time_hour doubleValue]]];
            [_secondCustomDict setObject:dateStringStr1 forKey:@"startTF"];
            [_secondCustomDict setObject:dateStringStr2 forKey:@"endTF"];
            _endTimeText = dateStringStr2;
            _startTimeText = dateStringStr1;
            
            _startMin = [dateString1 intValue]*60+[dateString2 intValue];
            
            _toMin = [dateString3 intValue]*60+[dateString4 intValue];
            
            [_secondCustomDict setObject:model.carId forKey:@"carId"];
            [_secondCustomDict setObject:model.classId forKey:@"classId"];
            [_secondCustomDict setObject:model.subjectId forKey:@"subjectId"];
            [_secondCustomDict setObject:model.studentMax forKey:@"studentMax"];
            [_secondCustomDict setObject:model.money forKey:@"money"];
            [self createAddHoursTableViewWithType:@"2" withState:state];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此时间段不能设置" delegate:self cancelButtonTitle:@"朕知道了" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }else{
        
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
    
    if([state isEqualToString:@"1"]){
        UIButton * saveBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake((_addHoursTable.frame.size.width-105-105)/3, 10, 105, 37);
        saveBtn.layer.cornerRadius = 18.5;
        saveBtn.titleLabel.font = Font15;
        saveBtn.backgroundColor = [UIColor colorWithHexString:@"#2e83ff"];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(pressSaveBtn) forControlEvents:UIControlEventTouchUpInside];
        [downView addSubview:saveBtn];
        
        UIButton * cancelBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake((_addHoursTable.frame.size.width-105-105)*2/3+105, 10, 105, 37);
        cancelBtn.layer.cornerRadius = 18.5;
        cancelBtn.titleLabel.font = Font15;
        cancelBtn.backgroundColor = [UIColor colorWithHexString:@"#2e83ff"];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(pressCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [downView addSubview:cancelBtn];
        
    }else{
        UIButton * saveBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake((_addHoursTable.frame.size.width-105)/2, 10, 105, 37);
        saveBtn.layer.cornerRadius = 18.5;
        saveBtn.titleLabel.font = Font15;
        saveBtn.backgroundColor = [UIColor colorWithHexString:@"#2e83ff"];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(pressSaveBtn) forControlEvents:UIControlEventTouchUpInside];
        [downView addSubview:saveBtn];
    }
    
    
    
    
    //添加下拉框
    [grayBackBtn addSubview:self.carlistTab];
}

- (void)cancelBtnClick
{
    [_carlistTable setHidden:YES];
    [self.grayBackBtn removeFromSuperview];
}

//弹框的取消按钮
- (void)pressCancelBtn
{
    if ([_type isEqualToString:@"1"]) {
        _fmdbDataArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getNOCrossAllObjectsFromTable:ChartName KeyArr:DataBaseArray WhereItsNOKey:@"tplId" IsNOValue:@"0" andkey:@"dateStr" value:_currentDate]]];
        EarnAppointModel * model = _fmdbDataArray[_windfallFirstIndex];
        [_manager updateTable:ChartName SetTargetKey:@"state" WithValue:@"0" WhereItsKey:@"id" IsValue:[NSString stringWithFormat:@"%@%@",model.start_time_hour,model.tplId]];
        _fmdbDataArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getNOCrossAllObjectsFromTable:ChartName KeyArr:DataBaseArray WhereItsNOKey:@"tplId" IsNOValue:@"0" andkey:@"dateStr" value:_currentDate]]];;
        
    }else if([_type isEqualToString:@"2"]){
        _fmdbCustomArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getCrossAllObjectsFromTable:ChartName KeyArr:DataBaseArray WhereItsKey:@"tplId" IsValue:@"0" andkey:@"dateStr" value:_currentDate]]];
        EarnAppointModel * model = _fmdbCustomArray[_windfallSecondIndex];
        [_manager deleteFromTable:ChartName TargetKey:@"id" TargetValue:[NSString stringWithFormat:@"%@%@",model.start_time_hour,model.tplId]];
        
        
//        NSArray * allNotArr = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getNOCrossAllObjectsFromTable:ChartName KeyArr:DataBaseArray WhereItsNOKey:@"id" IsNOValue:[NSString stringWithFormat:@"%@%@",model.start_time_hour,model.tplId] andkey:@"dateStr" value:_currentDate]];
//        
////        NSLog(@"%@ , %@",endStamp,startStamp);
//        for (int i=0; i<allNotArr.count; i++)
//        {
//            EarnAppointModel * model = allNotArr[i];
////            if ([model.state isEqualToString:@"1"]) {
//                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//                [dateFormat setDateFormat:@"HH:mm"];
//                NSString *dateString1 = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.start_time_hour doubleValue]]];
//                
//                NSString * dateString2 = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.end_time_hour doubleValue]]];
//                
//                int i = [self compareDate:dateString1 withDate:model.start_time_hour];
//                int j = [self compareDate:model.start_time_hour withDate:dateString2];
//                int k = [self compareDate:dateString1 withDate:model.end_time_hour];
//                int m = [self compareDate:model.end_time_hour withDate:dateString2];
//                
//                NSLog(@"%d-%d-%d-%d",i,j,k,m);
//                
//                NSLog(@"车型：%@",[ _secondCustomDict objectForKey:@"carId"]);
//                
//                if (j == -1 || j == 0 || k == -1 || k==0) {
//                    
//                    [_manager updateTable:ChartName SetTargetKey:@"state" WithValue:@"0" WhereItsKey:@"id" IsValue:[NSString stringWithFormat:@"%@%@",model.start_time_hour,model.tplId]];
//                    
//                }else{
//                    
//                }
//            }
////        }
//        _fmdbDataArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getNOCrossAllObjectsFromTable:ChartName KeyArr:DataBaseArray WhereItsNOKey:@"tplId" IsNOValue:@"0" andkey:@"dateStr" value:_currentDate]];

//        _fmdbCustomArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getCrossAllObjectsFromTable:ChartName KeyArr:DataBaseArray WhereItsKey:@"tplId" IsValue:@"0" andkey:@"dateStr" value:_currentDate]];
        
        
        _fmdbCustomArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getCrossAllObjectsFromTable:ChartName KeyArr:DataBaseArray WhereItsKey:@"tplId" IsValue:@"0" andkey:@"dateStr" value:_currentDate]]];
    }
    
    [self.grayBackBtn removeFromSuperview];
    [_earnTableView reloadData];
    
    
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

        NSString * keyValueStr = [NSString stringWithFormat:@"%@%@",_firstTypeModel.start_time_hour,_firstTypeModel.tplId];
        
        NSArray * stampArr = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getCrossAllObjectsFromTable:ChartName KeyArr:DataBaseArray WhereItsKey:@"tplId" IsValue:@"0" andkey:@"dateStr" value:_currentDate]];
        
        NSMutableArray * compareArr = [NSMutableArray array];
        for (int i=0 ; i<stampArr.count; i++) {
            EarnAppointModel * model = stampArr[i];
            int isExist = [self resultWithCompareStamp:[model.start_time_hour doubleValue] withStamp:[_firstTypeModel.end_time_hour doubleValue]];
            int isExtraExist = [self resultWithCompareStamp:[_firstTypeModel.start_time_hour doubleValue] withStamp:[model.end_time_hour doubleValue]];
            if (isExtraExist ==1 || isExist==0 || isExist == 1 || isExist == 0) {
                [compareArr addObject:@"1"];      //不冲突
            }else{
                [compareArr addObject:@"-1"];     //冲突
            }
        }
        
        NSLog(@"%@",compareArr);
        
        BOOL isbool1 = [compareArr containsObject: @"-1"];
        
        if (isbool1 == YES) {
            [LLUtils showTextAndProgressHud:@"时间段冲突"];
        }else{
            [_manager updateTable:ChartName TargetKeys:DataBaseArray TargetValues:@[keyValueStr,_currentDate,                                                                                               _firstTypeModel.carId,_firstTypeModel.classId,_firstTypeModel.end_time_hour,_firstTypeModel.money,_firstTypeModel.remaining,_firstTypeModel.start_time_hour,_firstTypeModel.state,_firstTypeModel.studentMax,_firstTypeModel.subjectId,_firstTypeModel.tplId] WhereItsKey:@"id" IsValue:keyValueStr];
        }
        
        
        NSLog(@"++%@++",firstDict);

        _fmdbDataArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getNOCrossAllObjectsFromTable:ChartName KeyArr:DataBaseArray WhereItsNOKey:@"tplId" IsNOValue:@"0" andkey:@"dateStr" value:_currentDate]];
        
//点击已自定义cell
    }else if ([_type isEqualToString:@"2"]){
        
        NSLog(@"**%@**",_secondCustomDict);
        
//        NSString * startTimeStr = [NSString stringWithFormat:@"%@:%@",[_secondCustomDict objectForKey:@"firstField"],[_secondCustomDict objectForKey:@"secondField"]];
//        NSString * endTimeStr = [NSString stringWithFormat:@"%@:%@",[_secondCustomDict objectForKey:@"thirdField"],[_secondCustomDict objectForKey:@"fourthField"]];
        
        NSString * startTimeStr = [NSString stringWithFormat:@"%@",[_secondCustomDict objectForKey:@"startTF"]];
        NSString * endTimeStr = [NSString stringWithFormat:@"%@",[_secondCustomDict objectForKey:@"endTF"]];
        
        EarnCalendarModel * calendarModel = _calendarArray[_currentIndex];
        
//        NSString * str1 = [NSString stringWithFormat:@"%@-%@ %@:%@",calendarModel.year,calendarModel.date,[_secondCustomDict objectForKey:@"firstField"],[_secondCustomDict objectForKey:@"secondField"]];
        NSString * str1 = [NSString stringWithFormat:@"%@-%@ %@",calendarModel.year,calendarModel.date,[_secondCustomDict objectForKey:@"startTF"]];
        NSString * startStamp = [NSString stringWithFormat:@"%lld",[LLUtils timestampsWithDateStr:str1 dateFormat:[NSString stringWithFormat:@"yyyy-MM-dd HH:mm"]]];
        
//        NSString * str2 = [NSString stringWithFormat:@"%@-%@ %@:%@",calendarModel.year,calendarModel.date,[_secondCustomDict objectForKey:@"thirdField"],[_secondCustomDict objectForKey:@"fourthField"]];
        NSString * str2 = [NSString stringWithFormat:@"%@-%@ %@",calendarModel.year,calendarModel.date,[_secondCustomDict objectForKey:@"endTF"]];
        NSString * endStamp = [NSString stringWithFormat:@"%lld",[LLUtils timestampsWithDateStr:str2 dateFormat:[NSString stringWithFormat:@"yyyy-MM-dd HH:mm"]]];
        
        NSArray * allNotArr = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getNOCrossAllObjectsFromTable:ChartName KeyArr:DataBaseArray WhereItsNOKey:@"id" IsNOValue:[NSString stringWithFormat:@"%@%@",startStamp,[_secondCustomDict objectForKey:@"tplId"]] andkey:@"dateStr" value:_currentDate]];
        
        NSLog(@"%@ , %@",endStamp,startStamp);
        for (int i=0; i<allNotArr.count; i++)
        {
            EarnAppointModel * model = allNotArr[i];
            if ([model.state isEqualToString:@"1"] || [model.state isEqualToString:@"0"]) {
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"HH:mm"];
                NSString *dateString1 = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.start_time_hour doubleValue]]];
                
                NSString * dateString2 = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.end_time_hour doubleValue]]];
                
                int i = [self compareDate:dateString1 withDate:startTimeStr];
                int j = [self compareDate:startTimeStr withDate:dateString2];
                int k = [self compareDate:dateString1 withDate:endTimeStr];
                int m = [self compareDate:endTimeStr withDate:dateString2];
                
                NSLog(@"%d-%d-%d-%d",i,j,k,m);
                
                NSLog(@"车型：%@",[ _secondCustomDict objectForKey:@"carId"]);
                
                if (j == -1 || j == 0 || k == -1 || k==0) {
                    
                }else{
//                    NSLog(@"+++%@+++",[NSString stringWithFormat:@"%@%@",startStamp,[_secondCustomDict objectForKey:@"tplId"]]);
                    
                    [_manager updateTable:ChartName SetTargetKey:@"state" WithValue:@"2" WhereItsKey:@"id" IsValue:[NSString stringWithFormat:@"%@%@",model.start_time_hour,model.tplId]];
                }
            }
        }

        [_manager updateTable:ChartName TargetKeys:AdditionalDataArray TargetValues:@[[_secondCustomDict objectForKey:@"carId"],[_secondCustomDict objectForKey:@"classId"],endStamp,[_secondCustomDict objectForKey:@"money"],startStamp,[_secondCustomDict objectForKey:@"studentMax"],[_secondCustomDict objectForKey:@"subjectId"]] WhereItsKey:@"id" IsValue:[NSString stringWithFormat:@"%@%@",startStamp,[_secondCustomDict objectForKey:@"tplId"]]];
        
//        NSLog(@"%@ , %@",endStamp,startStamp);
        
        _fmdbDataArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getNOCrossAllObjectsFromTable:ChartName KeyArr:DataBaseArray WhereItsNOKey:@"tplId" IsNOValue:@"0" andkey:@"dateStr" value:_currentDate]];
        
//        NSLog(@"--自定义：--%@---",[_manager getCrossAllObjectsFromTable:ChartName KeyArr:DataBaseArray WhereItsKey:@"tplId" IsValue:@"0" andkey:@"dateStr" value:_currentDate]);
        
        _fmdbCustomArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getCrossAllObjectsFromTable:ChartName KeyArr:DataBaseArray WhereItsKey:@"tplId" IsValue:@"0" andkey:@"dateStr" value:_currentDate]];
//按钮点击自定义
    }else if ([_type isEqualToString:@"3"]){
        
        NSLog(@"**%@**",_customDict);
        
//        if([[_customDict objectForKey:@"firstField"] isEqualToString:@""] || [[_customDict objectForKey:@"secondField"] isEqualToString:@""] || [[_customDict objectForKey:@"thirdField"] isEqualToString:@""] || [[_customDict objectForKey:@"fourthField"] isEqualToString:@""]){
//            [LLUtils showErrorHudWithStatus:@"时间不能为空"];
//            return;
//        }
        if([[_customDict objectForKey:@"startTF"] isEqualToString:@""] || [[_customDict objectForKey:@"endTF"] isEqualToString:@""]){
            [LLUtils showErrorHudWithStatus:@"时间不能为空"];
            return;
        }
        if ([[_customDict objectForKey:@"studentMax"] isEqualToString:@""]) {
            [LLUtils showErrorHudWithStatus:@"人数不能为空"];
            return;
        }
        
        if ([[_customDict objectForKey:@"money"] isEqualToString:@""]) {
            [LLUtils showErrorHudWithStatus:@"金钱不能为空"];
            return;
        }
        
        
        NSArray * allArr = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getAllValuesInTable:ChartName KeyArr:DataBaseArray WhereItsKey:@"dateStr" IsValue:_currentDate]];
        
//        NSString * startTimeStr = [NSString stringWithFormat:@"%@:%@",[_customDict objectForKey:@"firstField"],[_customDict objectForKey:@"secondField"]];
//        NSString * endTimeStr = [NSString stringWithFormat:@"%@:%@",[_customDict objectForKey:@"thirdField"],[_customDict objectForKey:@"fourthField"]];
        NSString * startTimeStr = [NSString stringWithFormat:@"%@",[_customDict objectForKey:@"startTF"]];
        NSString * endTimeStr = [NSString stringWithFormat:@"%@",[_customDict objectForKey:@"endTF"]];
        
        EarnCalendarModel * calendarModel = _calendarArray[_currentIndex];
        
//        NSString * str1 = [NSString stringWithFormat:@"%@-%@ %@:%@",calendarModel.year,calendarModel.date,[_customDict objectForKey:@"firstField"],[_customDict objectForKey:@"secondField"]];
        NSString * str1 = [NSString stringWithFormat:@"%@-%@ %@",calendarModel.year,calendarModel.date,[_customDict objectForKey:@"startTF"]];
        NSString * startStamp = [NSString stringWithFormat:@"%lld",[LLUtils timestampsWithDateStr:str1 dateFormat:[NSString stringWithFormat:@"yyyy-MM-dd HH:mm"]]];
        
//        NSString * str2 = [NSString stringWithFormat:@"%@-%@ %@:%@",calendarModel.year,calendarModel.date,[_customDict objectForKey:@"thirdField"],[_customDict objectForKey:@"fourthField"]];
        NSString * str2 = [NSString stringWithFormat:@"%@-%@ %@",calendarModel.year,calendarModel.date,[_customDict objectForKey:@"endTF"]];
        NSString * endStamp = [NSString stringWithFormat:@"%lld",[LLUtils timestampsWithDateStr:str2 dateFormat:[NSString stringWithFormat:@"yyyy-MM-dd HH:mm"]]];
        
        NSLog(@"%@ , %@",endStamp,startStamp);
        for (int i=0; i<allArr.count; i++)
        {
            EarnAppointModel * model = allArr[i];
            if ([model.state isEqualToString:@"1"] || [model.state isEqualToString:@"0"]) {
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
                
                if (j == -1 || j ==0 || k == -1 || k == 0) {
                    
                }else{
                    NSLog(@"+++%@+++",[NSString stringWithFormat:@"%@%@",startStamp,[_customDict objectForKey:@"tplId"]]);
                    
                    [_manager updateTable:ChartName SetTargetKey:@"state" WithValue:@"2" WhereItsKey:@"id" IsValue:[NSString stringWithFormat:@"%@%@",model.start_time_hour,model.tplId]];
                }
            }
        }
        [_manager insertIntoTable:ChartName Values:[NSString stringWithFormat:@"%@%@",startStamp,[_customDict objectForKey:@"tplId"]],_currentDate,[_customDict objectForKey:@"carId"],[_customDict objectForKey:@"classId"],endStamp,[_customDict objectForKey:@"money"],[_customDict objectForKey:@"remaining"],startStamp,[_customDict objectForKey:@"state"],[_customDict objectForKey:@"studentMax"],[_customDict objectForKey:@"subjectId"],[_customDict objectForKey:@"tplId"],nil];
        
        //同步时间段
        if([[_customDict objectForKey:@"step"] isEqualToString:@"1"]){
            [_manager updateTableThree:ChartName TargetKeys:ExtraDataBaseArray TargetValues:@[[_customDict objectForKey:@"carId"],[_customDict objectForKey:@"classId"],[_customDict objectForKey:@"money"],@"1",[_customDict objectForKey:@"studentMax"],[_customDict objectForKey:@"subjectId"]] WhereItsKey:@"state" IsValue:@"1" key:@"state" values:@"0" key:@"dateStr" values:_currentDate];
        //不同步时间段
        }else if([[_customDict objectForKey:@"step"] isEqualToString:@"0"]){
            
        }
        NSLog(@"%@ , %@",endStamp,startStamp);

        _fmdbDataArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getNOCrossAllObjectsFromTable:ChartName KeyArr:DataBaseArray WhereItsNOKey:@"tplId" IsNOValue:@"0" andkey:@"dateStr" value:_currentDate]];
        _fmdbCustomArray = [EarnAppointModel mj_objectArrayWithKeyValuesArray:[_manager getCrossAllObjectsFromTable:ChartName KeyArr:DataBaseArray WhereItsKey:@"tplId" IsValue:@"0" andkey:@"dateStr" value:_currentDate]];
        
        

    }
    
    [self.grayBackBtn removeFromSuperview];
    [_earnTableView reloadData];
}

#pragma mark  一键发布
//一键发布
- (void)pressSubmitBtn
{
    checkLogin()
    
    NSMutableArray * arr1 = [[_manager submitGetAllObjectsFromTable:ChartName KeyArr:DataBaseArray WhereItsKey:@"state" IsValue:@"1" key:@"dateStr" value:_currentDate] mutableCopy];
    
    
//    if (arr1.count == 0) {
//        [LLUtils showErrorHudWithStatus:@"请设置时间段"];
//        return;
//    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"content"] = [LLUtils jsonStrWithJSONObject:arr1];
    param[@"time"] = kTimeStamp;
    param[@"sign"] = kSignWithIdentify(@"/appointment/create");
    param[@"dateStr"] = _currentDate;
    
    [NetworkEngine postRequestWithRelativeAdd:@"/appointment/create" paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                
                //请求成功
                [LLUtils showSuccessHudWithStatus:@"发布成功"];
                
            }else if([jsonObj[@"code"] isEqualToNumber:@(2)])
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


//选择车型
#pragma mark -- EarnExtraThirdCellDelegate
- (void)EarnExtraThirdCellClickChooseBtn
{
    if (_carlistTable.hidden == YES) {
        _carlistTable.hidden = NO;
    }
    
    
    
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
            [_secondCustomDict setObject:@"1" forKey:@"classId"];
        }else if ([_type isEqualToString:@"3"]){
            [_customDict setObject:@"1" forKey:@"classId"];
        }
    }else if ([str isEqualToString:@"C2"]){
        NSLog(@"C2");
        if ([_type isEqualToString:@"1"]) {
            _firstTypeModel.classId = @"2";
        }else if ([_type isEqualToString:@"2"]){
            [_secondCustomDict setObject:@"2" forKey:@"classId"];
        }else if ([_type isEqualToString:@"3"]){
            [_customDict setObject:@"2" forKey:@"classId"];
        }
    }
}


#pragma mark EarnExtraOneCellDelegate
- (void)EarnExtraOneCell:(EarnExtraOneCell *)cell clicBtn:(UIButton *)btn
{
    
    if (btn.tag == 100) {
        NSLog(@"100");
        
        
        [_fromPickView remove];
        [_toPickView remove];
        NSMutableArray *arr1 = [NSMutableArray array];
        for (int i = 0; i<24; i++) {
            [arr1 addObject:[NSString stringWithFormat:@"%.2d",i]];
        }
        NSMutableArray *arr2 = [NSMutableArray array];
        for (int i = 0; i<60; i++) {
            [arr2 addObject:[NSString stringWithFormat:@"%.2d",i]];
        }
        NSArray *arr = [NSArray arrayWithObjects:arr1,arr2, nil];
        ZHPickView *pickView = [[ZHPickView alloc]initPickviewWithArray:arr isHaveNavControler:NO];
        pickView.tag = 405;
        _fromPickView = pickView;
        [pickView setPickViewColer:[UIColor whiteColor]];
        pickView.delegate = self;
        [pickView show];
        
    }else if(btn.tag == 200){
        NSLog(@"200");

        
        [_fromPickView remove];
        [_toPickView remove];
        NSMutableArray *arr1 = [NSMutableArray array];
        for (int i = 0; i<24; i++) {
            [arr1 addObject:[NSString stringWithFormat:@"%.2d",i]];
        }
        NSMutableArray *arr2 = [NSMutableArray array];
        for (int i = 0; i<60; i++) {
            [arr2 addObject:[NSString stringWithFormat:@"%.2d",i]];
        }
        NSArray *arr = [NSArray arrayWithObjects:arr1,arr2, nil];
        ZHPickView *pickView = [[ZHPickView alloc]initPickviewWithArray:arr isHaveNavControler:NO];
        pickView.tag = 406;
        _toPickView = pickView;
        [pickView setPickViewColer:[UIColor whiteColor]];
        pickView.delegate = self;
        [pickView show];
    }
    
    
}

#pragma mark - ZHPickViewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    if (pickView.tag == 405) {//第一个table
        
        NSMutableArray *strArr = [[resultString componentsSeparatedByString:@"-"] mutableCopy];
        
        [strArr removeFirstObject];
        
        NSInteger hour = [strArr[0] integerValue];
        NSInteger min = [strArr[1] integerValue];
        NSInteger fromMin = hour *60 + min;
        if ((fromMin>=_toMin)&&(_toMin!= 0)) {
            [self.hudManager showErrorSVHudWithTitle:@"不能大于结束时间!" hideAfterDelay:1.0];
            return;
        }
        else
        {
//            [self.fromTimeBtn setTitle:[NSString stringWithFormat:@"%@:%@",strArr[0],strArr[1]] forState:UIControlStateNormal];
            
            [_startTimeBtn setTitle:[NSString stringWithFormat:@"%@:%@",strArr[0],strArr[1]] forState:UIControlStateNormal];
            _startTimeText = [NSString stringWithFormat:@"%@:%@",strArr[0],strArr[1]];
            
            self.startMin = hour *60 + min;
            
            //参数发送请求
//            self.startTimeStr = [NSString stringWithFormat:@"%@:%@",strArr[0],strArr[1]];
            
            
            
        }
        
    }
    
    if (pickView.tag == 406) {//第一个table
        
        NSMutableArray *strArr = [[resultString componentsSeparatedByString:@"-"] mutableCopy];
        [strArr removeFirstObject];
        NSInteger hour = [strArr[0] integerValue];
        NSInteger min = [strArr[1] integerValue];
        NSInteger toMin = hour *60 + min;
        if (toMin<=_startMin) {
            [self.hudManager showErrorSVHudWithTitle:@"不能小于开始时间!" hideAfterDelay:1.0];
            return;
        }else
        {
            self.toMin = hour *60 + min;
//            [self.toTimeBtn setTitle:[NSString stringWithFormat:@"%@:%@",strArr[0],strArr[1]] forState:UIControlStateNormal];
            [_endTimeBtn setTitle:[NSString stringWithFormat:@"%@:%@",strArr[0],strArr[1]] forState:UIControlStateNormal];
            //参数发送请求
//            self.endTimeStr = [NSString stringWithFormat:@"%@:%@",strArr[0],strArr[1]];
            _endTimeText = [NSString stringWithFormat:@"%@:%@",strArr[0],strArr[1]];
            
        }
        
    }
    
    
    if ([_type isEqualToString:@"3"]) {
        [_customDict setObject:isEmptyStr(_startTimeText)?@"":_startTimeText forKey:@"startTF"];
        [_customDict setObject:isEmptyStr(_endTimeText)?@"":_endTimeText forKey:@"endTF"];
    }else if ([_type isEqualToString:@"2"]){
        
        [_secondCustomDict setObject:isEmptyStr(_startTimeText)?@"":_startTimeText forKey:@"startTF"];
        [_secondCustomDict setObject:isEmptyStr(_endTimeText)?@"":_endTimeText forKey:@"endTF"];
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
            [_secondCustomDict setObject:@"1" forKey:@"subjectId"];
        }else if ([_type isEqualToString:@"3"]){
            [_customDict setObject:@"1" forKey:@"subjectId"];
        }
    }else if ([str isEqualToString:@"科目三"]){
        NSLog(@"科目三");
        if ([_type isEqualToString:@"1"]) {
            _firstTypeModel.subjectId = @"2";
        }else if ([_type isEqualToString:@"2"]){
            [_secondCustomDict setObject:@"2" forKey:@"subjectId"];
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
            [_secondCustomDict setObject:field.text forKey:@"studentMax"];
        }else if ([_type isEqualToString:@"3"]){
            [_customDict setObject:field.text forKey:@"studentMax"];
        }
        
    }else if ([str isEqualToString:@"价格"]){
        if ([_type isEqualToString:@"1"]) {
            _firstTypeModel.money = field.text;
            
        }else if ([_type isEqualToString:@"2"]){
            [_secondCustomDict setObject:field.text forKey:@"money"];
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
        [_customDict setObject:@"1" forKey:@"step"];
    }else if ([str isEqualToString:@"NO"]){
        NSLog(@"不同步");
        [_customDict setObject:@"0" forKey:@"step"];
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
            if(_fmdbDataArray.count>0){
                return ceil(_fmdbDataArray.count/3.0)*75+10;
            }else{
                NSString * str = [kUserDefault objectForKey:@"CoachTemplatesNum"];
                return ceil([str floatValue]/3.0)*75+10;
            }
        }else{
//            if(_fmdbCustomArray.count){
                return ceil(_fmdbCustomArray.count/3.0)*75+10;
//            }else{
//                return ceil(_customArray.count/3.0)*75+10;
//            }
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
        return _carlistDataArray.count;
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
            cell.dataArray = _fmdbDataArray;

            return cell;
        }else if(indexPath.section == 1){
            static NSString * string = @"fallCellTwo";          //自定义时段cell
            WindfallSecondCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (cell == nil) {
                cell = [[WindfallSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
            cell.delegate = self;
            cell.dataArray = _fmdbCustomArray;
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
        EarnAppointModel * model = nil;
        if ([_type isEqualToString:@"1"]) {
            if(_fmdbDataArray.count>_windfallFirstIndex)
            {
                model = _fmdbDataArray[_windfallFirstIndex];
            }
        }else if([_type isEqualToString:@"2"]){
            if (_fmdbCustomArray.count>_windfallSecondIndex) {
                 model = _fmdbCustomArray[_windfallSecondIndex];
            }
        }
        
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
                
//                static NSString * string = @"extraCellONE";       //手动输入时段
//                EarnOneCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
//                if (cell == nil) {
//                    cell = [[[NSBundle mainBundle]loadNibNamed:@"EarnOneCell" owner:self options:nil]lastObject];
//                }
//                if ([_type isEqualToString:@"2"]) {
//                    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
//                    [dateFormat1 setDateFormat:@"HH"];
//                    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
//                    [dateFormat2 setDateFormat:@"mm"];
//                    NSString *dateString1 = [dateFormat1 stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.start_time_hour doubleValue]]];
//                    NSString *dateString2 = [dateFormat2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.start_time_hour doubleValue]]];
//                    NSString * dateString3 = [dateFormat1 stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.end_time_hour doubleValue]]];
//                    NSString *dateString4 = [dateFormat2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.end_time_hour doubleValue]]];
//                    _secondTypeModel = model;
//                    cell.firstTF.text = dateString1;
//                    cell.secondTF.text = dateString2;
//                    cell.thirdTF.text = dateString3;
//                    cell.fourthTF.text = dateString4;
//                }else if ([_type isEqualToString:@"3"]){
//                    cell.firstTF.text = @"";
//                    cell.secondTF.text = @"";
//                    cell.thirdTF.text = @"";
//                    cell.fourthTF.text = @"";
//                }
//                cell.delegate = self;
//                cell.backgroundColor = [UIColor whiteColor];
//                return cell;
                
                static NSString * string = @"extraCellONE";       //手动输入时段
                EarnExtraOneCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"EarnExtraOneCell" owner:self options:nil]lastObject];
                }
                cell.delegate = self;
                
                if ([_type isEqualToString:@"2"]) {
                    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
                    [dateFormat1 setDateFormat:@"HH:mm"];
                    NSString *dateString1 = [dateFormat1 stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.start_time_hour doubleValue]]];
                    NSString * dateString2 = [dateFormat1 stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.end_time_hour doubleValue]]];
                    _secondTypeModel = model;
                    [cell.startTimeBtn setTitle:dateString1 forState:UIControlStateNormal];
                    [cell.endTimeBtn setTitle:dateString2 forState:UIControlStateNormal] ;

                }else if ([_type isEqualToString:@"3"]){
                    [cell.startTimeBtn setTitle:@"开始时间" forState:UIControlStateNormal];
                    [cell.endTimeBtn setTitle:@"结束时间" forState:UIControlStateNormal];
                }
                cell.delegate = self;
                cell.backgroundColor = [UIColor whiteColor];
                _startTimeBtn = cell.startTimeBtn;
                _endTimeBtn = cell.endTimeBtn;
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
            if ([_type isEqualToString:@"1"] || [_type isEqualToString:@"2"]) {
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
            
            cell.carArray = _carlistDataArray;
            cell.delegate = self;
            if ([_type isEqualToString:@"1"] || [_type isEqualToString:@"2"]) {
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
            if ([_type isEqualToString:@"1"] || [_type isEqualToString:@"2"]) {
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
            if ([_type isEqualToString:@"1"] || [_type isEqualToString:@"2"]) {
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
//            NSLog(@"~~%lu~~%ld~~",(unsigned long)_carlistDataArray.count,(long)indexPath.row);
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
        if ([_type isEqualToString:@"1"]) {
            _firstTypeModel.carId = model.idStr;
        }else if ([_type isEqualToString:@"2"]) {
            [_secondCustomDict setObject:model.idStr forKey:@"carId"];
        }else if ([_type isEqualToString:@"3"]){
            [_customDict setObject:model.idStr forKey:@"carId"];
        }
        
        if (isEmptyStr(_chooseCarlistBtn.titleLabel.text)) {
            [_chooseCarlistBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _chooseCarlistBtn.bounds.size.width-_chooseCarlistBtn.imageView.image.size.width-7, 0, 16-_chooseCarlistBtn.imageView.image.size.width+7)];
        }
        else
        {
            [_chooseCarlistBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _chooseCarlistBtn.bounds.size.width-_chooseCarlistBtn.imageView.image.size.width, 0, 16-_chooseCarlistBtn.imageView.image.size.width)];
        }
        
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

//比较日期结果
- (int)resultWithCompareStamp:(NSTimeInterval)stamp1 withStamp:(NSTimeInterval)stamp2
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    NSString *dateString1 = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:stamp1]];
    
    NSString * dateString2 = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:stamp2]];
    
    int i = [self compareDate:dateString1 withDate:dateString2];
    return i;
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


@end
