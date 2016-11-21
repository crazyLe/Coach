//
//  SuperViewController.m
//  idea
//
//  Created by caochungui on 16/1/5.
//  Copyright © 2016年 mobisoft. All rights reserved.
//

#import "LoginRegisterVC.h"
#import "SuperViewController.h"
#import "AppDelegate.h"
#import "RDVTabBarController.h"

@interface SuperViewController ()<NoNetworkViewReloadDelegate>


@end

@implementation SuperViewController
{
    NSInteger _pageCount;
    NSMutableArray *_dataSourceArr;
    
    requestBlock tableRequestBlock;
}

- (id)init
{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (NoDataView *)noDataView
{
    if (_noDataView == nil) {
        _noDataView = [[NoDataView alloc] init];
        _noDataView.title = @"没有相关信息" ;
     
    }
    return _noDataView;
}

- (NoNetworkView *)noNetworkView
{
    if (_noNetworkView == nil) {
        _noNetworkView = [[NoNetworkView alloc] init];
        _noNetworkView.delegate = self;
    }
    return _noNetworkView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWithUI];
    [self initWithData];
    [self initWithInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initWithUI
{
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    //处理tableview被navigation覆盖一部分
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        backBtn.title = @"";
    } else {
        backBtn.title = @"返回";
    }
    self.navigationItem.backBarButtonItem = backBtn;
    
    [self setNavBgColor:[UIColor colorWithHexString:@"2e82ff"]];
    [self setLeftText:nil textColor:nil ImgPath:@"NavigationBar_Return"];
}

- (void)initWithData
{
    
}

- (void)initWithInterface
{
    
}

#pragma mark - 设置导航栏
- (void)setNavBgColor:(UIColor *)bgColor
{
    [self.navigationController.navigationBar setBarTintColor:bgColor==nil?[UIColor colorWithHexString:@"2e82ff"]:bgColor];
}

- (void)setTitleText:(NSString *)titleText textColor:(UIColor *)color
{
    if (_titleText != titleText) {
        _titleText = titleText;
        self.title = titleText;
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:color==nil?[UIColor whiteColor]:color}];
    }
}

- (void)setLeftText:(NSString *)leftText textColor:(UIColor *)color
            ImgPath:(NSString *)imgPath
{
    if (!leftText && !imgPath) {
        return;
    }
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 0, 70, 30);
    if (imgPath) {
        [_leftBtn setImage:[UIImage imageNamed:imgPath] forState:UIControlStateNormal];
    }
    if (leftText) {
        [_leftBtn setTitle:leftText forState:UIControlStateNormal];
        [_leftBtn setTitleColor:color==nil?[UIColor whiteColor]:color forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = Font15;
    }
    if (leftText && imgPath) {
        UIImage *leftBtnImg = [UIImage imageNamed:imgPath];
        [_leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -leftBtnImg.size.width, 0, leftBtnImg.size.width)];
        [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, -35)];
    }
    [_leftBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_leftBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    
    [_leftBtn addTarget:self action:@selector(clickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)setRightText:(NSString *)rightText textColor:(UIColor *)color
             ImgPath:(NSString *)imgPath
{
    if (!rightText && !imgPath) {
        return;
    }
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(0, 0, 70, 30);
    if (imgPath) {
        [_rightBtn setImage:[UIImage imageNamed:imgPath] forState:UIControlStateNormal];
    }
    if (rightText) {
        [_rightBtn setTitle:rightText forState:UIControlStateNormal];
        [_rightBtn setTitleColor:color==nil?[UIColor whiteColor]:color forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = Font15;
    }
    if (rightText && imgPath) {
        //        UIImage *rightBtnImg = [UIImage imageNamed:imgPath];
        //        [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -rightBtnImg.size.width, 0, rightBtnImg.size.width)];
        //        [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, -35)];
    }
    [_rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_rightBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    
    [_rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)setLeftBtnLeftInset:(CGFloat)offset
{
    [_leftBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -offset, 0, offset)];
    [_leftBtn setNeedsDisplay];
    [_leftBtn.layer displayIfNeeded];
}

- (void)setRightBtnLeftInset:(CGFloat)offset
{
    [_rightBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -offset, 0, offset)];
    [_rightBtn setNeedsDisplay];
    [_rightBtn.layer displayIfNeeded];
}

//- (void)setLeftBtnTextImgInterval:(CGFloat)spacing
//{
//    // 图片右移
//    CGSize imageSize = _leftBtn.imageView.frame.size;
//    _leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width - spacing, 0.0, imageSize.width);
//
//    // 文字左移
//    CGSize titleSize = _leftBtn.titleLabel.frame.size;
//    _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, - titleSize.width, 0.0,  titleSize.width - spacing);
//
//    [_leftBtn setNeedsDisplay];
//    [_leftBtn.layer displayIfNeeded];
//}

#pragma mark - 设置表

//block : 约束表的block , block传入nil即可添加默认约束UIEdgeInsetsMake(0, 0, 0, 0)
- (void)setBg_TableViewWithConstraints:(void(^)(MASConstraintMaker *make))block
{
    _bg_TableView =[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_bg_TableView];
    [_bg_TableView mas_makeConstraints: block==nil? ^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    } : block];
    _bg_TableView.delegate = self;
    _bg_TableView.dataSource = self;
    _bg_TableView.showsVerticalScrollIndicator = NO;
    _bg_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bg_TableView.backgroundColor = kBackgroundColor;
    //    bg_TableView.delaysContentTouches = NO;
}

- (void)setTableRefreshHandle:(requestBlock)actionHandler
{
    tableRequestBlock = actionHandler;
    NSInteger *pageCountWeak = &_pageCount;
    _bg_TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        actionHandler(*pageCountWeak=1);
    }];
    
    _bg_TableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        actionHandler(++*pageCountWeak);
    }];
}

