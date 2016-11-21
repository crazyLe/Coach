//
//  EarnPublishVC.m
//  Coach
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EarnPublishVC.h"
#import "DateView.h"
//#import "EarnView.h"

static NSInteger spacingNum = 0;
@interface EarnPublishVC ()<DateViewDelegate>

@property (nonatomic ,strong) UIScrollView * backScrollView;

@property (nonatomic ,strong) UIView * secondView;
@property (nonatomic ,strong) UIView * thirdView;

@property (nonatomic ,strong) UIView * customView;

/// DateView
@property (nonatomic,strong) DateView *dateView;

//打的黑色背景
@property (nonatomic, strong) UIButton *grayBackBtn;

@end

@implementation EarnPublishVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initWithUI
{
    [super initWithUI];
    self.title = @"发布";
    [self createFirstView];
    [self createSecondView];
    [self createThirdView];
    [self createFourthView];
}

- (void)initWithData
{
    [super initWithData];
    _dateView.dataArray = @[@"周日",@"周日",@"周日",@"周日",@"周日",@"周日",@"周日",@"周日",@"周日",@"周日",@"周日"];
}

- (void)createFirstView
{
//    _dateView = [[DateView alloc] initWithFrame:CGRectMake(0, 64+7, self.view.frame.size.width, 44)];
//    _dateView.delegate  = self;
//    [self.view addSubview:_dateView];
    
//    EarnView * earnView = [[EarnView alloc]initWithFrame:CGRectMake(0, 64+7, kScreenWidth, 72)];
//    earnView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:earnView];
//    
}

- (void)createSecondView
{
    _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+72+7+15, kScreenWidth, kScreenHeight-64-44-7)];
    //    _backScrollView.backgroundColor = [UIColor cyanColor];
    _backScrollView.backgroundColor = [UIColor colorWithHexString:@"#f2f6f7"];
    //    _backScrollView.contentSize=CGSizeMake(kScreenWidth,667-64+100);
    _backScrollView.contentSize = CGSizeMake(kScreenWidth, 631);
    _backScrollView.delegate = self;
    _backScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_backScrollView];
    
    spacingNum = (kScreenWidth - 111*3*HCoachWidth)/4;
    
    //    _secondView = [[UIView alloc]initWithFrame:CGRectMake(0, 58, kScreenWidth, 183)];
    _secondView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 183)];
    _secondView.backgroundColor = [UIColor whiteColor];
    [_backScrollView addSubview:_secondView];
    
    NSLog(@"++%ld++",(long)spacingNum);
    for (int i=0; i<2; i++) {
        for (int j=0; j<3; j++) {
            
            UIView * chooseView = [[UIView alloc]initWithFrame:CGRectMake(j*(spacingNum+111*HCoachWidth)+spacingNum, 20+i*(9+66), 111*HCoachWidth, 66)];
            //            chooseView.backgroundColor = [UIColor yellowColor];
            chooseView.backgroundColor = [UIColor whiteColor];
            chooseView.layer.borderWidth = 1;
            chooseView.layer.borderColor = [[UIColor colorWithHexString:@"#5cb6ff"] CGColor];
            chooseView.tag = i*3+j;
            [_secondView addSubview:chooseView];
            
            UILabel * dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, chooseView.frame.size.width, 25)];
            dateLabel.text = @"07:00-08:00";
            dateLabel.backgroundColor = [UIColor colorWithHexString:@"5cb6ff"];
            dateLabel.textColor = [UIColor whiteColor];
            dateLabel.font = Font11;
            dateLabel.textAlignment = NSTextAlignmentCenter;
            [chooseView addSubview:dateLabel];
            
            UILabel * subjectsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(dateLabel.frame)+8, chooseView.frame.size.width, 10)];
            subjectsLabel.textColor = RGBCOLOR(81, 173, 255);
            subjectsLabel.text = @"科二";
            subjectsLabel.font = Font10;
            subjectsLabel.textAlignment = NSTextAlignmentCenter;
            [chooseView addSubview:subjectsLabel];
            
            UILabel * personNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(subjectsLabel.frame)+2, chooseView.frame.size.width, 10)];
            personNumLabel.text = @"¥ 50/人";
            personNumLabel.font = Font10;
            personNumLabel.textAlignment = NSTextAlignmentCenter;
            personNumLabel.textColor = RGBCOLOR(81, 173, 255);
            [chooseView addSubview:personNumLabel];
        }
        
    }
}

