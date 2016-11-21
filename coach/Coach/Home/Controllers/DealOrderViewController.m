//
//  DealOrderViewController.m
//  Coach
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "DealOrderViewController.h"
#import "DealOrderCell.h"
#import "DealOrderModel.h"

@interface DealOrderViewController ()<UITableViewDelegate,UITableViewDataSource,DealOrderCellDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UITableView * dealOrderTable;

@property (nonatomic, assign) NSInteger pageId;

@property (nonatomic, strong) NSMutableArray * orderArray;

@property (nonatomic, copy) NSString * timeStr;

@property (nonatomic, copy) NSString * appointmentIdStr;

@end

@implementation DealOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initWithUI
{
    [super initWithUI];
    self.title = @"预约处理";
    self.view.backgroundColor = kBackgroundColor;
    self.pageId = 1;
    self.orderArray = [NSMutableArray array];
    self.timeStr = [NSString string];
    self.appointmentIdStr = [NSString string];
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(20, 5, 60, 20);
//    rightBtn.backgroundColor = [UIColor redColor];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"全部接受" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = Font13;
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    _dealOrderTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _dealOrderTable.delegate = self;
    _dealOrderTable.dataSource = self;
    _dealOrderTable.showsVerticalScrollIndicator = NO;
    _dealOrderTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_dealOrderTable];
    
    __weak typeof (self) weakSelf = self;
    
    _dealOrderTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.pageId = 1;
        
        [weakSelf requestWithData];
        
    }];
    
    
    _dealOrderTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageId ++;
        
        [weakSelf loadMoreAllData];
        
    }];
    
    _dealOrderTable.mj_footer.automaticallyHidden = YES;
    
    [_dealOrderTable.mj_header beginRefreshing];
    
}

- (void)initWithData
{
    [super initWithData];
//    [self requestWithData];
}

- (void)requestWithData
{
    
//    [LLUtils showTextAndProgressHud:@"正在加载"];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"deviceInfo"] = kDeviceInfo;
    param[@"time"] = kTimeStamp;
    param[@"pageId"] = @(self.pageId);
    param[@"sign"] = kSignWithIdentify(@"/appointment/order");
    
    [NetworkEngine postRequestWithRelativeAdd:@"/appointment/order" paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
//        [LLUtils dismiss];
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                NSString * jstr = [LLUtils jsonStrWithJSONObject:jsonObj];
                NSString * str = [LLUtils replaceUnicode:jstr];
                
                NSLog(@"%@",str);
                _orderArray = [DealOrderModel mj_objectArrayWithKeyValuesArray:jsonObj[@"info"][@"order"]];
                [_dealOrderTable reloadData];
                
                [_dealOrderTable.mj_header endRefreshing];
                
            }else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                
                //需要登录
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
                [_dealOrderTable.mj_header endRefreshing];
            }
            else
            {
                
                //失败
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
                [_dealOrderTable.mj_header endRefreshing];
            }
        }
    }];

}

- (void)loadMoreAllData
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"deviceInfo"] = kDeviceInfo;
    param[@"time"] = kTimeStamp;
    param[@"pageId"] = @(self.pageId);
    param[@"sign"] = kSignWithIdentify(@"/appointment/order");
    
    [NetworkEngine postRequestWithRelativeAdd:@"/appointment/order" paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                NSString * jstr = [LLUtils jsonStrWithJSONObject:jsonObj];
                NSString * str = [LLUtils replaceUnicode:jstr];
                
                NSLog(@"%@",str);
                NSArray * arr = [DealOrderModel mj_objectArrayWithKeyValuesArray:jsonObj[@"info"][@"order"]];
                [_orderArray addObjectsFromArray:arr];
                [_dealOrderTable reloadData];
                
                [_dealOrderTable.mj_footer endRefreshing];
                
            }else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                
                //需要登录
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
                [_dealOrderTable.mj_footer endRefreshing];
            }
            else
            {
                
                //失败
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
                [_dealOrderTable.mj_footer endRefreshing];
            }
        }
    }];

}

