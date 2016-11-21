//
//  MEHZController.m
//  KZXC_Headmaster
//
//  Created by 翁昌青 on 16/7/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "UITableView+CYLTableViewPlaceHolder.h"
#import "MEHZController.h"
#import "MEHZDeatilsController.h"
#import "TailorCell.h"
#import "MEHZCell.h"
#import "UIColor+Hex.h"
#import "ExamQuotaReleaseModel.h"
#import "CreateExamQuotaVC.h"
#import "ExamQuotaReleaseModel.h"

#import "HJHttpManager.h"
#import "HttpParamManager.h"
#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height

@interface MEHZController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger lastIndex;
}

@property(weak,nonatomic)UITableView *saletable;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) ExamQuotaReleaseModel * examQuotaRelease;
@property (nonatomic, assign) int otherCurrentPage;
@property (nonatomic, assign) int myCurrentPage;
@property (nonatomic, assign) BOOL isMyExamQuota;
@property (nonatomic, strong) UISegmentedControl *seg;

@end

@implementation MEHZController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMyQuota) name:@"reloadMyQuota" object:nil];
    
}
- (void)reloadMyQuota {
    
    _isMyExamQuota = YES; //此处赋值为了上拉数据时防止展示了other的数据
    _seg.selectedSegmentIndex = 1;
    _myCurrentPage = 1;
    [self requestMyData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _otherCurrentPage = 1;
    _myCurrentPage = 1;
    
    _examQuotaRelease = [[ExamQuotaReleaseModel alloc] init];
    
    self.view.backgroundColor = rgb(247, 247, 247);
    
    [self setupNav];
    
    [self setupTable];
    
    [self requestOtherData];
}
#pragma mark -- 买入的界面数据
- (void)requestOtherData {
    
//    NSString * url = MEHZUrl;
    [self.hudManager showNormalStateSVHUDWithTitle:@"加载中..."];
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    paramDict[@"deviceInfo"] = kDeviceInfo;
//    paramDict[@"cityId"] = @([HttpParamManager getCurrentCityID]);
    paramDict[@"cityId"] = @(1);
    paramDict[@"address"] = [NSString stringWithFormat:@"%@,%@",[HttpParamManager getLatitude],[HttpParamManager getLongitude]];
    NSString * timeString = kTimeStamp;
    paramDict[@"time"] = timeString;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/examinationQuota" time:timeString];
    paramDict[@"pageId"] = @(self.otherCurrentPage);
    
//    [HttpsTools POST:url parameter:paramDict progress:^(NSProgress *downloadProgress) {
//    } succeed:^(id responseObject) {
//        NSLog(@"别人的名额合作%@",responseObject);
//        NSInteger code = [responseObject[@"code"] integerValue];
//        NSString * msg = responseObject[@"msg"];
//        
//        if (code == 1) {
//            
//            NSDictionary * infoDict = responseObject[@"info"];
//            if ([infoDict isEqual:[NSNull null]]) {
//                
//                [self.hudManager showNormalStateSVHudWithTitle:@"无数据" hideAfterDelay:1.0];
//                return ;
//            }
//            
//            NSArray * examinationQuotaArray = infoDict[@"examinationQuota"];
//            _dataArray = [ExamQuotaReleaseModel mj_objectArrayWithKeyValuesArray:examinationQuotaArray];
//            
//            [_saletable reloadData];
//            
//            [_saletable.mj_header endRefreshing];
//            
//        }else {
//            
//            [MBProgressHUD showError:msg];
//            
//            [_saletable.mj_header endRefreshing];
//        }
//        
//        
//    } failure:^(NSError *error) {
//       
//        [MBProgressHUD showError:@"加载失败"];
//        
//        [_saletable.mj_header endRefreshing];
//        
//    }];
    
    [NetworkEngine postRequestWithRelativeAdd:@"/examinationQuota" paraDic:paramDict completeBlock:^(BOOL isSuccess, id jsonObj) {
        [self.hudManager dismissSVHud];
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                NSDictionary * infoDict = jsonObj[@"info"];
                if ([infoDict isEqual:[NSNull null]]) {
                    
//                    [self.hudManager showNormalStateSVHudWithTitle:@"无数据" hideAfterDelay:1.0];
                    [_saletable cyl_reloadData];
                    [_saletable.mj_header endRefreshing];
                    return ;
                }
                
                NSArray * examinationQuotaArray = infoDict[@"examinationQuota"];
                _dataArray = [ExamQuotaReleaseModel mj_objectArrayWithKeyValuesArray:examinationQuotaArray];
                
                [_saletable cyl_reloadData];
                
                [_saletable.mj_header endRefreshing];
            }
            else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                //需要登录
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
                [_saletable.mj_header endRefreshing];
            }
            else
            {
                //失败
//                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
                [LLUtils showErrorHudWithStatus:@"加载失败"];
                [_saletable.mj_header endRefreshing];
            }
        }
    }];
    
    
}
- (void)requestOtherMoreData {
//    NSString * url = MEHZUrl;
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    paramDict[@"deviceInfo"] = kTimeStamp;
    paramDict[@"cityId"] = @([HttpParamManager getCurrentCityID]);
    paramDict[@"address"] = [NSString stringWithFormat:@"%@,%@",[HttpParamManager getLatitude],[HttpParamManager getLongitude]];
    NSString * timeString = kTimeStamp;
    paramDict[@"time"] = timeString;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/examinationQuota" time:timeString];
    paramDict[@"pageId"] = @(self.otherCurrentPage);
    
//    [HttpsTools POST:url parameter:paramDict progress:^(NSProgress *downloadProgress) {
//    } succeed:^(id responseObject) {
//        NSLog(@"别人的名额合作%@",responseObject);
//        NSInteger code = [responseObject[@"code"] integerValue];
//        NSString * msg = responseObject[@"msg"];
//        
//        if (code == 1) {
//            
//            NSDictionary * infoDict = responseObject[@"info"];
//            if ([infoDict isEqual:[NSNull null]]) {
//                
//                [_saletable reloadData];
//                
//                [_saletable.mj_footer endRefreshing];
//                
//            }else {
//            
//                NSArray * examinationQuotaArray = infoDict[@"examinationQuota"];
//                NSArray * newArray = [ExamQuotaReleaseModel mj_objectArrayWithKeyValuesArray:examinationQuotaArray];
//                [_dataArray addObjectsFromArray:newArray];
//                
//                [_saletable reloadData];
//                
//                [_saletable.mj_footer endRefreshing];
//
//            }
//            
//            
//        }else {
//            
//            [MBProgressHUD showError:msg];
//            
//            [_saletable.mj_footer endRefreshing];
//        }
//        
//        
//    } failure:^(NSError *error) {
//        
//        [MBProgressHUD showError:@"加载失败"];
//        
//    }];
    
    [NetworkEngine postRequestWithRelativeAdd:@"/examinationQuota" paraDic:paramDict completeBlock:^(BOOL isSuccess, id jsonObj) {
        [self.hudManager dismissSVHud];
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                NSDictionary * infoDict = jsonObj[@"info"];
                if ([infoDict isEqual:[NSNull null]]) {
                    
                    [_saletable cyl_reloadData];
                    
                    [_saletable.mj_footer endRefreshing];
                    
                }else {
                    
                    NSArray * examinationQuotaArray = infoDict[@"examinationQuota"];
                    NSArray * newArray = [ExamQuotaReleaseModel mj_objectArrayWithKeyValuesArray:examinationQuotaArray];
                    [_dataArray addObjectsFromArray:newArray];
                    
                    [_saletable cyl_reloadData];
                    
                    [_saletable.mj_footer endRefreshing];
                    
                }
            }
            else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                //需要登录
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
                [_saletable.mj_footer endRefreshing];
            }
            else
            {
                //失败
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
                [_saletable.mj_footer endRefreshing];
            }
        }
    }];

    
    
}
#pragma mark -- 我的考试名额的请求
- (void)requestMyData {
    
    [self.hudManager showNormalStateSVHUDWithTitle:@"加载中..."];
    
//    NSString * url = myExamQuota;
    NSString * timeStr = kTimeStamp;
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    paramDict[@"time"] = timeStr;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/myExaminationquota" time:timeStr];
    paramDict[@"pageId"] = @(self.myCurrentPage);
    
//    [HttpsTools POST:url parameter:paramDict progress:^(NSProgress *downloadProgress) {
//    } succeed:^(id responseObject) {
//       
//        NSLog(@"我的考试名额%@",responseObject);
//        NSInteger code = [responseObject[@"code"] integerValue];
//        NSString * msg = responseObject[@"msg"];
//        if (code == 1) {
//
//            [_dataArray removeAllObjects];
//            
//            NSDictionary * infoDict = responseObject[@"info"];
//            if ([infoDict isEqual:[NSNull null]]) {
//                
//                [self.hudManager showNormalStateSVHudWithTitle:@"无数据" hideAfterDelay:1.0];
//                [_saletable reloadData];
//                [_saletable.mj_header endRefreshing];
//                return;
//            }
//            
//            NSArray * examinationQuotaArray = infoDict[@"myExaminationquota"];
//            _dataArray = [ExamQuotaReleaseModel mj_objectArrayWithKeyValuesArray:examinationQuotaArray];
//            [_saletable reloadData];
//            
//            [self.hudManager dismissSVHud];
//            [_saletable.mj_header endRefreshing];
//            
//        }else {
//            
//            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
//            [_saletable.mj_header endRefreshing];
//        }
//        
//        
//    } failure:^(NSError *error) {
//        
//        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
//        [_saletable.mj_header endRefreshing];
//        
//    }];
    
    [NetworkEngine postRequestWithRelativeAdd:@"/myExaminationquota" paraDic:paramDict completeBlock:^(BOOL isSuccess, id jsonObj) {
        [self.hudManager dismissSVHud];
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                NSDictionary * infoDict = jsonObj[@"info"];
                [_dataArray removeAllObjects];
                
                if ([infoDict isEqual:[NSNull null]]) {
                    
//                    [self.hudManager showNormalStateSVHudWithTitle:@"无数据" hideAfterDelay:1.0];
                    [_saletable cyl_reloadData];
                    [_saletable.mj_header endRefreshing];
                    return;
                }
                
                NSArray * examinationQuotaArray = infoDict[@"myExaminationquota"];
                _dataArray = [ExamQuotaReleaseModel mj_objectArrayWithKeyValuesArray:examinationQuotaArray];
                [_saletable cyl_reloadData];
                
                [self.hudManager dismissSVHud];
                [_saletable.mj_header endRefreshing];
                
            }
            else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                //需要登录
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
                [_saletable.mj_header endRefreshing];
            }
            else
            {
                //失败
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
                [_saletable.mj_header endRefreshing];
            }
        }
    }];
    
}
- (void)requestMyMoreData {
    
    [self.hudManager showNormalStateSVHUDWithTitle:@"加载中..."];
    
//    NSString * url = myExamQuota;
    NSString * timeStr = kTimeStamp;
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    paramDict[@"time"] = timeStr;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/myExaminationquota" time:timeStr];
    paramDict[@"pageId"] = @(self.myCurrentPage);
    
//    [HttpsTools POST:url parameter:paramDict progress:^(NSProgress *downloadProgress) {
//    } succeed:^(id responseObject) {
//        
//        NSLog(@"我的考试名额%@",responseObject);
//        NSInteger code = [responseObject[@"code"] integerValue];
//        NSString * msg = responseObject[@"msg"];
//        if (code == 1) {
//            
//            NSDictionary * infoDict = responseObject[@"info"];
//            if ([infoDict isEqual:[NSNull null]]) {
//                
//                [self.hudManager showNormalStateSVHudWithTitle:@"无更多数据" hideAfterDelay:1.0];
//                [_saletable reloadData];
//                [_saletable.mj_footer endRefreshing];
//                return;
//            }
//            
//            NSArray * examinationQuotaArray = infoDict[@"myExaminationquota"];
//            NSArray * newArray = [ExamQuotaReleaseModel mj_objectArrayWithKeyValuesArray:examinationQuotaArray];
//            [_dataArray addObjectsFromArray:newArray];
//            [_saletable reloadData];
//            
//            [self.hudManager dismissSVHud];
//            [_saletable.mj_footer endRefreshing];
//            
//        }else {
//            
//            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
//            [_saletable.mj_footer endRefreshing];
//        }
//        
//        
//    } failure:^(NSError *error) {
//        
//        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
//        [_saletable.mj_footer endRefreshing];
//        
//    }];
    
    
    [NetworkEngine postRequestWithRelativeAdd:@"/myExaminationquota" paraDic:paramDict completeBlock:^(BOOL isSuccess, id jsonObj) {
        [self.hudManager dismissSVHud];
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                NSDictionary * infoDict = jsonObj[@"info"];
                if ([infoDict isEqual:[NSNull null]]) {
                    
                    [self.hudManager showNormalStateSVHudWithTitle:@"无更多数据" hideAfterDelay:1.0];
                    [_saletable cyl_reloadData];
                    [_saletable.mj_footer endRefreshing];
                    return;
                }
                
                NSArray * examinationQuotaArray = infoDict[@"myExaminationquota"];
                NSArray * newArray = [ExamQuotaReleaseModel mj_objectArrayWithKeyValuesArray:examinationQuotaArray];
                [_dataArray addObjectsFromArray:newArray];
                [_saletable cyl_reloadData];
                
                [self.hudManager dismissSVHud];
                [_saletable.mj_footer endRefreshing];
                
            }
            else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                //需要登录
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
                [_saletable.mj_header endRefreshing];
            }
            else
            {
                //失败
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
                [_saletable.mj_header endRefreshing];
            }
        }
    }];
    
}
- (void)setupNav
{
    _seg = [[UISegmentedControl alloc]initWithItems:@[@"买 入",@"发 布"]];
    _seg.tintColor = [UIColor whiteColor];
    _seg.selectedSegmentIndex = 0;
    
    [_seg setTitleTextAttributes :[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,Font17,NSFontAttributeName, nil]forState:UIControlStateNormal];
    
    [_seg setTitleTextAttributes :[NSDictionary dictionaryWithObjectsAndKeys:kAppThemeColor,NSForegroundColorAttributeName,Font17,NSFontAttributeName, nil]forState:UIControlStateSelected];
    
    _seg.frame = CGRectMake(0, 0, 120, 30);
    [_seg addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView =  _seg;
    
    //创建导航栏右按钮
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(20, 0, 40, 30);
    [rightBtn setTitle:@"新增" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn addTarget:self action:@selector(releaseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBut = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBut;
}
- (void)releaseBtnClick {
    
    checkLogin()
    
    CreateExamQuotaVC * vc = [[CreateExamQuotaVC alloc] init];
    
    vc.isNewAdd = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)segClick:(UISegmentedControl *)seg
{
    NSInteger tag = seg.selectedSegmentIndex;
    if (0 == tag) {
        
//        _saletable.allowsSelection = NO;
        
        _isMyExamQuota = NO;
        _otherCurrentPage = 1;
//        self.saletable.alpha = 1;
        [self requestOtherData];
    }else
    {
//        _saletable.allowsSelection = NO;
        
        _isMyExamQuota = YES;
        _myCurrentPage = 1;
//        self.saletable.alpha = 0;
        [self requestMyData];
    }
}
- (void)setupTable
{
    UITableView *loctable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+10, kWidth, kHeight - 64)];
    loctable.tag = 201;
    loctable.dataSource = self;
    loctable.delegate = self;
    loctable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.saletable = loctable;
    [self.view addSubview:loctable];
    
    __weak typeof(self) weakSelf = self;
    
    _saletable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.otherCurrentPage = 1;
        weakSelf.myCurrentPage = 1;
        if (_isMyExamQuota) {
            
            [weakSelf requestMyData];
        }else {
            
            [weakSelf requestOtherData];
        }
        
    }];
    
    _saletable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (_isMyExamQuota) {
            
            weakSelf.myCurrentPage ++;
            [weakSelf requestMyMoreData];
            
        }else {
            
            weakSelf.otherCurrentPage ++;
            [weakSelf requestOtherMoreData];
        }
        
    } ];
    

    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identify = @"mehzID";
    
    MEHZCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MEHZCell" owner:nil options:nil]firstObject];
    }
    
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_isMyExamQuota) {
        
        cell.own.alpha = 0;
        
    }else {
        
        cell.push = ^(ExamQuotaReleaseModel *examQuotaRelease){
            
            MEHZDeatilsController *details = [[MEHZDeatilsController alloc]init];
            
            details.idString = examQuotaRelease.idStr;
            
            [self.navigationController pushViewController:details animated:YES];
        };

        
    }
   
    
    _examQuotaRelease = _dataArray[indexPath.section];
    
    cell.examQuotaRelease = _examQuotaRelease;

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 10;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 105;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isMyExamQuota) {
        
        CreateExamQuotaVC * vc = [[CreateExamQuotaVC alloc] init];
        
        vc.isNewAdd = NO;
        vc.examQuotaRelease = _dataArray[indexPath.section];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        ExamQuotaReleaseModel * examQuotaRelease = _dataArray[indexPath.section];
        
        MEHZDeatilsController *details = [[MEHZDeatilsController alloc]init];
        
        details.idString = examQuotaRelease.idStr;
        
        [self.navigationController pushViewController:details animated:YES];
    }
    
    
}

