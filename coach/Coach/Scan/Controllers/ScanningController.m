//
//  ScanningController.m
//  KZXC_Headmaster
//
//  Created by 翁昌青 on 16/7/25.
//  Copyright © 2016年 cqingw. All rights reserved.
//

//距离上间距
#define scanningTop 75
//扫描框宽
#define scanningW 240
//扫描框高
#define scanningH 250
//返回按钮名称
#define backStr @"Navigation_Return"

#define isUpIPhone6 ([UIScreen mainScreen].bounds.size.width > 320)

#define isIPhone6 ([UIScreen mainScreen].bounds.size.height == 667)

#define isIPhone5 ([UIScreen mainScreen].bounds.size.height == 568)

#define isIPhpne4 ([UIScreen mainScreen].bounds.size.height == 480)

#import "ScanningController.h"
#import "ValidationFailureController.h"
#import "ValidationSuccessController.h"
#import "ZBarSDK.h"
#import "UIColor+Hex.h"

@interface ScanningController ()<ZBarReaderViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    CGFloat jianju;
    CGFloat scale;
    
    NSString *codeStr;
}
@property(weak,nonatomic)ZBarReaderView *readerview;
@property(weak,nonatomic)UIImageView *bgimg;
@property(weak,nonatomic)UIView *bootomview;
@property(weak,nonatomic)UITextField *filed;
@end

@implementation ScanningController

- (id)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (isIPhpne4) {
        jianju = 20;
        scale = 170;
    }else if (isIPhone5)
    {
        jianju = 15;
        scale = 100;
    }else if (isIPhone6)
    {
        scale = 50;
    }
    
    NSLog(@"%f",kScreenHeight);
    
    ZBarReaderView *readerView = [[ZBarReaderView alloc]init];
    readerView.frame = CGRectMake(0, 0, kScreenWidth , kScreenHeight);
    readerView.readerDelegate = self;
    //关闭闪光灯
    readerView.torchMode = 0;
    //扫描区域
    CGRect scanMaskRect = CGRectMake(0, 80-jianju, kScreenWidth, 250);
    
    //处理模拟器
    if (TARGET_IPHONE_SIMULATOR) {
        ZBarCameraSimulator *cameraSimulator
        = [[ZBarCameraSimulator alloc]initWithViewController:self];
        cameraSimulator.readerView = readerView;
    }
    //扫描区域计算
    readerView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:readerView.bounds];
//    readerView.scanCrop = CGRectMake(0, 0, 1, 1);
    //扫描开始
    [readerView start];
    [self.view addSubview:readerView];
    self.readerview = readerView;
    
    UIImageView *bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scan_bg"]];
    bg.userInteractionEnabled = YES;
    bg.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [self.view addSubview:bg];
    self.bgimg = bg;
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 35, 20, 20)];
    [backBtn setImage:[UIImage imageNamed:backStr] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:backBtn];
    
    NSString *str = @"请扫描学员二维码凭证";
    UILabel *title = [[UILabel alloc]init];
    title.text = str;
    title.font = Font17;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithHexString:@"#999999"];
    [bg addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scanningTop - jianju);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,15));
    }];
    
    UIView *bottom = [[UIView alloc]init];
//    bottom.backgroundColor = [UIColor yellowColor];
    [bg addSubview:bottom];
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(500 - scale);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,200));
    }];
    self.bootomview = bottom;
    
    NSString *str2 = @"若无法扫描请输入12位验证码";
    UILabel *title2 = [[UILabel alloc]init];
    title2.text = str2;
    title2.font = Font17;
    title2.textAlignment = NSTextAlignmentCenter;
    title2.textColor = [UIColor colorWithHexString:@"#999999"];
    [bottom addSubview:title2];
    [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,15));
    }];

    UITextField *text = [[UITextField alloc]init];
    //设置文字内容显示位置
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    text.leftView = paddingView;
    text.leftViewMode = UITextFieldViewModeAlways;
    
    text.delegate = self;
    text.font = Font17;
    text.textColor = [UIColor whiteColor];
    text.layer.cornerRadius = 20.0*kWidthScale;
    
    text.layer.borderWidth = 1;
    text.layer.borderColor = [UIColor whiteColor].CGColor;
    [bottom addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title2.mas_bottom).offset(15);
        make.left.mas_equalTo(45);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 90,45));
    }];
    [text addTarget:self action:@selector(textFieldDidEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    text.keyboardType = UIKeyboardTypeASCIICapable;
    [text addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];

    self.filed = text;
    UIButton *keep = [[UIButton alloc]init];
    [keep addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    keep.backgroundColor = kAppThemeColor;
    keep.layer.cornerRadius = 20.0*kWidthScale;
    keep.titleLabel.font = Font19;
    [keep setTitle:@"验 证" forState:UIControlStateNormal];
    [keep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottom addSubview:keep];
    [keep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(text.mas_bottom).offset(20);
        make.left.mas_equalTo(45);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 90, 45));
    }];
}

