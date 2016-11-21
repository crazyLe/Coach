//
//  KSMEController.m
//  Coach
//
//  Created by 翁昌青 on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "KSMEController.h"
#import "ExamBuyCell.h"
#import "ExamSendCell.h"
#import "KSMEDetailsController.h"

@interface KSMEController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger lastIndex;
}
@property(strong,nonatomic)NSArray *keyArr;
@property(strong,nonatomic)NSArray *valueArr;

@property(weak,nonatomic)UITableView *buyTable;
@property(weak,nonatomic)UITableView *releaseTable;
@end

@implementation KSMEController

- (NSArray *)keyArr
{
    if (!_keyArr) {
        _keyArr = [NSArray arrayWithObjects:@[@"发布者",@"联系电话",@"地址"],@[@"人数",@"拿证时间要求",@"考试地域要求",@"装让说明",@"转让价格"], nil];
    }
    return _keyArr;
}

- (NSArray *)valueArr
{
    if (!_valueArr) {
        _valueArr = [NSArray arrayWithObjects:@[@"张小开教练",@"请输入您的手机号码",@"请输入您的地址"],@[@"请输入转让人数",@"60天",@"限本市",@"很急切",@"128.00"], nil];
    }
    return _valueArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setLeftText:nil textColor:nil ImgPath:@"Navigation_Return"];
//    买入
    [self setupbuyTabel];
//    发布
    [self setupreleaseTable];
}
- (void)setupbuyTabel
{
    UITableView *buy = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth , kScreenHeight)];
    
    buy.separatorStyle = UITableViewCellSeparatorStyleNone;
    buy.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
    buy.tag = 101;
    
    buy.dataSource = self;
    buy.delegate = self;
    
    [self.view addSubview:buy];
    
    self.buyTable = buy;
    
}
- (void)setupreleaseTable
{
    UITableView *release = [[UITableView alloc]initWithFrame:CGRectMake(0, 74, kScreenWidth , kScreenHeight)];
    
    release.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    release.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
    release.tag = 102;
    
    release.dataSource = self;
    release.delegate = self;
    
    [self.view addSubview:release];
    
    self.releaseTable = release;
    
    self.releaseTable.alpha = 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (101 == tableView.tag) {
        return 4;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (101 == tableView.tag) {
        return 1;
    }
    if (0 == section) {
        return 3;
    }
    else
    {
        return 5;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (101 == tableView.tag) {
        
        static NSString *buy = @"buycellID";
        ExamBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:buy];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ExamBuyCell" owner:nil options:nil]firstObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section > 2) {
            cell.meimg.image = [UIImage imageNamed:@"iconfont-wuminge"];
        }
        
        return cell;
        
    }else if (102 == tableView.tag)
    {
        
        static NSString *send = @"sendcellID";
        ExamSendCell *cell = [tableView dequeueReusableCellWithIdentifier:send];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ExamSendCell" owner:nil options:nil]firstObject];
        }
        
        cell.key.text = [self.keyArr[section] objectAtIndex:row];
        
        NSString *value = [self.valueArr[section] objectAtIndex:row];
        
        if (0 == section && 0 == row) {
            cell.jiantou.hidden = YES;
        }
        
        if ([value hasPrefix:@"请"]) {
            
            cell.value.placeholder = value;
        }else
        {
            cell.value.text = value;
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (101 == tableView.tag) {
        return 110;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (101 == tableView.tag) {
        return 10;
    }
    if (1 == section) {
        return 105;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (102 == tableView.tag && 1 == section) {
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (102 == tableView.tag && 1 == section) {
            return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (102 == tableView.tag && 1 == section) {
        
        UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        head.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iconfont-icon"]];
        img.frame = CGRectMake(10, 17, 16, 16);
        [head addSubview:img];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(36,0 , 80, 50)];
        
        title.font = Font16;
        title.textColor = [UIColor colorWithHexString:@"#646464"];
        title.text = @"名额信息";
        
        [head addSubview:title];
        
        return head;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (101 == tableView.tag) {
        KSMEDetailsController *details =[[KSMEDetailsController alloc]init];
        [self.navigationController pushViewController:details animated:YES];
    }
}

- (void)initWithUI
{
    UISegmentedControl *seg = [[UISegmentedControl alloc]initWithItems:@[@"买 入",@"发 布"]];
    seg.selectedSegmentIndex = 0;
    seg.tintColor = [UIColor whiteColor];
    seg.frame = CGRectMake(0, 0, 130, 30);
    [seg addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView =  seg;
    
}

- (void)segClick:(UISegmentedControl *)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    
    switch (index) {
        case 0:
            self.buyTable.alpha = 1;
            self.releaseTable.alpha = 0;
            break;
            
        case 1:
            self.buyTable.alpha = 0;
            self.releaseTable.alpha = 1;
            break;
            
        default:
            break;
    }
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
