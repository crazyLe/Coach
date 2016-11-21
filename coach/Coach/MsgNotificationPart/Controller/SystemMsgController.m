//
//  SystemMsgController.m
//  学员端
//
//  Created by zuweizhong  on 16/8/1.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "CYLTableViewPlaceHolder.h"
#import "CoachProveVC.h"
#import "MyAdmissionsVC.h"
#import "AppointListVC.h"
#import "LLWebViewController.h"
#import "CircleJSManager.h"
#import "DealOrderViewController.h"
#import "SystemMsgController.h"
#import "SystemMsgController.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "SystemHeaderCell.h"
#import "SystemMsgCell.h"
#import "MessageDataBase.h"
#import "ExtraMoneyVC.h"
#import "WithdrawRecordController.h"
#import "MyCircleViewController.h"
#import "SystemExtraMsgCell.h"
@interface SystemMsgController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,SystemExtraMsgCellDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,assign)int maxid;
@property(nonatomic,strong)NSMutableArray * xueshiArr;
@property(nonatomic,copy)NSString *student_id;
@property(nonatomic,strong)MsgModel *refuseMsgModel;
@end

@implementation SystemMsgController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BG_COLOR;

    [self setTitleText:@"系统消息" textColor:nil];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.dataArray =[NSMutableArray array];
    
