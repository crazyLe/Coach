//
//  RepaymentResultVC.m
//  Coach
//
//  Created by gaobin on 16/7/30.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "RepaymentResultVC.h"
#import "PartnerTrainSubmitCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "PartnerTrainWaitCell.h"
#import "PartnerTrainSuccessCell.h"
#import "PartnerTrainFailCell.h"

@interface RepaymentResultVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;

@end

@implementation RepaymentResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BG_COLOR;
    
    [self createNavigation];
    
    [self createUI];
    
    
}
- (void)createUI {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64,kScreenWidth,kScreenHeight-64) style:UITableViewStylePlain];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = BG_COLOR;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    [tableView registerClass:[PartnerTrainSubmitCell class] forCellReuseIdentifier:@"PartnerTrainSubmitCell"];
    [tableView registerClass:[PartnerTrainWaitCell class] forCellReuseIdentifier:@"PartnerTrainWaitCell"];
    [tableView registerClass:[PartnerTrainFailCell class] forCellReuseIdentifier:@"PartnerTrainFailCell"];
    [tableView registerNib:[UINib nibWithNibName:@"PartnerTrainSuccessCell" bundle:nil] forCellReuseIdentifier:@"PartnerTrainSuccessCell"];
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [tableView fd_heightForCellWithIdentifier:@"PartnerTrainSubmitCell" cacheByIndexPath:indexPath configuration:^(PartnerTrainSubmitCell * cell) {
            cell.fd_enforceFrameLayout = YES;
            cell.contentString = @"学时陪练提交成功";
            cell.timeString = @"";
            
        }];
    }
    if (indexPath.row == 1) {
        return [tableView fd_heightForCellWithIdentifier:@"PartnerTrainWaitCell" cacheByIndexPath:indexPath configuration:^(PartnerTrainWaitCell * cell) {
            cell.fd_enforceFrameLayout = YES;
            cell.contentString = @"等待教练确认......";
        }];
    }
    if (indexPath.row == 2) {
        return [tableView fd_heightForCellWithIdentifier:@"PartnerTrainSuccessCell" cacheByIndexPath:indexPath configuration:^(PartnerTrainSuccessCell * cell) {
        }];
    }
    if (indexPath.row == 3) {
        return [tableView fd_heightForCellWithIdentifier:@"PartnerTrainFailCell" cacheByIndexPath:indexPath configuration:^(PartnerTrainFailCell * cell) {
            cell.fd_enforceFrameLayout = YES;
            cell.titleString = @"预约失败";
            cell.subTitleString = @"原因:教练确认超时";
            cell.zhuanDouString = @"赚豆已退还账户";
            cell.timeString = @"";
            
        }];
    }
    
    return 0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *identify = @"PartnerTrainSubmitCell";
        PartnerTrainSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
        cell.fd_enforceFrameLayout = YES;//是Frame布局
        cell.contentString = @"学时陪练提交成功";
        cell.timeString = @"";
        return cell;
    }
    if (indexPath.row == 1) {
        static NSString *identify = @"PartnerTrainWaitCell";
        PartnerTrainWaitCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
        cell.fd_enforceFrameLayout = YES;//是Frame布局
        cell.contentString = @"等待教练确认......";
        return cell;
        
    }
    if (indexPath.row == 2) {
        static NSString *identify = @"PartnerTrainSuccessCell";
        PartnerTrainSuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
        
        return cell;
        
    }
    if (indexPath.row == 3) {
        static NSString *identify = @"PartnerTrainFailCell";
        PartnerTrainFailCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
        cell.fd_enforceFrameLayout = YES;
        cell.titleString = @"预约失败";
        cell.subTitleString = @"原因:教练确认超时";
        cell.zhuanDouString = @"赚豆已退还账户";
        cell.timeString = @"";
        return cell;
        
    }
    return nil;
    
}



- (void)createNavigation {
    
    [self setTitleText:@"支付结果" textColor:nil];
    [self setLeftText:nil textColor:nil ImgPath:@"Navigation_Return"];
    
    
    
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
