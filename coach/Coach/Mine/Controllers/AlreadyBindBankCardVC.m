//
//  AlreadyBindBankCardVC.m
//  KZXC_Headmaster
//
//  Created by gaobin on 16/9/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#define kWidth kScreenWidth
#define kHeight kScreenHeight

#import "AlreadyBindBankCardVC.h"
#import "CommonLRCellCell.h"
#import "BindBankCardVC.h"
#import "BindBankModel.h"

@interface AlreadyBindBankCardVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) BindBankModel * bindBank;

@end

@implementation AlreadyBindBankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"绑定银行卡";
    
    self.view.backgroundColor = RGBColor(247, 247, 247);
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self createUI];
    
    [self requestData];
    
}
- (void)requestData {
    
    [self.hudManager showNormalStateSVHUDWithTitle:@"加载中"];
    
    NSString * url = @"/Bankbind/selbank";
    NSString * timeStr = kTimeStamp;
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    paramDict[@"time"] = timeStr;
    paramDict[@"deviceInfo"] = kDeviceInfo;
    paramDict[@"sign"] = kSignWithIdentify(url);
    
    
    [NetworkEngine postRequestWithRelativeAdd:url paraDic:paramDict completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            NSLog(@"获取银行卡绑定信息%@",jsonObj);
            NSInteger code = [jsonObj[@"code"] integerValue];
            NSString * msg = jsonObj[@"msg"];
            if (code == 1) {
                
                [self.hudManager dismissSVHud];
                
                NSDictionary * infoDict = jsonObj[@"info"];
                _bindBank = [BindBankModel mj_objectWithKeyValues:infoDict];
                [_tableView reloadData];
                
            }else {
                
                [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            }
        }
        else
        {
            
        }
    }];
}
- (void)createUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = RGBColor(247, 247, 247);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"CommonLRCellCell" bundle:nil] forCellReuseIdentifier:@"CommonLRCellCell"];
    
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
    
    static NSString * identifier = @"CommonLRCellCell";
    CommonLRCellCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    if (indexPath.section == 0) {
        
        cell.titleLab.text = @"开户行";
        cell.detailLab.text = _bindBank.name;
    }
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            cell.titleLab.text = @"开户名";
            cell.detailLab.text = _bindBank.bankname;
        }else {
            
            cell.titleLab.text = @"银行卡号";
            cell.detailLab.text = _bindBank.cardnum;
        }

    }
    return cell;
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
        
        UIButton * changeBnakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        changeBnakBtn.frame = CGRectMake(20, 30, kWidth - 40, ButtonH);
        [changeBnakBtn setTitle:@"更换银行卡" forState:UIControlStateNormal];
        [changeBnakBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [changeBnakBtn addTarget:self action:@selector(changeBnakBtnClick) forControlEvents:UIControlEventTouchUpInside];
        changeBnakBtn.backgroundColor = CommonButtonBGColor;
        changeBnakBtn.layer.cornerRadius = ButtonH/2;
        changeBnakBtn.clipsToBounds = YES;
        [bgView addSubview:changeBnakBtn];
        
        UILabel * remindLab = [[UILabel alloc] init];
        remindLab.text = @"温馨提示:";
        remindLab.textColor = [UIColor colorWithHexString:@"666666"];
        remindLab.font = [UIFont boldSystemFontOfSize:18];
        [bgView addSubview:remindLab];
        [remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.equalTo(changeBnakBtn.mas_bottom).offset(40);
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
- (void)changeBnakBtnClick {
    
    BindBankCardVC * vc = [[BindBankCardVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
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
