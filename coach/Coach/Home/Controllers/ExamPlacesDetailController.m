//
//  ExamPlacesDetailController.m
//  Coach
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "ExamPlacesDetailController.h"
#import "ExamDetailTableCell.h"

#define HCoachWidth  kScreenWidth/375.0

@interface ExamPlacesDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _examDetailTableView;
    
    NSMutableArray * _dataImageArr;
    NSMutableArray * _dataMessageArr;
    NSMutableArray * _dataContentArr;
}

@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIView * downView;

@end

@implementation ExamPlacesDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initWithUI
{
    [super initWithUI];
    self.title = @"考试名额详情";
    
    [self createUI];
    
}

- (void)initWithData
{
    [super initWithData];
    _dataImageArr = [[NSMutableArray alloc]initWithObjects:@"examDetaiL_pNum",@"examDetaiL_publisher",@"examDetaiL_time",@"examDetaiL_positioning",@"examDetaiL_amount",@"examDetaiL_explain", nil];
    _dataMessageArr = [[NSMutableArray alloc]initWithObjects:@"人  数",@"发 布 者",@"歇间要求",@"地域要求",@"转让价格",@"转让说明", nil];
    _dataContentArr = [[NSMutableArray alloc]initWithObjects:@"10人(安徽合肥)",@"合肥新安驾校",@"60天拿证",@"不限",@"600元",@"暂无", nil];
}

- (void)createUI
{
    _examDetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _examDetailTableView.delegate = self;
    _examDetailTableView.dataSource = self;
    _examDetailTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_examDetailTableView];
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 246)];

//    _topView.backgroundColor = [UIColor cyanColor];
    _topView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    _examDetailTableView.tableHeaderView = _topView;
    [self createTopUI];
    
    _downView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
//    _downView.backgroundColor = [UIColor brownColor];
    _examDetailTableView.tableFooterView = _downView;
    [self createDownUI];
    
}

- (void)createTopUI
{
    UIImageView * backImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_topView.frame), CGRectGetHeight(_topView.frame)-6)];
    backImageV.image = [UIImage imageNamed:@"examDetaiL_backImage"];
    [_topView addSubview:backImageV];
    
    
    UIImageView * markImageV = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-76)/2, 27, 76, 76)];
    markImageV.image = [UIImage imageNamed:@"examDetaiL_markImage"];
    markImageV.contentMode = UIViewContentModeScaleAspectFit;
    [_topView addSubview:markImageV];
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-113)/2,CGRectGetMaxY(markImageV.frame)+7, 113, 18)];
//    nameLabel.backgroundColor = [UIColor redColor];
    nameLabel.text = @"合肥新安驾校";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:nameLabel];
    
    UIImageView * levelImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+3,CGRectGetMinY(nameLabel.frame), 17, 17)];
    levelImage.image = [UIImage imageNamed:@"examDetaiL_level"];
    [_topView addSubview:levelImage];
    
    NSArray * firstArr = @[@"10人",@"不限",@"合肥"];
    NSArray * secondArr = @[@"人数",@"地狱要求",@"地点"];
    
    for (int j=0; j<3; j++) {
        UILabel * firstLabel = [[UILabel alloc]initWithFrame:CGRectMake((62+(103)*j)*HCoachWidth, (177-1), 47, 17)];
//        firstLabel.backgroundColor = [UIColor orangeColor];
        firstLabel.text = firstArr[j];
        firstLabel.textAlignment = NSTextAlignmentCenter;
        [firstLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [_topView addSubview:firstLabel];
        
    }
    
    for (int i=0; i<3; i++) {
        UILabel * secondLabel = [[UILabel alloc]initWithFrame:CGRectMake((62+(103)*i)*HCoachWidth, (177-1)+30, 47, 17)];
//        secondLabel.backgroundColor = [UIColor orangeColor];
        secondLabel.text = secondArr[i];
        secondLabel.textAlignment = NSTextAlignmentCenter;
        secondLabel.font = Font10;
        [_topView addSubview:secondLabel];
        
    }
    
    for (int k=0; k<2; k++) {
        UIImageView * lineImage = [[UIImageView alloc]initWithFrame:CGRectMake((137+105*k)*HCoachWidth, 165, 1, 60)];
        lineImage.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
        [_topView addSubview:lineImage];
    }
    
}

- (void)createDownUI
{
    UIButton * contactBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    contactBtn.frame = CGRectMake((kScreenWidth-181)/2, 28, 181, 31);
    contactBtn.backgroundColor = RGBCOLOR(76, 165, 255);
    contactBtn.layer.cornerRadius = 15.0;
    contactBtn.titleLabel.font = Font15;
    [contactBtn setTitle:@"联系驾校" forState:UIControlStateNormal];
    [contactBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_downView addSubview:contactBtn];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string = @"cell";
    ExamDetailTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[ExamDetailTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    cell.iconView.image = [UIImage imageNamed:_dataImageArr[indexPath.row]];
    cell.messageLabel.text = _dataMessageArr[indexPath.row];
    cell.contentLabel.text = _dataContentArr[indexPath.row];
    return cell;
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
