//
//  TeachingSkillsController.m
//  Coach
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "TeachingSkillsController.h"
#import "TeachingTableCell.h"
#import "TeachingSecondCell.h"
#import "TSkillsView.h"
#import "TeachArticleModel.h"
#import "TeachingSkillsWapVC.h"

#import "LLWebViewController.h"

#define SubjectNum 3

@interface TeachingSkillsController ()<UITableViewDelegate,UITableViewDataSource,TSkillsViewDelegate,UIGestureRecognizerDelegate>
{
    UITableView * _teachTableView;
}

@property (nonatomic,strong) UIScrollView * backScrollView;

@property (nonatomic,strong)NSMutableArray *pageViewsArray;

@property (nonatomic,strong) TSkillsView * tSkillsView;

@property (nonatomic, assign) NSInteger pageId;

@property (nonatomic, strong) NSMutableArray * articleArray;

@property (nonatomic, assign)NSInteger topIndex;

@end

@implementation TeachingSkillsController

- (id)init
{
    if (self = [super init]) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initWithUI
{
    [super initWithUI];
    self.title =  @"教学技巧";
    
    
//    [self createTopBtn];
    
    
    [self createTopView];
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)initWithData
{
    [super initWithData];
    _tSkillsView.dataArray = @[@"全部",@"教学方法",@"教练修养"];
    
    self.pageId = 1;
    self.topIndex = 0;
}

- (void)createTopView
{
    _tSkillsView = [[TSkillsView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 48)];
    _tSkillsView.delegate  = self;
    [self.view addSubview:_tSkillsView];
    
    _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+40+4, kScreenWidth, kScreenHeight-64-40-4)];
    _backScrollView.backgroundColor = [UIColor colorWithHexString:@"#f2f6f7"];
    _backScrollView.contentSize = CGSizeMake(kScreenWidth*SubjectNum, 0);
    _backScrollView.delegate = self;
    _backScrollView.scrollEnabled = YES;
    _backScrollView.pagingEnabled = YES;
    _backScrollView.showsVerticalScrollIndicator = NO;
    _backScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_backScrollView];
    
//    NSArray * arrColor = @[[UIColor redColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor greenColor],[UIColor blueColor],[UIColor magentaColor],[UIColor purpleColor],[UIColor cyanColor]];
    
//    NSMutableArray *titleArray = [[NSMutableArray alloc]initWithObjects:@"全部",@"科目一",@"科目二",@"科目三",@"科目四",@"科目五",@"科目六",@"科目七", nil];
//    _pageViewsArray = [NSMutableArray new];
    
    // 获取内容数据
//    for (int i = 0; i<titleArray.count; i++)
//    {
//        UIViewController *pageVC = [UIViewController new];
//        pageVC.view.backgroundColor = arrColor[i];
//        pageVC.view.frame = CGRectMake(kScreenWidth*i, 0, CGRectGetWidth(_backScrollView.frame)*i,CGRectGetHeight(_backScrollView.frame));
//        [_backScrollView addSubview:pageVC.view];
//        [_pageViewsArray addObject:pageVC];
//    }
    
}

- (void)createTableView
{
//    UIViewController * vc = _pageViewsArray[0];
    
    _teachTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+40+4, kScreenWidth, kScreenHeight-64-40-4) style:UITableViewStylePlain];
    _teachTableView.dataSource = self;
    _teachTableView.delegate = self;
    _teachTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _teachTableView.showsVerticalScrollIndicator = NO;
//    [vc.view addSubview:_teachTableView];
    [self.view addSubview:_teachTableView];
    
    UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipeRecognizer:)];
    leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [_teachTableView addGestureRecognizer:leftSwipeRecognizer];
    
    UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipeRecognizer:)];
    rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [_teachTableView addGestureRecognizer:rightSwipeRecognizer];
    
    
    __weak typeof (self) weakSelf = self;
    
    _teachTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.pageId = 1;
        
        [weakSelf requestWithAllData];
        
    }];
    
    
    _teachTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageId ++;
        
        [weakSelf loadMoreAllData];
        
    }];
    
    _teachTableView.mj_footer.automaticallyHidden = YES;
    
    [_teachTableView.mj_header beginRefreshing];
    
}

