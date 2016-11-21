//
//  ExamPlacesViewController.m
//  Coach
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "ExamPlacesViewController.h"
#import "ExamPlacesTableCell.h"
#import "ExamPlacesDetailController.h"

#define CUSTOM 11
#define PartitionNum 2.0
#define ECJiaDominantHue            [UIColor colorWithRed:0/255.0 green:160/255.0 blue:233/255.0 alpha:1]

@interface ExamPlacesViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _examTableView;
}
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *topButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) ExamPlacesType type;
@end

@implementation ExamPlacesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initWithUI
{
    [super initWithUI];
    self.title = @"考试名额";
    
    [self createTopBtn];
    [self createUI];
}

- (void)createTopBtn
{
    
    if (self.numString == nil) {
        self.numString = @"0";
        _type = ExamPlacesBuy;
    }else if([self.numString isEqualToString:@"0"]){
        //        self.numString = @"0";
        _type = ExamPlacesBuy;
        //        _goodsType = 3;
    }else if([self.numString isEqualToString:@"1"]){
        //        self.numString = @"1";
        _type = ExamPlacesSell;
        //        _goodsType = 6;
    }
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"买入", @"卖出", nil];
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 4 * CUSTOM)];
    //    self.topView.backgroundColor = [UIColor redColor];
    for (int i = 0; i < 2; i++) {
        self.topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.topButton.frame = CGRectMake(kScreenWidth * i / PartitionNum, 0, kScreenWidth / PartitionNum, 4 * CUSTOM);
        [self.topButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.topButton.tag = 1000 + i;
        
        //        self.topButton.userInteractionEnabled = NO;
        self.topButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.topButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [self.topButton addTarget:self action:@selector(topButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        self.topButton.backgroundColor = [UIColor whiteColor];
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 3.7 * CUSTOM, kScreenWidth / PartitionNum, 3.0)];
        if (self.topButton.tag == 1000 + [_numString integerValue]) {
            self.lineView.backgroundColor = ECJiaDominantHue;
        }
        //        if(self.topButton.tag == 1000 + ){
        //            self.lineView.backgroundColor = ECJiaDominantHue;
        //        }
        self.lineView.tag = 1100 + i;
        [self.topButton addSubview:_lineView];
        [self.topView addSubview:_topButton];
    }
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 3.9 * CUSTOM, kScreenWidth, 1.0)];
    colorView.backgroundColor = ECJiaDominantHue;
    [self.topView addSubview:colorView];
    [self.view addSubview:_topView];
    
}

//顶部按钮触发事件
- (void)topButtonTouch:(UIButton *)aButton {
    
    //    self.tableView.tag = 3000 + aButton.tag - 1000;
    //    NSInteger count = aButton.tag - 1000;
    //    [self getNetWorkData:[NSString stringWithFormat:@"%ld", (long)count]];
    
    //    if(_orderArray.count != 0){
    //        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    //    }
    
    for (UIButton *button in self.topView.subviews) {
        if (button.tag == aButton.tag) {
            //            [button setTitleColor:ECJiaDominantHue forState:UIControlStateNormal];
            for (UIView *view in button.subviews) {
                if (view.tag == button.tag + 100) {
                    view.backgroundColor = ECJiaDominantHue;
                }
            }
        } else {
            //            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            for (UIView *view in button.subviews) {
                if (view.tag > 1090 && view.tag < 1200) {
                    view.backgroundColor = [UIColor clearColor];
                }
            }
        }
        //        button.userInteractionEnabled = NO;
    }
}


- (void)createUI
{
    _examTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+44, kScreenWidth, kScreenHeight-64-40) style:UITableViewStylePlain];
    _examTableView.delegate = self;
    _examTableView.dataSource = self;
    _examTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _examTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_examTableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 113;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string = @"cell";
    ExamPlacesTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[ExamPlacesTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExamPlacesDetailController * examDetailVC = [[ExamPlacesDetailController alloc]init];
    [self.navigationController pushViewController:examDetailVC animated:YES];
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
