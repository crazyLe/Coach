//
//  AccountSecurityVC.m
//  Coach
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "AccountSecurityVC.h"

@interface AccountSecurityVC ()
{
    NSTimer *_timerOld;
    NSTimer *_timerNew;
}
@property (nonatomic, strong)UIView * passWordView;
@property (nonatomic, strong)UIView * mobileView;

@property (nonatomic, strong) UIButton * oldSendBtn;
@property (nonatomic, strong) UIButton * modifySendBtn;

@end

@implementation AccountSecurityVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initWithUI
{
    [super initWithUI];
    
    self.view.backgroundColor = rgb(239, 239, 239);
    [self setUpNavigationBar];
    [self createUI];
    
}

- (void)initWithData
{
    [super initWithData];

}

#pragma mark --- 初始化导航条
- (void)setUpNavigationBar
{
    UIView * barView = [[UIView alloc]init];
    barView.backgroundColor = kAppThemeColor;
    barView.userInteractionEnabled = YES;
    barView.tag = 10;
    barView.frame = CGRectMake(0.f, 0, kScreenWidth, 64.f);
    [self.view addSubview:barView];
    
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 40, 44);
//    backBtn.backgroundColor = [UIColor redColor];
    [backBtn setImage:[UIImage imageNamed:@"NavigationBar_Return"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pressBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:backBtn];
    
    NSArray * segemntArray = @[@"修改密码",@"修改手机号"];
    UISegmentedControl * segment = [[UISegmentedControl alloc]initWithItems:segemntArray];
    segment.selectedSegmentIndex = 0;
    segment.tintColor = [UIColor whiteColor];
    segment.frame = CGRectMake((kScreenWidth-212)/2, 7+20, 212, 30);
    [segment addTarget:self action:@selector(segementValueChanged:) forControlEvents:UIControlEventValueChanged];
    [barView addSubview:segment];
    
}

- (void)createUI
{
    _passWordView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 247)];
    //    _passWordView.backgroundColor = [UIColor cyanColor];
    _passWordView.backgroundColor = rgb(239, 239, 239);
    [self.view addSubview:_passWordView];
    [self createPassWordView];
    
    _mobileView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 300)];
    _mobileView.backgroundColor = rgb(239, 239, 239);
    _mobileView.hidden = YES;
    [self.view addSubview:_mobileView];
    [self createMobileView];
}

- (void)createPassWordView
{
    NSArray * arr = @[@"请输入旧密码",@"输入新密码",@"再次确认新密码"];
    for (int i=0; i<3; i++)
    {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 10+54*i, kScreenWidth, 54)];
        view.backgroundColor = [UIColor whiteColor];
        [_passWordView addSubview:view];
        
        UITextField * field = [[UITextField alloc]initWithFrame:CGRectMake(15, 7, kScreenWidth-15*2, 40)];
