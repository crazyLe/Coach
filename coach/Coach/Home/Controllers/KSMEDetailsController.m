//
//  KSMEDetailsController.m
//  Coach
//
//  Created by 翁昌青 on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "KSMEDetailsController.h"
#import "ExamSendCell.h"
#import "ExamBottomCell.h"

@interface KSMEDetailsController ()<UITableViewDataSource,UITableViewDelegate>
@property(weak,nonatomic)UITableView *examDetailsTable;

@property(strong,nonatomic)NSArray *keyArr;
@property(strong,nonatomic)NSArray *valueArr;
@end

@implementation KSMEDetailsController

- (NSArray *)keyArr
{
    if (!_keyArr) {
    _keyArr = [NSArray arrayWithObjects:@[@"人数",@"发布者",@"时间要求",@"地域要求",@"转让价格"], nil];
    }
    return _keyArr;
    }

- (NSArray *)valueArr
{
    if (!_valueArr) {
        _valueArr = [NSArray arrayWithObjects:@[@"10人",@"新安驾校",@"60天",@"不限",@"600元"], nil];
    }
    return _valueArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
    [self setLeftText:nil textColor:nil ImgPath:@"Navigation_Return"];
    
    self.title = @"考试名额";
    
    [self setupbuyTabel];
}
- (void)initWithUI
{
    
}

- (void)setupbuyTabel
{
    UITableView *buy = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth , kScreenHeight)];
    buy.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    buy.separatorStyle = UITableViewCellSeparatorStyleNone;
    buy.tag = 101;
    
    buy.dataSource = self;
    buy.delegate = self;
    
    [self.view addSubview:buy];
    
    self.examDetailsTable = buy;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return 5;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (0 == section) {
        
    
    static NSString *send = @"sendcellID";
    ExamSendCell *cell = [tableView dequeueReusableCellWithIdentifier:send];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ExamSendCell" owner:nil options:nil]firstObject];
    }
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.key.text = [self.keyArr[section] objectAtIndex:row];
        
        NSString *value = [self.valueArr[section] objectAtIndex:row];
        
        cell.value.text = value;
        
    
    return cell;
        }
    else if(1 == section)
    {
        
        static NSString *shuoming = @"sendcellID";
        
        ExamBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:shuoming];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ExamBottomCell" owner:nil options:nil]firstObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    return nil;
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
    if (0 == section) {
        return 10;
    }
    return 100;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (1 == section) {
        UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 105)];
        foot.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        
        UIButton *keep = [[UIButton alloc]init];
        keep.backgroundColor = [UIColor colorWithHexString:@"#2e83ff"];
        keep.layer.cornerRadius = 22.5;
        [keep setTitle:@"保存并发布" forState:UIControlStateNormal];
        [keep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [keep addTarget:self action:@selector(outClick) forControlEvents:UIControlEventTouchUpInside];
        [foot addSubview:keep];
        [keep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth - 40, 45));
        }];
        return foot;
    }
    return nil;
}

- (void)outClick
{
    NSLog(@"keep ...");
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