- (void)textFieldDidEditingChanged:(UITextField *)textField
{
    codeStr = textField.text;
}

- (void)backBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    x = rect.origin.y / readerViewBounds.size.height;
    y = 1 - (rect.origin.x + rect.size.width) / readerViewBounds.size.width;
    width = (rect.origin.y + rect.size.height) / readerViewBounds.size.height;
    height = 1 - rect.origin.x / readerViewBounds.size.width;
    return CGRectMake(x, y, width, height);
}

-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    
    for (ZBarSymbol *symbol in symbols) {
        NSLog(@"%@", symbol.data);
        codeStr = symbol.data;
        break;
    }
    
//    int a = arc4random()%100;
//    NSLog(@"%d",a);
//    if (a%2) {
//        //待删除
//        
//        ValidationSuccessController * vc = [[ValidationSuccessController alloc]init];
//        [self presentViewController:vc animated:YES completion:nil];
//
//    }else
//    {
//        ValidationFailureController * validationFailureVC= [[ValidationFailureController alloc]init];
//        
//        [self presentViewController:validationFailureVC animated:YES completion:nil];
//    }
    [self validateInfoRequest];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.bootomview.frame;
        rect.origin.y = rect.origin.y - 216;
        self.bootomview.frame = rect;
        
        CGRect rect2 = self.bgimg.frame;
        rect2.origin.y = rect2.origin.y - 216;
        self.bgimg.frame = rect2;
    }];
}

- (void)textFieldDidChanged:(UITextField *)textField
{
    if (textField.text.length>=12) {
        textField.text = [textField.text substringToIndex:12];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(!self.bgimg.bounds.origin.y){
        [self.filed resignFirstResponder];
        self.bgimg.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.bootomview.frame = CGRectMake(0, 500-scale, kScreenWidth, 200);
    }
}


- (void)click
{
    if(!self.bgimg.bounds.origin.y){
        [self.filed resignFirstResponder];
        self.bgimg.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.bootomview.frame = CGRectMake(0, 500-scale, kScreenWidth, 200);
    }
//    NSLog(@"keep ...");
//    int a = arc4random()%100;
//    NSLog(@"%d",a);
//    if (a%2) {
//        //待删除
//        
//        ValidationSuccessController * vc = [[ValidationSuccessController alloc]init];
//        [self presentViewController:vc animated:YES completion:nil];
//        
//    }else
//    {
//        ValidationFailureController * validationFailureVC= [[ValidationFailureController alloc]init];
//        
//        [self presentViewController:validationFailureVC animated:YES completion:nil];
//    }
    [self validateInfoRequest];
}

- (void)keyboardWillHide:(NSNotification *)notify
{
    if(!self.bgimg.bounds.origin.y){
        [self.filed resignFirstResponder];
        self.bgimg.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.bootomview.frame = CGRectMake(0, 500-scale, kScreenWidth, 200);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.readerview) {
        [self.readerview start];
    }
}
//- (void)viewWillDisappear:(BOOL)animated
//{
//     self.navigationController.navigationBar.barTintColor = NavBackColor;
//}

#pragma mark - Network

- (void)validateInfoRequest
{
    [NetworkEngine sendAsynPostRequestRelativeAdd:@"/qrcode" paraNameArr:@[@"uid",@"time",@"code",@"sign"] paraValueArr:@[kUid,kTimeStamp,isEmptyStr(codeStr)?@"":codeStr,kSignWithIdentify(@"/qrcode")] completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            NSLog(@"%@",jsonObj[@"msg"]);
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                ValidationSuccessController * vc = [[ValidationSuccessController alloc]init];
                vc.infoDic = jsonObj[@"info"];
                [self presentViewController:vc animated:YES completion:nil];
            }
            else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                //需要登录
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请先登录" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertView.tag = 100;
                [alertView show];
            }
            else
            {
                //失败
                ValidationFailureController * validationFailureVC= [[ValidationFailureController alloc]init];
                
                [self presentViewController:validationFailureVC animated:YES completion:nil];
            }
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        [self showLoginRegisterWithLoginSuccessBlock:nil];
    }
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