//    self.maxid = [[MessageDataBase shareInstance]getMaxIdModel].idNum;
    
    self.maxid = [[kUserDefault objectForKey:kMaxMessageId] intValue];
    
    [self createUI];
    
    [self loadMessage];

}
-(void)loadMessage
{
//    [self.hudManager showNormalStateSVHUDWithTitle:nil];
    [LLUtils showTextAndProgressHud:@"加载中"];
    NSString *url = @"/message";
    NSString *time = kTimeStamp;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"maxId"] = @(self.maxid);
    param[@"time"] = time;
    param[@"sign"] = kSignWithIdentify(@"/message");
    param[@"deviceInfo"] = kDeviceInfo;
    
    [NetworkEngine postRequestWithRelativeAdd:url paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
        [LLUtils dismiss];
        if (isSuccess) {
            if ([jsonObj[@"code"] intValue] == 1)
            {
//                NSString * jstr = [LLUtils jsonStrWithJSONObject:jsonObj];
//                NSString * str = [LLUtils replaceUnicode:jstr];
//                NSLog(@"%@",str);
                
                NSArray *arr = [MsgModel mj_objectArrayWithKeyValuesArray:jsonObj[@"info"][@"message"]];
                
                for (int i = 0; i<arr.count; i++) {
                    MsgModel *model = arr[i];
                    [[MessageDataBase shareInstance] insertDataWithModel:model];
                }
                
                if (arr.count>0) {
                    //存储最大ID
                    MsgModel *t_MessageModel = [[MessageDataBase shareInstance] getMaxIdModel];
                    [kUserDefault setObject:intToStr(t_MessageModel.idNum) forKey:kMaxMessageId];
                }
                
                if (self.isCircle) {
                    self.dataArray = [[MessageDataBase shareInstance]queryCircleMessage].mutableCopy;
                }
                else
                {
                    self.dataArray = [[MessageDataBase shareInstance]query].mutableCopy;
                }
                //设置所有信息已读
                for (int i = 0; i<self.dataArray.count ; i++) {
                    MsgModel *model = self.dataArray[i];
                    [[MessageDataBase shareInstance]setDataIsReadWithModel:model];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kMakeMsgIsReadNotification object:nil];
//                [self.hudManager dismissSVHud];
                [self.tableView cyl_reloadData];
                
            }
            else
            {
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
        }
    }];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createUI
{
    //新消息
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setExtraCellLineHidden];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor colorWithHexString:@"ececec"];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"SystemMsgCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SystemMsgCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SystemExtraMsgCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SystemExtraMsgCell"];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark -- SystemExtraMsgCellDelegate
- (void)SystemExtraMsgCell:(SystemExtraMsgCell *)cell tagStr:(NSString *)tag student_idStr:(NSString *)student_idStr
{
    NSDictionary *msgDict = cell.model.msg.mj_JSONObject;
    _student_id = student_idStr;
    
    if ([msgDict[@"msg_id"]integerValue] == 25) {
        //学员绑定消息
        if ([tag isEqualToString:@"100"]) {              //拒绝
            _refuseMsgModel = cell.model;  //记录model
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否拒绝此学员的绑定请求?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认拒绝", nil];
            alertView.tag = 10;
            [alertView show];
        }else{
            [self bindingCoachRequest:1 model:cell.model];
        }
    }
    else if ([msgDict[@"msg_id"]integerValue] == 50)
    {
        //招生团消息
        if ([tag isEqualToString:@"100"]) {              //拒绝
            _refuseMsgModel = cell.model;  //记录model
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否拒绝加入教练招生团?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认拒绝", nil];
            alertView.tag = 20;
            [alertView show];
        }else{
            [self joiningHeadmasterRequest:1 model:cell.model];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SystemHeaderCell *header = [[[NSBundle mainBundle]loadNibNamed:@"SystemHeaderCell" owner:nil options:nil]lastObject];
    header.backgroundColor = [UIColor clearColor];
    MsgModel *model = self.dataArray[section];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"MM-dd HH:mm";
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:model.addtime];
    NSString *time = [df stringFromDate:lastDate];
    header.timeLabel.text = time;
    return header;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MsgModel *model = self.dataArray[indexPath.section];
    
//    HJLog(@"%@",model.description);
    
    NSDictionary *msgDict = model.msg.mj_JSONObject;

    switch ([msgDict[@"msg_id"] integerValue]) {
        case 25:
        {
            //学员申请绑定
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否接受此学员的绑定请求?" message:nil delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"接受", nil];
//            alertView.tag = 10;
//            [alertView show];
        }
            break;
        case 26:
        {
            //学员预约学时陪练提醒
            DealOrderViewController *appointVC = [[DealOrderViewController alloc] init];
            [self.navigationController pushViewController:appointVC animated:YES];
        }
            break;
        case 27:
        {
            //优惠券被领取通知
            
        }
            break;
        case 28:
        {
            //邀请学员加入招生团被接受通知（学员端接受）
            MyAdmissionsVC *myAdmissionVC = [[MyAdmissionsVC alloc] init];
            [self.navigationController pushViewController:myAdmissionVC animated:YES];
        }
            break;
        case 29:
        {
            //圈子新消息通知
            MyCircleViewController *myCircleVC = [[MyCircleViewController alloc] init];
            [self.navigationController pushViewController:myCircleVC animated:YES];
        }
            break;
        case 30:
        {
            //被推荐上头条通知
            NSString *momentId = msgDict[@"top_id"];
            NSString *componentStr = [NSString stringWithFormat:@"/community/show/%@?uid=%@&app=1&cityid=%@&address=%@",momentId,kUid,kCityID,kAddress];
            LLWebViewController *webVC = [[LLWebViewController alloc] initWithUrl:[NSURL URLWithString:[WAP_HOST_ADDR stringByAppendingPathComponent:componentStr]] title:@"圈子详情" rightImgName:nil];
            
            CircleJSManager *js_Manager = [[CircleJSManager alloc] init];
            webVC.js_Manager = js_Manager;
            webVC.object = @(1);
            
            //            WeakObj(self)
            js_Manager.needRefreshBlock = ^(CircleJSManager *js_Manager){
                //                //计算当前Cell所在页码
                //                CircleMainContentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                //                NSUInteger currentPageIndex = cell.indexPath.row/_pageSize+1;
                //
                //                //请求并刷新UI
                //                [selfWeak refreshDataWithPage:currentPageIndex];
            };
            
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 31:
        {
            //充值提现成功通知
            
        }
            break;
        case 32:
        {
            //提现申请审核失败通知
            
        }
            break;
        case 33:case 34:
        {
            //教练认证审核结果通知
            CoachProveVC * vc = [[CoachProveVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 35:
        {
            //修改密码成功通知
            
        }
            break;
            
        default:
            break;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MsgModel *model = self.dataArray[indexPath.section];
    NSDictionary *msgDict = model.msg.mj_JSONObject;
    
    if([msgDict[@"msg_id"]integerValue] == 25 || [msgDict[@"msg_id"]integerValue] == 50) {
        return [tableView fd_heightForCellWithIdentifier:@"SystemExtraMsgCell" cacheByIndexPath:indexPath configuration:^(SystemExtraMsgCell * cell) {
            cell.backgroundColor = [UIColor whiteColor];
            //        MsgModel *model = self.dataArray[indexPath.section];
            
            cell.contentLabel.text = model.title;
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            df.dateFormat = @"yyyy-MM-dd";
            NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:model.addtime];
            NSString *time = [df stringFromDate:lastDate];
            cell.timeLabel.text = time;

        }];
    }else{
        return [tableView fd_heightForCellWithIdentifier:@"SystemMsgCell" cacheByIndexPath:indexPath configuration:^(SystemMsgCell * cell) {
            cell.backgroundColor = [UIColor whiteColor];
            //        MsgModel *model = self.dataArray[indexPath.section];
            
            cell.contentLbl.text = model.title;
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            df.dateFormat = @"yyyy-MM-dd";
            NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:model.addtime];
            NSString *time = [df stringFromDate:lastDate];
            cell.timeLbl.text = time;
        }];
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MsgModel *model = self.dataArray[indexPath.section];
    NSData *jsonData = [model.msg dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    NSDictionary *msgDict = model.msg.mj_JSONObject;
    
    if([msgDict[@"msg_id"]integerValue] == 25 || [msgDict[@"msg_id"]integerValue] == 50) {
        static NSString * string = @"SystemExtraMsgCell";
        SystemExtraMsgCell * cell = [tableView dequeueReusableCellWithIdentifier:string forIndexPath:indexPath];
        cell.model = model;
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentLabel.text = model.title;
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        df.dateFormat = @"yyyy-MM-dd";
        NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:model.addtime];
        NSString *time = [df stringFromDate:lastDate];
        cell.timeLabel.text = time;
        cell.contentLabel.adjustsFontSizeToFitWidth = YES;
        
//        NSLog(@"~~%@~~%@~~",dic,[dic objectForKey:@"student_id"]);
        if ([msgDict[@"msg_id"]integerValue] == 25) {
            cell.student_idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"student_id"]];
        }
        else if ([msgDict[@"msg_id"]integerValue] == 50)
        {
            cell.student_idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tid"]];
        }
        
        cell.delegate = self;
        return cell;
    }else{
        static NSString * identifer = @"SystemMsgCell";
        SystemMsgCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.contentLbl.text = model.title;
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        df.dateFormat = @"yyyy-MM-dd";
        NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:model.addtime];
        NSString *time = [df stringFromDate:lastDate];
        cell.timeLbl.text = time;
        cell.contentLbl.adjustsFontSizeToFitWidth = YES;
        return cell;
    }

}

#pragma mark - CYLTableViewPlaceHolderDelegate

- (UIView *)makePlaceHolderView;
{
    UIView *bgView = [UIView new];
    
    UILabel *promptLbl = [UILabel new];
    [bgView addSubview:promptLbl];
    NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithImg:[UIImage imageNamed:@"CoachCarRent_Cry"] bounds:CGRectMake(0, 0, 100, 100)];
    [attStr appendBreakLineWithInterval:20];
    [attStr appendText:@"暂无数据" withAttributesArr:@[rgb(249, 117, 43)]];
    //    [attStr appendBreakLineWithInterval:3];
    //    [attStr appendText:@"可出租的教练车资源" withAttributesArr:@[rgb(249, 117, 43)]];
    promptLbl.attributedText = attStr;
    promptLbl.textAlignment = NSTextAlignmentCenter;
    promptLbl.numberOfLines = 0;
    
    //    UIButton *goPublicbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [bgView addSubview:goPublicbtn];
    //    [goPublicbtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(bgView.mas_centerY);
    //        make.centerX.equalTo(promptLbl);
    //        make.width.offset(0.8*kScreenWidth);
    //        make.height.offset(40);
    //    }];
    //    goPublicbtn.layer.cornerRadius = 20;
    //    goPublicbtn.layer.masksToBounds = YES;
    //    [goPublicbtn setBackgroundColor:kAppThemeColor];
    //    [goPublicbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [goPublicbtn setTitle:segmentedControl.selectedSegmentIndex==1?@"去发布":@"刷新" forState:UIControlStateNormal];
    //    [goPublicbtn addTarget:self action:@selector(clickGoPublicBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(-self.view.bounds.size.height/4);
    }];
    
    return bgView;
}

