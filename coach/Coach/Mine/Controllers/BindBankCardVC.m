//
//  BindBankCardVC.m
//  KZXC_Headmaster
//
//  Created by gaobin on 16/9/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#define kWidth kScreenWidth
#define kHeight kScreenHeight

#import "ValidateHelper.h"
#import "BindBankCardVC.h"
#import "TailorCell.h"
#import "ZHPickView.h"
#import "BindBankModel.h"
#import "BankModel.h"

@interface BindBankCardVC ()<UITableViewDelegate,UITableViewDataSource,ZHPickViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) ZHPickView * bankPickView;
@property (nonatomic, strong) UIImageView * triangleImgView;
@property (nonatomic, strong) NSMutableArray * banksArray;
@property (nonatomic, strong) NSMutableArray * bankNameArray;
@property (nonatomic, strong) BindBankModel * bindBank;

@end

@implementation BindBankCardVC

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [_bankPickView remove];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"绑定银行卡";
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    _bankNameArray = [NSMutableArray array];
    
    _bindBank = [[BindBankModel alloc] init];
    
    self.view.backgroundColor = RGBColor(247, 247, 247);
    
    [self createUI];
    
    [self loadData];
    
}
- (void)createUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = RGBColor(247, 247, 247);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"TailorCell" bundle:nil] forCellReuseIdentifier:@"TailorCell"];
    
}
#pragma mark -- tableView的道代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
    }else {
        
        return 2;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"TailorCell";
    TailorCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
   
    
    if (indexPath.section ==0) {
        
        cell.showKey.text = @"开户行";
        cell.showValue.enabled = NO;
        cell.showValue.placeholder = @"请选择银行";
        
        cell.showValue.tag = 100;
        
        _triangleImgView = cell.rightImg;
        
    }
    if (indexPath.section == 1) {
        
        cell.showValue.enabled = YES;
        
        if (indexPath.row == 0) {
            
            cell.showKey.text = @"开户名";
            cell.showValue.placeholder = @"请输入银行卡开户名";
            cell.showValue.tag = 1000;
            
        }else {
            
            cell.showKey.text = @"银行卡号";
            cell.showValue.placeholder = @"请输入银行卡号";
            cell.showValue.keyboardType = UIKeyboardTypeNumberPad;
            cell.showValue.tag = 1001;
        }
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:cell.showValue];
    
    return cell;
}
- (void)textFieldChanged:(NSNotification *)notification {
    
    [_bankPickView remove];
    
    UITextField *textField = (UITextField *)[notification object];
    textField.textColor = [UIColor colorWithHexString:@"#333333"];
    
    switch (textField.tag) {
        case 100:
        {
            _bindBank.bankid = textField.text;
        }
            break;
        case 1000:
        {
            _bindBank.bankname = textField.text;
        }
            break;
        case 1001:
        {
            _bindBank.cardnum = textField.text;
            
        }
            break;
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 15;
    }else {
        
        return 8;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return CGFLOAT_MIN;
    }else {
        
        return 200;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        
        UIView * bgView = [[UIView alloc] init];
        
        UIButton * confirmBindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBindBtn.frame = CGRectMake(20, 30, kWidth - 40, ButtonH);
        [confirmBindBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
        [confirmBindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmBindBtn addTarget:self action:@selector(confirmBindBtnClick) forControlEvents:UIControlEventTouchUpInside];
        confirmBindBtn.backgroundColor = CommonButtonBGColor;
        confirmBindBtn.layer.cornerRadius = ButtonH/2;
        confirmBindBtn.clipsToBounds = YES;
        [bgView addSubview:confirmBindBtn];
        
        UILabel * remindLab = [[UILabel alloc] init];
        remindLab.text = @"温馨提示:";
        remindLab.textColor = [UIColor colorWithHexString:@"666666"];
        remindLab.font = [UIFont boldSystemFontOfSize:18];
        [bgView addSubview:remindLab];
        [remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.equalTo(confirmBindBtn.mas_bottom).offset(40);
        }];
        
        UILabel * detailLab = [[UILabel alloc] init];
        detailLab.text = @"银行卡绑定后,获得的收益将在3个工作日内打入该账户,请谨慎填写,如有疑问请致电400-800-6533.";
        detailLab.textColor = [UIColor colorWithHexString:@"666666"];
        detailLab.font = [UIFont systemFontOfSize:14];
        detailLab.numberOfLines = 0;
        [bgView addSubview:detailLab];
        [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(remindLab);
            make.top.equalTo(remindLab.mas_bottom).offset(10);
            make.right.offset(-20);
        }];
        
        return bgView;
    }
    return nil;
}