#pragma mark - LLCollectionViewPlaceHolderDelegate

- (UIView *)makePlaceHolderView;
{
    UIView *bgView = [UIView new];
    
    UILabel *promptLbl = [UILabel new];
    [bgView addSubview:promptLbl];
    NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithImg:[UIImage imageNamed:@"CoachCarRent_Cry"] bounds:CGRectMake(0, 0, 100, 100)];
    [attStr appendBreakLineWithInterval:6];
    [attStr appendText:_seg.selectedSegmentIndex==1?@"您暂时未发布":@"" withAttributesArr:@[rgb(249, 117, 43)]];
    [attStr appendBreakLineWithInterval:3];
    [attStr appendText:_seg.selectedSegmentIndex==1?@"考试名额":@"暂时未搜索到资源" withAttributesArr:@[rgb(249, 117, 43)]];
    promptLbl.attributedText = attStr;
    promptLbl.textAlignment = NSTextAlignmentCenter;
    promptLbl.numberOfLines = 0;
    
    UIButton *goPublicbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:goPublicbtn];
    [goPublicbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_centerY);
        make.centerX.equalTo(promptLbl);
        make.width.offset(0.8*kScreenWidth);
        make.height.offset(40);
    }];
    goPublicbtn.layer.cornerRadius = 20;
    goPublicbtn.layer.masksToBounds = YES;
    [goPublicbtn setBackgroundColor:kAppThemeColor];
    [goPublicbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goPublicbtn setTitle:_seg.selectedSegmentIndex==1?@"去发布":@"刷新" forState:UIControlStateNormal];
    [goPublicbtn addTarget:self action:@selector(clickGoPublicBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(-self.view.bounds.size.height/4);
    }];
    
    return bgView;
}

- (BOOL)enableScrollWhenPlaceHolderViewShowing;
{
    return YES;
}

- (void)clickGoPublicBtn:(UIButton *)publicBtn
{
    if (_seg.selectedSegmentIndex==1) {
        [self releaseBtnClick];
    }
    else
    {
        [_saletable.mj_header beginRefreshing];
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