//        field.backgroundColor = [UIColor orangeColor];
        field.placeholder = arr[i];
        field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:arr[i] attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"999999"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        field.tag = 100+100*i;
        [view addSubview:field];
        field.secureTextEntry = YES;
        
        if (i<2) {
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height-kLineWidth, view.frame.size.width, kLineWidth)];
            lineView.backgroundColor = rgb(231, 231, 231);
            [view addSubview:lineView];
        }
    }
    
    UIButton * ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ensureBtn.frame = CGRectMake(38, 163+20, kScreenWidth-38*2, 44);
    ensureBtn.layer.cornerRadius = 22.0;
    ensureBtn.tag = 1000;
    ensureBtn.backgroundColor = kAppThemeColor;
    [ensureBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [ensureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ensureBtn addTarget:self action:@selector(pressEnsureBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_passWordView addSubview:ensureBtn];
    
}

- (void)createMobileView
{
    NSArray * arr = @[@"输入原绑定手机号码",@"验证码",@"输入新绑定手机号码",@"验证码"];
    for (int i=0; i<4; i++)
    {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 10+54*i, kScreenWidth, 54)];
        view.backgroundColor = [UIColor whiteColor];
        [_mobileView addSubview:view];
        
        UITextField * field = [[UITextField alloc]initWithFrame:CGRectMake(15, 7, kScreenWidth-15*2, 40)];
//        field.backgroundColor = [UIColor orangeColor];
        field.font = Font15;
        field.textColor = rgb(30, 30, 30);
        field.placeholder = arr[i];
        field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:arr[i] attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"999999"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        field.tag = 500+10*i;
        [view addSubview:field];
         field.keyboardType = UIKeyboardTypeNumberPad;
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height-kLineWidth, view.frame.size.width, kLineWidth)];
        lineView.backgroundColor = rgb(231, 231, 231);
        [view addSubview:lineView];
        
        if (i == 1 || i==3) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(kScreenWidth-12-99, 9, 99, 35);
            btn.layer.cornerRadius = 5.0;
            btn.tag = 10+10*i;
            btn.titleLabel.font = Font15;
            btn.backgroundColor = [UIColor colorWithHexString:@"95c0ff"];
            [btn setTitle:@"发送" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(clickSendBtn:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
        }
        else
        {
           
        }
        
    }
    UIButton * ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ensureBtn.frame = CGRectMake(38, 215+20, kScreenWidth-38*2, 44);
    ensureBtn.layer.cornerRadius = 22.0;
    ensureBtn.tag = 2000;
    ensureBtn.backgroundColor = kAppThemeColor;
    [ensureBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [ensureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ensureBtn addTarget:self action:@selector(pressEnsureBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_mobileView addSubview:ensureBtn];
}

- (void)pressBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)segementValueChanged:(UISegmentedControl *)segment
{
    NSInteger index = segment.selectedSegmentIndex;
    switch (index) {
        case 0:
        {
//            NSLog(@"0");
            _passWordView.hidden = NO;
            _mobileView.hidden = YES;
            
        }
            break;
        case 1:
        {
//            NSLog(@"1");
            _passWordView.hidden = YES;
            _mobileView.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

- (void)clickSendBtn:(UIButton *)sender
{
    UIButton * btn = sender;
    switch (sender.tag) {
        case 20:
        {
            _oldSendBtn = btn;
            [self requestOldSendData];
            
        }
            break;
        case 40:
        {
            _modifySendBtn = btn;
            [self requesModifySendData];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)requestOldSendData
{
//    NSLog(@"20");
//    btn.backgroundColor = [UIColor colorWithHexString:@"b0b0b0"];
//    [btn setTitle:@"已发送(153)" forState:UIControlStateNormal];
    [self.view endEditing:YES];
    
    UITextField * fieldOne = [self.view viewWithTag:500];
    if ([fieldOne.text isEqualToString:@""]) {
        [self.hudManager showErrorSVHudWithTitle:@"请输入手机号码" hideAfterDelay:1.0f];
//        [LLUtils showErrorHudWithStatus:@"请输入手机号码"];
        return;
    }
    
    if (![LLUtils validateMobile:fieldOne.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"手机号不正确" hideAfterDelay:1.0f];
        return;
    }
    
    [LLUtils showTextAndProgressHud:@"正在加载"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = fieldOne.text;
    param[@"time"] = kTimeStamp;
    param[@"flag"] = @"changemobile";
    
    [NetworkEngine postRequestWithRelativeAdd:@"/user/sendCode" paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
        [LLUtils dismiss];
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                NSString * jstr = [LLUtils jsonStrWithJSONObject:jsonObj];
                NSString * str = [LLUtils replaceUnicode:jstr];
                
                NSLog(@"%@",str);
                
                //请求成功，取消按钮的点击
                self.oldSendBtn.userInteractionEnabled = NO;
                //设置验证码的button的title
                [self.oldSendBtn setTitle:@"已发送(60s)" forState:UIControlStateNormal];
//                self.OldSendBtnWidthConstraint.constant = 100;
                self.oldSendBtn.backgroundColor = [UIColor colorWithHexString:@"b0b0b0"];
                
                //倒计时
                _timerOld =[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop]addTimer:_timerOld forMode:NSRunLoopCommonModes];
                
            }
            else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                //需要登录
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
            else
            {
                
                //失败
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
//                [LLUtils showErrorHudWithStatus:@"获取验证码失败"];
            }
        
        }
    }
     ];
}

- (void)timeChange
{
    NSString *time = [self.oldSendBtn.titleLabel.text substringWithRange:NSMakeRange(4, 2)];
    if ([time integerValue] == 0) {
        //倒计时结束，开启用户交互
        self.oldSendBtn.userInteractionEnabled = YES;
//        self.OldSendBtnWidthConstraint.constant = 70;
        self.oldSendBtn.backgroundColor = [UIColor colorWithHexString:@"95c0ff"];
        [self.oldSendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_timerOld invalidate];
        _timerOld = nil;
        return;
    }
    NSString *str = [NSString stringWithFormat:@"已发送(%ds)",[time intValue]-1];
    [self.oldSendBtn setTitle:str forState:UIControlStateNormal];
}

- (void)requesModifySendData
{
    
    [self.view endEditing:YES];
    UITextField * fieldThree = [self.view viewWithTag:520];
    if ([fieldThree.text isEqualToString:@""]) {
        [self.hudManager showErrorSVHudWithTitle:@"请输入手机号码" hideAfterDelay:1.0f];
        return;
    }
    
    if (![LLUtils validateMobile:fieldThree.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"手机号不正确" hideAfterDelay:1.0f];
        return;
    }
    
    [LLUtils showTextAndProgressHud:@"正在发送"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = fieldThree.text;
    param[@"time"] = kTimeStamp;
    param[@"flag"] = @"changemobile";
    
//    [self.hudManager showSuccessKVNHudWithTitle:@"手机号码修改成功" hideAfterDelay:1.0f];
    
    
    [NetworkEngine postRequestWithRelativeAdd:@"/user/sendCode" paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
        [LLUtils dismiss];
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                NSString * jstr = [LLUtils jsonStrWithJSONObject:jsonObj];
                NSString * str = [LLUtils replaceUnicode:jstr];
                
                NSLog(@"%@",str);
                
                //请求成功，取消按钮的点击
                self.modifySendBtn.userInteractionEnabled = NO;
                //设置验证码的button的title
                [self.modifySendBtn setTitle:@"已发送(60s)" forState:UIControlStateNormal];
                //                self.OldSendBtnWidthConstraint.constant = 100;
                self.modifySendBtn.backgroundColor = [UIColor colorWithHexString:@"b0b0b0"];
                
                //倒计时
                _timerNew =[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeChange2) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop]addTimer:_timerNew forMode:NSRunLoopCommonModes];
                
            }
            else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                //需要登录
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
            else
            {
                
                //失败
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
                //                [LLUtils showErrorHudWithStatus:@"获取验证码失败"];
            }
            
        }
    }
     ];
}