- (void)createThirdView
{
    _thirdView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_secondView.frame)+8, kScreenWidth, 235)];
    _thirdView.backgroundColor = [UIColor whiteColor];
    [_backScrollView addSubview:_thirdView];
    
    UILabel * customLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 44)];
    customLabel.text = @"自定义时段：";
    customLabel.font = Font13;
    //    customLabel.backgroundColor = [UIColor greenColor];
    [_thirdView addSubview:customLabel];
    
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(customLabel.frame), kScreenWidth, 1)];
    lineLabel.backgroundColor = RGBCOLOR(214, 214, 214);
    [_thirdView addSubview:lineLabel];
    
    for (int i=0; i<2; i++) {
        
        _customView = [[UIView alloc]initWithFrame:CGRectMake(spacingNum+i*(spacingNum+111*HCoachWidth), CGRectGetMaxY(lineLabel.frame)+23, 111*HCoachWidth, 80)];
        //        customView.backgroundColor = [UIColor orangeColor];
        _customView.backgroundColor = [UIColor whiteColor];
        _customView.layer.borderWidth = 1;
        _customView.layer.borderColor = [[UIColor colorWithHexString:@"#5cb6ff"] CGColor];
        [_thirdView addSubview:_customView];
        
        UIView * topCusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _customView.frame.size.width, 38)];
        topCusView.backgroundColor = [UIColor colorWithHexString:@"#5cb6ff"];
        [_customView addSubview:topCusView];
        
        UILabel * yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, _customView.frame.size.width, 10)];
        yearLabel.textAlignment = NSTextAlignmentCenter;
        yearLabel.textColor = [UIColor whiteColor];
        yearLabel.text = @"2016-6-17";
        yearLabel.font = Font11;
        [topCusView addSubview:yearLabel];
        
        UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(yearLabel.frame)+4, _customView.frame.size.width, 10)];
        timeLabel.text = @"07:00-08:00";
        timeLabel.font = Font11;
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [topCusView addSubview:timeLabel];
        
        
        UILabel * subjectsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topCusView.frame)+8, topCusView.frame.size.width, 10)];
        subjectsLabel.textColor = RGBCOLOR(81, 173, 255);
        subjectsLabel.text = @"科二";
        subjectsLabel.font = Font10;
        subjectsLabel.textAlignment = NSTextAlignmentCenter;
        [_customView addSubview:subjectsLabel];
        
        UILabel * personNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(subjectsLabel.frame)+2, topCusView.frame.size.width, 10)];
        personNumLabel.text = @"¥ 50/人";
        personNumLabel.font = Font10;
        personNumLabel.textAlignment = NSTextAlignmentCenter;
        personNumLabel.textColor = RGBCOLOR(81, 173, 255);
        [_customView addSubview:personNumLabel];
        
    }

    
    UIButton * bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake((kScreenWidth-151)/2, CGRectGetMaxY(_customView.frame)+20, 151, 40);
    bottomBtn.backgroundColor = kAppThemeColor;
    [bottomBtn setTitle:@"分享给学员" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = Font18;
    bottomBtn.layer.cornerRadius = 20.0;
    [bottomBtn addTarget:self action:@selector(pressBottomBtn) forControlEvents:UIControlEventTouchUpInside];
    [_thirdView addSubview:bottomBtn];
    

    
}

- (void)createFourthView
{
    UIView * fourthView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_thirdView.frame)+8, kScreenWidth, 197)];
    //    fourthView.backgroundColor = [UIColor orangeColor];
    [_backScrollView addSubview:fourthView];
    
    
    UIButton * publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame = CGRectMake(15, 88, kScreenWidth-15*2, 40);
    publishBtn.backgroundColor = kAppThemeColor;
    [publishBtn setTitle:@"一键发布" forState:UIControlStateNormal];
    [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    publishBtn.titleLabel.font = Font18;
    publishBtn.layer.cornerRadius = 20.0;
    [publishBtn addTarget:self action:@selector(pressPublishBtn) forControlEvents:UIControlEventTouchUpInside];
    [fourthView addSubview:publishBtn];
    
}

