//
//  VoucherController.m
//  Coach
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "VoucherController.h"
#import "VoucherTableCell.h"

@interface VoucherController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _VoucherTableView;
    NSMutableArray * _dataImageArr;
    NSMutableArray * _dataMessageArr;
    NSMutableArray * _dataContentArr;
    NSMutableArray * _dataArrowImageArr;
}
@end

@implementation VoucherController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initWithUI
{
    [super initWithUI];
    self.title = @"编辑代金券";
    
    _VoucherTableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _VoucherTableView.delegate = self;
    _VoucherTableView.dataSource = self;
    _VoucherTableView.sectionHeaderHeight = 11.0f;
    _VoucherTableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self.view addSubview:_VoucherTableView];
    
    UIView * customFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 192)];
//    customFooterView.backgroundColor = [UIColor cyanColor];®
    _VoucherTableView.tableFooterView = customFooterView;
    
    UILabel * remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(11, 8, 200, 6)];
    remindLabel.center = CGPointMake(self.view.center.x, 58);
    remindLabel.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    remindLabel.text = @"＊仅限对本人报名使用";
    remindLabel.font = Font15;
    remindLabel.textAlignment = NSTextAlignmentCenter;
    [customFooterView addSubview:remindLabel];
    
    UIButton * publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame = CGRectMake(97,CGRectGetMaxY(remindLabel.frame)+14, kScreenWidth-15.0f*2, 40);
    publishBtn.center = CGPointMake(remindLabel.center.x, publishBtn.center.y);
    [publishBtn setTitle:@"确认发布" forState:UIControlStateNormal];
    [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    publishBtn.titleLabel.font = Font14;
    publishBtn.backgroundColor = [UIColor colorWithHexString:@"2e82ff"];
    publishBtn.layer.cornerRadius = 20.0;
    [publishBtn addTarget:self action:@selector(pressPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
    [customFooterView addSubview:publishBtn];

}

- (void)initWithData
{
    _dataImageArr = [[NSMutableArray alloc]initWithObjects:@"vocher_title",@"vocher_Amount",@"vocher_timeExtra",@"vocher_time", nil];
    _dataMessageArr = [[NSMutableArray alloc]initWithObjects:@"标题",@"金额",@"开始时间",@"结束时间", nil];
    _dataContentArr = [[NSMutableArray alloc]initWithObjects:@"例:开学报名优惠",@"200元",@"03 / 10 / 2014",@"03 / 10 / 2014", nil];
    _dataArrowImageArr = [[NSMutableArray alloc]initWithObjects:@"card_arrow",@"card_arrow",@"iconfont-rili(1)",@"iconfont-rili(1)", nil];
}

- (void)pressPublishBtn:(UIButton *)sender
{
    NSLog(@"确认发布");
}

#pragma mark --UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string = @"cell";
    VoucherTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[VoucherTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    if (indexPath.row == 0) {
        cell.contentLabel.textColor  = RGBCOLOR(190, 190, 190);
    }
    if (indexPath.row == 1) {
        cell.accessoryImageView.frame = CGRectMake(kScreenWidth-13-13, 15, 13, 13);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.iconView.image = [UIImage imageNamed:_dataImageArr[indexPath.row]];
    cell.messageLabel.text = _dataMessageArr[indexPath.row];
    cell.contentLabel.text = _dataContentArr[indexPath.row];
    cell.accessoryImageView.image = [UIImage imageNamed:_dataArrowImageArr[indexPath.row]];
    return cell;
}


@end
