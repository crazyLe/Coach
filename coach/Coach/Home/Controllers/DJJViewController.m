//
//  DJJViewController.m
//  Coach
//
//  Created by 翁昌青 on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "DJJViewController.h"
#import <YYKit/YYKit.h>
#import "VouchersCell.h"
//  发布代金劵
#import "SendDDJController.h"

#define DDJScale 310.0/375.0

#define kHeadImageHeight kScreenWidth * DDJScale

#define  KheadTop (kHeadImageHeight*256.0)/620.0

#define DDJHScale kHeadImageHeight/620.0
#define DDJWScale kScreenWidth/750.0

@interface DJJViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(weak,nonatomic)UIScrollView *scroll;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation DJJViewController
{
    UILabel *studentNumLbl;
    
    NSArray *couponArr;
    NSArray *couponOldArr;
    NSMutableArray *totalArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"代金劵";
    
    [self setLeftText:nil textColor:nil ImgPath:@"Navigation_Return"];

//    UIScrollView *locscroll = [[UIScrollView alloc]init];
//    
//    locscroll.scrollEnabled = YES;
//    locscroll.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
//
//    [locscroll setContentSize:CGSizeMake(kScreenWidth, 800)];
//    locscroll.delegate = self;
//    self.scroll = locscroll;
//    [self.view addSubview:locscroll];
    
//    [locscroll mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight));
//    }];
    
    [self addHeadView];
    [self addtable];
    [self requestData];
}
-(void)addHeadView
{
    
    self.imageView = [[UIImageView alloc]init];
    self.imageView.userInteractionEnabled = YES;
    
    self.imageView.frame = CGRectMake(0, 0, kScreenWidth, kHeadImageHeight);
    
    self.imageView.image = [UIImage imageNamed:@"iconfont-couponblackbg"];
    
    [self.scroll addSubview:self.imageView];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:@"0名学员已报名优惠"];
    [attr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,Font12,NSFontAttributeName, nil] range:NSMakeRange(0, attr.length)];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:34.0] range:NSMakeRange(0, 2)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 330*DDJWScale, KheadTop, 290*DDJWScale, 35)];
    label.textAlignment = NSTextAlignmentRight;
    label.attributedText = attr;
    [self.imageView addSubview:label];
    studentNumLbl = label;

    UIButton *send = [[UIButton alloc]init];
    send.titleLabel.font = Font16;
    [send setTitleColor:[UIColor colorWithHexString:@"#812715"] forState:UIControlStateNormal];
    [send setTitle:@"发布代金劵" forState:UIControlStateNormal];
    [send addTarget:self action:@selector(sendDDJ) forControlEvents:UIControlEventTouchUpInside];
    [send setBackgroundImage:[UIImage imageNamed:@"iconfont-couponbg"] forState:UIControlStateNormal];
    [self.imageView addSubview:send];
    
    [send mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(12*DDJHScale);
        make.right.mas_equalTo(label.mas_right);
        make.size.mas_equalTo(CGSizeMake(290*DDJWScale, 90*DDJHScale));
    }];
    
    UILabel *tips = [[UILabel alloc]init];
    tips.font = Font13;
    tips.textColor = [UIColor whiteColor];
    tips.text = @"温馨提示：代金劵发布成功将自动到微名片，通过在线报名时将自动减免优惠金额。";
    tips.numberOfLines = 2;
    [self.imageView addSubview:tips];
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(send.mas_bottom).offset(30*DDJHScale);
        make.left.mas_equalTo(90*DDJWScale);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 180*DDJWScale, 90*DDJHScale));
    }];
    
    //设置图片的模式
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    //解决设置UIViewContentModeScaleAspectFill图片超出边框的问题
    self.imageView.clipsToBounds = YES;
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, kHeadImageHeight+20, 100, 20)];

    title.backgroundColor = [UIColor yellowColor];
    title.font = [UIFont systemFontOfSize:12.0];
    title.textColor = [UIColor colorWithHexString:@"#999999"];
    title.text = @"火热进行中";
    
    [self.imageView addSubview:title];
    
}