- (void)requestWithAllData
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"deviceInfo"] = kDeviceInfo;
    param[@"time"] = kTimeStamp;
    param[@"typeId"] = @(_topIndex);
    param[@"pageId"] = @(self.pageId);
    param[@"sign"] = kSignWithIdentify(@"/article");
    
    [NetworkEngine postRequestWithRelativeAdd:@"/article" paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                NSString * jstr = [LLUtils jsonStrWithJSONObject:jsonObj];
                NSString * str = [LLUtils replaceUnicode:jstr];
                
                NSLog(@"%@",str);
                
                _articleArray = [TeachArticleModel mj_objectArrayWithKeyValuesArray:jsonObj[@"info"][@"article"]];
                [_teachTableView reloadData];
                [_teachTableView.mj_header endRefreshing];
                
            }
            else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                //需要登录
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
                [_teachTableView.mj_header endRefreshing];
            }
            else
            {
                //失败
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
                [_teachTableView.mj_header endRefreshing];
            }
        }
    }];
}

- (void)loadMoreAllData
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"deviceInfo"] = kDeviceInfo;
    param[@"time"] = kTimeStamp;
    param[@"typeId"] = @"0";
    param[@"pageId"] = @(self.pageId);
    param[@"sign"] = kSignWithIdentify(@"/article");
    
    [NetworkEngine postRequestWithRelativeAdd:@"/article" paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                NSString * jstr = [LLUtils jsonStrWithJSONObject:jsonObj];
                NSString * str = [LLUtils replaceUnicode:jstr];
                
                NSLog(@"%@",str);
                
                NSArray * arr = [TeachArticleModel mj_objectArrayWithKeyValuesArray:jsonObj[@"info"][@"article"]];
                [_articleArray addObjectsFromArray:arr];
                [_teachTableView.mj_footer endRefreshing];
            }
            else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                //需要登录
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
                [_teachTableView.mj_footer endRefreshing];
            }
            else
            {
                //失败
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
                [_teachTableView.mj_footer endRefreshing];
            }
        }
    }];
}

//处理手势
- (void)handleLeftSwipeRecognizer:(UISwipeGestureRecognizer *)swipeGesture
{
    
}

- (void)handleRightSwipeRecognizer:(UISwipeGestureRecognizer *)swipeGesture
{
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && _teachTableView.contentOffset.x == 0) {
            return NO;
        }
    }
    
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
{
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _articleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0 || indexPath.row == 2) {
//        return 293.f;
//    }else{
//        return 150.f;
//    }
    CGFloat height = 0;
    if (_articleArray.count>0) {
        TeachArticleModel * articleModel = _articleArray[indexPath.row];
        height = [articleModel.articleContent sizeWithFont:Font14 maxSize:CGSizeMake(kScreenWidth, MAXFLOAT)].height;
    }
    
    
    return 230+height-136+9/25.0*kScreenWidth;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
        static NSString * string = @"cell";
        TeachingTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TeachingTableCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_articleArray.count>0) {
        cell.articleModel = _articleArray[indexPath.row];
    }
    
        return cell;
//    }else if (indexPath.row == 2){
//        static NSString * string = @"cell";
//        TeachingTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
//        if (cell == nil) {
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"TeachingTableCell" owner:self options:nil]lastObject];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }else{
//        static NSString * string = @"celltwo";
//        TeachingSecondCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
//        if (cell == nil) {
//            cell = [[[NSBundle mainBundle]loadNibNamed:@"TeachingSecondCell" owner:self options:nil] lastObject];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeachArticleModel * articleModel = _articleArray[indexPath.row];
    LLWebViewController * vc = [[LLWebViewController alloc]initWithUrl:[NSURL URLWithString:[articleModel.articleUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] title:@"详情" rightImgName:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tSkillsViewDidSelectedIndex:(NSInteger)index
{
//    NSLog(@"点击了教学技巧上面按钮");
    _topIndex = index;
//    [self requestWithAllData];
    [_teachTableView.mj_header beginRefreshing];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (_backScrollView == scrollView) {
//        if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
//            scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height);
//            return;
//        }
//    }  
//    return;
}

//文字高度自适应
- (CGFloat)calculateCellHeightWithString:(NSString *)string font:(UIFont *)font width:(CGFloat)width
{
    if ([string isEqualToString:@""] || string == nil) {
        return 1.f;
    }
    NSDictionary *dicAttribute = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] ;
    CGRect textRect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                           options:NSStringDrawingUsesFontLeading|
                       NSStringDrawingUsesLineFragmentOrigin|
                       NSStringDrawingTruncatesLastVisibleLine
                                        attributes:dicAttribute
                                           context:nil];
    
    return ceilf(textRect.size.height) ;
}


@end