- (void)rightBtnAction
{
    
}

- (void)pressBottomBtn
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIButton *grayBackBtn = [[UIButton alloc] init];
    grayBackBtn.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    grayBackBtn.backgroundColor = [UIColor colorWithRed:25/255.0 green: 25/255.0 blue:25/255.0 alpha:0.5];
    //    clearBtn.backgroundColor = [UIColor brownColor];
    [window addSubview:grayBackBtn];
    [grayBackBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.grayBackBtn = grayBackBtn;
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0,kScreenHeight-245, kScreenWidth, 245)];
//    backView.layer.cornerRadius = 5.0;
    backView.backgroundColor = [UIColor whiteColor];
    [grayBackBtn addSubview:backView];
    
    UILabel * chooseLabel = [[UILabel alloc]initWithFrame:CGRectMake((backView.frame.size.width-100)/2, 29, 100, 15)];
    //    chooseLabel.backgroundColor = [UIColor orangeColor];
    chooseLabel.text = @"将页面分享到：";
    chooseLabel.textColor = [UIColor colorWithHexString:@"#b9b9b9"];
    chooseLabel.textAlignment = NSTextAlignmentCenter;
    chooseLabel.font = Font14;
    [backView addSubview:chooseLabel];
    
    
    
//    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(chooseLabel.frame)+29, backView.frame.size.width, 1)];
//    lineLabel.backgroundColor = [UIColor colorWithHexString:@"#b7d6ff"];
//    [backView addSubview:lineLabel];
    
    NSInteger spaceNum = (kScreenWidth-55*4-25*2*kScreenWidth/375.0)/3;
    NSArray * imageArr = @[@"earn_weixin",@"earn_pengyouquan",@"earn_weibo",@"earn_qq"];
    NSArray * shareArr = @[@"朋友圈",@"微信",@"新浪微博",@"QQ空间"];
    for (int i =0; i<4; i++) {
        UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.frame = CGRectMake((25*kScreenWidth/375.0+i*(55+spaceNum)), CGRectGetMaxY(chooseLabel.frame)+29, 55, 55);
//        shareBtn.backgroundColor = [UIColor purpleColor];
        shareBtn.tag = 100+i*10;
        [shareBtn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(pressShareBtn:) forControlEvents:UIControlEventTouchUpInside];
        //        [self.view addSubview:shareBtn];
        [backView addSubview:shareBtn];
        
        UILabel * shareLabel = [[UILabel alloc]initWithFrame:CGRectMake((25*kScreenWidth/375.0+i*(55+spaceNum)), CGRectGetMaxY(shareBtn.frame)+13, 55, 12)];
//        shareLabel.backgroundColor = [UIColor blueColor];
        shareLabel.text = shareArr[i];
        shareLabel.textAlignment = NSTextAlignmentCenter;
        shareLabel.textColor = [UIColor colorWithHexString:@"b8b8b8"];
        shareLabel.font = Font11;
        [backView addSubview:shareLabel];
    }
    
    UIButton * cancelBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake((backView.frame.size.width-100)/2, 180, 100, 36);
    //    cancelBtn.backgroundColor = [UIColor redColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    cancelBtn.layer.cornerRadius = 4.0;
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.titleLabel.font = Font18;
    cancelBtn.layer.borderColor = [UIColor colorWithHexString:@"6e6e6e"].CGColor;
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:cancelBtn];

}

- (void)pressPublishBtn
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"学时发布成功后才能分享给学员\n确定要发布？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        
    }
}

- (void)cancelBtnClick
{
    [self.grayBackBtn removeFromSuperview];
}

- (void)pressShareBtn:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
        {
            NSLog(@"100");
        }
            break;
        case 110:
        {
            NSLog(@"110");
        }
            break;
        case 120:
        {
            NSLog(@"120");
        }
            break;
        case 130:
        {
            NSLog(@"130");
        }
            break;
            
        default:
            break;
    }
}

//选中日期
- (void)dateViewDidSelectedIndex:(NSInteger)index
{
    //        NSLog(@"开放时间管理,选择日期");
    
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