- (void)addtable
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    
    self.tableView = tableView;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:tableView];
//    [self.scroll addSubview:tableView];
    
    self.tableView.tableHeaderView = self.imageView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return totalArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
//    return section==0?couponArr.count:couponOldArr.count;
}
//@property (weak, nonatomic) IBOutlet UIImageView *leftbg;
//@property (weak, nonatomic) IBOutlet UIImageView *rightbg;
//@property (weak, nonatomic) IBOutlet UILabel *price;
//@property (weak, nonatomic) IBOutlet UILabel *content;
//@property (weak, nonatomic) IBOutlet UILabel *time;
//@property (weak, nonatomic) IBOutlet UIButton *send;
//
//@property (weak, nonatomic) IBOutlet UILabel *juan;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indetify = @"voucherscellID";
    VouchersCell *cell = [tableView dequeueReusableCellWithIdentifier:indetify];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"VouchersCell" owner:nil options:nil]firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (0 == indexPath.section)
    {
        //火热进行优惠券
        cell.send.hidden = YES;
        
    }else
    {
//        cell.leftbg.image = [UIImage imageNamed:@"juanleft_n"];
//        cell.rightbg.image = [UIImage imageNamed:@"un_juan"];
        //往期优惠券
        
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.section < couponArr.count) {
        cell.send.hidden = YES;
    }
    
//    NSDictionary *dic = indexPath.section==0?couponArr[indexPath.row]:couponOldArr[indexPath.row];

    cell.delegate = self;
    cell.indexPath = indexPath;

    NSDictionary *dic = totalArr[indexPath.section];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithHexString:@"000000" alpha:0.3];
    shadow.shadowOffset = CGSizeMake(0, 3);
    NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithText:@"¥" attributes:@[[UIColor whiteColor],[UIFont fontWithName:@"Helvetica-BoldOblique" size:15*kWidthScale],@{NSShadowAttributeName:shadow}]];
    [attStr appendText:dic[@"money"] withAttributesArr:@[[UIColor whiteColor],[UIFont fontWithName:@"Helvetica-BoldOblique" size:25*kWidthScale],@{NSShadowAttributeName:shadow}]];
    cell.price.attributedText = attStr;
    cell.content.text = dic[@"title"];
    NSString *startTime = [LLUtils dateStrWithTimeStamp:dic[@"startTime"] dateFormat:@"yyyy/MM/dd"];
    NSString *endTime = [LLUtils dateStrWithTimeStamp:dic[@"endTime"] dateFormat:@"yyyy/MM/dd"];
    cell.time.text = [NSString stringWithFormat:@"有效期:%@-%@",startTime,endTime];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (0 != couponArr.count) {
        
        if(couponArr.count-1 == section)
        {
            UIView *head1 = [[UIView alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth - 40, 60)];
            
            [head1 setBackgroundColor:[UIColor colorWithHexString:@"#f2f2f2"]];
            
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, 100, 20)];
            title.font = [UIFont systemFontOfSize:12.0];
            title.textColor = [UIColor colorWithHexString:@"#999999"];
            title.text = @"往期优惠";
            
            [head1 addSubview:title];
            
            UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iconfont-couponexit"]];
            img.frame = CGRectMake(kScreenWidth - 20 - 65, 15, 12, 12);
            [head1 addSubview:img];
            
            UILabel *title2 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 20 - 50, 10, 100, 20)];
            title2.font = [UIFont systemFontOfSize:12.0];
            title2.textColor = [UIColor colorWithHexString:@"#999999"];
            title2.text = @"侧划删除";
            
            [head1 addSubview:title2];
            
            return head1;
        }
        }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 50)];
        title.font = [UIFont systemFontOfSize:12.0];
        title.textColor = [UIColor colorWithHexString:@"#999999"];
        title.text = @"火热进行中";
        [view addSubview:title];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (couponArr.count-1 == section) {
        return 60;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteCouponRequest:totalArr[indexPath.section][@"id"]];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    y = (y<0)?-y:y;
    float alpha = y/64;
    alpha = alpha>1?1:alpha;
