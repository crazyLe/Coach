//
//  WMPPopView.m
//  KZXC_Headmaster
//
//  Created by 翁昌青 on 16/8/16.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#define kHeight kScreenHeight
#define kWidth  kScreenWidth

#import <IQKeyboardManager.h>
#import <SVProgressHUD.h>

#import "WMPPopView.h"
#import "DrivingTypeCell.h"

@implementation WMPPopView


- (instancetype)init
{
        self = [super init];
        if (self) {
            [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
            
            self.frame = CGRectMake(0, 0, kWidth, kHeight);
            
            self.backgroundColor = self.backgroundColor =  [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:0.5];
            
            self.userInteractionEnabled = YES;
            
        }
        return self;
}

- (UIView *)introduce
{
    if (!_introduce) {
        _introduce = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 225)];
        _introduce.backgroundColor = [UIColor whiteColor];
        UIButton *cancle = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 50, 45)];
        cancle.tag = 501;
        cancle.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [cancle setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [cancle setTitle:@"取消" forState:UIControlStateNormal];
        [cancle addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_introduce addSubview:cancle];
        
        UIButton *sure = [[UIButton alloc]initWithFrame:CGRectMake(kWidth - 70, 0, 50, 45)];
        sure.tag = 502;
        sure.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [sure setTitleColor:[UIColor colorWithHexString:@"#5bd5ff"] forState:UIControlStateNormal];
        [sure setTitle:@"确定" forState:UIControlStateNormal];
        [sure addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_introduce addSubview:sure];
    
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 46, kWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"ececec"];
        [_introduce addSubview:line];
    
        UITextView *filed = [[UITextView alloc]initWithFrame:CGRectMake(25, 65, kWidth - 40, 100)];
        
        filed.returnKeyType = UIReturnKeyDone;
        filed.delegate = self;
        filed.textColor = [UIColor colorWithHexString:@"999999"];
        filed.contentMode = UIViewContentModeLeft;
        filed.font = [UIFont systemFontOfSize:15.0];
        filed.text = @"请输入您的驾校介绍...";
        self.textview = filed;
        [_introduce addSubview:filed];
    }
    return _introduce;
}

- (void)btnClick:(UIButton *)btn
{
    NSInteger tag = btn.tag;
    switch (tag) {
        case 501:
        [self hidden];
        break;
        case 502:
        {
            if (0 == _textview.text.length||[_textview.text isEqualToString:@""]) {
                [SVProgressHUD showErrorWithStatus:@"请输入介绍..."];
                return;
            }
            if ([_delegate respondsToSelector:@selector(surebtnClicked:)]) {
                [_delegate surebtnClicked:_textview.text];
            }
            [self hidden];
        }
        break;
        default:
        break;
    }
    NSLog(@"22");
}

+(instancetype)PopViewWithIntroduce
{
    WMPPopView *pop = [[WMPPopView alloc]init];
    [pop addSubview:pop.introduce];
    return pop;
}