- (BOOL)enableScrollWhenPlaceHolderViewShowing;
{
    return YES;
}

#pragma mark - 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10) {
        if (buttonIndex == 1) {
            [self bindingCoachRequest:0 model:_refuseMsgModel];
        }
    }
    else if (alertView.tag==20)
    {
        if (buttonIndex == 1) {
            [self joiningHeadmasterRequest:0 model:_refuseMsgModel];
        }
    }
}

//接受/拒绝学员绑定教练请求
- (void)bindingCoachRequest:(NSInteger)buttonIndex model:(MsgModel *)model
{
    WeakObj(self)
    
    NSDictionary *jsonDic = [LLUtils jsonObjectWithJSONStr:model.msg];
    
    NSString *relativeAdd = @"/bindingCoach/update";
    NSDictionary *paraDic = @{@"uid":kUid,@"student_id":kHandleEmptyStr(_student_id),@"result":integerToStr(buttonIndex),@"time":kTimeStamp,@"sign":kSignWithIdentify(relativeAdd),@"deviceInfo":kDeviceInfo,@"id":jsonDic[@"id"]};
    [NetworkEngine postRequestWithRelativeAdd:relativeAdd paraDic:paraDic completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if (isEqualValue(jsonObj[@"code"], 1)) {
                //成功
                [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
                [[MessageDataBase shareInstance] deleteMessgateWithId:buttonIndex==0?intToStr(_refuseMsgModel.idNum):intToStr(model.idNum)];
                [selfWeak.dataArray removeObject:buttonIndex==0?_refuseMsgModel:model];
                [selfWeak.tableView reloadData];
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

//接受/拒绝加入校长招生团请求
- (void)joiningHeadmasterRequest:(NSInteger)buttonIndex model:(MsgModel *)model
{
    WeakObj(self)
    
//    NSDictionary *jsonDic = [LLUtils jsonObjectWithJSONStr:model.msg];
    
    NSString *relativeAdd = @"/schoolrecruit/update";
    NSDictionary *paraDic = @{@"uid":kUid,@"tid":kHandleEmptyStr(_student_id),@"result":integerToStr(buttonIndex),@"time":kTimeStamp,@"sign":kSignWithIdentify(relativeAdd),@"deviceInfo":kDeviceInfo};
    [NetworkEngine postRequestWithRelativeAdd:relativeAdd paraDic:paraDic completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if (isEqualValue(jsonObj[@"code"], 1)) {
                //成功
                [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
                [[MessageDataBase shareInstance] deleteMessgateWithId:buttonIndex==0?intToStr(_refuseMsgModel.idNum):intToStr(model.idNum)];
                [selfWeak.dataArray removeObject:buttonIndex==0?_refuseMsgModel:model];
                [selfWeak.tableView reloadData];
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

@end