//    NSLog(@"alpha==%f",alpha);
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithHexString:@"#2e82ff" alpha:alpha]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    //导航栏变为透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    //让黑线消失的方法
    self.navigationController.navigationBar.shadowImage=[UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    self.navigationController.navigationBar.barTintColor = kAppThemeColor;
    [self.navigationController.navigationBar setTranslucent:YES];
}

- (void)setNavigation
{
    self.title = @"代金劵";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}

#pragma mark - 发布代金券

- (void)sendDDJ
{
    checkLogin()
    
    WeakObj(self)
    SendDDJController *send = [[SendDDJController alloc]init];
    send.type = EditCouponTypeAdd;
    send.successBlock = ^(EditCouponType type){
        [selfWeak requestData];
    };
    [self.navigationController pushViewController:send animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - VouchersCellDelegate

- (void)VouchersCell:(VouchersCell *)cell clickRePublicBtn:(UIButton *)republicBtn;
{
    WeakObj(self)
    SendDDJController *send = [[SendDDJController alloc]init];
    send.infoDic = totalArr[cell.indexPath.section];
    send.type = EditCouponTypeEdit;
    send.successBlock = ^(EditCouponType type){
        [selfWeak requestData];
    };
    [self.navigationController pushViewController:send animated:YES];
}

#pragma mark - Network

//获取代金券列表请求
- (void)requestData
{
    [NetworkEngine sendAsynPostRequestRelativeAdd:@"/cashCoupon" paraNameArr:@[@"uid",@"time",@"deviceInfo",@"sign"] paraValueArr:@[kUid,kTimeStamp,kDeviceInfo,kSignWithIdentify(@"/cashCoupon")] completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                [self refreshStudentNum:jsonObj[@"info"][@"studentNum"]];
                
                couponArr = jsonObj[@"info"][@"couponon"];
                couponOldArr = jsonObj[@"info"][@"couponOld"];
                
                NSMutableArray *tempArr = [NSMutableArray array];
                
                for (NSDictionary *temp in couponArr) {
                    [tempArr addObject:temp];
                }
                
                for (NSDictionary *temp1 in couponOldArr) {
                    [tempArr addObject:temp1];
                }
                
                
                 NSLog(@"%d",tempArr.count);
                totalArr = tempArr;
                
                NSLog(@"%d",totalArr.count);
                
                [self.tableView reloadData];
            }
            else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                //需要登录
                
            }
            else
            {
                //失败
            }
        }
    }];
}

- (void)refreshStudentNum:(NSString *)num
{
    NSMutableAttributedString *attr = [NSMutableAttributedString attributeStringWithText:[NSString stringWithFormat:@"%@",isNull(num)?@"0":num] attributes:@[[UIFont systemFontOfSize:34.0],[UIColor whiteColor]]];
    [attr appendText:@"名学员已报名优惠" withAttributesArr:@[[UIColor whiteColor],
                                                     Font12]];
    studentNumLbl.attributedText = attr;
}

//删除代金券请求
- (void)deleteCouponRequest:(NSString *)couponId
{
    NSString *relativeAdd = @"/cashCoupon/delete";
    NSDictionary *paraDic = @{@"uid":kUid,@"coupon_id":couponId,@"time":kTimeStamp,@"sign":kSignWithIdentify(relativeAdd)};
    [NetworkEngine postRequestWithRelativeAdd:relativeAdd paraDic:paraDic completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if (isEqualValue(jsonObj[@"code"], 1)) {
                //成功
                [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
                [self requestData];
            }
            else
            {
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
        }
        else
        {
            [LLUtils showErrorHudWithStatus:@"服务器异常，请稍后"];
        }
    }];
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