- (void)showIntroduce
{
    [UIView animateWithDuration:0.15 animations:^{
        CGRect rect = self.introduce.frame;
        rect.origin.y = kHeight - 225;
        self.introduce.frame = rect;
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

+(instancetype)PopViewWithTable
{
    WMPPopView *pop = [[WMPPopView alloc]init];
    
    pop.userInteractionEnabled = YES;
    
    CGRect tableFream = CGRectMake(0, kHeight, kWidth, 406);
    UITableView *loctable = [[UITableView alloc]initWithFrame:tableFream];
    
    loctable.backgroundColor = [UIColor whiteColor];
    loctable.scrollEnabled = NO;
    loctable.separatorStyle = UITableViewCellSeparatorStyleNone;
    loctable.dataSource = pop;
    loctable.delegate = pop;
    pop.table = loctable;
    
    [pop addSubview:loctable];
    return pop;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DrivingTypeCell *cell = [[NSBundle mainBundle] loadNibNamed:@"DrivingTypeCell" owner:nil options:nil].firstObject;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.userInteractionEnabled = YES;
    
    cell.DrivingClassName.text = self.classesModel.className;
    
    if ([self.classesModel.classCar isEqualToString:@"C1"]) {
        cell.C1.selected = YES;
        cell.C2.selected = NO;
        cell.lastFirIndex = 101;
    }
    else if ([self.classesModel.classCar isEqualToString:@"C2"])
    {
        cell.C1.selected = NO;
        cell.C2.selected = YES;
        cell.lastFirIndex = 102;
    }
    else
    {
        cell.C1.selected = NO;
        cell.C2.selected = NO;
        cell.lastFirIndex = 0;
    }
    cell.DrivingPrice.text = self.classesModel.classMoney;
    
    if ([self.classesModel.classDate isEqualToString:@"周一至周五"]) {
        cell.timeBtn1.selected = YES;
        cell.timeBtn2.selected = NO;
        cell.timeBtn3.selected = NO;
        cell.timeBtn4.selected = NO;
        cell.lastSecIndex = 150;
    }
    else if([self.classesModel.classDate isEqualToString:@"周六至周日"])
    {
        cell.timeBtn1.selected = NO;
        cell.timeBtn2.selected = YES;
        cell.timeBtn3.selected = NO;
        cell.timeBtn4.selected = NO;
        cell.OtherDrivingTime.text = @"";
        cell.lastSecIndex = 151;
    }
    else if([self.classesModel.classDate isEqualToString:@"晚上"])
    {
        cell.timeBtn1.selected = NO;
        cell.timeBtn2.selected = NO;
        cell.timeBtn3.selected = YES;
        cell.timeBtn4.selected = NO;
        cell.OtherDrivingTime.text = @"";
        cell.lastSecIndex = 152;
    }
    else if([self.classesModel.classDate isEqualToString:@"周一至周日"])
    {
        cell.timeBtn1.selected = NO;
        cell.timeBtn2.selected = NO;
        cell.timeBtn3.selected = NO;
        cell.timeBtn4.selected = YES;
        cell.OtherDrivingTime.text = @"";
        cell.lastSecIndex = 153;
        
    }
    else
    {
        cell.timeBtn1.selected = NO;
        cell.timeBtn2.selected = NO;
        cell.timeBtn3.selected = NO;
        cell.timeBtn4.selected = NO;
        cell.OtherDrivingTime.text = self.classesModel.classDate;
        cell.lastSecIndex = 0;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellClick)];
    [cell addGestureRecognizer:tap];
    
    cell.cancle = ^(id sender){
        [self hidden];
    };
    
    cell.succeed = ^(DrivingTypeCell *sender)
    {
        NSString *name = sender.DrivingClassName.text;
        NSString *price = sender.DrivingPrice.text;
        NSString *drvingtype;
        
        NSString *promptStr = nil;
        if (isEmptyStr(name)) {
            promptStr = @"请输入班型名称";
        }
        else if (sender.lastFirIndex == 0) {
            promptStr = @"请选择车型";
        }
        else if (isEmptyStr(price))
        {
            promptStr = @"请输入您的价格";
        }
        else if (sender.lastSecIndex == 0) {
            if (isEmptyStr(sender.OtherDrivingTime.text)) {
                promptStr = @"请选择或输入学车时间";
            }
        }
        
        if (promptStr) {
            [LLUtils showErrorHudWithStatus:promptStr];
            return ;
        }
        
        switch (sender.lastFirIndex) {
            case 101:
                {
                    drvingtype = @"1";
                }
            break;
            
            case 102:
                {
                    drvingtype = @"2";
                }
            default:
            break;
        }
        if (drvingtype == nil) {
            drvingtype = [self.classesModel.classCar substringFromIndex:1];
        }
        NSString *xuetime;
        switch (sender.lastSecIndex) {
            case 150:
            {
                xuetime = @"12";
            }
            break;
            case 151:
            {
                xuetime = @"3";
            }
            break;
            case 152:
            {
                xuetime = @"4";
            }
            break;
            case 153:
            {
                xuetime = @"2";
            }
            break;
            default:
            break;
        }
        NSString *customtime = sender.OtherDrivingTime.text;
        if ([_delegate respondsToSelector:@selector(WMPPopView:surebtnClickedsendName:andPrice:andDrvingtype:andXuetime:andOthertime:classesModelId:)]) {
            [_delegate WMPPopView:self surebtnClickedsendName:name andPrice:price andDrvingtype:drvingtype andXuetime:xuetime andOthertime:customtime classesModelId:self.classesModel.classId];
        }
        [self hidden];
    };
    cell.update = ^(UITextField *sender)
    {
        NSInteger tag = sender.tag;
        
        if (202 == tag) {
            [UIView animateWithDuration:0.15 animations:^{
                CGRect rect = self.table.frame;
                rect.origin.y = kHeight - 406 - 100;
                self.table.frame = rect;
            }];
        }
        
        else if (203 == tag){
            [UIView animateWithDuration:0.15 animations:^{
                CGRect rect = self.table.frame;
                rect.origin.y = kHeight - 406 - 216 - 64;
                self.table.frame = rect;
            }];
        }
    };
    
    cell.reset = ^(){
        [self cellClick];
    };
    
    
    if (_row == -1) {
        cell.deleteBtn.hidden = YES;
    }else{
        cell.deleteBtn.hidden = NO;
        cell.deleteself = ^(){
            if ([_delegate respondsToSelector:@selector(deleteselfrow:)]) {
                [_delegate deleteselfrow:_row];
            }
            [self hidden];
        };
    }
    
    return cell;
}

-(void)cellClick
{
    [self endEditing:YES];
    
    [UIView animateWithDuration:0.15 animations:^{
        CGRect rect = self.table.frame;
        rect.origin.y = kHeight - 406;
        self.table.frame = rect;
    }];
}
-(void)setClassesModel:(CardClassesModel *)classesModel
{
    _classesModel = classesModel;
    
    [self.table reloadData];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 406;
}
- (void)showTable
{
    [UIView animateWithDuration:0.15 animations:^{
        CGRect rect = self.table.frame;
        rect.origin.y = kHeight - 406;
        self.table.frame = rect;
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
- (void)hidden{
    [self removeFromSuperview];
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.15 animations:^{
        CGRect rect = self.introduce.frame;
        rect.origin.y = kHeight - 225 - 217 - 64;
        self.introduce.frame = rect;
    }];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"%@",text);
    if ([text isEqualToString:@"\n"]) {
        [UIView animateWithDuration:0.15 animations:^{
            CGRect rect = self.introduce.frame;
            rect.origin.y = kHeight - 225;
            self.introduce.frame = rect;
        }];
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hidden];
}

@end