- (void)loadData {
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    
    NSString *relativeAdd = @"/bank";
    
    paramDict[@"uid"] = kUid;
    NSString * timeString = kTimeStamp;
    paramDict[@"time"] = timeString;
    paramDict[@"sign"] = kSignWithIdentify(relativeAdd);
    paramDict[@"deviceInfo"] = kDeviceInfo;
    
    [NetworkEngine postRequestWithRelativeAdd:relativeAdd paraDic:paramDict completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] intValue] == 1) {
                
                //            NSArray *temp = backdata[@"Banks"];
                //            NSMutableArray *names = [NSMutableArray array];
                //            for (int i = 0; i<temp.count; i++) {
                //                NSDictionary *dict = temp[i];
                //                [names addObject:dict[@"name"]];
                //            }
                //
                //            [curDefaults setObject:names forKey:@"banknames"];
                //            [curDefaults setObject:temp forKey:@"banks"];
                NSArray * banksArray = jsonObj[@"info"][@"Banks"];
                _banksArray = [BankModel mj_objectArrayWithKeyValuesArray:banksArray];
                for (BankModel * bank in _banksArray) {
                    
                    [_bankNameArray addObject:bank.name];
                }
                
                
            }else {
                
            }
        }
        else
        {
            
        }
    }];
    
    

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_bankPickView remove];
    [_tableView endEditing:YES];
    
    if (indexPath.section == 0) {
        
        //_triangleImgView.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        _bankPickView = [[ZHPickView alloc] initPickviewWithArray:_bankNameArray isHaveNavControler:NO];
        _bankPickView.delegate = self;
        [_bankPickView setPickViewColer:[UIColor groupTableViewBackgroundColor]];
        [_bankPickView show];

    }
    
    
    
}
#pragma mark -- ZHPickView的代理方法
- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString {
    
    //_triangleImgView.transform = CGAffineTransformIdentity;
    
    TailorCell * cell = (TailorCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.showValue.text = resultString;
    
    for (BankModel * bank in _banksArray) {
        
        if ([bank.name isEqualToString:resultString]) {
            
            _bindBank.bankid = bank.idStr;
        }
    }

    
}
#pragma mark -- 确认绑定银行卡的请求
- (void)confirmBindBtnClick {
    
    if (_bindBank.bankid.length == 0) {
        
        [self.hudManager showErrorSVHudWithTitle:@"请选择银行" hideAfterDelay:1.0];
        return;
    }
    if (_bindBank.bankname.length == 0) {
        
        [self.hudManager showErrorSVHudWithTitle:@"请填写开户名" hideAfterDelay:1.0];
        return;
    }
    if (![ValidateHelper validateCardNo:_bindBank.cardnum]) {
        [self.hudManager showErrorSVHudWithTitle:@"请输入正确的银行卡号" hideAfterDelay:1.0];
        return;
    }
    
    [self.hudManager showNormalStateSVHUDWithTitle:@"绑定中"];
    
    NSString * url = @"/Bankbind/bind";
    NSString * timeStr = kTimeStamp;
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    paramDict[@"time"] = timeStr;
    paramDict[@"deviceInfo"] = kDeviceInfo;
    paramDict[@"sign"] = kSignWithIdentify(url);
    paramDict[@"bankid"] = _bindBank.bankid;
    paramDict[@"bankname"] = _bindBank.bankname;
    paramDict[@"cardnum"] = _bindBank.cardnum;
    
    [NetworkEngine postRequestWithRelativeAdd:url paraDic:paramDict completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            NSLog(@"银行卡绑定%@",jsonObj);
            NSInteger code = [jsonObj[@"code"] integerValue];
            NSString * msg = jsonObj[@"msg"];
            if (code == 1) {
                
                [self.hudManager showSuccessSVHudWithTitle:@"绑定成功" hideAfterDelay:1.0 animaton:YES];
                
            }else {
                
                [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            }
        }
        else
        {
            
        }
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_tableView endEditing:YES];
    [_bankPickView remove];
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
