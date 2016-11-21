//
//  OrderInfomationVC.m
//  Coach
//
//  Created by gaobin on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "OrderInfomationVC.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "PToderFirstTableCell.h"
#import "PToderSecondTableCell.h"
#import "PersonThirdTableCell.h"
#import "PersonFourthTableCell.h"
#import "OrderInfomationCell.h"
#import "RepaymentResultVC.h"

@interface OrderInfomationVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,PersonFourthTableCellDelegete>

@property (nonatomic, strong) UITableView * orderTableView;
@property (nonatomic, strong) UIScrollView * backScrollView;
@property (nonatomic, strong) UIImageView * topImageView;
@property (nonatomic, strong) UIButton * paymentBtn;

@end

@implementation OrderInfomationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creaeteNavigation];
    
    [self createUI];
    
    
}
- (void)createUI {
    
    _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    _backScrollView.delegate = self;
    _backScrollView.showsVerticalScrollIndicator =  NO;
    _backScrollView.contentSize = CGSizeMake(kScreenWidth, 664 + 38*3 );
    [self.view addSubview:_backScrollView];
    
    [self createTopImageView];
    

    
}
- (void)createTopImageView {
    
    _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 476+105 +38*3)];
    _topImageView.contentMode = UIViewContentModeScaleToFill;
    _topImageView.image = [UIImage imageNamed:@"组-4"];
    _topImageView.userInteractionEnabled = YES;
    [_backScrollView addSubview:_topImageView];
    
    _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 15, kScreenWidth-15*2, 397+104+9 +38*3) style:UITableViewStylePlain];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    _orderTableView.separatorColor = [UIColor colorWithHexString:@"f0f0f0"];
    _orderTableView.showsVerticalScrollIndicator = NO;
    _orderTableView.backgroundColor = [UIColor clearColor];
    _orderTableView.scrollEnabled = NO;
    [_topImageView addSubview:_orderTableView];
    [_orderTableView registerClass:[PToderFirstTableCell class] forCellReuseIdentifier:@"PToderFirstTableCell"];
    [_orderTableView registerNib:[UINib nibWithNibName:@"OrderInfomationCell" bundle:nil] forCellReuseIdentifier:@"OrderInfomationCell"];
    
    
    
    _paymentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _paymentBtn.frame = CGRectMake(64, CGRectGetMaxY(_topImageView.frame), kScreenWidth-64*2, 40);
    
    _paymentBtn.backgroundColor = [UIColor colorWithHexString:@"#fc812c"];
    _paymentBtn.layer.cornerRadius = 20.0;
    NSMutableAttributedString * payStr = nil;
    payStr = [[NSMutableAttributedString alloc]initWithString:@"支付" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    [payStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"¥2100.00" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}]];
    [payStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"元" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
    [_paymentBtn setAttributedTitle:payStr forState:UIControlStateNormal];
    [_paymentBtn addTarget:self action:@selector(clickPayBtn) forControlEvents:UIControlEventTouchUpInside];
    [_backScrollView addSubview:_paymentBtn];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        static NSString *identifier = @"OrderInfomationCell";
        OrderInfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
        
        
    }else if (indexPath.row == 1){
        static NSString * string = @"cellTwo";
        PToderSecondTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[PToderSecondTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 2){
        static NSString * string = @"cellThree";
        PersonThirdTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[PersonThirdTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else if(indexPath.row == 3){
        static NSString * string = @"cellFour";
        PersonFourthTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[PersonFourthTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        cell.delegate = self;
        cell.warningLabel.hidden = NO;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        return [tableView fd_heightForCellWithIdentifier:@"OrderInfomationCell" cacheByIndexPath:indexPath configuration:^(OrderInfomationCell * cell) {
            cell.backgroundColor = [UIColor clearColor];
        }];

        
    }if (indexPath.row == 1) {
        
        //返回的行高应是你选择的订单的个数加1(最后一行为总计)
        return 38 * 6;
    }if (indexPath.row == 2) {
        
        return 55;
    }else {
        
        return 134;
    }
    

}
- (void)clickPayBtn {
    
    RepaymentResultVC * vc = [[RepaymentResultVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];

    
}
- (void)creaeteNavigation {
    
    [self setTitleText:@"订单" textColor:nil];
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