- (void)rightBtnAction
{
//    NSMutableArray * arr = [NSMutableArray array];
//    for (int i =0 ; i<_orderArray.count; i++) {
//        DealOrderModel * model = _orderArray[i];
//        [arr addObject:model.idStr];
//    }
//    
//    NSString * str = [arr componentsJoinedByString:@","];
//    
//    NSMutableDictionary * param = [NSMutableDictionary dictionary];
//    param[@"uid"] = kUid;
//    param[@"appointmentId"] = str;
//    param[@"time"] = kTimeStamp;
//    param[@"sign"] = kSignWithIdentify(@"/appointment/orderupdate");
//    param[@"state"] = @"1";
//    [self getOrderWithDataWith:param withState:@"1"];
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否接受全部预约？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
    
}

#pragma mark -- DealOrderCellDelegate
- (void)DealOrderCellClickBtn:(UIButton *)sender withIdStr:(NSString *)str withTimeStr:(NSString *)time
{
    
    _timeStr = time;
    
    switch (sender.tag) {
        case 10:
        {
//            [self getOrderWithDataWithState:@"1"];
            [self getOrderWithDataWithAppointmentId:str State:@"1"];
        }
            break;
        case 20:
        {
            _appointmentIdStr = str;
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否拒绝该预约？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alert.tag = 1000;
            [alert show];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            NSLog(@"拒绝");
//            [self getOrderWithDataWithState:@"2"];
            [self getOrderWithDataWithAppointmentId:_appointmentIdStr State:@"2"];
        }
    }else{
        if(buttonIndex == 1){
            NSLog(@"全部接受的按钮");
            NSMutableArray * arr = [NSMutableArray array];
            for (int i =0 ; i<_orderArray.count; i++) {
                DealOrderModel * model = _orderArray[i];
                [arr addObject:model.idStr];
            }
            NSString * str = [arr componentsJoinedByString:@","];
            [self getOrderWithDataWithAppointmentId:str State:@"1"];
        }
    }
    
}

//- (void)getOrderWithDataWith:(NSMutableDictionary *)param withState:(NSString *)state
- (void)getOrderWithDataWithAppointmentId:(NSString *)appointId State:(NSString *)state
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"appointmentId"] = appointId;
    param[@"time"] = kTimeStamp;
    param[@"state"] = state;
    param[@"sign"] = kSignWithIdentify(@"/appointment/orderupdate");
    
    [NetworkEngine postRequestWithRelativeAdd:@"/appointment/orderupdate" paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                
                //成功
                if ([state isEqualToString:@"1"]) {
                    [LLUtils showSuccessHudWithStatus:@"已接受"];
                }else if ([state isEqualToString:@"2"]){
                    [LLUtils showSuccessHudWithStatus:@"该订单已拒绝"];
                }
                
                if ([state isEqualToString:@"2"]) {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    [dict setValue:_timeStr forKey:@"time"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"DealOrderRefuse" object:self userInfo:dict];
                    });
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self requestWithData];
                });
                
                
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat contentH = 18.0;
    DealOrderModel * model =  _orderArray[indexPath.row];
    if (![model.title isEqualToString:@""]) {
        contentH =[self sizeWithText:model.title font:Font15 maxSize:CGSizeMake(kScreenWidth-82, CGFLOAT_MAX)].height;
    }
    NSLog(@"%f",contentH);
    if ([model.state isEqualToString:@"1"]) {
        return 190-30+model.timeList.count*22-18+contentH;
    }else{
        return 190+model.timeList.count*22-18+contentH;
    }
    
}

//根据字数计算高度
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _orderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string = @"cell";
    DealOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DealOrderCell" owner:self options:nil]lastObject];
    }
    cell.backgroundColor = [UIColor brownColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _orderArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

@end
