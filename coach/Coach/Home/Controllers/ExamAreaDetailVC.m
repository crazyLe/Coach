//
//  ExamAreaDetailVC.m
//  Coach
//
//  Created by gaobin on 16/7/30.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "ExamAreaDetailVC.h"
#import "PartnerTrainingDetailCell1.h"
#import "PartnerTrainingDetailCell2.h"

@interface ExamAreaDetailVC ()

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UIButton * confirmBtn;

@end

@implementation ExamAreaDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createNavigation];
    
    [self createUI];
    
    
}
- (void)createUI {
    
    //创建UITableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64,kScreenWidth,kScreenHeight-kNavHeight) style:UITableViewStyleGrouped];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    [self.view addSubview:tableView];
    
    UIButton *confirmBtn = [[UIButton alloc]init];
    
    confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#5cb6ff"];
    
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    self.confirmBtn = confirmBtn;
    
    [confirmBtn setTitle:@"确定预约" forState:UIControlStateNormal];
    
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.confirmBtn];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        
        make.right.offset(0);
        
        make.bottom.offset(0);
        
        make.height.equalTo(@52);
        
    }];

    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    
    return 10;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return CGFLOAT_MIN;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 93;
    }
    
    if (indexPath.section == 1) {
        
        PartnerTrainingDetailCell2 *cell = (PartnerTrainingDetailCell2 *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        [cell setNeedsLayout];
        
        [cell layoutIfNeeded];
        
        return cell.cellHeight;
    }
    return 0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *identify = @"PartnerTrainingDetailCell1";
        
        PartnerTrainingDetailCell1 *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PartnerTrainingDetailCell1" owner:nil options:nil]lastObject];
        }
        
        return cell;
    }
    if (indexPath.section == 1) {
        
        static NSString *identify = @"PartnerTrainingDetailCell2";
        
        PartnerTrainingDetailCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (!cell) {
            cell = [[PartnerTrainingDetailCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        return cell;
    }
    
    return nil;
    
    
}
- (void)confirmBtnClick {
    
    
    
    
    
    
}
- (void)createNavigation {
    
    [self setTitleText:@"合肥南岗考场" textColor:nil];
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