-(void)timeChange2
{
    NSString *time = [self.modifySendBtn.titleLabel.text substringWithRange:NSMakeRange(4, 2)];
    if ([time integerValue] == 0) {
        //倒计时结束，开启用户交互
        self.modifySendBtn.userInteractionEnabled = YES;
//        self.NewSendBtnWidthConstraint.constant = 70;
        self.modifySendBtn.backgroundColor = [UIColor colorWithHexString:@"95c0ff"];
        [self.modifySendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_timerNew invalidate];
        _timerNew = nil;
        return;
    }
    NSString *str = [NSString stringWithFormat:@"已发送(%ds)",[time intValue]-1];
    [self.modifySendBtn setTitle:str forState:UIControlStateNormal];
    
    
}


- (void)pressEnsureBtn:(UIButton *)sender
{
    switch (sender.tag) {
        case 1000:
        {
            [self submitPassWordWithData];
        }
            break;
        case 2000:
        {
            [self submitMobilePhone];
        }
            break;
            
        default:
            break;
    }
}

//确认修改密码按钮
- (void)submitPassWordWithData
{
    [self.view endEditing:YES];
    
    UITextField * field1 = [self.view viewWithTag:100];
    UITextField * field2 = [self.view viewWithTag:200];
    UITextField * field3 = [self.view viewWithTag:300];
    
    if (![field2.text isEqualToString:field3.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"两次输入的密码不一致" hideAfterDelay:1.0f];
        return;
    }
    
    if (![LLUtils validatePassword:field2.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"密码必须在6-20位之间" hideAfterDelay:1.0f];
        return;
    }
    
//    [LLUtils showTextAndProgressHud:@"正在确认"];
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = kTimeStamp;
    param[@"sign"] = kSignWithIdentify(@"/editPassword");
    param[@"oPwd"] = field1.text;
    param[@"nPwd"] = field2.text;
    
    [NetworkEngine postRequestWithRelativeAdd:@"/editPassword" paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                NSString * jstr = [LLUtils jsonStrWithJSONObject:jsonObj];
                NSString * str = [LLUtils replaceUnicode:jstr];
                
                NSLog(@"%@",str);
                [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
                
                if (_successBlock) {
                    _successBlock();
                }
                [self.navigationController popViewControllerAnimated:NO];
                
            }
            else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                //需要登录
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
            else
            {
                //失败
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
        }
    }];
}

