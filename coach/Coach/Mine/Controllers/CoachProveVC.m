//
//  CoachProveVC.m
//  Coach
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "CoachProveVC.h"
#import "MCoachFirstCell.h"
#import "MCoachSecondCell.h"
#import "CoachProveTableCell.h"
#import "CoachCertificationVC.h"
#import "CoachProveModel.h"

@interface CoachProveVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * proveTable;

@property (nonatomic, strong) CoachProveModel * proveModel;

@property (nonatomic, strong) UIButton * againBtn;

@end

@implementation CoachProveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initWithUI
{
    [super initWithUI];
    self.title = @"实名认证";
    _proveTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _proveTable.delegate = self;
    _proveTable.dataSource = self;
    _proveTable.showsVerticalScrollIndicator = YES;
    _proveTable.backgroundColor = rgb(236, 236, 236);
    _proveTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_proveTable];
    
    UIView * downView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
    downView.backgroundColor = rgb(236, 236, 236);
    _proveTable.tableFooterView = downView;
    
    
    _againBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _againBtn.frame = CGRectMake(46, 37, kScreenWidth-46*2, 44);
    _againBtn.backgroundColor = [UIColor colorWithHexString:@"#2e83ff"];
    _againBtn.layer.cornerRadius = 22.0;
    [_againBtn setTitle:@"去认证" forState:UIControlStateNormal];
    [_againBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_againBtn addTarget:self action:@selector(pressAgainBtn:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:_againBtn];
}

- (void)initWithData
{
    [super initWithData];
    
    [self requestWithData];
}

- (void)requestWithData
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
//    param[@"deviceInfo"] = kDeviceInfo;
    param[@"time"] = kTimeStamp;
    param[@"sign"] = kSignWithIdentify(@"/userAuth");
    
    NSLog(@"=====>%@",[NSString stringWithFormat:@"%@%@%@%@%@",kUUID,@"/user/login",kUid,kToken,kTimeStamp]);
    
    [NetworkEngine postRequestWithRelativeAdd:@"/userAuth" paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                NSString * jstr = [LLUtils jsonStrWithJSONObject:jsonObj];
                NSString * str = [LLUtils replaceUnicode:jstr];
                
                NSLog(@"%@",str);
                
                self.proveModel = [CoachProveModel mj_objectWithKeyValues:jsonObj[@"info"]];
                
                if (_proveModel.state == nil || [_proveModel.state isEqualToString:@"-1"] || [_proveModel.state isEqualToString:@"2"]) {
                    [_againBtn setTitle:@"去认证" forState:UIControlStateNormal];
                }else if([_proveModel.state isEqualToString:@"0"]){
                    [_againBtn setTitle:@"去认证" forState:UIControlStateNormal];
                }else{
                    [_againBtn setTitle:@"重新认证" forState:UIControlStateNormal];
                }
//                [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
                [_proveTable reloadData];
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

- (void)pressAgainBtn:(UIButton *)sender
{
    CoachCertificationVC * vc = [[CoachCertificationVC alloc]init];
    vc.coachModel = _proveModel;
    vc.refresh = ^(NSString * type){
        [self newRequestWithData:type];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)newRequestWithData:(NSString *)type
{
    if ([type isEqualToString:@"new"]) {
        [self requestWithData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 105;
    }else if (indexPath.row == 1 || indexPath.row == 2){
        return 48;
    }else{
        return 232;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString * string = @"cellone";
        MCoachFirstCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MCoachFirstCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.avatorImageView sd_setImageWithURL:[NSURL URLWithString:kFace] placeholderImage:[UIImage imageNamed:@"MCoach_Avator"]];
        cell.phoneLabel.text = kPhone;
        cell.nameLabel.text = _proveModel.trueName;
        if (_proveModel.state == nil || [_proveModel.state isEqualToString:@"-1"] || [_proveModel.state isEqualToString:@"2"]) {
            cell.idImageV.image = [UIImage imageNamed:@"MCoach_grayImage"];
        }else if([_proveModel.state isEqualToString:@"0"]){
            cell.idImageV.image = [UIImage imageNamed:@"MCoach_review"]; 
        }else{
            cell.idImageV.image = [UIImage imageNamed:@"MCoach_markImage"];
        }
        return cell;
    }else if (indexPath.row == 1){
        
        static NSString * string = @"celltwo";
        MCoachSecondCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MCoachSecondCell" owner:self options:nil]lastObject];
        }
        cell.nameLabel.text = @"真实姓名";
//        cell.contentLabel.text = @"匹诺曹";
//        cell.contentLabel.text = _proveModel.trueName;
        cell.contentTF.text =  isEmptyStr(_proveModel.trueName)?@"未认证":_proveModel.trueName;
        cell.contentTF.borderStyle = UITextBorderStyleNone;
        cell.contentTF.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (indexPath.row == 2){
        
        static NSString * string = @"celltwo";
        MCoachSecondCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MCoachSecondCell" owner:self options:nil]lastObject];
        }
        cell.nameLabel.text = @"身份证号";
//        cell.contentLabel.text = @"420303 45567 8930";
//        cell.contentLabel.text = _proveModel.IDNum;
        cell.contentTF.userInteractionEnabled = NO;
        cell.contentTF.text = isEmptyStr(_proveModel.IDNum)?@"未认证":_proveModel.IDNum ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.row == 3){
        static NSString * string = @"cell";
        CoachProveTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CoachProveTableCell" owner:self options:nil]lastObject];
        }
        cell.nameLabel.text = @"教练资格证";
//        cell.contentLabel.text = @"编号：9733221";
        cell.contentLabel.text = [NSString stringWithFormat:@"编号:%@",_proveModel.coachNum == nil? @"": _proveModel.coachNum];
//        cell.proveImageView.image = [UIImage imageNamed:@"MCoach_TDCardImage"];
        [cell.proveImageView sd_setImageWithURL:[NSURL URLWithString:_proveModel.coachPic] placeholderImage:[UIImage imageNamed:@"MCoach_TDCardImage"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    return nil;
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
