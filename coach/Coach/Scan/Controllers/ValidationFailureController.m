//
//  ValidationFailureController.m
//  KZXC_Headmaster
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "ValidationFailureController.h"

@interface ValidationFailureController ()

@property (nonatomic,strong)UIView * backView;
@property (nonatomic,strong)UILabel * timeLabel;
@end

@implementation ValidationFailureController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav:@"验证失败"];
    
    [self initWithUI];
    [self initWithData];
    
}

- (void)setupNav:(NSString *)title
{
    
    UIView *barview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    barview.backgroundColor = kAppThemeColor;
    [self.view addSubview:barview];
    
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(15, 20, 44, 44)];
    [back setImage:[UIImage imageNamed:@"Navigation_Return"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [barview addSubview:back];
    
    UILabel *bartitle = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-100)/2, 20, 100, 44)];
    bartitle.textAlignment = NSTextAlignmentCenter;
    bartitle.textColor = [UIColor whiteColor];
    bartitle.text = title;
    bartitle.font = Font22;
    [barview addSubview:bartitle];
    
}

- (void)initWithUI
{
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight)];
//    _backView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_backView];
    
    UIImageView * markImageV = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-75)/2, 50, 75, 75)];
    markImageV.image = [UIImage imageNamed:@"scan_fail"];
//    markImageV.backgroundColor = [UIColor redColor];
    [_backView addSubview:markImageV];
    
    UILabel * validationLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-96)/2, CGRectGetMaxY(markImageV.frame)+16, 96, 23)];
    validationLabel.text = @"验 证 失 败";
    validationLabel.textAlignment = NSTextAlignmentCenter;
//    validationLabel.backgroundColor = [UIColor orangeColor];
    validationLabel.font = Font18;
    validationLabel.textColor = [UIColor colorWithHexString:@"fc812c"];
    [_backView addSubview:validationLabel];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-140)/2, CGRectGetMaxY(validationLabel.frame)+4, 140, 11)];
    _timeLabel.text = @"2016-07-15-14:30";
//    _timeLabel.backgroundColor = [UIColor yellowColor];
    _timeLabel.font = Font15;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [_backView addSubview:_timeLabel];
    
    UIButton * retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    retryBtn.frame = CGRectMake(20, CGRectGetMaxY(_timeLabel.frame)+105, kScreenWidth-40, ButtonH);
    retryBtn.backgroundColor = [UIColor colorWithHexString:@"#fc812c"];
    retryBtn.layer.cornerRadius = ButtonH/2;
    [retryBtn setTitle:@"重新尝试" forState:UIControlStateNormal];
    [retryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [retryBtn addTarget:self action:@selector(pressRetryBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:retryBtn];
    
    UIButton * phoneNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneNumBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    phoneNumBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    phoneNumBtn.titleLabel.font = BoldFontWithSize(18);
    phoneNumBtn.frame = CGRectMake(20, CGRectGetMaxY(retryBtn.frame)+20, kScreenWidth-40, ButtonH);
//    phoneNumBtn.layer.borderWidth = 1;
//    phoneNumBtn.layer.borderColor = [UIColor colorWithHexString:@"#90d659"].CGColor;
    phoneNumBtn.backgroundColor = kAppThemeColor;
    phoneNumBtn.layer.cornerRadius = ButtonH/2;
    [phoneNumBtn setTitle:validationPhoneNum forState:UIControlStateNormal];
    [phoneNumBtn setImage:[UIImage imageNamed:@"iconfont-dianhua"] forState:UIControlStateNormal];
    [phoneNumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phoneNumBtn addTarget:self action:@selector(pressPhoneNumBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:phoneNumBtn];
    
    UILabel * warnLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, CGRectGetMaxY(phoneNumBtn.frame)+8, kScreenWidth-70, 30)];
    warnLabel.text = @"如有疑问请联系客服(点击按钮一键拨号)";
//    warnLabel.backgroundColor = [UIColor orangeColor];
    warnLabel.font = Font15;
    warnLabel.textColor = [UIColor colorWithHexString:@"999999"];
    warnLabel.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:warnLabel];
    [warnLabel sizeToFit];
    warnLabel.center = CGPointMake(phoneNumBtn.center.x, warnLabel.center.y);
}

- (void)initWithData
{
    
}

- (void)pressRetryBtn:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pressPhoneNumBtn:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", validationPhoneNum]];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