//确认修改手机号码按钮
- (void)submitMobilePhone
{
    [self.view endEditing:YES];
    
    UITextField * fieldOne = [self.view viewWithTag:500];
    UITextField * fieldTwo = [self.view viewWithTag:510];
    UITextField * fieldThree = [self.view viewWithTag:520];
    UITextField * fieldFour = [self.view viewWithTag:530];
    
    if ([fieldOne.text isEqualToString:@""]) {
        [self.hudManager showErrorSVHudWithTitle:@"请输入原绑定手机号码" hideAfterDelay:1.0f];
        return;
    }else if (![LLUtils validateMobile:fieldOne.text]){
        [self.hudManager showErrorSVHudWithTitle:@"原绑定手机号不正确" hideAfterDelay:1.0f];
        return;
    }
    
    if ([fieldTwo.text isEqualToString:@""]) {
        [self.hudManager showErrorSVHudWithTitle:@"请输入原绑定手机号验证码" hideAfterDelay:1.0f];
        return;
    }
    
    if ([fieldThree.text isEqualToString:@""]) {
        [self.hudManager showErrorSVHudWithTitle:@"请输入新绑定手机号码" hideAfterDelay:1.0f];
        return;
    }else if (![LLUtils validateMobile:fieldThree.text]){
        [self.hudManager showErrorSVHudWithTitle:@"新绑定手机号不正确" hideAfterDelay:1.0f];
        return;
    }
    
    if ([fieldFour.text isEqualToString:@""]) {
        [self.hudManager showErrorSVHudWithTitle:@"请输入新手机号验证码" hideAfterDelay:1.0f];
        return;
    }

//    [LLUtils showTextAndProgressHud:@"正在确认"];
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = kTimeStamp;
    param[@"sign"] = kSignWithIdentify(@"/editPhone");
    param[@"oPhone"] = fieldOne.text;
    param[@"oCode"] = fieldTwo.text;
    param[@"nPhone"] = fieldThree.text;
    param[@"nCode"] = fieldFour.text;
    
    [NetworkEngine postRequestWithRelativeAdd:@"/editPhone" paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
        [LLUtils dismiss];
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                NSString * jstr = [LLUtils jsonStrWithJSONObject:jsonObj];
                NSString * str = [LLUtils replaceUnicode:jstr];
                
                NSLog(@"%@",str);
//                [LLUtils showSuccessHudWithStatus:@"手机号码修改成功"];
                [LLUtils showSuccessHudWithStatus:@"手机号码修改成功"];
                if (_successBlock) {
                    _successBlock();
                }
                [self.navigationController popViewControllerAnimated:NO];
            }
            else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                //需要登录
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
            else
            {
                //失败
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
        }
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