- (void)setNetworkRelativeAdd:(NSString *)relativeAdd paraDic:(NSDictionary *)paraDic pageFiledName:(NSString *)pageFiledName parseDicKeyArr:(NSArray *)dicKeyArr
{
    WeakObj(self)
    [self setTableRefreshHandle:^(NSInteger page) {
        NSMutableDictionary *paraMutDic = [paraDic mutableCopy];
        if (pageFiledName) {
            [paraMutDic setObject:[NSString stringWithFormat:@"%ld",page] forKey:pageFiledName];
        }
        [NetworkEngine postRequestWithRelativeAdd:relativeAdd paraDic:paraMutDic completeBlock:^(BOOL isSuccess, id jsonObj) {
            if (isSuccess) {
                if (page==1) {
                    //Drop down
                    selfWeak.contentArr = [[selfWeak parseJsonDataWithJsonObj:jsonObj dicKeyArr:dicKeyArr] mutableCopy];
                    [selfWeak.bg_TableView reloadData];
                    [selfWeak.bg_TableView.mj_header endRefreshing];
                    [selfWeak contentArrDidRefresh:selfWeak.contentArr];
                }
                else
                {
                    if (!isNull(jsonObj[@"info"])) {
                        NSArray *appendArr = [selfWeak parseJsonDataWithJsonObj:jsonObj dicKeyArr:dicKeyArr];
                        if (appendArr.count) {
                            //还有数据 （追加）
                            [selfWeak.contentArr appendObjects:appendArr];
                            [selfWeak.bg_TableView reloadData];
                            [selfWeak contentArrDidLoadMoreData:appendArr];
                        }
                        else
                        {
                            //No more data
                            [selfWeak noMoreData];
                        }
                    }
                    else
                    {
                        
                    }
                    [selfWeak.bg_TableView.mj_footer endRefreshing];
                }
            }
            else
            {
                [selfWeak.bg_TableView.mj_header endRefreshing];
                [selfWeak.bg_TableView.mj_footer endRefreshing];
            }
        }];
    }];
}

//已经重新加载了数据
- (void)contentArrDidRefresh:(NSArray *)newArr
{
    
}

//已经追加了数据
- (void)contentArrDidLoadMoreData:(NSArray *)appendArr
{
    
}

//没有更多数据了
- (void)noMoreData
{
    
}

//静默刷新
- (void)silenceRefresh
{
    
}

//解析json数据
- (NSArray *)parseJsonDataWithJsonObj:(id)jsonObj dicKeyArr:(NSArray *)dicKeyArr
{
    id arr = nil;
    int i = 0;
    for (NSString *dicKey in dicKeyArr)
    {
        if (i==0)
        {
            if ([jsonObj isKindOfClass:[NSDictionary class]]) {
                arr = jsonObj[dicKey];
            }
            else if([jsonObj isKindOfClass:[NSArray class]])
            {
                if (((NSArray *)jsonObj).count) {
                    arr = jsonObj[0];
                }
            }
        }
        else
        {
            if ([arr isKindOfClass:[NSDictionary class]]) {
                arr = arr[dicKey];
            }
            else if([arr isKindOfClass:[NSArray class]])
            {
                if (((NSArray *)arr).count) {
                    arr = arr[0];
                }
            }
        }
        i++;
    }
    
    if ([arr isKindOfClass:[NSArray class]]) {
        return arr;
    }
    else if(!isNull(arr))
    {
        return @[arr];
    }
    else
    {
        return @[];
    }
}

//nameArr : 注册的Cell类名字符串构成的数组
//indentifierArr : 对应得标识符，如果传入空值，则默认以类名字符串作为标识符
- (void)registerClassWithClassNameArr:(NSArray *)nameArr cellIdentifier:(NSArray *)identifierArr
{
    if (!nameArr.count) {
        return;
    }
    for (int i = 0; i < nameArr.count; i++) {
        [_bg_TableView registerClass:NSClassFromString(nameArr[i]) forCellReuseIdentifier:identifierArr==nil?nameArr[i]:identifierArr[i]];
    }
}

#pragma mark - 导航栏点击方法

- (void)clickLeftBtn:(UIButton *)leftBtn;
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightBtn:(UIButton*)rightBtn;
{
    ;
}
-(void)clickSecondRightBtu:(UIButton* )secondRightBtu
{
    
}

//判断用户是否登录
- (BOOL)judgeLogin{
    
    NSString *mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"Mobile"];
    if (mobile) {
        return YES;
    } else {
        return NO;
    }
    return YES;
}

- (BOOL)judgeNetWork
{
    Reachability *reachability = [AppDelegate sharedApplicationDelegate].hostReachability;
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable:
            return NO;
            break;
        case ReachableViaWWAN:
            return YES;
            break;
        case ReachableViaWiFi:
            return YES;
            break;
        default:
            return YES;
            break;
    }
}

- (void)reloadButtonClick
{
    
}

@end
